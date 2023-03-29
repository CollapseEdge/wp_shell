#!/bin/bash

echo "欢迎使用wordpress一键安装脚本"
echo "============================="
echo "|@author: CollapseEdge      |"
echo "|@GITHUB:CollapseEdge       |"
echo "|@copyight:2023             |"
echo "============================="
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
		sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker.io
        apt install docker-compose
		wget https://raw.githubusercontent.com/CollapseEdge/wp_shell/main/docker-compose.yml
        systemctl start docker.service
        systemctl enable docker
        docker-compose -f docker-compose.yml up -d
		echo "安装完成!"
		echo "请访问 http://`curl -s ident.me`:8000/wp-admin/install.php"
		echo "并按照指引完成安装"
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

