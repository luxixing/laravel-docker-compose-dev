# 基于Docker Compose的 Laravel 9开发环境
## 目录结构说明
```
├── README.md 本文件
├── .env 环境变量配置文件(尽量把公共配置抽取到这个里面)
├── docker-compose.yaml 环境构建文件
├── mysql 数据库文件夹
│   └── data
├── nginx nginx文件夹
│   ├── Dockerfile
│   ├── nginx.conf.template # nginx配置文件模版
│   ├── nginx_product.conf.template
│   └── start.sh # 启动脚本, 根据.env中的环境变量替换nginx配置文件
└── php
    ├── Dockerfile
    ├── env.template #laravel .env配置文件模版, 可以把自己的laravel项目的.env.example的内容复制进来, 进行修改
    └── start.sh # 启动脚本, 根据.env中的环境变量替换.env配置文件, composer install, PHP  artisan migrate等
```
## 使用说明
### docker compose 常用命令
> 需要进到docker-compose.yaml所在目录
```
#构建容器, 修改了Dockerfile或者和镜像相关的文件,执行build; 只构建特定容器, 加上服务名称即可
docker-compose build
docker-compose build php
# 启动, 参数 -d 是后台运行; 去掉则前台运行
docker-compose up -d
# 停止服务并且删除相关容器, 如果只想停止服务,可以使用 docker-compose stop
docker-compose down
# 重启全部容器
docker-compose restart
# 查看日志
docker-compose logs
# 列出和当前项目相关的容器
docker-compose ps 
```
### docker 常用命令
``` 
# 网络查看
docker network ls
# 查看指定网络的详细信息, <network_name> 是您要查看的网络名称
docker network inspect <network_name> 
# 启动某个镜像,查看镜像内容什么的,用于排查镜像问题
docker image ls
docker run -it <image_name>:<tag> /bin/sh
# 进入运行中的容器
docker ps
docker exec -it <container_name or id> /bin/sh
#清理没有使用过的镜像
docker image prune -a
#删除已经停止的容器
docker container prune
# 这个命令会清理:
#   未被任何容器使用的中间层缓存
#   清理所有停止状态的容器
#   清理所有未被挂载的卷
#   清理所有网络没有使用的端点
# 使用的时候要小心
docker system prune -a --volumes
```

## docker 镜像源配置
```
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
```
## 踩坑记录
- php 镜像访问mysql数据库的时候,总是connection refuse
> 缘由: 容器之间的通信端口,使用的是容器内部的端口,而不是容器对外暴露的端口, 不能使用对外暴露的端口
- laravel 启动报错,目录不存在
> 缘由: laravel 服务启动的时候, 使用脚本自动创建
- nginx映射到宿主机的端口10080, 浏览器无法访问,telnet是通的
> 原因: 10080好像是个特殊端口,换成 30080 就好了
- orbstack 镜像始终下载不了
> 原因: 配置的proxy 不要使用系统代理, 手动配置一个(研究下为啥配置了docker的镜像源,但是没有生效)