# bestpaste

Win+V-style clipboard history for KDE Plasma on Wayland (Arch/EndeavourOS).
Meta+V → pick with arrows → Enter pastes into the window you were in.

    ./install.sh              # install (log out/in once if it says so)
    ./install.sh --picker     # switch popup between rofi and fuzzel
    ./install.sh --uninstall

Uses cliphist, wl-clipboard, ydotool, kdotool and a popup of your choice, picked at install
(`~/.config/bestpaste/picker`): rofi (image gallery, clear-all; needs imagemagick) or fuzzel (light, text only).

Keys in the popup (rofi only):
- Alt+I: switch between the compact text list and the image gallery (thumbnails)
- Alt+X: clear all history (asks to confirm; also deletes cached thumbnails in `~/.cache/bestpaste`)

- New terminal pastes wrong? Find its class with `sleep 3; kdotool getactivewindow getwindowclassname`
  (click into it) and add it to the `case` pattern in `clip-paste`, then re-run `./install.sh`.
- Debug: add `exec >/tmp/clip-paste.log 2>&1; set -x` after the shebang in `~/.local/bin/clip-paste`.
- Popup shows but nothing pastes: raise `sleep 0.2` to `0.3`.
- Images can't be pasted into terminals.
