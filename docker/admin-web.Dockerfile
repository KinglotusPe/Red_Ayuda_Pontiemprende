# Multi-stage build for Admin Web
FROM node:20-alpine AS builder
WORKDIR /app

COPY admin-web/package*.json ./
RUN npm install

COPY admin-web/ ./
RUN npm run build

# Nginx production serve
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
