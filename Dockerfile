FROM node:22-slim AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install --fetch-retries=5 --fetch-retry-mintimeout=20000

COPY . .
RUN npm run build

FROM nginx:alpine AS runner
RUN rm -rf /etc/nginx/conf.d/*
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
