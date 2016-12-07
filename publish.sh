#!/bin/sh
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.1
## Date:    09/26/2016

# Absolute path this script is in. /home/user/bin
REPOPATH=`dirname $(readlink -f $0)`    # Set absolut path to script directory
DOT_FILES_DIR="$REPOPATH/files"         # Set files directory
DOT_BACKUP_DIR="$HOME/dots_backup"      # Set Backup directory

rollout() {
    echo "Doing backups of your current files"
    echo "you will find your old files in ${DOT_BACKUP_DIR}"

    cd $DOT_FILES_DIR

    for DOT_FILE in `ls`
    do
        # Deployment function
        cp -r ${DOT_FILES_DIR}/${DOT_FILE} ${HOME}/.${DOT_FILE} 2> /dev/null
    done
}

backup () {

    for DOT_FILE in `ls`
    do
        # Backup function
        if [ ! -d ${DOT_BACKUP_DIR} ]
        then
            mkdir ${DOT_BACKUP_DIR}
        fi

        if [ -f ${HOME}/.${DOT_FILE} ]
        then
            echo "Backup: .${DOT_FILE}"
            mv ${HOME}/.${DOT_FILE} ${DOT_BACKUP_DIR}/${DOT_FILE}.bak
        fi
    done
}

usage () {
    echo -e "HELP:"
    echo -e "\t-i install local files"
    echo -e "\t-u to upgrade all dotfiles"
    echo -e "\t-s to check for updates"
    echo -e "\t-h for help"
}

while [ $# -gt 0 ]
do
    case $1 in
        -b)  backup;;
        -i)  rollout;;
        -u)  cd $REPOPATH && git pull && rollout;;
        -s)  cd $REPOPATH && git status;;
        -h|-*|*)  usage && return;;
    esac
    shift
done
