#!/bin/bash
_PWD=$(pwd)
_DIR=$(dirname "${0}")

#shellcheck source=functions/config.sh
source "${_DIR}/functions/config.sh"
read_config "${_DIR}/../config/image.properties"

echo -e "\n********************************************************************************"
echo -e "\tRUN Docker image ${CONFIG[name]}:${CONFIG[version]} !"
echo -e "********************************************************************************\n\n"

docker run -it --rm \
        --name ${CONFIG[container]} \
        -p 127.0.0.1:20122:22/tcp \
        "${CONFIG[name]}:${CONFIG[version]}"
