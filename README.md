# bestpaste

### Installation
```bash
    ./install.sh
```

### What is it 
Set of tools and scripts to improve the clipboard experience on **KDE Plasma and Wayland**.
Allows to paste directly by pressing `Enter`.
Uses cliphist, wl-clipboard, rofi, ydotool, kdotool, imagemagick.

Keys in the popup (rofi only):
- Alt+I: switch between the compact text list and the image gallery (thumbnails)
- Alt+X: clear all history (asks to confirm; also deletes cached thumbnails in `~/.cache/bestpaste`)

### Troubleshooting
- New terminal pastes wrong? Find its class with `sleep 3; kdotool getactivewindow getwindowclassname`
  (click into it) and add it to the `case` pattern in `clip-paste`, then re-run `./install.sh`.
- Debug: add `exec >/tmp/clip-paste.log 2>&1; set -x` after the shebang in `~/.local/bin/clip-paste`.

### Uninstall
```bash
    ./install.sh --uninstall
```
