#! /usr/bin/env bash
set -euo pipefail

FILENAME="${1}"
KEY_1="${2}"
KEY_2="${3}"

if [[ "${FILENAME}" =~ .*yaml$ ]]; then
    contents="$(yq eval -j "${FILENAME}")"
elif [[ "${FILENAME}" =~ .*json$ ]]; then
    contents="$(cat "${FILENAME}")"
else    
    echo "unsupported"
    exit 1
fi

data=$(echo "${contents}" | jq --arg key1 "${KEY_1}" --arg key2 "${KEY_2}" '.[$key1] | .[$key2]')

if [[ "${KEY_1}" == "Nodes" ]]; then
    echo "${data}" | jq -r '.IBMsoftware'
    echo "${data}" | jq -r '.CPUType'
fi

if [[ "${KEY_1}" == "Instances" ]]; then
    echo "${data}" | jq -r '.Memory'
    echo "${data}" | jq -r '."ComputeUnits(ECU)"'
    echo "${data}" | jq -r '.vCPUs'
fi