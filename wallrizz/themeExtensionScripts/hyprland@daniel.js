/*
 For:            Hyprland (Lua config), https://hyprland.org
 Author:         daniel
 Note:           Uses hyprctl keyword for live color updates — no reload needed.
                 Replaces hyprland@5hubham5ingh.js which requires source= in .conf mode.
*/

function buildTheme(colors, isDark = true) {
  if (colors.length < 5) throw new Error("Need at least 5 colors");

  const colorDist = (a, b) => {
    const lDiff = a.getLuminance() - b.getLuminance();
    const hDiff = Math.min(
      Math.abs((a.toHsv().h || 0) - (b.toHsv().h || 0)),
      360 - Math.abs((a.toHsv().h || 0) - (b.toHsv().h || 0)),
    );
    return Math.sqrt(lDiff ** 2 + (hDiff / 360) ** 2);
  };

  const selectDistinct = (input, n) => {
    const selected = [Color(input[0])];
    const rest = input.slice(1).map(Color);
    while (selected.length < n && rest.length > 0) {
      let best = null, bestDist = -Infinity;
      for (const c of rest) {
        const d = Math.min(...selected.map((s) => colorDist(c, s)));
        if (d > bestDist) { bestDist = d; best = c; }
      }
      if (best) { selected.push(best); rest.splice(rest.indexOf(best), 1); }
      else break;
    }
    return selected;
  };

  const distinct = selectDistinct(colors, 5);
  while (distinct.length < 5)
    distinct.push(distinct[Math.floor(Math.random() * distinct.length)].analogous()[5]);

  const [bg, fg, ab1, ab2, ib] = distinct;
  const adj = (c, n) => isDark ? c.darken(n) : c.lighten(n);
  const hex = (c) => c.toHexString().substring(1);

  return {
    activeBorder:     [hex(ab1.setAlpha(0.7)), hex(ab2)],
    inactiveBorder:   hex(ib),
    background:       hex(adj(bg, 10)),
    foreground:       hex(adj(fg, 20)),
    groupActive:      hex(ab1),
    groupInactive:    hex(ab2),
    groupLockedActive:   hex(ab1.darken(10)),
    groupLockedInactive: hex(ab2.darken(10)),
    splash:           hex(fg),
  };
}

export const getDarkThemeConf  = (colors) => JSON.stringify(buildTheme(colors, true));
export const getLightThemeConf = (colors) => JSON.stringify(buildTheme(colors, false));

export async function setTheme(themeJsonPath) {
  const f = STD.open(themeJsonPath, "r");
  const theme = JSON.parse(f.readAsString());
  f.close();

  const kw = (key, val) => execAsync(["hyprctl", "keyword", key, val]);

  await Promise.all([
    kw("general:col.active_border",
       `rgb(${theme.activeBorder[0]}) rgb(${theme.activeBorder[1]}) 45deg`),
    kw("general:col.inactive_border",    `rgb(${theme.inactiveBorder})`),
    kw("group:col.border_active",        `rgb(${theme.groupActive})`),
    kw("group:col.border_inactive",      `rgb(${theme.groupInactive})`),
    kw("group:col.border_locked_active", `rgb(${theme.groupLockedActive})`),
    kw("group:col.border_locked_inactive", `rgb(${theme.groupLockedInactive})`),
    kw("group:groupbar:text_color",      `rgb(${theme.foreground})`),
    kw("group:groupbar:col.active",      `rgb(${theme.groupActive})`),
    kw("group:groupbar:col.inactive",    `rgb(${theme.groupInactive})`),
    kw("misc:background_color",          `rgb(${theme.background})`),
    kw("misc:col.splash",                `rgb(${theme.splash})`),
  ]);
}
