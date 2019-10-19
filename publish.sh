#!/bin/bash
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.3
## Date:    10.04.2017

# Uncomment to get debug info
# set -x
set -e

# Absolute path this script is in. /home/$USERNAME/dots
REPOPATH=`pwd $0`    # Set absolut path to script directory
DOT_FILES_DIR="${REPOPATH}/files"         # Set files directory
VIM_DIR="${HOME}/.vim"
GIT=`which git`
WGET=`which wget`
DOWNLOAD_EXTRA_BIN_FILES=(https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.dmg)
PYTHON_PACKAGE_FILE="${REPOPATH}/files/python3/default_packages.txt"

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

            if [ ! -e "${WGET}" ]
            then
                echo "wget not availabe please install!"
                exit 1
            fi

            cd ${HOME}/bin/
            for file in ${DOWNLOAD_EXTRA_BIN_FILES[*]}
            do
                ${WGET} -N -q ${file}
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

bootstrap_python() {
    python3=$(command -v python3)
    pip3=$(command -v pip3)
    if [[ -z "${python3}" ]]; then
        echo "Python3 not installed on your system."
        exit 127
    fi
    if [[ -z "${pip3}" ]]; then
        echo "Pip3 is not installed on your system."
        exit 127
    fi
    if [[ -f ${PYTHON_PACKAGE_FILE} ]]; then
        PIP_REQUIRE_VIRTUALENV="" $pip3 install virtualenvwrapper
        if [[ -x files/zshrc_custom/python_env_setup.sh ]]; then
            echo "Setting up default python virtual environment."
            source files/zshrc_custom/python_env_setup.sh
            mkvirtualenv -r ${PYTHON_PACKAGE_FILE} default
        else
            echo "python_env_setup.sh either not executable or not present."
        fi
    else
        echo "No Python3 bootstrap file present."
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
        -i)  fetch_submodules && bootstrap_python && rollout ;;
        -u)  cd $REPOPATH && git pull && fetch_submodules;;
        -h|-*|*)  usage;;
    esac
    shift
done
