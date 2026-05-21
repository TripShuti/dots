
shutdown="⏻ Вимкнути"
reboot=" Перезавантажити"
suspend="󰒲 Сон"
logout="󰗽 Вийти (Hyprland)"
lock=" Заблокувати"

chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$logout" "$lock" | rofi -dmenu -i -theme-str 'window { width: 300px; } inputbar { enabled: false; } listview { lines: 5; }')
case "$chosen" in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$suspend") systemctl suspend ;;
    "$logout") hyprctl dispatch exit ;;
    "$lock") hyprlock ;; 
esac
