FROM node:latest

WORKDIR /usr/src/app

COPY package*.json ./

COPY . /usr/src/app

RUN npm install

EXPOSE 5173

CMD [ "npm", "run", "dev", "--", "--host" ]
