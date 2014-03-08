# Ubuntu 12.04 TLS
FROM ubuntu
MAINTAINER fisto

RUN apt-get update -y

# root
RUN echo 'root:root' | chpasswd

RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 644 /root/.ssh/authorized_keys

# user add
#RUN useradd fisto
#RUN echo 'fisto:fisto' | chpasswd
#RUN echo 'fisto ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/fisto
#RUN chmod 440 /etc/sudoers.d/fisto

#RUN mkdir /home/fisto
#RUN chown fisto:fisto /home/fisto

#RUN mkdir /home/fisto/.ssh
#RUN chown fisto:fisto /home/fisto/.ssh
#RUN chmod 700 /home/fisto/.ssh

#ADD authorized_keys /home/fisto/.ssh/authorized_keys
#RUN chown fisto:fisto /home/fisto/.ssh/authorized_keys
#RUN chmod 644 /home/fisto/.ssh/authorized_keys

# ssh
RUN apt-get install -y openssh-server
#RUN sed -ri 's/Port 22/Port 22/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN chmod 711 /var/run/sshd
CMD /usr/sbin/sshd -D

# Nginx
RUN sed -i -e "1i deb http://nginx.org/packages/mainline/ubuntu/ precise nginx" /etc/apt/sources.list
RUN sed -i -e "2i deb-src http://nginx.org/packages/mainline/ubuntu/ precise nginx" /etc/apt/sources.list

#RUN apt-get install wget -y
RUN wget http://nginx.org/keys/nginx_signing.key
RUN apt-key add nginx_signing.key

RUN apt-get remove nginx nginx-common -y
RUN apt-get update -y
RUN apt-get install nginx -y

# git
RUN apt-get install git -y

# rbenv
#RUN git clone git://github.com/sstephenson/rbenv.git /root/.rbenv
#RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build

# Ruby 2.1.1
RUN apt-get install build-essential libssl-dev -y
#ADD rbenv.sh /opt/rbenv.sh
#RUN sudo -u root bash /opt/rbenv.sh

# mongodb
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
#RUN echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list
#RUN apt-get update
#RUN apt-get -y install apt-utils
#RUN apt-get -y install mongodb-10gen
##RUN echo "" >> /etc/mongodb.conf
#CMD ["/usr/bin/mongod", "--config", "/etc/mongodb.conf"] 

# node.js
#RUN add-apt-repository ppa:chris-lea/node.js
#RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
#RUN apt-get update
#RUN apt-get install -y nodejs

# port
EXPOSE 22 80
