#!/bin/bash

shutdown="⏻ Вимкнути"
reboot=" Перезавантажити"
suspend="󰒲 Сон"
logout="󰗽 Вийти (Hyprland)"
lock=" Заблокувати"

chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$logout" "$lock" | wofi --conf /dev/null --dmenu -i --width 190 --height 205 --style ~/.config/wofi/power.css --cache-file /dev/null)

case "$chosen" in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$suspend") systemctl suspend ;;
    "$logout") hyprctl dispatch exit ;;
    "$lock") hyprlock ;; 
esac