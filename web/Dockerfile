FROM node:10.12-slim as dev
MAINTAINER David Martin <davidmartingarcia0@gmail.com>

#Base dependencies
RUN apt-get clean && apt-get update && apt-get install -y --force-yes --fix-missing \
  ssh \
  build-essential \
  inotify-tools

ENV NPM_CONFIG_LOGLEVEL info

#Cleaning
RUN apt-get clean

WORKDIR /app
ENTRYPOINT []
CMD ["npm", "run", "start"]

#Multistage build angular for prod env
FROM node:10.12-slim as build-stage
# ENV NODE_ENV production
ADD . /app
WORKDIR /app
RUN npm install --silent
ARG configuration=production

RUN npm run build -- --output-path=./dist/out --configuration $configuration

#Multistage production server
FROM nginx:1.15 as prod-image
COPY infra/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html