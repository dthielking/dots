#!/bin/sh
## Usage:   publish.sh
## Purpose: Publish all dotfiles into appropriate directories
## Author:  Daniel Thielking
## Mail:    github@thielking-vonessen.de
## Version: 0.1
## Date:    09/26/2016

# Absolute path this script is in. /home/user/bin
REPOPATH=`dirname $(readlink -f $0)`					# Set absolut path to script directory
DOT_FILES_DIR="$REPOPATH/files"							# Set files directory
DOT_BACKUP_DIR="$HOME/dots_backup"						# Set Backup directory


echo "Doing backups of your current files"
echo "you will find your old files in ${DOT_BACKUP_DIR}"

cd $DOT_FILES_DIR

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

		if [ -f ${DOT_BACKUP_DIR}/${DOT_FILE}.bak ]
		then
			# Deployment function
			cp ${DOT_FILES_DIR}/${DOT_FILE} ${HOME}/.${DOT_FILE}
		fi
done
