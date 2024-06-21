# 使用官方 Node.js 镜像作为基础镜像
FROM node:16

RUN set -ex; \
	apt update && apt-get install libaio1;

# 设置工作目录
WORKDIR /usr/src/app

# 复制当前目录下的所有文件到工作目录
COPY . .

RUN curl -O https://download.oracle.com/otn_software/linux/instantclient/2114000/instantclient-basic-linux-21.14.0.0.0dbru.zip && unzip instantclient-basic-linux-21.14.0.0.0dbru.zip

# 安装项目依赖
RUN npm install

# 构建源码 (如果需要)
RUN npm run build

# 暴露 Node-RED 默认端口
EXPOSE 1880

# 设置容器启动时执行的命令
CMD ["npm", "start"]
