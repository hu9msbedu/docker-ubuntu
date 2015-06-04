FROM wangh/ssh:latest

MAINTAINER wangh<wanghui94@live.com>

RUN apt-get update

# 安装编译环境
RUN apt-get install -y build-essential debhelper make autoconf automake patch 
RUN apt-get install -y dpkg-dev fakeroot pbuilder gnupg dh-make libssl-dev libpcre3-dev git-core

# 设置系统时间
RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# 创建nginx用户
RUN adduser --disabled-login --gecos 'Tengine' nginx

WORKDIR /home/nginx

# 下载Tengine安装包
RUN su nginx -c 'git clone https://github.com/alibaba/tengine.git'

WORKDIR /home/nginx/tengine
RUN su nginx -c 'mv packages/debian .'

ENV DEB_BUILD_OPTIONS nocheck

RUN su nginx -c 'dpkg-buildpackage -rfakeroot -uc -b'

WORKDIR /home/nginx
RUN dpkg -i tengine_2.1.0-1_amd64.deb

VOLUME [ "/data", "/etc/nginx/sites-enabled", "/var/log/nginx" ]

# 让nginx以非daemon模式运行
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

WORKDIR /etc/nginx


# 安装ssh服务
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
# 用户名，密码
RUN echo 'root:12345' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 取消pam的限制，否则用户登录后就被踢出
RUN sed -ri 's/session required pam_loginuid.so/#session required pam_loginuid.so/g' /etc/pam.d/sshd


# 添加运行脚本，并设置权限
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]
CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 80
EXPOSE 443
EXPOSE 22
