# 使用官方 Node.js 镜像作为基础镜像
FROM node:16

# 设置工作目录
WORKDIR /usr/src

# 复制 package.json 和 package-lock.json 文件到工作目录

RUN git clone https://github.com/guoqqqi/node-red.git

WORKDIR /usr/src/node-red

# 安装项目依赖
RUN npm install

# 复制当前目录下的所有文件到工作目录
COPY . .

# 构建源码 (如果需要)
RUN npm run build

# 暴露 Node-RED 默认端口
EXPOSE 1880

# 设置容器启动时执行的命令
CMD ["npm", "start"]
