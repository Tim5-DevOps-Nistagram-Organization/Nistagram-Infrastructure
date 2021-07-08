#!/bin/bash

RUN_BUILD=${1:-0}

cp -r ../Nistagram-Api-Gateway ./Nistagram-Api-Gateway
cp -r ../Nistagram-Auth ./Nistagram-Auth
cp -r ../Nistagram-Campaign ./Nistagram-Campaign
cp -r ../Nistagram-Media ./Nistagram-Media
cp -r ../Nistagram-Post ./Nistagram-Post
cp -r ../Nistagram-Search ./Nistagram-Search
cp -r ../Nistagram-User ./Nistagram-User


if [ ${RUN_BUILD} -eq 1 ]
then
# ## mora ovako zbog [output clipped, log limit 1MiB reached]
docker buildx create --use --name larger_log --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=50000000

# ## Build Nistagram-Api-Gateway microsrevice
docker buildx build --load --progress plain ./Nistagram-Api-Gateway --target gatewayRuntimeDev --tag gateway-nistagram

# ## Build Auth microservice
docker buildx build --load --progress plain ./Nistagram-Auth --target nistagramAuthMicroserviceRuntimeDev --tag auth-service-nistagram

# # ## Build Campaign microsrevice
docker buildx build --load --progress plain ./Nistagram-Campaign --target nistagramCampaignMicroserviceRuntimeDev --tag campaign-service-nistagram

# # ## Build Nistagram-Media microsrevice
docker buildx build --load --progress plain ./Nistagram-Media --target nistagramMediaMicroserviceRuntimeDev --tag media-service-nistagram

# # ## Build Nistagram-Post microsrevice
docker buildx build --load --progress plain ./Nistagram-Post --target nistagramPostMicroserviceRuntimeDev --tag post-service-nistagram

# # ## Build Nistagram-Search microsrevice
docker buildx build --load --progress plain ./Nistagram-Search --target nistagramSearchMicroserviceRuntimeDev --tag search-service-nistagram

# # ## Build Nistagram-User microsrevice
docker buildx build --load --progress plain ./Nistagram-User --target nistagramUserMicroserviceRuntimeDev --tag user-service-nistagram

echo "Finished builds"
fi

COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f ./docker-compose.dev.yml --env-file ./config/.env.dev up -d

