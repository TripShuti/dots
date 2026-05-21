STATE_FILE="/tmp/waybar_timer"
DUR_FILE="/tmp/waybar_timer_duration"

if [ -f "$DUR_FILE" ]; then
    TIMER_MINUTES=$(cat "$DUR_FILE")
else
    TIMER_MINUTES=25
    echo "$TIMER_MINUTES" > "$DUR_FILE"
fi

case $1 in
    toggle)
        if [ -f "$STATE_FILE" ]; then
            rm -f "$STATE_FILE"
        else
            echo $(( $(date +%s) + TIMER_MINUTES * 60 )) > "$STATE_FILE"
        fi
        ;;
    up)
        if [ ! -f "$STATE_FILE" ]; then
            echo $(( TIMER_MINUTES + 1 )) > "$DUR_FILE"
        fi
        ;;
    down)
        if [ ! -f "$STATE_FILE" ]; then
            NEW_MIN=$(( TIMER_MINUTES - 1 ))
            [ $NEW_MIN -lt 1 ] && NEW_MIN=1
            echo "$NEW_MIN" > "$DUR_FILE"
        fi
        ;;
update)
        while true; do
            if [ -f "$DUR_FILE" ]; then
                TIMER_MINUTES=$(cat "$DUR_FILE")
            else
                TIMER_MINUTES=25
            fi

            if [ -f "$STATE_FILE" ]; then
                END_TIME=$(cat "$STATE_FILE")
                CUR_TIME=$(date +%s)
                LEFT=$(( END_TIME - CUR_TIME ))

                if [ $LEFT -le 0 ]; then
                    rm -f "$STATE_FILE"
                    notify-send -u critical "Таймер" "Час вийшов!"
                    (for i in {1..3}; do paplay /usr/share/sounds/freedesktop/stereo/complete.oga; sleep 0.5; done) &
                    echo '{"text": "󰂚 00:00", "class": "done"}'
                else
                    MIN=$(( LEFT / 60 ))
                    SEC=$(( LEFT % 60 ))
                    printf '{"text": "󱎫 %02d:%02d", "class": "running"}\n' $MIN $SEC
                fi
            else
                echo '{"text": "󱎫 '$TIMER_MINUTES':00", "class": "idle"}'
            fi
            
            sleep 1
        done
        ;;
esac