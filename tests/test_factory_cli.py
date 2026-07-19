from pathlib import Path
from types import SimpleNamespace

from factory_cli import cli


def test_unmanaged_repository_is_out_of_scope(tmp_path: Path) -> None:
    assert cli.compliance(tmp_path, strict=True) == []


def test_enrolling_repository_uses_onboarding_checks(tmp_path: Path, monkeypatch) -> None:
    monkeypatch.chdir(tmp_path)
    monkeypatch.setattr(cli, "project_root", lambda: tmp_path)
    args = SimpleNamespace(project_id="pilot", name="Pilot", mode="existing", force=False)
    assert cli.cmd_enroll(args) == 0
    context = cli.load_yaml(tmp_path / ".factory/project-context.yaml")
    assert context["factoryStatus"] == "enrolling"
    assert context["enforcementMode"] == "onboarding"
    assert cli.compliance(tmp_path, strict=False) == []


def test_manage_promotes_only_after_checks(tmp_path: Path, monkeypatch) -> None:
    monkeypatch.chdir(tmp_path)
    monkeypatch.setattr(cli, "project_root", lambda: tmp_path)
    args = SimpleNamespace(project_id="pilot", name="Pilot", mode="existing", force=False)
    cli.cmd_enroll(args)
    assert cli.cmd_manage(SimpleNamespace()) == 0
    context = cli.load_yaml(tmp_path / ".factory/project-context.yaml")
    assert context["factoryStatus"] == "managed"
    assert context["enforcementMode"] == "strict"
