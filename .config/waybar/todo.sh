#!/usr/bin/env bash

DATA_DIR="$HOME/.local/share/waybar-todo"
DATA_FILE="$DATA_DIR/tasks.tsv"
SETTINGS_FILE="$DATA_DIR/settings.conf"

mkdir -p "$DATA_DIR"
touch "$DATA_FILE" "$SETTINGS_FILE"

AUTO_DEL_TIME=$(grep '^AUTO_DEL_TIME=' "$SETTINGS_FILE" | cut -d'=' -f2)
MID_ACTION=$(grep '^MID_ACTION=' "$SETTINGS_FILE" | cut -d'=' -f2)
MID_ACTION=${MID_ACTION:-completed}

if [ -n "$AUTO_DEL_TIME" ]; then
    CUR_TIME=$(date +%H:%M)
    if [ "$CUR_TIME" == "$AUTO_DEL_TIME" ]; then
        > "$DATA_FILE"
    fi
fi

format_tasks() {
    sort -t'|' -k1,1n -k2,2n "$DATA_FILE"
}

case "$1" in
    --waybar)
        PENDING_COUNT=$(awk -F'|' '$1=="0"' "$DATA_FILE" | wc -l)
        if [ "$PENDING_COUNT" -gt 0 ]; then
            TOP_TASK=$(format_tasks | awk -F'|' '$1=="0"{print $3; exit}')
            CLASS="pending"
        else
            TOP_TASK="All done!"
            CLASS="clear"
        fi
        
        TOOLTIP=$(format_tasks | awk -F'|' '{
            if ($1=="1") { prefix="✅" } else { prefix="⏳ P"$2 }
            print prefix " " $3
        }' | sed -z 's/\n/\\n/g' | sed 's/\\n$//')
        
        [ -z "$TOOLTIP" ] && TOOLTIP="Список порожній"
        
        jq -n -c --arg text " $TOP_TASK" --arg tooltip "$TOOLTIP" --arg class "$CLASS" \
        '{"text": $text, "tooltip": $tooltip, "class": $class}'
        ;;
        
    --add)
        INPUT=$(rofi -dmenu -p "➕ Нова задача (Пріоритет Текст):")
        if [ -n "$INPUT" ]; then
            if [[ "$INPUT" =~ ^([0-9]+)\ (.*)$ ]]; then
                echo "0|${BASH_REMATCH[1]}|${BASH_REMATCH[2]}" >> "$DATA_FILE"
            else
                echo "0|9|$INPUT" >> "$DATA_FILE"
            fi
        fi
        ;;
        
    --rofi)
        while true; do
            MENU="➕ Додати задачу\n⚙️ Налаштування\n🗑️ Видалити виконані\n🗑️ Очистити все\n"
            TASKS=$(format_tasks | awk -F'|' '{
                if ($1=="1") { icon="✅" } else { icon="⏳" }
                print NR " | " icon " [P"$2"] " $3
            }')
            
            CHOICE=$(echo -e "$MENU$TASKS" | rofi -dmenu -p "Задачі:" -i -format i,s)
            [ -z "$CHOICE" ] && exit 0
            
            INDEX=$(echo "$CHOICE" | cut -d',' -f1)
            TEXT=$(echo "$CHOICE" | cut -d',' -f2-)
            
            case "$INDEX" in
                0) "$0" --add ;;
                1) "$0" --settings ;;
                2) awk -F'|' '$1=="0"' "$DATA_FILE" > "$DATA_FILE.tmp" && mv "$DATA_FILE.tmp" "$DATA_FILE" ;;
                3) > "$DATA_FILE" ;;
                *)
                    TASK_LINE=$(echo "$TEXT" | cut -d'|' -f1 | tr -d ' ')
                    NEW_STATUS=$(format_tasks | sed -n "${TASK_LINE}p" | awk -F'|' '{print 1-$1}')
                    awk -F'|' -v r="$TASK_LINE" -v ns="$NEW_STATUS" 'NR==r {$1=ns}1' OFS='|' <(format_tasks) > "$DATA_FILE.tmp" && mv "$DATA_FILE.tmp" "$DATA_FILE"
                    ;;
            esac
        done
        ;;
        
    --settings)
        S_CHOICE=$(echo -e "Автовидалення ($AUTO_DEL_TIME)\nДія на клік коліщатком ($MID_ACTION)" | rofi -dmenu -p "Налаштування:")
        if [[ "$S_CHOICE" == "Автовидалення"* ]]; then
            NEW_TIME=$(rofi -dmenu -p "Час (HH:MM або порожньо для вимкнення):")
            sed -i '/^AUTO_DEL_TIME=/d' "$SETTINGS_FILE"
            [ -n "$NEW_TIME" ] && echo "AUTO_DEL_TIME=$NEW_TIME" >> "$SETTINGS_FILE"
        elif [[ "$S_CHOICE" == "Дія на клік"* ]]; then
            NEW_ACT=$(echo -e "completed\nall" | rofi -dmenu -p "Дія (completed/all):")
            if [ -n "$NEW_ACT" ]; then
                sed -i '/^MID_ACTION=/d' "$SETTINGS_FILE"
                echo "MID_ACTION=$NEW_ACT" >> "$SETTINGS_FILE"
            fi
        fi
        ;;
        
    --mark-done)
        awk -F'|' 'BEGIN {done=0} $1=="0" && done==0 {$1="1"; done=1} 1' OFS='|' <(format_tasks) > "$DATA_FILE.tmp" && mv "$DATA_FILE.tmp" "$DATA_FILE"
        ;;
        
    --middle-click)
        if [ "$MID_ACTION" == "all" ]; then
            > "$DATA_FILE"
        else
            awk -F'|' '$1=="0"' "$DATA_FILE" > "$DATA_FILE.tmp" && mv "$DATA_FILE.tmp" "$DATA_FILE"
        fi
        ;;
esac