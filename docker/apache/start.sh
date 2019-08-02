#!/bin/bash


if [ "x$GIT_URL" != "x" ]; then
	git clone -b $GIT_BRANCH $GIT_URL /var/www
	if [[ $? != 0 ]]; then
		echo "failed to clone project"
		exit 1;
	fi



fi

# run cron if set
if [ "x$PERSISTENT_DISK" != "x" ]; then
	# Script to create persistent links on startup
	declare -A persistents
	persistents["/persistent/uploads"]="/var/www/storage/app/public/uploads"

	for i in "${!persistents[@]}"
	do
		if [ ! -d "$i" ] # check if the directory exists
		then
			mkdir -p "$i"
		fi
		# set directory permissions to www-data:www-data
		chown -R www-data:www-data "$i"

		# if the value part does not exist, create a symlink
		echo "${persistents[$i]}"
		if [ ! -e "${persistents[$i]}" ]
		then
			filesystem=$(df -PTh /var/www/storage/ | awk '{print $2}' | grep -v 'Type')
			# if filesystem is drvfs -- windows drive
			if [ $filesystem = "drvfs" ]
			then
				mkdir -p "${persistents[$i]}"
			else
				ln -s "$i" "${persistents[$i]}"
			fi
		fi
	done
fi

# run cron if set
if [ "x$CRON" != "x" ]; then
    touch /var/log/cron.log
    crontab /etc/cron.d/crontab
    printenv >> /etc/environment #pass env vars to child processes (cron)
    cron
fi

#run apache
/usr/sbin/apache2ctl -D FOREGROUND
