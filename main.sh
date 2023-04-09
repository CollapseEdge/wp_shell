#!/bin/bash

SETCOLOR_SUCCESS="echo -en \\033[1;32m"

echo "欢迎使用wordpress一键安装脚本"
echo "======================================"
echo "|Author: CollapseEdge                |"
echo "|Email: collapse_edge@outlook.com    |"
echo "|Description: 一键安装wordpress脚本   |"
echo "======================================"
echo "正在进行系统检测..."
if [[ $EUID -ne 0 ]];then
	echo "请以root账户运行脚本"
	exit 1
else
	echo "系统信息:`uname -v`"
	echo "IP信息:`curl -s myip.ipip.net`"
fi
echo "本程序会安装docker,apache,mysql,php以及wordpress本体"
echo -n "确认按照(y|n):"
read result
case $result in
	[yY][eE][sS]|[yY])
	echo "安装docker"
        sudo apt-get update
	curl -sSL https://get.docker.com/ | sh
        systemctl start docker.service
        systemctl enable docker
	wget https://raw.githubusercontent.com/CollapseEdge/wp_shell/main/upload.ini
        docker run --name wordpress --link db:mysql -p 80:80 -e WORDPRESS_DB_HOST=mysql:3306 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_TABLE_PREFIX=wp_ -v /home/wordpress/upload.ini:/usr/local/etc/php/conf.d/uploads.ini -d wordpress
        rm -f upload.ini
	echo -e "\033[32m ---安装成功--- \033[0m" 
	echo "请访问 http://`curl -s ident.me`/wp-admin/install.php"
	echo "并按照指引完成安装"
	echo "如果访问之后出现安装错误的提示,请强制刷新网页"
		;;
	[nN][oO]|[nN])
		echo "no"
		exit 1
		;;
	*)
		echo "Invalid input..."
		exit 1
		;;
esac

