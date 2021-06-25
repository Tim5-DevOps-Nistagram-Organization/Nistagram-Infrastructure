#!/bin/bash


cp -r ../nistagram-front ./nistagram-front
cp -r ../Nistagram-Api-Gateway ./Nistagram-Api-Gateway
cp -r ../Nistagram-Auth ./Nistagram-Auth
cp -r ../Nistagram-Campaign ./Nistagram-Campaign
cp -r ../Nistagram-Media ./Nistagram-Media
cp -r ../Nistagram-Post ./Nistagram-Post
cp -r ../Nistagram-Search ./Nistagram-Search
cp -r ../Nistagram-User ./Nistagram-User



COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose -f ./docker-compose.dev.yml  --env-file ./config/.env.dev up --build -d


is_running() {
    service="$1"
    container_id="$(docker-compose -f ./docker-compose.dev.yml ps -q "$service")"
    health_status="$(docker inspect -f "{{.State.Status}}" "$container_id")"

    echo "STATUS: $health_status, CONTAINER: $service"

    if [ "$health_status" = "running" ]; then
        return 0
        echo "trcii, CONTAINER: $service"
    else
        return 1
    fi
}

# ## remove folder Nistagram-Api-Gateway, nistagram-front after container build gateway
while ! is_running nistagram-gateway; do sleep 20; done


# ## remove folder Nistagram-Auth after container build
while ! is_running nistagram-auth-service; do sleep 20; done


# ## remove folder Nistagram-Campaign after container build
while ! is_running nistagram-campaign-service; do sleep 20; done


# ## remove folder Nistagram-Media after container build
while ! is_running nistagram-media-service; do sleep 20; done


# ## remove folder Nistagram-Post after container build
while ! is_running nistagram-post-service; do sleep 20; done


# ## remove folder Nistagram-Search after container build
while ! is_running nistagram-search-service; do sleep 20; done


# ## remove folder Nistagram-User
while ! is_running nistagram-user-service; do sleep 20; done


rm -rf ./Nistagram-Api-Gateway
rm -rf ./nistagram-front
rm -rf ./Nistagram-Auth
rm -rf ./Nistagram-Campaign
rm -rf ./Nistagram-Media
rm -rf ./Nistagram-Search
rm -rf ./Nistagram-Post
rm -rf ./Nistagram-User