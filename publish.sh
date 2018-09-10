#!/bin/bash
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.3
## Date:    10.04.2017

# Uncomment to get debug info
set -x

# Absolute path this script is in. /home/$USERNAME/dots
REPOPATH=`dirname $(readlink -f $0)`    # Set absolut path to script directory
DOT_FILES_DIR="${REPOPATH}/files"         # Set files directory
VIM_DIR="${HOME}/.vim"
GIT=`which git`
DOWNLOAD_EXTRA_BIN_FILES=(https://raw.githubusercontent.com/dthielking/az-sub-loader/master/az-sub-loader.py
    https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
    https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_windows_amd64.zip
    https://raw.githubusercontent.com/Azure/azure-cli/master/az.completion)

rollout() {
    cd ${DOT_FILES_DIR}

    DOT_FILES=`ls`
    for DOT_FILE in ${DOT_FILES[*]}
    do
        if [[ ${DOT_FILE} = config ]]
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
        elif [[ ${DOT_FILE} = bin ]]
        then
            if [[ ! -d ~/bin ]]
            then
                mkdir -p ~/bin
            fi

            BIN_FILES=`ls ./bin`
            for bin_file in ${BIN_FILES[*]}
            do
                if [[ ! -L ~/bin/${bin_file} ]]
                then
                    ln -s ${DOT_FILES_DIR}/bin/${bin_file} ~/bin/${bin_file}
                fi
            done

            cd ${HOME}/bin/
            for file in ${DOWNLOAD_EXTRA_BIN_FILES[*]}
            do
                wget -N -q ${file}
            done

            BIN_ZIPS=`find . -iname "*.zip"`
            for zips in $BIN_ZIPS
            do
                unzip -qf ${zips}
                rm -f ${zips}
            done
            chmod +x ./*
            cd - > /dev/null
        else
            if [[ ! -L ~/.${DOT_FILE} ]]
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
