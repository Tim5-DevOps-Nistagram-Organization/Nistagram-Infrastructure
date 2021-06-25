## =================> STAGES for FrontEnd <=====================
FROM node:13.12.0-alpine as frontEndBuild

ARG PROTOCOL="http"
ARG API="localhost:8081"

# set working directory
WORKDIR /usr/src

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY ./nistagram-front/package.json ./
COPY ./nistagram-front/package-lock.json ./
RUN npm install
# add app
COPY ./nistagram-front/ ./
# change API GATEWAY .env
RUN sed -i "s/REACT_APP_API_GATEWAY_URL=.*/REACT_APP_API_GATEWAY_URL=${PROTOCOL}:\/\/${API}\//" .env && \
    cat .env && \
    npm run build --prod





## =================> STAGES for Gateway <=======================
FROM maven:3.6.3-ibmjava-8-alpine  AS gatewayBuild
ARG STAGE=dev
WORKDIR /usr/src/server
COPY ./Nistagram-Api-Gateway .
COPY --from=frontEndBuild /usr/src/build/index.html ./src/main/resources/
COPY --from=frontEndBuild /usr/src/build/asset-manifest.json ./src/main/resources/
COPY --from=frontEndBuild /usr/src/build/ ./src/main/resources/static
RUN mvn package -P${STAGE} -DskipTests 


FROM openjdk:8-jdk-alpine AS gatewayRuntimeDev
WORKDIR /app
COPY ./Nistagram-Api-Gateway/entrypoint.sh /entrypoint.sh
COPY ./Nistagram-Api-Gateway/consul-client.json /consul-config/consul-client.json
RUN apk --no-cache add \
    curl \
    unzip \
    && curl https://releases.hashicorp.com/consul/1.7.2/consul_1.7.2_linux_amd64.zip -o consul.zip \
    && unzip consul.zip \
    && chmod +x consul \
    && rm -f consul.zip \
    && chmod +x /entrypoint.sh \
    && apk --no-cache del \
    && mkdir consul-data \
    curl \
    unzip

COPY --from=gatewayBuild /usr/src/server/target/*.jar gateway-1.0.0.jar
CMD ["/entrypoint.sh"]



FROM openjdk:8-jdk-alpine AS gatewayRuntimeProd
WORKDIR /app
COPY --from=gatewayBuild /usr/src/server/target/gateway-1.0.0.jar gateway.jar
CMD java -jar gateway.jar



## =================> STAGES for Consul server <=======================
FROM consul:1.9.5 as consulServerDev
COPY ./consul-server/entrypoint.sh /entrypoint.sh
COPY ./consul-server /consul/config/
RUN chmod +x /entrypoint.sh
EXPOSE 8500
CMD ["/entrypoint.sh"]
