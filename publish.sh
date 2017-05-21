#!/bin/bash
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.3
## Date:    10.04.2017
set -x
# Absolute path this script is in. /home/$USERNAME/dots
REPOPATH=`dirname $(readlink -f $0)`    # Set absolut path to script directory
DOT_FILES_DIR="${REPOPATH}/files"         # Set files directory
GITHUB_URL="https://github.com"
VIM_DIR="${HOME}/.vim"
VIM_BUNDLE="${VIM_DIR}/bundle"
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
    cd ${REPOPATH}

    if [[ -x ${GIT} ]]
    then
            $GIT submodule update --init --recursive
    fi
}

install_youcompleteme() {
    if [[ -x "${DOT_FILES_DIR}/vim/bundle/YouCompleteMe/install.py" ]]
    then
        cd ${VIM_BUNDLE}/YouCompleteMe
        ./install.py
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
