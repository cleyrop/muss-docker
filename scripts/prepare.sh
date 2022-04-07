#!/bin/bash
_PWD=$(pwd)
_DIR=$(dirname "${0}")

#shellcheck source=functions/config.sh
source "${_DIR}/functions/config.sh"
read_config "${_DIR}/../config/image.properties"

#shellcheck source=functions/check.sh
source "${_DIR}/functions/check.sh"

echo -e "\n********************************************************************************"
echo -e "\tPREPARE ${CONFIG[name]}:${CONFIG[version]} !"
echo -e "********************************************************************************\n\n"

# Check tools are installed
check "git --version" "exit"
check "docker --version" "exit"
