#!/usr/bin/env bash

# Проверяет, существует ли пользователь в системе.
# @param string userName Имя пользователя.
function system.hasUser ()
{
    if [[ -n ${1:-} ]]
    then
        grep -e "^$1:" /etc/passwd > /dev/null 2>&1
        return "$?"
    fi
    return 1
}

# Проверяет, существует ли группа в системе.
# @param string groupName Имя группы.
function system.hasGroup ()
{
    if [[ -n ${1:-} ]]
    then
        grep -e "^$1:" /etc/group > /dev/null 2>&1
        return "$?"
    fi
    return 1
}

# Показывает пользователей, которые включены в группу.
# @param string groupName Имя группы, для которой нужно показать пользователей, которые в нее включены.
function system.usersInGroup ()
{
    if [[ -n ${1:-} && $(system.hasGroup "$1") -eq 0 ]]
    then
        declare -a RESULT
        local IDX=0
        local GROUP_LINE=$(grep -e "^$1:" /etc/group)
        local USERS_LIST=$(echo "$GROUP_LINE" | awk -F ":" '{print $4}')
        local GROUP_ID=$(echo "$GROUP_LINE" | awk -F ":" '{print $3}')
        echo "$USERS_LIST"
        return 0
    fi
    return 1
}

#
# @param string userName Имя пользователя, для которого нужно показать группы, в которые он включен.
function system.userGroups ()
{
    return 0
}
