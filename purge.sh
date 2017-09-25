#!/bin/bash
clear
images=($(docker images | grep -v "IMAGE" |uniq -f3|awk '{print $3"  "$1":"$2" off"}'))

_list=$(whiptail --title "Purge Docker Images" --checklist --separate-output \
"Select images to purge:" 34 80 20 "${images[@]}" \
3>&1 1>&2 2>&3)|| exit 1

docker rmi  $_list
#docker rmi -f $_list
