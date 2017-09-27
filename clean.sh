#!/bin/bash
while getopts ":p:" opt; do
  case ${opt} in
    p) data=${OPTARG}
        if [[ "$data" = "data" ]]; then
            rm -rf data
        fi
      ;;
    \? ) echo "Usage: clean [-p data]"
        exit 1;
      ;;
  esac
done
shift $((OPTIND-1))

rm -rf "$(grep -v "data" .gitignore)"
docker rmi "$(docker images -f dangling=true -q)" 2>/dev/null
exit 0
