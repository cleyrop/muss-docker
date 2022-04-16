#!/bin/bash

_DIR=$(dirname "${0}")

#shellcheck source=functions/config.sh
source "${_DIR}/functions/config.sh"
read_config "${_DIR}/../config/image.properties"

echo -e "\n********************************************************************************"
echo -e "\tBUILD Docker image ${CONFIG[name]}:${CONFIG[version]} !"
echo -e "********************************************************************************\n\n"

# ${1} is used to insert some parameters to build command like --no-cache
DOCKER_BUILDKIT=1 docker build ${1} -t "${CONFIG[name-base]}:${CONFIG[version]}" -f "${_DIR}/../docker/Dockerfile-base" "${_DIR}/../docker"
DOCKER_BUILDKIT=1 docker build ${1} -t "${CONFIG[name-model-fr]}:${CONFIG[version]}" -f "${_DIR}/../docker/Dockerfile-model-fr" "${_DIR}/../docker"
DOCKER_BUILDKIT=1 docker build ${1} -t "${CONFIG[name-model-es]}:${CONFIG[version]}" -f "${_DIR}/../docker/Dockerfile-model-es" "${_DIR}/../docker"
DOCKER_BUILDKIT=1 docker build ${1} -t "${CONFIG[name-model-en]}:${CONFIG[version]}" -f "${_DIR}/../docker/Dockerfile-model-en" "${_DIR}/../docker"
DOCKER_BUILDKIT=1 docker build ${1} -t "${CONFIG[name]}:${CONFIG[version]}" "${_DIR}/../docker"
