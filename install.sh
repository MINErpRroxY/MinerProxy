#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi

install() {
    if [ -d "/root/minerProxy" ]; then
        echo -e "您已安装了该软件,如果确定没有安装,请输入rm -rf /root/minerProxy" && exit 1
    fi
    if screen -list | grep -q "minerProxy_v5-1_linux"; then
        echo -e "检测到您已启动了minerProxy_v5-1_linux,请关闭后再安装" && exit 1
    fi

    $cmd update -y
    $cmd install curl wget screen -y
    mkdir /root/minerProxy
    cd minerProxy
    
    echo "请选择数字1版本"
    echo "  1、V5-1"
    read -p "$(echo -e "请输入[1]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/MINErpRroxY/MinerProxy/main/minerProxy_v5-1_linux -O /root/minerProxy/minerProxy_v5-1_linux
        ;;
    *)
        echo "请输入数字1"
        ;;
    esac
    chmod a+x /root/minerProxy/minerProxy_v5-1_linux
    nohup ./minerProxy_v5-1_linux &

    wget https://raw.githubusercontent.com/MINErpRroxY/MinerProxy/main/install.sh -O /root/minerProxy/install.sh
    chmod a+x /root/minerProxy/install.sh
    echo "如果没有报错则安装成功"
    echo "正在启动..."
    screen -dmS minerProxy
    sleep 0.2s
    screen -r minerProxy -p 0 -X stuff "cd /root/minerProxy"
    screen -r minerProxy -p 0 -X stuff $'\n'
    screen -r minerProxy -p 0 -X stuff "./run.sh"
    screen -r minerProxy -p 0 -X stuff $'\n'
    sleep 1s
    nohup ./minerProxy_v5-1_linux &
    sleep 3s
    cat /root/minerProxy/config.yml
    echo "<<<如果成功了,这是您的端口号 请打开 http://服务器ip:端口 访问web服务进行配置:v5-1版本默认端口号为18888，请记录您的token,尽快登陆并修改密码"
    echo "已启动web后台 您可运行 screen -r minerProxy 查看程序输出"
}

uninstall() {
    read -p "是否确认删除minerProxy_v5-1_linux[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            screen -X -S minerProxy quit
            rm -rf /root/minerProxy
            echo "卸载minerProxy成功"
        fi
    fi
}

update() {
    if screen -list | grep -q "minerProxy"; then
        screen -X -S minerProxy quit
    fi
    rm -rf /root/minerProxy/minerProxy_v5-1_linux
    echo "请选择数字1版本"
    echo "  1、v5-1"
    read -p "$(echo -e "请输入[1]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/MINErpRroxY/MinerProxy/main/minerProxy_v5-1_linux -O /root/minerProxy/minerProxy_v5-1_linux
        ;;
    *)
        echo "请输入数字1"
        ;;
    esac
    chmod a+x /root/mineProxy/minerProxy_v5-1_linux
    nohup ./minerProxy_v5-1_linux &

#    echo "暂无更新，请按ctrl+C退出，请勿更新，以免文件错误"
#    read -p "是否删除配置文件[yes/no]：" flag
#    if [ -z $flag ]; then
#        echo "输入错误" && exit 1
#    else
#        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
#            rm -rf /root/miner_proxy/config.yml
#            echo "删除配置文件成功"
#        fi
#    fi
    screen -dmS minerProxy
    sleep 0.2s
    screen -r minerProxy -p 0 -X stuff "cd /root/minerProxy"
    screen -r minerProxy -p 0 -X stuff $'\n'
    screen -r minerProxy -p 0 -X stuff "./run.sh"
    screen -r minerProxy -p 0 -X stuff $'\n'

    sleep 1s
    nohup ./minerProxy_v5-1_linux &
    sleep 3s
    cat /root/minerProxy/config.yml
    echo "<<<如果成功了,这是您的端口号 请打开 http://服务器ip:端口 访问web服务进行配置:v5-1版本默认端口号为18888，请记录您的token,尽快登陆并修改密码"
    echo "您可运行 screen -r minerProxy 查看程序输出"
}

start() {
    if screen -list | grep -q "minerProxy_v5-1_linux"; then
        echo -e "minerProxy_v5-1_linux已启动,请勿重复启动" && exit 1
    fi
    screen -dmS minerProxy
    sleep 0.2s
    screen -r minerProxy -p 0 -X stuff "cd /root/minerProxy"
    screen -r minerProxy -p 0 -X stuff $'\n'
    screen -r minerProxy -p 0 -X stuff "./run.sh"
    screen -r minerProxy -p 0 -X stuff $'\n'

    echo "minerProxy_v5-1_linux已启动"
    echo "您可以使用指令screen -r minerProxy查看程序输出"
}

restart() {
    if screen -list | grep -q "minerProxy_v5-1_linux"; then
        screen -X -S minerProxy quit
    fi
    screen -dmS minerProxy
    sleep 0.2s
    screen -r minerProxy -p 0 -X stuff "cd /root/minerProxy"
    screen -r minerProxy -p 0 -X stuff $'\n'
    screen -r minerProxy -p 0 -X stuff "./run.sh"
    screen -r minerProxy -p 0 -X stuff $'\n'

    echo "minerProxy_v5-1_linux 重新启动成功"
    echo "您可运行 screen -r minerProxy 查看程序输出"
}

stop() {
    if screen -list | grep -q "minerProxy_v5-1_linux"; then
        screen -X -S minerProxy_v5-1_linux quit
    fi
    echo "minerProxy_v5-1_linux 已停止"
}

change_limit(){
    num="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 102400" >>/etc/security/limits.conf
        num="y"
    fi

    if [[ "$num" = "y" ]]; then
        echo "连接数限制已修改为102400,重启服务器后生效"
    else
        echo -n "当前连接数限制："
        ulimit -n
    fi
}

check_limit(){
    echo -n "当前连接数限制："
    ulimit -n
}

echo "======================================================="
echo "安装minerProxy_v5-1_linux 一键工具"
echo "  1、安装(默认安装到/root/minerProxy)"
echo "  2、卸载"
echo "  3、更新"
echo "  4、启动"
echo "  5、重启"
echo "  6、停止"
echo "  7、解除linux系统连接数限制(需要重启服务器生效)"
echo "  8、查看当前系统连接数限制"
#echo "  9、配置开机启动"
echo "======================================================="
read -p "$(echo -e "请选择[1-8]：")" choose
case $choose in
1)
    install
    ;;
2)
    uninstall
    ;;
3)
    update
    ;;
4)
    start
    ;;
5)
    restart
    ;;
6)
    stop
    ;;
7)
    change_limit
    ;;
8)
    check_limit
    ;;
*)
    echo "输入错误请重新输入！"
    ;;
esac
