#!/bin/sh
# 导入变量设置
set -o allexport
source /.env
set +o allexport
# 基于环境变量生成laravel .env文件
envsubst < /env.template > ./.env
#创建laravel目录
set -x
mkdir -p ./storage/framework/sessions
mkdir -p ./storage/framework/views
mkdir -p ./storage/framework/cache
chown -R www-data:www-data ./storage/framework/sessions
chown -R www-data:www-data ./storage/framework/views
chown -R www-data:www-data ./storage/framework/cache


composer install --no-scripts --no-progress --no-interaction

if [ -f ./artisan ]; then
    php ./artisan migrate 
else 
    echo "artisan file not found, skip migrate"
fi
# 编译前端内容的时候(laravel-mix)
# npm install
# npm run dev 或者 npm watch
exec php-fpm
