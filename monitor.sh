#!/bin/bash
# monitor.sh
# Listens to new files in source folders (src1, src2...) and copy them to dst1_1 and dst2_1, dst1_2 and dst2_2, ...

DIRS=`find / -maxdepth 1 -type d -name 'src?'`

echo Directories to be monitored: $DIRS


[ -e /tmp/FILES_ALREADY_THERE ] && rm /tmp/FILES_ALREADY_THERE

# put the already existing ones in the already_there file
for d in $DIRS
do
		find $d -type f >>/tmp/FILES_ALREADY_THERE
done

(cat /tmp/FILES_ALREADY_THERE ; inotifywait --monitor $DIRS --event close_write --event moved_to --format "%w%f") |
	while read file; do
		# Verarbeite nur Dateien ohne Wildcards
		if [ "$file" == "${file//[\[\]|?+*]/}" ]
		then
			echo received "$file", waiting 4 seconds...
			sleep 4
			cp -p "$file" "/dst1_${file:4:1}"
			mv "$file" "/dst2_${file:4:1}"
		fi
	done



