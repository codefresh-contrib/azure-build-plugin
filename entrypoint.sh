#!/bin/sh
set -e

msg() { echo -e "INF---> $1"; }
err() { echo -e "ERR---> $1" ; exit 1; }

${AUTH:-USER}

if [ "$AUTH" = "service-principal" ]
then
  do az login --service-principal -u $APP_ID -p $PASSWORD --tenant $TENANT >/dev/null
else
  do az login -u $USER -p $PASSWORD

az acr build --registry $ACR_NAME --image $IMAGE:$TAG --file ${DOCKERFILE_PATH:-Dockerfile} $CF_VOLUME_PATH/$CF_REPO_NAME/

echo AZURE_IMAGE=$ACR_NAME.azureecr.io/$IMAGE:$TAG >> $CF_VOLUME_PATH/env_vars_to_export
