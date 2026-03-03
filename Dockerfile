FROM node:14-alpine AS build
RUN git clone -b "QE-Live-Midnight" https://github.com/Voulk/QuestionablyEpic 
WORKDIR QuestionablyEpic

COPY package.json package-lock.json ./
RUN npm ci

ENV CI=false
RUN npm run build

FROM nginx:alpine-slim
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
