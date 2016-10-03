#!/usr/bin/env bash
# Модуль для работы с экраном
#
# getColorIndex($colorName) - Получить индекс цвета, по его названию
# getModeIndex($modeName) - Получить индекс режима, по его названию
# setColor($colorName, "$modeName ..." = empty, $backgroundColor = empty) - Установить цвет и режим текста и цвет фона
# setFontColor($colorName) - Установить цвет текста
# setFontMode("$modeName ...") - Установить режим текста
# setBackgroundColor($colorName) - Установить цвет фона
# resetColor() - Сросить установленные настройки текста и фона
# clearScreen() - Очистить экран
# clearToEndScreen() - Очистить экран с текущего символа, до конца экрана
# clearToBeginingLine() - Очистить строку с начала до текущего символа
# clearToEndLine() - Очистить строку с текущего символа, до конца строки
# bell() - Звонок
#
# Допустимые цвета:
#   black,
#   red,
#   green,
#   yellow,
#   blue,
#   magenta,
#   cyan,
#   white
# Допустимые режимы:
#   bold - Жирный,
#   dim - Режим половинной яркости,
#   smul - Начало подчеркивания,
#   rmul - Окончание подчеркивания (deprecated),
#   rev - Обратный видеорежим,
#   smso - Начать режим standout,
#   rmso - Завершить режим standout (deprecated),
#   blink - Мерцание
#   eo - Забивать лишние символы пробелом

screen_COLORS=([0]=black [1]=red [2]=green [3]=yellow [4]=blue [5]=magenta [6]=cyan [7]=white)
screen_MODES=([0]=bold [1]=dim [2]=smul [3]=rev [4]=smso [5]=blink [6]=eo)

function screen.getColorIndex()
{
    if [[ -n "${1:-}" ]]
    then
        local IDX=0;
        local COUNT=${#screen_COLORS[@]}
        local REQUEST_COLOR=$(strings.toLower "$1")
        while [ "$IDX" -lt "$COUNT" ]
        do
            if [[ ${screen_COLORS[$IDX]} == $REQUEST_COLOR ]]
            then
                local INDEX=$IDX
                IDX=$COUNT
            fi
            let "IDX=$IDX + 1"
        done
        if [[ -n "${INDEX:-}" ]]
        then
            echo "$INDEX"
            return 0
        fi
    fi
    screen._colorNotFoundScreenModuleException "$1"
    return 1
}

function screen.getModeIndex()
{
    if [ -n "$1" ]
    then
        local IDX=0;
        local COUNT=${#screen_MODES[@]}
        local REQUEST_MODE=$(strings.toLower "$1")
        while [ "$IDX" -lt "$COUNT" ]
        do
            if [[ ${screen_MODES[$IDX]} == $REQUEST_MODE ]]
            then
                local INDEX=$IDX
                IDX=$COUNT
            fi
            let "IDX=$IDX + 1"
        done
        if [ -n "${INDEX:-}" ]
        then
            echo "$INDEX"
            return 0
        fi
    fi
    screen._modeNotFoundScreenModuleException "$1"
    return 1
}

# input params textColor textMode backgroundColor
function screen.setColor()
{
    if [ -n "${1:-}" ]
    then
        screen.setFontColor "$1"
    fi
    if [ -n "${2:-}" ]
    then
        screen.setFontMode "$2"
    fi
    if [ -n "${3:-}" ]
    then
        screen.setBackgroundColor "$3"
    fi
}

function screen.setFontColor()
{
    local INDEX
    if [[ "$1" =~ "^[0-9]+$" ]]
    then
        INDEX=$1
    else
        INDEX=$(screen.getColorIndex $1)
    fi
    if [ "$?" -eq 0 -a -n "$INDEX" ]
    then
        tput setaf "$INDEX"
        return 0
    fi
    return 1
}

function screen.setBackgroundColor()
{
    local INDEX
    if [[ "$1" =~ "^[0-9]+$" ]]
    then
        INDEX=$1
    else
        INDEX=$(screen.getColorIndex $1)
    fi
    if [ "$?" -eq 0 -a -n "$INDEX" ]
    then
        tput setab "$INDEX"
        return 0
    fi
    return 1
}

function screen.setFontMode()
{
    if [ -n "$1" ]
    then
        local SET_MODES=($1)
        local IDX=0;
        local COUNT=${#SET_MODES[@]}
        while [ "$IDX" -lt "$COUNT" ]
        do
            INDEX=$(screen.getModeIndex $1)
            if [ "$?" -eq 0 -a -n "$INDEX" ]
            then
                tput ${screen_MODES[$INDEX]}
                #case "$INDEX" in
                #    [0-6]* )
                #        tput ${SET_MODES[$IDX]}
                #        ;;
                #    "7" )
                #        echo -e "\e[5;m"
                #        ;;
                #esac
            fi
            let "IDX=$IDX + 1"
        done
    fi
    return 0
}

function screen.resetColor()
{
    tput sgr0
    screen.clearToEndLine
}

function screen.clearScreen()
{
    tput clear
}

function screen.clearToEndScreen()
{
    tput ed
}

function screen.clearToBeginingLine()
{
    tput el 1
}

function screen.clearToEndLine()
{
    tput el
}

function screen.bell()
{
    tput bell
}

# Restrict area
function screen._run_tput_command()
{
    tput clear
}

function screen._colorNotFoundScreenModuleException()
{
    messages.showError "Color \"$1\" not found."
}

function screen._modeNotFoundScreenModuleException()
{
    messages.showError "Mode \"$1\" not found."
}
