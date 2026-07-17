#!/usr/bin/env python3
"""Search an App Factory reusable-library catalog by capability or name."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("query", help="Capability, package name, or library ID")
    parser.add_argument(
        "--catalog",
        default=".factory/library-catalog.json",
        help="Path to a project catalog snapshot or central registry",
    )
    args = parser.parse_args()

    path = Path(args.catalog)
    if not path.exists():
        raise SystemExit(f"Catalog not found: {path}")

    catalog = json.loads(path.read_text())
    needle = args.query.casefold()
    matches = []
    for library in catalog.get("libraries", []):
        haystack = [
            library.get("id", ""),
            library.get("name", ""),
            library.get("repository", ""),
            *library.get("capabilities", []),
            *library.get("platforms", []),
        ]
        if any(needle in str(value).casefold() for value in haystack):
            matches.append(library)

    if not matches:
        print(f"No registered reusable library matches: {args.query}")
        return 1

    for library in matches:
        print(f"{library['name']} ({library['id']})")
        print(f"  repository: {library['repository']}")
        print(f"  version: {library['latestStableVersion']}")
        print(f"  status: {library['status']}")
        print(f"  capabilities: {', '.join(library['capabilities'])}")
        print(f"  installation: {library['installation']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
