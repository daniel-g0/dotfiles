/*
 For:            awww (swww fork), https://github.com/5hubham5ingh/awww
 Author:         daniel
 Prerequisite:   awww-daemon must be running (started via Hyprland autostart)
*/

export async function setWallpaper(wallpaperPath) {
  const command = createAwwwCommand(wallpaperPath, generateRandomOptions());
  await execAsync(command);
}

function createAwwwCommand(imagePath, options) {
  const command = ["awww", "img", imagePath];

  if (options.resize)             command.push("--resize", options.resize);
  if (options.filter)             command.push("-f", options.filter);
  if (options.transitionType)     command.push("--transition-type", options.transitionType);
  if (options.transitionStep !== undefined)    command.push("--transition-step",    String(options.transitionStep));
  if (options.transitionDuration !== undefined) command.push("--transition-duration", String(options.transitionDuration));
  if (options.transitionFps !== undefined)     command.push("--transition-fps",     String(options.transitionFps));
  if (options.transitionAngle !== undefined)   command.push("--transition-angle",   String(options.transitionAngle));
  if (options.transitionPos)      command.push("--transition-pos", options.transitionPos);

  return command;
}

function generateRandomOptions() {
  const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

  return {
    resize:             "crop",
    transitionType:     pick(["fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "outer"]),
    transitionStep:     255,
    transitionDuration: 1,
    transitionFps:      60,
    transitionAngle:    Math.floor(Math.random() * 360),
    transitionPos:      pick([
      "center", "top", "left", "right", "bottom",
      "top-left", "top-right", "bottom-left", "bottom-right",
      `${Math.random() * 100},${Math.random() * 100}`,
    ]),
  };
}
