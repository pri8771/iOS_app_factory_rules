#!/usr/bin/env python3
"""Validate that key App Factory files satisfy their declared JSON schemas.

This performs shallow structural validation (required keys, types, enum and
const constraints, array minItems) without a third-party JSON Schema
library, matching this repository's zero-dependency automation. It is not a
full JSON Schema implementation; it exists to catch drift between a schema
and the templates or registry files meant to satisfy it.
"""

from __future__ import annotations

import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

PAIRS = [
    ("schemas/project-context.schema.json", "templates/project/.factory/project-context.json"),
    ("schemas/standard-lock.schema.json", "templates/project/.factory/standard-lock.json"),
    ("schemas/library-catalog.schema.json", "templates/project/.factory/library-catalog.json"),
    ("schemas/library-catalog.schema.json", "registry/libraries.json"),
    ("schemas/repository-map.schema.json", "templates/project/.factory/repository-map.json"),
    ("schemas/repository-map.schema.json", ".factory/repository-map.json"),
    ("schemas/quality-manifest.schema.json", "templates/project/quality/quality-manifest.json"),
    ("schemas/feature-contract.schema.json", "templates/project/quality/feature-contracts/EXAMPLE.json"),
    ("schemas/completion-report.schema.json", "templates/project/quality/completion-reports/EXAMPLE.json"),
]


def check(schema: dict, instance: object, path: str, errors: list[str]) -> None:
    schema_type = schema.get("type")

    if schema_type == "object":
        if not isinstance(instance, dict):
            errors.append(f"{path}: expected object, got {type(instance).__name__}")
            return
        for key in schema.get("required", []):
            if key not in instance:
                errors.append(f"{path}: missing required key '{key}'")
        for key, subschema in schema.get("properties", {}).items():
            if key in instance:
                check(subschema, instance[key], f"{path}.{key}", errors)
        return

    if schema_type == "array":
        if not isinstance(instance, list):
            errors.append(f"{path}: expected array, got {type(instance).__name__}")
            return
        min_items = schema.get("minItems")
        if min_items is not None and len(instance) < min_items:
            errors.append(f"{path}: expected at least {min_items} item(s), got {len(instance)}")
        item_schema = schema.get("items")
        if item_schema:
            for index, item in enumerate(instance):
                check(item_schema, item, f"{path}[{index}]", errors)
        return

    if schema_type == "string" and not isinstance(instance, str):
        errors.append(f"{path}: expected string, got {type(instance).__name__}")
    if schema_type == "boolean" and not isinstance(instance, bool):
        errors.append(f"{path}: expected boolean, got {type(instance).__name__}")

    if "enum" in schema and instance not in schema["enum"]:
        errors.append(f"{path}: {instance!r} not in {schema['enum']}")
    if "const" in schema and instance != schema["const"]:
        errors.append(f"{path}: {instance!r} != {schema['const']!r}")


def main() -> int:
    all_errors: list[str] = []
    for schema_relative, instance_relative in PAIRS:
        schema_path = ROOT / schema_relative
        instance_path = ROOT / instance_relative
        if not instance_path.exists():
            all_errors.append(f"{instance_relative}: file does not exist")
            continue
        schema = json.loads(schema_path.read_text())
        instance = json.loads(instance_path.read_text())
        errors: list[str] = []
        check(schema, instance, instance_relative, errors)
        if errors:
            all_errors.extend(errors)
        else:
            print(f"ok: {instance_relative} matches {schema_relative}")

    if all_errors:
        print("Schema validation failed:", file=sys.stderr)
        for error in all_errors:
            print(f"  - {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
