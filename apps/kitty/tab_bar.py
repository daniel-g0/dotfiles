import json, os
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb

# ── Dynamic palette (auto-reloads from palette.json on change) ────────────────

_PALETTE_PATH = os.path.expanduser("~/.cache/dynamic-theme/palette.json")
_mtime        = 0.0

_BG     = as_rgb(0x1a1b26)
_BLUE   = as_rgb(0x7aa2f7)
_PURPLE = as_rgb(0xbb9af7)
_CYAN   = as_rgb(0x2ac3de)
_GREEN  = as_rgb(0x9ece6a)
_FG     = as_rgb(0xc0caf5)
_DIM    = as_rgb(0x565f89)


def _h(c: str) -> int:
    return as_rgb(int(c.lstrip("#"), 16))


def _reload():
    global _mtime, _BG, _BLUE, _PURPLE, _CYAN, _GREEN, _FG, _DIM
    try:
        mt = os.stat(_PALETTE_PATH).st_mtime
    except OSError:
        return
    if mt <= _mtime:
        return
    _mtime = mt
    try:
        with open(_PALETTE_PATH) as f:
            p = json.load(f)
        _BG     = _h(p.get("bg",     "#1a1b26"))
        _BLUE   = _h(p.get("blue",   "#7aa2f7"))
        _PURPLE = _h(p.get("accent", "#bb9af7"))
        _CYAN   = _h(p.get("cyan",   "#2ac3de"))
        _GREEN  = _h(p.get("green",  "#9ece6a"))
        _FG     = _h(p.get("fg",     "#c0caf5"))
        _DIM    = _h(p.get("fg_dim", "#565f89"))
    except Exception:
        pass


# ── Tab bar ───────────────────────────────────────────────────────────────────

SEP = '   '


def _vlen(s: str) -> int:
    w = 0
    for c in s:
        cp = ord(c)
        if 0xE000 <= cp <= 0xF8FF or 0xF0000 <= cp <= 0xFFFFF:
            w += 2
        else:
            w += 1
    return w


def _parse(title: str) -> list[tuple[str, int]]:
    # Expected: "~/path 󰊢 branch [+1 ~2] | 5f 2d | 14:23"
    parts      = title.split(' | ')
    git_sec    = parts[0].strip() if parts else ''
    counts_sec = parts[1].strip() if len(parts) > 1 else ''
    time_sec   = parts[2].strip() if len(parts) > 2 else ''

    if ' 󰊢 ' in git_sec:
        dir_str, branch_str = git_sec.split(' 󰊢 ', 1)
    else:
        dir_str, branch_str = git_sec, ''

    segs: list[tuple[str, int]] = []
    if dir_str.strip():
        segs.append((dir_str.strip(), _BLUE))
    if branch_str.strip():
        segs.append((f'󰊢  {branch_str.strip()}', _PURPLE))
    if counts_sec:
        segs.append((counts_sec, _CYAN))
    if time_sec:
        segs.append((time_sec, _GREEN))
    return segs


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int,
    is_last: bool, extra_data: ExtraData,
) -> int:
    _reload()
    segs = _parse(tab.title or '')

    single = index == 1 and is_last

    if single:
        total = screen.columns
        plain = SEP.join(t for t, _ in segs)
        pad   = max(0, (total - _vlen(plain)) // 2)

        screen.cursor.fg = _FG
        screen.cursor.bg = _BG
        screen.cursor.x  = 0
        screen.draw(' ' * total)
        screen.cursor.x = pad
    else:
        screen.cursor.fg = _FG
        screen.cursor.bg = _BG

    for i, (text, color) in enumerate(segs):
        if i > 0:
            screen.cursor.fg = _DIM
            screen.draw(SEP)
        screen.cursor.fg = color
        screen.draw(text)

    if not single:
        end = before + max_title_length
        remaining = end - screen.cursor.x
        if remaining > 0:
            screen.cursor.fg = _FG
            screen.cursor.bg = _BG
            screen.draw(' ' * remaining)

    return screen.columns if single else before + max_title_length
