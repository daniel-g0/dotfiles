---
name: sync-docs
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: (hyprland\.lua|README\.md|CLAUDE\.md|cheatsheet\.sh)$
---

📄 **Doc sync required**

You edited a file that owns keybindings or documentation. Before finishing, check:

- `hyprland.lua` changed → update keybindings tables in `README.md` AND `CLAUDE.md`, update `cheatsheet.sh` if a bind was added/removed
- `cheatsheet.sh` changed → update `README.md` Cheatsheet section + window rules table if needed
- `README.md` / `CLAUDE.md` changed → verify the other file reflects the same facts (they share keybindings tables, symlink map, structure tree)

All four files must stay consistent. Do not mark the task done until you have checked each one.
