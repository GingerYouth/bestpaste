# bestpaste

### Installation
```bash
    ./install.sh
```
The installer asks which popup to use and asks again on every run (Enter keeps the current one):
- **rofi** (recommended): image gallery and clear-all
- **fuzzel**: lighter, text only

Switch later without redoing the setup:
```bash
    ./install.sh --picker
```

### What is it 
Set of tools and scripts to improve the clipboard experience on **KDE Plasma and Wayland**.
Allows to paste directly by pressing `Enter`.
Uses cliphist, wl-clipboard, ydotool, kdotool, and rofi (+ imagemagick for thumbnails) or fuzzel.
The choice is saved in `~/.config/bestpaste/picker`.

Keys in the popup (rofi only):
- Alt+I: switch between the compact text list and the image gallery (thumbnails)
- Alt+X: clear all history (asks to confirm; also deletes cached thumbnails in `~/.cache/bestpaste`)

### Troubleshooting
- New terminal pastes wrong? Find its class with `sleep 3; kdotool getactivewindow getwindowclassname`
  (click into it) and add it to the `case` pattern in `clip-paste`, then re-run `./install.sh`.
- Popup shows but nothing pastes: raise `sleep 0.2` to `0.3` in `clip-paste`.
- Images can't be pasted into terminals.
- Debug: add `exec >/tmp/clip-paste.log 2>&1; set -x` after the shebang in `~/.local/bin/clip-paste`.

### Uninstall
```bash
    ./install.sh --uninstall
```
