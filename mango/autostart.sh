wlr-randr --output HDMI-A-1 --off
wlr-randr --output DP-3 --on --mode 1920x1080@143.981003 --pos 0,0

mako &

# Keep clipboard content after app closes
wl-clip-persist --clipboard regular --reconnect-tries 0 &
# Watch clipboard and store history
wl-paste --type text --watch cliphist store &

waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css >/dev/null 2>&1 &

swaybg -i /home/vavr0/Downloads/bg.png & disown

swayidle -w \
  lock 'pidof hyprlock || hyprlock' \
  timeout 3600 'loginctl lock-session' \
  timeout 4200 'wlopm --off "*"' resume 'wlopm --on "*"' &
