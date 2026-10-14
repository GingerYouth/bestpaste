#!/usr/bin/env bash
# bestpaste: Win+V-style clipboard history for KDE Plasma (Wayland) on Arch.
# Usage: ./install.sh [--uninstall | --picker]
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
bin=$HOME/.local/bin/clip-paste
autostart=$HOME/.config/autostart/cliphist.desktop
app=$HOME/.local/share/applications/net.local.clip-paste.desktop
udev=/etc/udev/rules.d/80-uinput.rules
conf=$HOME/.config/bestpaste/picker
rc=kglobalshortcutsrc
grp=net.local.clip-paste.desktop

if [ "${1:-}" = --uninstall ]; then
  pkill -f 'wl-paste.*cliphist store' || true
  rm -rf "$bin" "$autostart" "$app" "$(dirname "$conf")"
  kwriteconfig6 --file $rc --group services --group $grp --key _launch --delete
  kwriteconfig6 --file $rc --group plasmashell --key show-on-mouse-pos "none,Meta+V,Show Clipboard Items at Mouse Position"
  sudo rm -f $udev
  echo "Removed. Packages and 'input' group membership left alone."
  exit 0
fi

ask_picker() {
  mkdir -p "$(dirname "$conf")"
  local a=1
  [ -t 0 ] && read -rp "Popup: [1] rofi (image gallery, clear-all)  [2] fuzzel (light, text only)  [1]: " a
  [ "$a" = 2 ] && echo fuzzel > "$conf" || echo rofi > "$conf"
}
if [ "${1:-}" = --picker ]; then
  ask_picker
  p=$(cat "$conf")
  sudo pacman -S --needed "$p"; [ "$p" = rofi ] && sudo pacman -S --needed imagemagick
  echo "Popup set to $p."
  exit 0
fi

[ "${XDG_SESSION_TYPE:-}" = wayland ] || { echo "Wayland session required." >&2; exit 1; }

# 1. packages (kdotool may be AUR-only)
[ -f "$conf" ] || ask_picker
picker=$(cat "$conf")
sudo pacman -S --needed cliphist wl-clipboard ydotool "$picker"
[ "$picker" = rofi ] && sudo pacman -S --needed imagemagick
command -v kdotool >/dev/null || sudo pacman -S --needed kdotool || yay -S --needed kdotool

# 2. ydotool: uinput access + user daemon
relog=
id -nG | grep -qw input || { sudo usermod -aG input "$USER"; relog=1; }
echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' | sudo tee $udev >/dev/null
sudo udevadm control --reload && sudo udevadm trigger
systemctl --user enable --now ydotool

# 3. clipboard watchers: autostart + start now (setsid so they outlive the terminal)
mkdir -p "$(dirname "$autostart")"
cat > "$autostart" <<'EOF'
[Desktop Entry]
Type=Application
Name=cliphist
Exec=sh -c 'wl-paste --type text --watch cliphist store & wl-paste --type image --watch cliphist store & wait'
EOF
for t in text image; do
  pgrep -f "wl-paste --type $t --watch" >/dev/null || setsid -f wl-paste --type $t --watch cliphist store
done

# 4. script
install -Dm755 "$here/clip-paste" "$bin"

# 5. Meta+V: free Klipper's key, bind ours
mkdir -p "$(dirname "$app")"
cat > "$app" <<EOF
[Desktop Entry]
Exec=$bin
Name=Clipboard paste
NoDisplay=true
StartupNotify=false
Type=Application
X-KDE-GlobalAccel-CommandShortcut=true
EOF
kwriteconfig6 --file $rc --group plasmashell --key show-on-mouse-pos "none,none,Show Clipboard Items at Mouse Position"
kwriteconfig6 --file $rc --group services --group $grp --key _launch Meta+V
systemctl --user restart plasma-kglobalaccel 2>/dev/null || true

echo "Done. Press Meta+V."
[ -z "$relog" ] || echo "Log out and back in once so the 'input' group applies (needed for pasting)."
echo "If Meta+V still opens Klipper: disable Clipboard in System Tray settings."
