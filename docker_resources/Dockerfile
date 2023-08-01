FROM alpine:3.8

RUN addgroup www
RUN adduser -D -g 'www' nginx

RUN apk update && apk add nginx

# Create the /run/nginx/ directory
RUN mkdir -p /run/nginx

# Set appropriate permissions for the /run/nginx/ directory
RUN chown nginx:www /run/nginx

RUN mkdir /www && \
    chown -R nginx:www /var/lib/nginx && \
    chown -R nginx:www /www

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

COPY sub/. /www

EXPOSE 80

# Start Nginx in the background with the "daemon off;" option
CMD ["nginx", "-g", "daemon off;"]
