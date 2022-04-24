#!/usr/bin/env bash

COMMIT=${1:-stable}

set -e

echo "Deploying revison $COMMIT"

declare -A yaml_file_name
yaml_file_name["a"]="a"
yaml_file_name["b"]="b"
yaml_file_name["c"]="c"

for key in "${!yaml_file_name[@]}" ; do
    echo $key --- ${yaml_file_name[$key]}
    sed -e "s/\$IMAGETAG/$COMMIT/g" "./k8s/prod/${yaml_file_name[$key]}-deployment.yaml" \
      | kubectl --context=${CONTEXT} --namespace=${NAMESPACE} apply -f -
done
