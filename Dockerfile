FROM node:14-alpine AS build
WORKDIR /app
ENV CI=false

RUN apk add --no-cache git
RUN git clone -b "QE-Live-Midnight" https://github.com/Voulk/QuestionablyEpic 
RUN npm ci
RUN npm run build

FROM nginx:alpine-slim
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
