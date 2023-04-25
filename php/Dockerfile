# 使用多阶段构建
FROM php:8.0-fpm-alpine AS composer

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

FROM node:16-alpine AS nodejs

FROM php:8.0-fpm-alpine

# 拷贝 Composer 和 Node.js
COPY --from=composer /usr/local/bin/composer /usr/local/bin/composer
COPY --from=nodejs /usr/local/bin/node /usr/local/bin/node
COPY --from=nodejs /usr/local/bin/npm /usr/local/bin/npm

# 安装系统依赖
RUN apk update && apk add --no-cache \
    mysql-client \
    busybox-extras \
    git \
    procps \
    net-tools \
    iproute2 \
    gettext \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd zip pdo_mysql \
    # 清理 apk 缓存
    && rm -rf /var/cache/apk/*

# 设置工作目录的值必须和 .env中的APP_ROOT一致
WORKDIR /var/www/html
# 全局变量导入
COPY .env /.env
COPY ./php/env.template /env.template
COPY ./php/start.sh /start.sh
RUN chmod +x /start.sh 

#EXPOSE 9000
CMD ["/start.sh"]