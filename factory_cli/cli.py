from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import yaml
from jsonschema import Draft202012Validator

RULES_VERSION = "0.5.0"
FACTORY_DIR = Path(".factory")
REQUIRED_MANAGED = [
    ".factory/project-context.yaml",
    ".factory/current-state.yaml",
    ".factory/scope-lock.yaml",
    ".factory/agent-policy.yaml",
    ".factory/standard-lock.json",
    "AGENTS.md",
    "CLAUDE.md",
    ".cursor/rules/00-factory-router.mdc",
    "tasks",
    "conversations/handoffs",
    "quality",
]


def now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def load_yaml(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        value = yaml.safe_load(handle) or {}
    if not isinstance(value, dict):
        raise ValueError(f"{path} must contain a mapping")
    return value


def write_yaml(path: Path, value: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(yaml.safe_dump(value, sort_keys=False), encoding="utf-8")


def write_json(path: Path, value: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")


def git(*args: str, check: bool = True) -> str:
    result = subprocess.run(["git", *args], text=True, capture_output=True)
    if check and result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "git command failed")
    return result.stdout.strip()


def project_root() -> Path:
    try:
        return Path(git("rev-parse", "--show-toplevel"))
    except Exception:
        return Path.cwd()


def install_entry_files(root: Path) -> None:
    agents = """# App Factory Agent Entry Point\n\nThis repository is governed only when `.factory/project-context.yaml` declares `factoryStatus: enrolling` or `managed`.\n\nBefore project work:\n1. Read `.factory/project-context.yaml`.\n2. Read `.factory/current-state.yaml`.\n3. Inspect the current Git diff.\n4. Read the active task and latest handoff when present.\n5. Load only task-relevant standards.\n\nClassify requests as ADVISORY, PROPOSAL, INSPECTION, or EXECUTION. Questions are read-only unless the user explicitly authorizes changes. Scope changes require an approved decision when required by `.factory/scope-lock.yaml`.\n\nBefore completion run `factory compliance check` and `factory checkpoint` for execution tasks.\n"""
    claude = """@AGENTS.md\n\n# Claude Code adapter\nUse repository state rather than private chat history for resumability. Respect `.factory/agent-policy.yaml`. The selected main model remains the main model; invoke a required specialized agent only when policy requires it. Never claim a model or effort was verified without a run receipt.\n"""
    cursor = """---\ndescription: App Factory request router\nalwaysApply: true\n---\n\nClassify each request before acting:\n- ADVISORY: answer only; no edits or mutating commands.\n- PROPOSAL: analyze impact; do not implement.\n- INSPECTION: begin read-only; verify current behavior.\n- EXECUTION: activate a task, follow scoped rules, verify, and checkpoint.\n\nWhen ambiguous, default to ADVISORY or PROPOSAL. A question is not authorization to modify the repository. Read `AGENTS.md` and `.factory/current-state.yaml` before EXECUTION.\n"""
    (root / "AGENTS.md").write_text(agents, encoding="utf-8")
    (root / "CLAUDE.md").write_text(claude, encoding="utf-8")
    cursor_path = root / ".cursor/rules/00-factory-router.mdc"
    cursor_path.parent.mkdir(parents=True, exist_ok=True)
    cursor_path.write_text(cursor, encoding="utf-8")


def cmd_enroll(args: argparse.Namespace) -> int:
    root = project_root()
    context_path = root / ".factory/project-context.yaml"
    if context_path.exists() and not args.force:
        raise RuntimeError("Project is already enrolled; pass --force to replace enrollment metadata")
    for directory in ["tasks/backlog", "tasks/active", "tasks/blocked", "tasks/review", "tasks/done", "conversations/handoffs", "conversations/decisions", "quality/evidence", ".factory/runs"]:
        (root / directory).mkdir(parents=True, exist_ok=True)
    write_yaml(context_path, {
        "schemaVersion": 1,
        "projectId": args.project_id,
        "projectName": args.name or args.project_id,
        "projectType": args.mode,
        "factoryStatus": "enrolling",
        "enforcementMode": "onboarding",
        "targetRulesVersion": RULES_VERSION,
        "enrolledAt": now(),
    })
    write_yaml(root / ".factory/current-state.yaml", {
        "schemaVersion": 1,
        "updatedAt": now(),
        "updatedBy": {"tool": "factory-cli"},
        "activeTask": None,
        "completed": [],
        "knownFailures": [],
        "nextRecommendedAction": "Complete enrollment compliance checks",
        "workingTreeExpectedDirty": False,
    })
    write_yaml(root / ".factory/scope-lock.yaml", {
        "schemaVersion": 1,
        "release": "unassigned",
        "mustShip": [],
        "mayShip": [],
        "explicitlyExcluded": [],
        "approvalRequiredFor": ["new-backend", "user-accounts", "cloud-sync", "new-dependency", "new-permission", "new-data-collection", "pricing-change", "subscription-change"],
    })
    write_yaml(root / ".factory/agent-policy.yaml", {
        "schemaVersion": 1,
        "defaults": {"maxConcurrentAgents": 3, "maxDelegationDepth": 1, "requireRunReceipt": True, "prohibitRecursiveDelegation": True},
        "riskPolicy": {
            "low": {"minimumVerification": "configuration-only"},
            "medium": {"minimumVerification": "ide-reported"},
            "high": {"minimumVerification": "provider-response"},
        },
        "roles": {},
    })
    write_json(root / ".factory/standard-lock.json", {
        "rulesRepository": "pri8771/iOS_app_factory_rules",
        "rulesVersion": RULES_VERSION,
        "compatibilityRange": ">=0.5.0 <1.0.0",
        "lockedAt": now(),
    })
    install_entry_files(root)
    print(f"Enrolled {args.project_id} in onboarding mode. Strict enforcement remains disabled until `factory manage`.")
    return 0


def cmd_manage(_: argparse.Namespace) -> int:
    root = project_root()
    path = root / ".factory/project-context.yaml"
    context = load_yaml(path)
    failures = compliance(root, strict=False)
    if failures:
        print("Cannot mark managed; enrollment checks failed:")
        for item in failures:
            print(f"- {item}")
        return 2
    context["factoryStatus"] = "managed"
    context["enforcementMode"] = "strict"
    context["managedAt"] = now()
    write_yaml(path, context)
    print("Project is now managed and strict compliance applies.")
    return 0


def cmd_task_start(args: argparse.Namespace) -> int:
    root = project_root()
    task_path = root / f"tasks/active/{args.task_id}.yaml"
    if task_path.exists():
        raise RuntimeError(f"Active task already exists: {args.task_id}")
    task = {
        "schemaVersion": 1,
        "id": args.task_id,
        "title": args.title,
        "status": "active",
        "riskClass": args.risk,
        "startedAt": now(),
        "interactionClass": "execution",
        "scope": {"allowedPaths": args.allow or [], "forbiddenPaths": args.forbid or []},
        "successCriteria": args.success or [],
        "verification": [],
    }
    write_yaml(task_path, task)
    state_path = root / ".factory/current-state.yaml"
    state = load_yaml(state_path)
    state["activeTask"] = args.task_id
    state["updatedAt"] = now()
    state["nextRecommendedAction"] = args.title
    write_yaml(state_path, state)
    print(f"Started {args.task_id}: {args.title}")
    return 0


def cmd_checkpoint(args: argparse.Namespace) -> int:
    root = project_root()
    state_path = root / ".factory/current-state.yaml"
    state = load_yaml(state_path)
    task_id = args.task_id or state.get("activeTask")
    branch = git("branch", "--show-current", check=False)
    status = git("status", "--short", check=False).splitlines()
    changed = [line[3:] for line in status if len(line) > 3]
    commit = git("rev-parse", "HEAD", check=False)
    handoff = root / "conversations/handoffs/LATEST.md"
    body = [
        "# Latest Cross-IDE Handoff",
        "",
        f"- Task: `{task_id or 'none'}`",
        f"- Created: `{now()}`",
        f"- Source: `{args.source}`",
        f"- Target: `{args.target}`",
        f"- Branch: `{branch or 'unknown'}`",
        f"- Commit: `{commit or 'unknown'}`",
        "",
        "## Changed files",
    ]
    body.extend([f"- `{path}`" for path in changed] or ["- None"])
    body += ["", "## Completed", args.completed or "Not supplied.", "", "## Remaining", args.remaining or "Inspect the active task and current diff.", "", "## Known failures", args.failures or "None reported.", "", "## Resume instructions", "1. Read `AGENTS.md` and `.factory/current-state.yaml`.", "2. Inspect Git status and the current diff.", "3. Read the active task.", "4. Reproduce any documented failure before editing."]
    handoff.parent.mkdir(parents=True, exist_ok=True)
    handoff.write_text("\n".join(body) + "\n", encoding="utf-8")
    state.update({"updatedAt": now(), "updatedBy": {"tool": args.source}, "workingTreeExpectedDirty": bool(changed), "lastHandoff": "conversations/handoffs/LATEST.md"})
    write_yaml(state_path, state)
    print(handoff)
    return 0


def cmd_resume(_: argparse.Namespace) -> int:
    root = project_root()
    state = load_yaml(root / ".factory/current-state.yaml")
    context = load_yaml(root / ".factory/project-context.yaml")
    print(f"Project: {context.get('projectName')} ({context.get('factoryStatus')})")
    print(f"Rules: {context.get('targetRulesVersion')}")
    print(f"Active task: {state.get('activeTask') or 'none'}")
    print(f"Next: {state.get('nextRecommendedAction') or 'inspect repository state'}")
    print(f"Branch: {git('branch', '--show-current', check=False) or 'unknown'}")
    print(f"Working tree dirty: {bool(git('status', '--porcelain', check=False))}")
    latest = root / "conversations/handoffs/LATEST.md"
    if latest.exists():
        print(f"Handoff: {latest.relative_to(root)}")
    return 0


def validate_json_schema(instance_path: Path, schema_path: Path) -> list[str]:
    try:
        instance = json.loads(instance_path.read_text(encoding="utf-8"))
        schema = json.loads(schema_path.read_text(encoding="utf-8"))
    except Exception as exc:
        return [f"{instance_path}: {exc}"]
    return [f"{instance_path}: {error.message}" for error in Draft202012Validator(schema).iter_errors(instance)]


def compliance(root: Path, strict: bool) -> list[str]:
    context_path = root / ".factory/project-context.yaml"
    if not context_path.exists():
        return []  # Unmanaged repositories are intentionally out of scope.
    failures: list[str] = []
    try:
        context = load_yaml(context_path)
    except Exception as exc:
        return [str(exc)]
    status = context.get("factoryStatus")
    if status not in {"enrolling", "managed"}:
        failures.append("factoryStatus must be enrolling or managed")
        return failures
    required = REQUIRED_MANAGED if status == "managed" or strict else REQUIRED_MANAGED[:7]
    for relative in required:
        if not (root / relative).exists():
            failures.append(f"missing required path: {relative}")
    lock_path = root / ".factory/standard-lock.json"
    if lock_path.exists():
        try:
            lock = json.loads(lock_path.read_text(encoding="utf-8"))
            if lock.get("rulesVersion") != RULES_VERSION:
                failures.append(f"rules version drift: expected {RULES_VERSION}, found {lock.get('rulesVersion')}")
        except Exception as exc:
            failures.append(f"invalid standard lock: {exc}")
    active = load_yaml(root / ".factory/current-state.yaml").get("activeTask") if (root / ".factory/current-state.yaml").exists() else None
    if active and not (root / f"tasks/active/{active}.yaml").exists():
        failures.append(f"current-state references missing active task: {active}")
    return failures


def cmd_compliance(args: argparse.Namespace) -> int:
    failures = compliance(project_root(), strict=args.strict)
    if failures:
        print("Factory compliance failed:")
        for item in failures:
            print(f"- {item}")
        return 2
    print("Factory compliance passed (or repository is unmanaged and out of scope).")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="factory")
    sub = parser.add_subparsers(dest="command", required=True)
    enroll = sub.add_parser("enroll", help="Opt an existing or new project into onboarding mode")
    enroll.add_argument("project_id")
    enroll.add_argument("--name")
    enroll.add_argument("--mode", choices=["new", "existing"], default="existing")
    enroll.add_argument("--force", action="store_true")
    enroll.set_defaults(func=cmd_enroll)
    manage = sub.add_parser("manage", help="Promote an enrolled project to strict managed status")
    manage.set_defaults(func=cmd_manage)
    task = sub.add_parser("task-start", help="Start a portable execution task")
    task.add_argument("task_id")
    task.add_argument("title")
    task.add_argument("--risk", choices=["low", "medium", "high"], default="medium")
    task.add_argument("--allow", action="append")
    task.add_argument("--forbid", action="append")
    task.add_argument("--success", action="append")
    task.set_defaults(func=cmd_task_start)
    checkpoint = sub.add_parser("checkpoint", help="Write a cross-IDE handoff")
    checkpoint.add_argument("--task-id")
    checkpoint.add_argument("--source", default="unknown")
    checkpoint.add_argument("--target", default="any")
    checkpoint.add_argument("--completed")
    checkpoint.add_argument("--remaining")
    checkpoint.add_argument("--failures")
    checkpoint.set_defaults(func=cmd_checkpoint)
    resume = sub.add_parser("resume", help="Print portable project state")
    resume.set_defaults(func=cmd_resume)
    check = sub.add_parser("compliance", help="Run deterministic opt-in compliance checks")
    check.add_argument("--strict", action="store_true")
    check.set_defaults(func=cmd_compliance)
    return parser


def main() -> None:
    try:
        args = build_parser().parse_args()
        raise SystemExit(args.func(args))
    except (RuntimeError, ValueError) as exc:
        print(f"factory: {exc}", file=sys.stderr)
        raise SystemExit(2)


if __name__ == "__main__":
    main()
