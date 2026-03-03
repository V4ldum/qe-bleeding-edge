FROM node:14-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

ENV CI=false
RUN npm run build

FROM nginx:alpine-slim
COPY --from=build /app/build /usr/share/nginx/html
