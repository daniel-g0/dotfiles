from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb

# Tokyo Night palette
_BG     = as_rgb(0x24283b)
_BLUE   = as_rgb(0x7aa2f7)
_PURPLE = as_rgb(0xbb9af7)
_CYAN   = as_rgb(0x7dcfff)
_GREEN  = as_rgb(0x9ece6a)
_FG     = as_rgb(0xc0caf5)
_DIM    = as_rgb(0x414868)

SEP = '   '


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
    segs = _parse(tab.title or '')

    single = index == 1 and is_last

    if single:
        total = screen.columns
        plain = SEP.join(t for t, _ in segs)
        pad   = max(0, (total - len(plain)) // 2)

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

    return screen.columns if single else before + max_title_length
