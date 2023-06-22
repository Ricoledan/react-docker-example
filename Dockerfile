FROM node:16.20.1-alpine as build

USER node
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production
COPY . ./

RUN npm run build

FROM nginx:latest

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]