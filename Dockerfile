FROM registry.access.redhat.com/ubi8/nodejs-16

COPY . /opt/app-root/src
WORKDIR /opt/app-root/src

RUN npm install

CMD ["npm", "start"]
