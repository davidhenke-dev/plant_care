#!/usr/bin/env python3
"""Aktualisiert altstore-source.json nach einem neuen Release."""

import argparse
import json
import os
from datetime import date

parser = argparse.ArgumentParser()
parser.add_argument("--version", required=True)
parser.add_argument("--download-url", required=True)
args = parser.parse_args()

source_path = os.path.join(os.path.dirname(__file__), "..", "altstore-source.json")

with open(source_path) as f:
    source = json.load(f)

app = source["apps"][0]
app["version"] = args.version.lstrip("v")
app["versionDate"] = date.today().isoformat()
app["downloadURL"] = args.download_url

with open(source_path, "w") as f:
    json.dump(source, f, indent=2, ensure_ascii=False)

print(f"AltStore source aktualisiert: {args.version}")
