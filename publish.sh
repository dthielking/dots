#!/bin/bash
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.3
## Date:    10.04.2017

# Uncomment to get debug info
# set -x

# Absolute path this script is in. /home/$USERNAME/dots
REPOPATH=`dirname $(readlink -f $0)`    # Set absolut path to script directory
DOT_FILES_DIR="${REPOPATH}/files"         # Set files directory
VIM_DIR="${HOME}/.vim"
GIT=`which git`

rollout() {
    cd ${DOT_FILES_DIR}

    for DOT_FILE in `ls`
    do
        if [[ ${DOT_FILE} = "config" ]]
        then
            if [[ ! -d ~/.config ]]
            then
                mkdir -p ~/.config
            fi

            CONFIG_FILES=`ls ./config`
            if [[ ! -L ~/.config/${CONFIG_FILES} ]]
            then
                ln -s ${DOT_FILES_DIR}/config/${CONFIG_FILES} ~/.config/${CONFIG_FILES}
            fi
        else
            if [[ ! -L ~/.${DOT_FILE}  ]]
            then
                # Link function
                ln -s ${DOT_FILES_DIR}/${DOT_FILE} ~/.${DOT_FILE} 2> /dev/null
            fi
        fi
    done
}

fetch_submodules() {
    echo "Fetching all submodules for you"
    echo "This will take few minutes"
    cd ${REPOPATH}

    if [[ -x ${GIT} ]]
    then
        UPDATED_MODULES=`${GIT} submodule update --init --recursive --quiet`
    fi

    if [[ $? -eq 0 ]]
    then
        echo "Fetching completed"
    else
        echo "Fetching failed"
    fi
}


usage () {
    echo -e "HELP:"
    echo -e "\t-i install local files"
    echo -e "\t-u updates all local submodules"
    echo -e "\t-h for help"
}

while [ $# -gt 0 ]
do
    case $1 in
        -i)  fetch_submodules && rollout ;;
        -u)  cd $REPOPATH && git pull && fetch_submodules;;
        -h|-*|*)  usage;;
    esac
    shift
done
