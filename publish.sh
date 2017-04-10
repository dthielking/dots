#!/bin/bash
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.3
## Date:    10.04.2017

# Absolute path this script is in. /home/$USERNAME/dots
REPOPATH=`dirname $(readlink -f $0)`    # Set absolut path to script directory
DOT_FILES_DIR="${REPOPATH}/files"         # Set files directory
GITHUB_URL="https://github.com"
VIM_DIR="${HOME}/.vim"
VIM_BUNDLE="${VIM_DIR}/bundle"
declare -a GIT_REPOS
GIT_REPOS=(
        'vim-airline/vim-airline'
        'pearofducks/ansible-vim'
        'rodjek/vim-puppet'
        'vim-syntastic/syntastic'
        'Valloric/YouCompleteMe'
    )

rollout() {
    cd ${DOT_FILES_DIR}

    for DOT_FILE in `ls`
    do
        # Deployment function
        cp -r -f ${DOT_FILES_DIR}/${DOT_FILE} ${HOME}/.${DOT_FILE} 2> /dev/null
    done
}

gitclone() {
    echo "Cloning all your Configured Git Repositorys for vim"

    if [ -e ${VIM_BUNDLE} ]
    then
        cd ${VIM_BUNDLE}
    else
        mkdir -p ${VIM_BUNDLE}
        cd ${VIM_BUNDLE}
    fi

    for REPO in ${GIT_REPOS[*]}
    do
        REPO_DIR=$(echo $REPO | cut -f2 -d "/")
        if [ -e ${VIM_BUNDLE}/${REPO_DIR} ]
        then
            git --git-dir=${VIM_BUNDLE}/${REPO_DIR}/.git --work-tree=${VIM_BUNDLE}/${REPO_DIR} pull
        else
            git clone ${GITHUB_URL}/${REPO}
            if [ ${REPO_DIR} = 'YouCompleteMe' ]
            then
                cd ${VIM_BUNDLE}/${REPO_DIR}
                git submodule update --init --recursive
                ./install.py
            fi
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
        -i)  rollout && gitclone;;
        -g)  gitclone;;
        -u)  cd $REPOPATH && git pull && rollout;;
        -s)  cd $REPOPATH && git status;;
        -h|-*|*)  usage && return;;
    esac
    shift
done
