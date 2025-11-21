from pathlib import Path

# Set this to your local clone of the repo
REPO_PATH = "$HOME/SandBox/sketchybar-app-font"
MAPPINGS_DIR = Path(REPO_PATH) / "mappings"

app_to_icon = {}

for mapping_file in MAPPINGS_DIR.iterdir():
    if mapping_file.is_file():
        icon_code = mapping_file.name  # e.g. ":activity_monitor:"
        with open(mapping_file, "r", encoding="utf-8") as f:
            content = f.read().strip()
            # Split by |, strip quotes and whitespace, remove trailing *
            app_names = [name.strip().strip('"').rstrip("*").strip() for name in content.split("|")]
            for app_name in app_names:
                if app_name:  # skip empty
                    app_to_icon[app_name] = icon_code

# Sort by app name (case-insensitive, Unicode-safe)
for app in sorted(app_to_icon, key=lambda s: s.casefold()):
    icon = app_to_icon[app]
    print(f'["{app}"] = "{icon}",')
