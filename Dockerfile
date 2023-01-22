FROM node:14
# Use a stable version of Nodejs, create a directory for app files
WORKDIR /src/app
# Copy package-json files
COPY package*.json /src/app/
#Install npm dependencies
RUN npm install
# Copy app resources
COPY . /src/app/
# Specify a volume
VOLUME ["/src/app"]
# Start app
CMD [ "npm", "start" ]