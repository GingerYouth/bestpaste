# bestpaste

Win+V-style clipboard history for KDE Plasma on Wayland (Arch/EndeavourOS).
Meta+V → pick with arrows → Enter pastes into the window you were in.

    ./install.sh              # install (log out/in once if it says so)
    ./install.sh --uninstall

Uses cliphist, wl-clipboard, rofi, ydotool, kdotool, imagemagick.

Keys in the popup:
- Alt+I: switch between the compact text list and the image gallery (thumbnails)
- Alt+X: clear all history (asks to confirm; also deletes cached thumbnails in `~/.cache/bestpaste`)

- New terminal pastes wrong? Find its class with `sleep 3; kdotool getactivewindow getwindowclassname`
  (click into it) and add it to the `case` pattern in `clip-paste`, then re-run `./install.sh`.
- Debug: add `exec >/tmp/clip-paste.log 2>&1; set -x` after the shebang in `~/.local/bin/clip-paste`.
- Popup shows but nothing pastes: raise `sleep 0.2` to `0.3`.
- Images can't be pasted into terminals.
