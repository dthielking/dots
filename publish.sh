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
        # Link function
        ln -s ${DOT_FILES_DIR}/${DOT_FILE} ~/.${DOT_FILE} 2> /dev/null
    done
}

fetch_submodules() {
    echo -e "\e[32mFetching all submodules for you"
    echo -e "\e[32mThis will take few minutes"
    cd ${REPOPATH}

    if [[ -x ${GIT} ]]
    then
        UPDATED_SUBMODULE=`$GIT submodule update --init --recursive --quiet`
    fi

    if [[ $? -eq 0 ]]
    then
        echo -e "Fetching completed"
    else
        echo -e "\e[31mFetching failed\n"
        echo "\e[31m$UPDATED_SUBMODULE"
    fi
}

install_youcompleteme() {
    echo -e "\e[32mInstalling YouCompleteMe"
    if [[ -x "${DOT_FILES_DIR}/vim/bundle/YouCompleteMe/install.py" ]]
    then
        cd "${DOT_FILES_DIR}/vim/bundle/YouCompleteMe"
        ./install.py > /dev/null
    fi
}

usage () {
    echo -e "HELP:"
    echo -e "\t-i install local files"
    echo -e "\t-h for help"
}

while [ $# -gt 0 ]
do
    case $1 in
        -i)  fetch_submodules && install_youcompleteme && rollout ;;
        -u)  cd $REPOPATH && git pull && fetch_submodules;;
        -h|-*|*)  usage && return;;
    esac
    shift
done
