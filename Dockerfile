FROM node
RUN apt-get update
RUN apt-get install dpkg --add-architecture i386 &&\
  apt-get update && \
  apt-get install wine32
RUN apt-get install -y zip
ENV DISPLAY=""

ADD ./package.json /data/package.json
WORKDIR /data
RUN npm install && mv node_modules /node_modules

ADD . /data
RUN cp -R ../node_modules ./ && npm run deploy
