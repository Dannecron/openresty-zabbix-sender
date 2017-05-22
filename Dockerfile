FROM centos:centos7

RUN rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm &&\
	yum update &&\
	yum install -y zabbix-sender

RUN yum-config-manager --add-repo https://openresty.org/yum/centos/OpenResty.repo &&\
	yum update &&\
	yum install -y openresty &&\
	yum install -y wget unzip make

ENV PATH /usr/local/openresty/nginx/sbin/:$PATH

RUN wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.2.tar.gz &&\
	tar -xzvf luarocks-2.4.2.tar.gz &&\
	cd luarocks-2.4.2 &&\
	./configure --prefix=/usr/local/openresty/luajit \
    	--with-lua=/usr/local/openresty/luajit/ \
    	--lua-suffix=jit \
    	--with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 &&\
    make &&\
    make install

ADD ./nginx/* /etc/nginx/
RUN mkdir /var/log/nginx

RUN nginx -c /etc/nginx/nginx.conf
