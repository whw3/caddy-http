#!/bin/bash
clear
purge="docker rmi "
force=0
while getopts ":f" opt; do
  case ${opt} in
    f ) purge+="-f "
        force=1
        echo "Forcing purge"
      ;;
    \? ) echo "Usage: purge [-f]"
        exit 1;
      ;;
  esac
done

if [[ "$(docker ps -a -f "status=exited"| wc -l)" > "1" ]]; then 
    if (whiptail --title "Stopped Containers Detected" --yesno "Should stopped containers be removed?" 8 78) then
        images=($(docker ps -a -f "status=exited" | grep -v "IMAGE" | awk '{print $1" "$2" on"}'))
        _list=$(whiptail --title "Remove Stopped Containers" --checklist --separate-output \
        "Select images to remove:" 24 50 10 "${images[@]}" 3>&1 1>&2 2>&3)|| echo "Remove Cancelled"
        [[ ! -z "${_list[@]}" ]] && docker rm $_list
    else
        if [ $force = 0 ]; then
            if (whiptail --title "Stopped Containers Detected" --yesno "Should I force purge instead?" 8 78) then
                purge+="-f "
                force=1
                echo "Forcing purge"
            fi
        fi
    fi
fi
images=($(docker images | grep -v "IMAGE" |uniq -f3|awk '{print $3" "$1":"$2" off"}'))
_list=$(whiptail --title "Purge Docker Images" --checklist --separate-output \
"Select images to purge:" 34 80 20 "${images[@]}" 3>&1 1>&2 2>&3)|| echo "Purge Cancelled"
[[ ! -z "${_list[@]}" ]] && $purge $_list
