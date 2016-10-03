#!/usr/bin/env bash
# Модуль для работы с текстовыми строками

# Дополняет строку символами
# @param string                 Исходная строка
# @param int                    До скольки символов дополнять
# @param int    default 0       С какой стороны дополнять -1 - слева, 0 - с обеих, 1 - справа
# @param string default " "     Каким символом дополнять
function strings.pad ()
{
    if [[ -z "${1:-}" ]]
    then
        strings._emptyStringException
        return 1
    fi
    if [[ -z "${2:-}" ]]
    then
        strings._emptyLimitException
        return 1
    fi
    local FILL_CHAR=" "
    if [[ -n "${4:-}" ]]
    then
        FILL_CHAR="$4"
    fi
    local SUB_RESULT="$1"
    local SOURCE="$1"
    local SOURCE_LEN=$(strings.length "$SOURCE")
    local DEST_LENGTH="$2"
    local LEN_DIFF=$((${DEST_LENGTH} - ${SOURCE_LEN}))
    if [[ "$LEN_DIFF" -gt 0 ]]
    then
        SUB_RESULT=""
        case "${3:-}" in
            -1)
                SUB_RESULT="$(strings.fill $LEN_DIFF $FILL_CHAR)$SOURCE"
                ;;
            1)
                SUB_RESULT="$SOURCE$(strings.fill $LEN_DIFF $FILL_CHAR)"
                ;;
            *)
                local LAST_PART_LEN=$((${LEN_DIFF} / 2))
                local FIRST_PART_LEN=$((${LEN_DIFF} - ${LAST_PART_LEN}))
                SUB_RESULT="$(strings.fill $FIRST_PART_LEN $FILL_CHAR)$SOURCE"
                SUB_RESULT="$SUB_RESULT$(strings.fill $LAST_PART_LEN $FILL_CHAR)"
                ;;
        esac
    fi
    echo "$SUB_RESULT"
    return 0
}

# Обрезает строку до заданной длинны
# @param string             Исходная строка
# @param int                До какой длинны обрезать
# @paran int default 1      С какой стороны обрезать -1 - слева, 0 - с обеих, 1 - справа
function strings.cut ()
{
    if [[ -z "${1:-}" ]]
    then
        strings._emptyStringException
        return 1
    fi
    if [[ -z "${2:-}" ]]
    then
        strings._emptyLimitException
        return 1
    fi

    local SUB_RESULT="$1"
    local SOURCE="$1"
    local SOURCE_LEN=$(strings.length "$SOURCE")
    local DEST_LEN="$2"
    local LEN_DIFF=$((${SOURCE_LEN} - ${DEST_LEN}))

    if [[ "$LEN_DIFF" -gt 0 ]]
    then
        case "${3:-}" in
            -1)
                SUB_RESULT=${SOURCE:${LEN_DIFF}:${DEST_LEN}}
                ;;
            1)
                SUB_RESULT=${SOURCE:0:${DEST_LEN}}
                ;;
            *)
                local LAST_PART_LEN=$((${LEN_DIFF} / 2))
                local FIRST_PART_LEN=$((${LEN_DIFF} - ${LAST_PART_LEN}))
                SUB_RESULT=${SOURCE:${FIRST_PART_LEN}:${DEST_LEN}}
                ;;
        esac
    fi
    echo "$SUB_RESULT"
    return 0
}

# Вычисление длинны строки
# @param string             Исходная строка
function strings.length ()
{
    if [[ -z "${1:-}" ]]
    then
        strings._emptyStringException
        return 1
    fi
    echo "${#1}"
    return 0
}

# Создает строку, определенной длинны, заполненую определенными символами.
# @param string                 Исходная строка
# @param int                    Лимит символов
# @param string default " "     Каким символом дополнять
function strings.fill ()
{
    if [[ -z "${1:-}" ]]
    then
        strings._emptyLimitException
        return 1
    fi
    local FILL_CHAR
    if [[ -z "${2:-}" ]]
    then
        FILL_CHAR=" "
    else
        FILL_CHAR="$2"
    fi
    local SUB_RESULT=""
    local I
    for (( I=1; I<="$1"; I++ ))
    do
        SUB_RESULT="$FILL_CHAR$SUB_RESULT"
    done
    echo "$SUB_RESULT"
    return 0
}

# Переводит строку в верхний регистр
# @param string             Исходная строка
function strings.toUpper ()
{
    if [[ -z "${1:-}" ]]
    then
        strings._emptyStringException
        return 1
    fi
    echo $(echo "$1" | sed 's/.*/\U&/')
}

# Переводит строку в нижний регистр
# @param string             Исходная строка
function strings.toLower ()
{
    if [[ -z "${1:-}" ]]
    then
        strings._emptyLimitException
        return 1
    fi
    echo $(echo "$1" | sed 's/.*/\L&/')
}

# Вставляет в stdout разрыв строки
function strings.newLine ()
{
    echo -en "\n"
}

# Исключение, не указана исходная строка
function strings._emptyStringException()
{
    messages.showError "Не допускается использование пустой строки."
}

# Исключение, не указан лимит символов
function strings._emptyLimitException()
{
    messages.showError "Необходимо указать лимит символов"
}
