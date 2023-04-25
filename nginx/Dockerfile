FROM nginx:alpine

COPY .env /.env
COPY ./nginx/start.sh /start.sh
COPY ./nginx/nginx.conf.template /etc/nginx/conf.d/laravel.conf.template

RUN chmod +x /start.sh

#EXPOSE 10080
CMD ["/start.sh"]