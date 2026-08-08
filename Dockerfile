## SRC ##
FROM node:14-alpine AS src
ARG UPSTREAM_SHA
ADD https://github.com/Voulk/QuestionablyEpic.git#$UPSTREAM_SHA /app


## BUILD ##
FROM node:14-alpine AS build
ENV CI=false
WORKDIR /app

# Build dependencies
COPY --from=src /app/package*.json /app
RUN npm ci

# Build
COPY --from=src /app /app
RUN npm run build


## RUN ##
FROM nginxinc/nginx-unprivileged:alpine-slim
ARG UPSTREAM_SHA
LABEL upstream.sha=$UPSTREAM_SHA
COPY --from=build /app/build /usr/share/nginx/html/live
COPY nginx.conf /etc/nginx/conf.d/default.conf
