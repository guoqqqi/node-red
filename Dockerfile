ARG ARCH=amd64
ARG NODE_VERSION=16
ARG OS=alpine

#### Stage BASE ########################################################################################################
FROM ${ARCH}/node:${NODE_VERSION}-${OS} AS base

# Install tools, create Node-RED app and data dir, add user and set rights
RUN set -ex && \
    apk add --no-cache \
        bash \
        tzdata \
        iputils \
        curl \
        nano \
        git \
        openssl \
        openssh-client \
        ca-certificates && \
    mkdir -p /usr/src/node-red /data && \
    deluser --remove-home node && \
    adduser -h /usr/src/node-red -D -H node-red -u 1000 && \
    chown -R node-red:root /data && chmod -R g+rwX /data && \
    chown -R node-red:root /usr/src/node-red && chmod -R g+rwX /usr/src/node-red
    # chown -R node-red:node-red /data && \
    # chown -R node-red:node-red /usr/src/node-red

# 设置工作目录  
WORKDIR /usr/src/node-red  
  
# 将 Node-RED 源代码克隆到工作目录中  
# 注意：这里使用了 SSH URL，但 GitHub 推荐使用 HTTPS URL（尤其是当你不需要 SSH 密钥时）  
# 你可以替换为你自己的分支或标签  
# 如果你使用 HTTPS URL，可能需要设置 GIT_SSL_NO_VERIFY=1 来绕过 SSL 验证（不推荐用于生产）  
# 或者，你可以在构建 Docker 镜像之前先克隆仓库，并将代码添加到 Docker 上下文中  
COPY . .

RUN chmod 
  
# 安装 Node-RED 及其依赖项  
RUN npm install  
  
# 如果你需要构建 Node-RED（例如，如果你从源代码进行了修改），你可以取消注释以下行  
RUN npm run build  
  
# 设置环境变量（可选，但可能有用）  
ENV NODE_RED_HOME=/data/nodered  
ENV NODE_PATH=$NODE_RED_HOME/node_modules  
ENV FLOWS=$NODE_RED_HOME/flows  
  
# 创建数据目录（如果它们还不存在）  
RUN mkdir -p $NODE_RED_HOME $FLOWS  
  
# 复制启动脚本（如果有的话）或直接运行 Node-RED  
# 例如，你可以创建一个名为 start.sh 的脚本，其中包含运行 Node-RED 的命令  
# 然后使用 COPY 命令将其复制到容器中  
# COPY start.sh /usr/src/node-red/  
  
# 设置默认的启动命令  
CMD ["npm", "start", "--userDir", "$NODE_RED_HOME"]  
  
# 如果你有 start.sh 脚本，并且想用它来启动 Node-RED，你可以这样做：  
# CMD ["/bin/bash", "/usr/src/node-red/start.sh"]  
  
# 如果你希望暴露 Node-RED 的默认端口（1880），可以添加以下行  
EXPOSE 1880