#!/bin/bash

docker rm -f $(docker ps -a -q)

rm -rf ./Nistagram-Api-Gateway
rm -rf ./nistagram-front
rm -rf ./Nistagram-Auth
rm -rf ./Nistagram-Campaign
rm -rf ./Nistagram-Media
rm -rf ./Nistagram-Search
rm -rf ./Nistagram-Post
rm -rf ./Nistagram-User
