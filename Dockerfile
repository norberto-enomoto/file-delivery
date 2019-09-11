FROM node:12-alpine

LABEL mantainer="Paulo Luan <pauloluan.inova@gmail.com>"

# Bundle APP files
COPY src src/
COPY index.js .	
COPY package.json .
COPY pm2.json .

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install --production
RUN npm install pm2 -g
RUN pm2 install pm2-server-monit
RUN pm2 install pm2-logrotate

EXPOSE 9000
ENV FILES_PATH /data/files
VOLUME ["${FILES_PATH}","/logs"]

# Show current folder structure in logs
RUN ls -al -R

CMD ["pm2-runtime", "--env", "production", "start", "pm2.json", "--web", "-l", "/logs/out.log"]