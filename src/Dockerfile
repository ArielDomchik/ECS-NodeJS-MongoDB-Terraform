FROM node:14-alpine
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install
COPY . .
CMD ["node", "/app/index.js"]
