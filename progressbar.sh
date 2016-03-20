#!/bin/bash

# Made in 2016 by Enrico Lamperti
# https://github.com/elamperti/bash-progressbar

# ToDo: Maybe calc width according to available cols?
#       I kinda like it with this fixed value though.
pb_width=40
pb_prog_char="#"
pb_fill_char="."
pb_done_msg=""

# Params: progress [pb_total_items=100] [message]
progressbar() {
    trap "tput cnorm" EXIT

    [ -n "$1" ] || return 1

    if [ ${1,,} == "start" ]; then
        local pb_count=0
        local is_starting=1
    else
        local pb_count=$1
    fi

    if [ -z "$2" ]; then
        local pb_total=100
    else
        local pb_total=$2
    fi


    if [ ${1,,} == "finish" ]; then
        local pb_total=100
        local pb_count=$pb_total
        if [ -z "$2" ]; then
            local pb_message=$pb_done_msg
        else
            local pb_message=$2
        fi
    else
        # are args numeric?
        if [ ! "$pb_count" -eq "$pb_count" ] \
        || [ ! "$pb_total" -eq "$pb_total" ] 2>/dev/null; then
            return 1
        fi
        local pb_message=$3
    fi

    [ $pb_count -gt $pb_total ] && pb_count=$pb_total

    local percentage=$(awk "BEGIN { pc=100*${pb_count}/${pb_total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
    local completeness=$(awk "BEGIN { pc=$pb_width*${percentage}/100; i=int(pc); print (pc-i>0.1)?i+1:i }")


    tput civis
    if [ -n "$is_starting" ]; then
        tput sc
        echo $(date)
    fi
    get_cur_pos pb_origin
    tput rc
    tput el
    echo -ne "  ["
    printf %${completeness}s |tr " " $pb_prog_char
    printf %$((${completeness}-${pb_width}))s |tr " " $pb_fill_char
    echo -e "] (`printf "%-3s" ${percentage}`%) $pb_message"
    tput cup ${pb_origin[0]} ${pb_origin[1]}
    tput cud 1
    tput cnorm
}

# Black magic to get cursor position
# https://askubuntu.com/a/366158/198486
get_cur_pos() {
    export $1
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    eval "$1[0]=$((${pos[0]:2} - 2))"
    eval "$1[1]=$((${pos[1]} - 1))"
}
