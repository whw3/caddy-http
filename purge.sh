#!/bin/bash
clear
purge="docker rmi "
force=0
function force_purge()
{
    purge+="-f "
    force=1
    echo "Forcing purge"
}
while getopts ":f" opt; do
  case ${opt} in
    f ) force_purge
      ;;
    \? ) echo "Usage: purge [-f]"
        exit 1;
      ;;
  esac
done

if [[ "$(docker ps -a -f "status=exited"| wc -l)" -gt 1 ]]; then
    if (whiptail --title "Stopped Containers Detected" --yesno "Should stopped containers be removed?" 8 78) then
        images=($(docker ps -a -f "status=exited" | grep -v "IMAGE" | awk '{print $1" "$2" on"}'))
        _list=$(whiptail --title "Remove Stopped Containers" --checklist --separate-output \
        "Select images to remove:" 24 50 10 "${images[@]}" 3>&1 1>&2 2>&3)|| echo "Remove Cancelled"
        [[ ! -z "${_list[@]}" ]] && docker rm "${_list[@]}"
    else
        if [ $force = 0 ]; then
            if (whiptail --title "Stopped Containers Detected" --yesno "Should I force purge instead?" 8 78) then
                force_purge
            fi
        fi
    fi
fi
images=($(docker images | grep -v "IMAGE" |uniq -f3|awk '{print $3" "$1":"$2" off"}'))
_list=$(whiptail --title "Purge Docker Images" --checklist --separate-output \
"Select images to purge:" 34 80 20 "${images[@]}" 3>&1 1>&2 2>&3)|| echo "Purge Cancelled"
[[ -z "${_list[@]}" ]] && exit 1
_list=($(echo "${_list[@]}"| tr '\n' ' '))
$purge "${_list[@]}"
exit 0
