#!/usr/bin/env bash
# Модуль вывода сообщений

messages_HEADER_BACKGROUND="GREEN"
messages_HEADER_FOREGROUND="YELLOW"
messages_HEADER_TYPE=""

# Выводит сообщение об ошибке
# @param string         Сообщение об ошибке
# @param int default 0  Поток для вывода: 0 - stderr, 1 - stdout
function messages.showError ()
{
    if [[ -z "${1:-}" ]]
    then
        return 0
    fi
    if [[ ${2:-0} -eq 0 ]]
    then
        >&2 echo "ERROR: $1"
    else
        screen.setColor red
        echo "ERROR: $1"
        screen.resetColor
    fi
}

# Выводит заголовок в stdout
# @param string             Текст заголовка
# @param int default 80     Ширина заголовка: 0..10 - автоопределение по размерам консоли, остальные положительные значения, количество символов | Пока реализовано только указание количества символов.
# @param int default -1     Расположение заголовка: -1 - слева, 0 - посередине, 1 - справа | Пока не реализовано
function messages.showHeader ()
{
    if [[ -z ${1:-} ]]
    then
        return 0
    fi
    local SCREEN_WIDTH=80
    if [[ -n ${2:-} ]]
    then
        SCREEN_WIDTH="$2"
    fi
    local TITLE
    if [[ $(strings.length "$1") -gt $((${SCREEN_WIDTH} - 4)) ]]
    then
        local PRE_TITLE=$(strings.cut "$1" $((${SCREEN_WIDTH} - 7)) 1)
        TITLE=$(strings.pad "$PRE_TITLE..." $((${SCREEN_WIDTH} - 2)))
    else
        TITLE=$(strings.pad "$1" $((${SCREEN_WIDTH} - 2)))
    fi
    local TITLE_PREPARE=$(strings.pad "$(strings.cut "$1" 36 1)" 38)
    screen.setColor "$messages_HEADER_FOREGROUND" "$messages_HEADER_TYPE" "$messages_HEADER_BACKGROUND" && echo $(strings.fill "$SCREEN_WIDTH" "#") && screen.resetColor
    screen.setColor "$messages_HEADER_FOREGROUND" "$messages_HEADER_TYPE" "$messages_HEADER_BACKGROUND" && echo "#$TITLE#" && screen.resetColor
    screen.setColor "$messages_HEADER_FOREGROUND" "$messages_HEADER_TYPE" "$messages_HEADER_BACKGROUND" && echo $(strings.fill "$SCREEN_WIDTH" "#") && screen.resetColor
    echo ""
}

# Выводит текст ошибки в stderr
function messages.showStdError()
{
    if [ -n "$1" ]
    then
        setColor red "bold blink"
        >&2 echo -en "ERROR: "
        resetColor
        setColor red
        >&2 echo -e $@
        resetColor
        return 0
    fi
    return 1
}

# Выводит текст ошибки в stdout с форматированием
function messages.showError()
{
    if [ -n "$1" ]
    then
        setColor red "bold blink"
        echo -en "ERROR: "
        resetColor
        setColor red
        echo -e $@
        resetColor
        return 0
    fi
    return 1
}

# Выводит предупреждение в stdout с форматированием
function messages.showWarning()
{
    if [ -n "$1" ]
    then
        setColor yellow bold
        echo -en "WARNING: "
        resetColor
        setColor yellow
        echo -e $@
        resetColor
        return 0
    fi
    return 1
}

# Выводит сообщение в stdout
function messages.showMessage()
{
    if [ -n "$1" ]
    then
        echo -e "MESSAGE: $@"
        return 0
    fi
    return 1
}

# Выводит сообщение в stdout и запрашивает пользовательские данные
function messages.showPromt()
{
    if [ -n "$1" ]
    then
        echo -en "$@: "
        read
        return 0
    fi
    return 1
}
