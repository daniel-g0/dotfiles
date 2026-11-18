---
name: sync-docs
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: (hyprland\.lua|README\.md|CLAUDE\.md|cheatsheet\.sh|docs/[^/]+\.md)$
---

📄 **Doc sync required**

You edited a file that owns keybindings or documentation. Before finishing, check:

- `hyprland.lua` changed → update keybindings tables in `README.md` AND `docs/hyprland.md`, update `cheatsheet.sh` if a bind was added/removed
- `cheatsheet.sh` changed → update `README.md` Cheatsheet section + window rules table if needed
- `README.md` / `docs/*.md` changed → verify the other side reflects the same facts (keybindings tables: `docs/hyprland.md`; symlink map: `docs/repo.md`; structure tree)
- New or renamed file in `docs/` → update the "Docs (read on demand)" table in `CLAUDE.md`

`CLAUDE.md` is only an index + TODO + "What NOT to do". Put details in `docs/`, not back into `CLAUDE.md`.

All these files must stay consistent. Do not mark the task done until you have checked each one.
