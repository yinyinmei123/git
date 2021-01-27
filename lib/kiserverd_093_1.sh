#!/bin/bash:/usr/local/bin
read -t 5 -p "[ kiserverd ] please enter install password : " kpasswd
if [ "$kpasswd" = "" ] ; then
    echo "" 
    echo "[ kiserverd ] Timeout , Please start the script again "
    exit 1
elif [ ! $kpasswd = 1226 ] ; then
    echo "[ kiserverd ] ERROR , Please enter the correct password "
    exit 2
fi
mkdir -p /tomcat_file/conf
echo "[ kiserverd ] INFO Checking dependencies >>>"
sleep 1
if [ `rpm -qa multitail |wc -l` = 0 ] ; then
    echo "[ kiserverd ] INFO Installing dependencies >>>"
    yum install -y multitail >/dev/null 2>&1
    [ $? -ne 0 ] && echo "[ kiserverd ] ERROR Dependency installation failed >>>" || echo "[ kiserverd ] INFO Dependency installed successfully >>>"
else
    echo "[ kiserverd ] INFO Writing >>>"
fi
cat > /tomcat_file/conf/yym.cnf <<'EOF'
K_COMMAND=/usr/bin/kiserverd
K_BIN=/tomcat_file/bin
K_CONF=/tomcat_file/conf
K_LOG=/tomcat_file/log
K_TMP=/tomcat_file/tmp
K_MONITOR=/tomcat_file/monitor
K_WORKTMP=/tomcat_file/worktmp
EOF
. /tomcat_file/conf/yym.cnf
touch $K_COMMAND
mkdir -p $K_BIN
mkdir -p $K_CONF
mkdir -p $K_LOG
mkdir -p $K_TMP
mkdir -p $K_MONITOR
mkdir -p $K_WORKTMP
cat > $K_CONF/kiserverd.conf <<'EOF'
[ Basics ]
. /tomcat_file/conf/yym.cnf
fg=--------------------------------------------------------------------------------------------
# 创建tomcat监听目录
mkdir -p $K_MONITOR/$3
# kill的tomcat服务的PID存放文件
KPID=$K_WORKTMP/kill_process.log
# tomcat服务的路径存放位置
Shpath=$K_CONF/startup.log
# ANSI绿色
B_green="\033[032m"
# ANSI红色
B_red="\033[031m"
# ANSI黄色
B_yellow="\033[033m"
# ANSI闪烁
B_twinkle="\033[5m"
# ANSI高亮
B_highlight="\033[1m"
# ANSI结束
B_end="\033[0m"
# tomcat启动文件名
tomcat_start="startup.sh"
# 金蝶启动文件名
jindie_start="startapusic"
# 脚本检索服务的目录
server_path=/opt/
# 系统物理内存总量
Mem_systotal=`free |awk -F "[ ]+" '/Mem/{print $2}'`
# 监测服务title
message="殷银梅是傻蛋"

[ Status ]

# shutdown端口
S_shutdown=off
# ajp端口
S_ajp=off
# http端口
S_http=on
# pid进程号
S_pid=on
# 夹层目录
S_interlayer_path=on
# 状态
S_state=on
# ESTAB
S_estab=on
# 服务路径
S_server_path=on

[ Multitail ]

# 配置文件选择,默认defaults,自定义custom,无null
mul_conf=custom
# 需要开启的模块,null为空
mul_schema=fatebygod
# 日志分割类型,transverse=1，vertical=2
mul_divider=1
# 当垂直分布时生效，定义垂直分列数量
mul_divider_num=2
# 当垂直分布时生效，定义垂直分布的框架
mul_divider_range=null
# 日志名标签，null为空
mul_outer_label=null
# 日志内容标签，null为空
mul_inside_label=null
# 附加命令
mul_command='null'
# 附加命令刷新时间,设置为null或者0则关闭刷新
mul_command_time=0
# 缓冲行数量
mul_buffer_num=100
# 缓冲区大小,以字节为单位，使用xKB/mb/GB
mul_buffer_size=1

EOF

cat > $K_CONF/basics.conf <<'EOF'
# This is debugging basics conf.
# If you don't know about this program, please don't modify this file at will

B_exclude_values="bin|webapps|conf|work|logs|lib|temp|File"

B_exclude_process="grep|tail"

B_check_values="tomcat"

B_include_httpprot=protocol\=\"HTTP\/1.1\"


EOF
cat > $K_CONF/kiserverd.help <<'EOF'
###################################################################################################

KISERVERD

This paper introduces how to use kiserverd and how to control the service more efficiently.
This content will be constantly updated to improve the new functions and optimize the operation. 
However, the update speed is not particularly fast, so please use the version you see.


FRONT AND APPLICATION

     -p
          (Tomcat) (keyword) (start | stop | restart) controls the state of a Tomcat service
          Active front-end operation can control the service, start, stop and restart

     -status 
           View all Tomcat service status information under / opt directory, including service name,
           process number, status information, service directory, etc. If you need port number,\
           estab information, etc., you need to turn on the display of related ports in the
           configuration file. Some ports are hidden by default. The monitoring directory / opt 
           can also be changed, also in the configuration file.

     -c 
           Clean up / Tomcat_ All contents under file are used to clear the cache, but the
           configuration is also cleaB_red
 
     -l [options]
           view the log file of Tomcat service monitoB_red in the background
           增强日志查看模式：
           1>此模式需要配置文件支持
           2>参数mul_conf，定义需要启动的配置文件路径，默认defaultom,无nulls,自定义custom,无null 
             自定义配置文件路径/tomcat_file/conf/multitail.conf
             默认配置文件路径/etc/multitail.conf
             null则为不启动配置文件，简洁模式
           2>参数mul_schema，指定个性化模板，null为空
           3>参数mul_divide，指定屏幕分割方式，transverse=1，vertical=2 
             transverse=1 为水平模式，日志将以上下分屏的方式显示
             vertical=2   为垂直模式，日志将以左右分表的方式显示
           4>参数mul_divider_num，指定垂直模式时，垂直分割的数量，设定为N,则为N分割
           5>参数mul_divider_range，指定垂直分布的框架，以“,”表示分割
             例如：mul_divider_range=1,2 表示垂直分割数量为2，左屏日志数量为1，右屏日志数量为2
             注意：当查看日志数量大于指定框架数量的总量时，多余的日志会默认在垂直分割最右边以添加的方式显示
           6>参数mul_outer_label,定义外标签，文件名标签
           7>参数mul_inside_label，定义内标签，在日志内显示定义的标签内容
           8>参数mul_command，附加额外命令，可新增一个窗口，用来监控
           9>参数mul_command_time，附加命令刷新时间，单位s
     -999l [options] 
           view the log file of Tomcat service monitoB_red in the background, with 999 lines

     --version 
           to view the version information of the currently used script

     --process
            view the currently running background listening process information

     --process-kill
            shut down all running background listening processes

     --log
            view script listening log

     --999log
            view script listening log, 999 lines

     -m
            monitors Tomcat service status



Kiserverd monitor [options] [start|stop|restart]
            Start the background monitoring mode to perform the specified operation on the specified
            service. When the files that need to be decompressed appear in the monitoring directory, 
            the operation will be carried out. And continue to work in the background, monitoring

kiserverd monitor -c 
            A new interactive mode, in which you can monitor the directory for operation, you can also
            choose the type of control, real-time control, delay control, or even no control.
EOF

cat > $K_CONF/status.conf <<'EOF'
# tomcat进程号，需开启
local tomcat_pid=`ps -ef|grep "${n2}/"|egrep -v "$B_exclude_process"|awk '{print $2}'`

# shutdonw端口显示默认关闭

# while [ `echo "$shutdown_prot"|wc -L` -lt 9 ]
# do
#     shutdown_prot="$shutdown_prot "
# done
# rung_shutdown_prot="-----------+"
# title_shutdown_prot=" \033[1mSHUT DOWN\033[0m |"
# SHUTDOWN_PROT=" $shutdown_prot |"

# ajp端口显示默认关闭

# while [ `echo "$ajp_prot"|wc -L` -lt 9 ]
# do
#     ajp_prot="$ajp_prot "
# done
# rung_ajp_prot="-----------+"
# title_ajp_prot=" \033[1mAJP  端口\033[0m |"
# AJP_PROT=" $ajp_prot |"

# http端口显示默认打开

while [ `echo "$http_prot"|wc -L` -lt 9 ]                                                                                          
do
     http_prot="$http_prot "
done
if [ "$tomcat_pid" = "" ] ; then                                                                                                                             
    if [ "$http_prot" = "端口异常 " ] ; then
        http_prot=$B_twinkle$B_red$http_prot$B_end$B_end
    else
        http_prot=$B_yellow$http_prot$B_end
    fi
else
    http_prot=$B_green$http_prot$B_end
fi
HTTP_PROT=" $http_prot |"
rung_http_prot=-----------+
title_http_prot=" ${B_highlight}HTTP 端口$B_end |"

# PID进程号显示

if [ "$tomcat_pid" = "" ] ; then
    tomcat_runstatus="\033[031m\033[5mstop\033[0m\033[0m   "
else
    tomcat_runstatus="\033[032mruning\033[0m "
fi

if [ `echo $tomcat_pid|wc -L` -eq 5 ] ; then
    tomcat_pid=$tomcat_pid$blackspace
elif [ `echo $tomcat_pid|wc -L` -eq 4 ] ; then
    tomcat_pid=$tomcat_pid$blackspace$blackspace
elif [ `echo $tomcat_pid|wc -L` -eq 6 ] ; then
    tomcat_pid=$tomcat_pid
else
    tomcat_pid=$tomcat_pid$blackspace$blackspace$blackspace$blackspace$blackspace$blackspace
fi
TOMCAT_PID=" $B_green$tomcat_pid$B_end |"
rung_tomcat_pid="--------+"
title_tomcat_pid=" $B_highlight进程号$B_end$pid_blackspace |"

# 夹层目录显示默认开启

interlayer_path=`echo ${n2%/*}`
interlayer_path=`echo ${interlayer_path#*opt}`
if [ ! "$interlayer_path" = "" ] ; then
    interlayer_path=$B_green${interlayer_path#/}$B_end
else
    interlayer_path="${B_yellow}无$B_end"
fi
while [ `echo -e "$interlayer_path"|wc -L` -lt 16 ]
do
    interlayer_path=$interlayer_path$blackspace
done
INTERLAYER_PATH=" $interlayer_path |"
rung_interlayer_path="----------+"
title_interlayer_path=" \033[1m夹层目录\033[0m |"

# 状态显示默认开启

tomcat_pid=`ps -ef|grep "${n2}/"|egrep -v "$B_exclude_process"|awk '{print $2}'`
if [ "$tomcat_pid" = "" ] ; then
    tomcat_runstate="\033[031m\033[5mstop\033[0m\033[0m   "
else
    tomcat_runstate="\033[032mruning\033[0m "
fi 
TOMCAT_RUNSTATE=" $tomcat_runstate |"
title_tomcat_state=" \033[1m状态\033[0m$status_blackspace    |"
rung_tomcat_state=---------+

# estab默认开启
 
[ -f ${n2}/conf/server.xml ] && {
http_prot_s=`egrep "Connector" ${n2}/conf/server.xml |egrep "$B_include_httpprot"|awk -F '"' '{print $2}'`
}
if [ "$tomcat_pid" = "" ] ; then                                                                                                              
    ESTABLISHED="${B_yellow}NULL $B_end"
else
    ESTABLISHED=`ss -na | grep ESTAB | grep $http_prot_s | wc -l`
fi
while [ `echo "$ESTABLISHED"|wc -L` -lt 5 ]
do
    ESTABLISHED="$ESTABLISHED "
done
ESTABLISHED=" $ESTABLISHED |"
title_estab=" \033[1mESTAB\033[0m |"
rung_estab="-------+"

# tomcat服务路径默认开启
while [ `echo "$n2"|wc -L` -lt $[$maxdepth_path-1] ]
do
    n2=$n2$blackspace
done   
while [ `echo "$tomcat_path_dir_blackspace"|wc -L` -lt $[$maxdepth_path-6] ]
do
    tomcat_path_dir_blackspace="$tomcat_path_dir_blackspace "
    rung_3=${rung_3}-
done
rung_tomcat_server_path=$rung_3-------+
titile_tomcat_server_path=" \033[1m路径\033[0m$tomcat_path_dir_blackspace  |"
TOMCAT_SERVER_PATH=" $n2 |"
EOF

cat > $K_CONF/multitail.conf <<'EOF'
colorscheme:fatebygod
cs_re:yellow:[Ww]arning.*
cs_re:magenta:1226
cs_re:green:INFO
cs_re:blue:[Mm][Aa][Ii][Nn]
cs_re:red:ERROR.*|Error.*|error.*
cs_re:red:error
EOF


cat > $K_CONF/.aes.cnf <<'EOF'
#!/bin/bash
aes() {
    SSH_pw_w=(`sed -n "/password/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}'`)
    SSH_pw=($(for passwd in ${SSH_pw_w[*]} ; do
        local nn=`eval echo '${SSH_pw_w[passwd]}=' | openssl aes-128-cbc -d -k 1226 -base64`
        echo $nn
        done))
    SSH_global_pw_w=$(sed -n "/global_passwd/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}') 
    SSH_global_pw=`echo ${SSH_global_pw_w}= | openssl aes-128-cbc -d -k 1226 -base64`                                                                     
}
EOF
cat > $K_BIN/control.sh <<'EOF'
#-----------------------------------------------------------------------------------------------------------------------------
# This is a script to refresh and control the restart of Tomcat service.
# This script does not need to be started manually. It is called automatically when running kiserver monitor.
# Please don't change the content without understanding the running process.
#
#  flush_date     It is used to cycle control the restart service time. It will refresh automatically after 60 seconds, 
#                 and output new waiting practice until the end of waiting, and call out the loop
#  
#  control_restart This function is used to determine how to promote the service, restart now, delay restart, regular 
#                  restart, and output the log content.
#
#
#
#
#
#------------------------------------------------------------------------------------------------------------------------------

flush_date() {
    jiange_date=$control_time
    for ((i=60;i<$control_time;i=i+60))
    do
        daemon_process $* 
        ((jiange_date=$jiange_date-60))
        echo -e "[ $ltime - $3 ]   wait sleep$B_yellow  $jiange_date $B_end s ，until $B_yellow $control_time_h:$control_time_m $B_end restart server"  >>$K_LOG/kiserverd.log
        sleep 60
    done
    ex=0
}

flush_date_new() {
    jiange_date=$control_time
    jiange_date=$[$jiange_date-60]
    while true ; do
        while [ "$jiange_date" -gt 0 ] ; do
            ltime=`date +%F" "%T`
		    echo -e "[ $ltime - $3 ]   wait sleep $B_yellow $jiange_date $B_end s ，until $B_yellow $6:$7 $B_end restart server"  >>$K_LOG/kiserverd.log
            jiange_date=$[$jiange_date-60]
            sleep 60	
	    done
        [ "$jiange_date" -le 0 ] && break  
    done
	ex=0
}

control_restart() {
    case $5 in
        now)
            :
            ;;
        delay)
            daemon_process $* 
            echo $$ |tee -a $K_WORKTMP/monitor_process.tmp
            echo -e "[ $ltime - $3 ]   wait sleep $B_yellow $control_time $B_end s ，until $B_yellow $control_time_h:$control_time_m $B_end restart server"  >>$K_LOG/kiserverd.log
            sleep 60
            flush_date $*
            ;;
        fixed)
            daemon_process $* 
            if [ $jiange_date -gt 0 ];then
            echo $$ |tee -a $K_WORKTMP/monitor_process.tmp
            echo -e "[ $ltime - $3 ]   wait sleep $B_yellow $control_time $B_end s ，until $B_yellow $6:$7 $B_end restart server"  >>$K_LOG/kiserverd.log
            control_time_h=$6
            control_time_m=$7
            sleep 60
            jiange_date=$control_time
            jiange_date=$[$jiange_date-60]
            fi
            flush_date_new $*
            ;;
        *)
    esac
}

EOF

cat > $K_BIN/jindie.sh <<'EOF'
#-----------------------------------------------------------------------------------------------------
#  This script has not been completed, so it can not be applied well at present.
#  It needs to wait for a large number of test data access to improve the script.
#  It can only be used after that.
#-----------------------------------------------------------------------------------------------------


jindie_start() {
    find $server_path |grep "$jindie_path"|grep $3 >$Shpath
    echo $fg >>$K_LOG/kiserverd.log
    for startGJZ in `cat $Shpath`
    do
        setsid ${startGJZ} -p &
        retval=$?
        successful_fail $*
    done
}

jindie_stop() {
    daemon_process &>/dev/null
    echo $fg >>$K_LOG/kiserverd.log
    echo "[ $ltime - $3 ]   [ $3 ]  PID : ${CatKPID:-:}   Killed " >>$K_LOG/kiserverd.log
    kill -9 $CatKPID &>/dev/null
    echo $fg >>$K_LOG/kiserverd.log
}


# 金蝶模块，待添加

jindie() {
    case "$4" in
        start)
            jindie_start $*
            ;;
        stop)
            jindie_stop $*
            ;;
        restart)
            jindie_stop $*
            sleep 2
            jindie_start $*
            ;;
        status)
            jindie_status
            ;;
        *)
    esac
}

EOF

cat > $K_BIN/tomcat_main.sh <<'EOF'
#-----------------------------------------------------------------------------------------
#    This script is used to determine the parameters to control Tomcat
#-----------------------------------------------------------------------------------------

. $K_BIN/shutdown.sh
. $K_BIN/start.sh

tomcat_start_path() {
    case $4 in
        start)
            tomcat_start $*
            ;;
        stop)
            tomcat_stop $*
            ;;
        restart)
            tomcat_stop $*
            sleep 2
            tomcat_start $*  
            monitor_pid=`echo $$`
            sed -i "/$monitor_pid/d" $K_WORKTMP/monitor_process.tmp
            ;;
        *)
            echo "usage : $0 {start|stop|restart}" >>$K_LOG/kiserverd.log
    esac
}

EOF
cat > $K_BIN/start.sh <<'EOF'
#----------------------------------------------------------------------------------------
#    Start Tomcat and proceed to the next step
#----------------------------------------------------------------------------------------

successful_fail() {
    [ $retval -eq 0 ] && {
    daemon_process &>/dev/null
    new_tomcat=`ps -ef|grep "${startGJZ}/"|egrep -v "kiserverd|grep"|awk '{print $2}'`
    echo -e "[ $ltime - $3 ] $B_green $startGJZ  ==========    successful...... $B_end" >>$K_LOG/kiserverd.log
    echo -e "[ $ltime - $3 ] \033[034m  [ $3 ]  PID : $new_tomcat   Started $B_end" >>$K_LOG/kiserverd.log

    if [ "$1" = "-p" ]
    then
        . /etc/init.d/functions
        action  "$(echo -e "\033[032m tomcat_$3 \033[0m")" /bin/true
    fi
    echo $fg >>$K_LOG/kiserverd.log
    return $retval
    } || {
    daemon_process &>/dev/null
    echo -e "[ $ltime - $3 ] $B_red $startGJZ  ==========  fail...... $B_end" >>$K_LOG/kiserverd.log
    echo $fg >>$K_LOG/kiserverd.log
    if [ "$1" = "-p" ]
    then
        . /etc/init.d/functions
        action  "$(echo -e "\033[031m tomcat_$3 \033[0m")" /bin/false
    fi

    return $retval
    }
}

tomcat_start() {
    echo $fg >>$K_LOG/kiserverd.log
    for startGJZ in ${tomcat_select[*]}                                                                                                                                                  
    do
        sh ${startGJZ}/bin/startup.sh >>$K_LOG/kiserverd.log
        retval=$?   
        successful_fail $*
    done
}

EOF

cat > $K_BIN/shutdown.sh <<'EOF'
#-----------------------------------------------------------------------------------------
#    Stop Tomcat and proceed to the next step
#-----------------------------------------------------------------------------------------


tomcat_stop() {
    daemon_process &>/dev/null
    KPID=$(ps -ef|grep  $3|egrep -v "grep|kiserverd"|awk '{print $2}')
    echo $fg >>$K_LOG/kiserverd.log
    echo "[ $ltime - $3 ]   [ $3 ]  PID : ${KPID:-:}   Killed " >>$K_LOG/kiserverd.log
    kill -9 $KPID &>/dev/null
    echo $fg >>$K_LOG/kiserverd.log
}

EOF


cat > /tomcat_file/version.info<<'EOF'
# File Name: kiserverd.sh
# Version: 0.9.3.1
# Author: fate by god
# Created Time : 2021-01-27 16:53:09
# Description: 1.修复部分bug
EOF

A_VERSION="kiserver_version=0.88"
H_VERSION="0.9.1"
local_hostname=`ifconfig |grep 10.0.0.52|wc -l`
if [ "`hostname`" = "db02" ] ; then
    if [ "$local_hostname" = "1" ] ; then
        sed -i "/kiserver_version=/c $A_VERSION" /root/make-kiserverd.sh
        sed -i "/kiserver_version=/c $A_VERSION" /server/scripts/make-install-kiserverd.sh
        sed -i "/kiserver_version=/c $A_VERSION" /server/scripts/make-install-kiserverd-ssh.sh
    fi
fi
sed -i "/Version/c # Version:$H_VERSION" /tomcat_file/version.info
cat > $K_COMMAND <<'EOF'
#!/bin/bash
#########################################################################################
# File Name: kiserverd.sh
# Version: 0.8.4
# Author: fate by god
# Created Time : 2020-12-23 15:20:09
# Description: 1.修复定时重启bug，可于设定的好的规定时间每日自动操作（监测到压缩文件后）
#                需注意，当服务器时间晚于规定定时时间时，服务会默认立即重启
#              2.修复延时启动bug，修正每次延时后显示时间皆为第一次读取时间的Bug
#                服务将于每次监测后，重新刷新延时时间
#              3.优化--process功能，更改表格框架
#              4.修复--process功能进程显示bug ( kiserverd其他功能被识别为进程)
#              5.修复--99log下的tab键不识别bug
#              6.更新监测解压后，不重启的功能
#              7.新增--help,才看脚本的操作帮助
########################################################################################
. /tomcat_file/conf/yym.cnf
. $K_CONF/kiserverd.conf
. $K_CONF/basics.conf
. $K_BIN/tomcat_server_monitor.sh
[ ! "$3" = "" ] && tomcat_select=(`cat $K_WORKTMP/tomcat_full_path.dir|grep $3`)
touch $K_WORKTMP/unzip_protect.lock
touch $K_LOG/kiserverd.log

date_process() {

    ltime=`date +%F" "%T`
}


daemon_process() {
    ltime=`date +%F" "%T`
    local control_time_h_old="$6"
    local control_time_m_old="$7"
	if [ $5 = "delay" ];then
	        now_time_h=`date +%H`
            now_time_m=`date +%M`
            control_time=$[${control_time_h_old}*60+$control_time_m_old]
            control_time=$[${control_time}*60] 
       if [ "$ex" = "0" ];then
            control_time_h=$[${control_time_h_old}+${now_time_h}]
            control_time_m=$[${control_time_m_old}+${now_time_m}]
       fi
       if [ $control_time_m -gt 59 ];then
           control_time_m=$[$control_time_m-60]
           control_time_h=$[$control_time_h+1]
       fi
       if [ $control_time_m -lt 10 ] && [ `echo "$control_time_m"|wc -L` -eq 1 ];then
           control_time_m="0$control_time_m"
       fi
       if [ $control_time_h -lt 10 ] && [ `echo "$control_time_h"|wc -L` -eq 1 ];then
           control_time_h="0$control_time_h"
       fi
       ex=1
	fi
	
	if [ $5 = "fixed" ];then
	    now_time_h=`date +%H`
        now_time_m=`date +%M`
        if [ "$now_time_h" -lt 10 ];then
            now_time_h=${now_time_h#0}
        fi
        if [ "$now_time_m" -lt 10 ];then
            now_time_m=${now_time_m#0}
        fi
        control_time=$[($6-${now_time_h})*60+$7-${now_time_m}] 
        control_time=$[${control_time}*60]
        jiange_date=$control_time 
	fi
}

sleep_information() {
    daemon_process &>/dev/null
    echo "[ $ltime - $3 ] >>>>>>>>>>请稍后，正在监控......" >>$K_LOG/kiserverd.log  
    sleep 60
}

# 转换单位到人类易读
bit_to_human_readable(){
    #input bit value
    local MemValue=$1
 
    if [[ ${MemValue%.*} -gt 1014 ]];then
        #conv to Mb
        MemValue=`awk -v value=$MemValue 'BEGIN{printf "%0.2f",value/1024}'`
        if [[ ${MemValue%.*} -gt 1014 ]];then                                                                                                                           
        #conv to Gb
            MemValue=`awk -v value=$MemValue 'BEGIN{printf "%0.2f",value/1024}'`
            echo "${MemValue}Gb"
        else
            echo "${MemValue}Mb"
        fi
    else
        echo "${MemValue}Kb"                                                                                                                                            
    fi
}


# 服务控制：web服务类型选择

Provinces() {
    daemon_process &>/dev/null
    case "$2" in
        tomcat)
            . $K_BIN/tomcat_main.sh
            tomcat_start_path $*
            ;;
        jindie)
            . $K_BIN/jindie.sh
            jindie $*
            ;;
        *)
            echo -e "[ $ltime - $3 ] $B_red Usage : $0 : {tomcat|hn|sx}  You have to choose a province ! $B_end" >>$K_LOG/kiserverd.log
    esac
}

clear_path() {
    [ -f $K_TMP/clear.lock ] || {
        touch $K_TMP/clear.lock
    }	
    rm -rf ${K_MONITOR:-$K_TMP/clear.lock}
	[ $? -eq 0 ] && {
	    echo ">>>>>>>>>>已清除 $K_MONITOR"
	    exit 0
	} || {
	    echo ">>>>>>>>>>清除失败 $K_MONITOR"
	    exit 1
    }
}



# 解压目标目录下的新文件

unzippath() {
    daemon_process &>/dev/null
	case "$2" in
	    tomcat)
                echo ${tomcat_select[*]} >>$K_WORKTMP/unzip.dir		
	        ;;
		jindie)
		    find $server_path -name application -type d|grep $3|tee "$K_WORKTMP/unzip.dir" &>/dev/null
			;;
		*)
		    :
	esac
	html_path=`cat $K_WORKTMP/unzip.dir`
    for n in ${html_path[*]}
    do
        unzip -o $jy_path -d ${n}/webapps >>$K_LOG/kiserverd.log
		if [ $? -eq 0 ]
		then
		    echo -e "[ $ltime - $3 ] $B_yellow 检索到文件：[ $jy_path ] 已解压到 [ ${n}/webapps ] $B_end" >>$K_LOG/kiserverd.log
		else
		    echo -e "[ $ltime - $3 ] $B_red 检索到文件：[ $jy_path ] 解压失败 $B_end" >>$K_LOG/kiserverd.log
		fi
    done
	sleep 1
    echo $fg >>$K_LOG/kiserverd.log
    echo -e "[ $ltime - $3 ] $B_green 检索到文件：[ $jy_path ] 已解压到 [ $html_path ] $B_end" >>$K_LOG/kiserverd.log
    rm -f ${jy_path:-$K_WORKTMP/unzip_protect.lock}
	sleep 1
    [ "$4" = "null" ] && xunhuan $*
    ex=0
	> $K_WORKTMP/unzip.dir
    daemon_process $*   
    . $K_BIN/control.sh
    control_restart $*
    Provinces $*
}

# 判断用户上传的新文件是否完整

test_unzip() {
    daemon_process &>/dev/null
    for n in $jy_path
    do
        unzip -t $n &>/dev/null
        retavl=$?
        [ $retavl -eq 0 ] && {
            echo -e "[ $ltime - $3 ] $B_green 检索到文件：[ $jy_path ] $B_end" >>$K_LOG/kiserverd.log
            unzippath $*
        } || {
            echo -e "[ $ltime - $3 ] $B_yellow 检索到文件：[ $jy_path ], 但文件不完整  $B_end" >>$K_LOG/kiserverd.log
            break 2
        }
    done
}

# 守护进程主进程，监控目标目录的文件变化情况

xunhuan() {
while true
do
    # 守护进程副保护进程
    [ -f $K_WORKTMP/unzip_protect.lock ] || {
        touch $K_WORKTMP/unzip_protect.lock
    }
    # 监控目标目录
    while [ ! "`ls -A $K_MONITOR/$3`" = "" ]
    do
        jy_path=$(find $K_MONITOR/$3/* )
        test_unzip $*
        if [ $retavl -ne 0 ]
        then
            sleep 2
        fi
    done
    sleep_information $*
done
}
 

daemon_module() {

if [ -z $1 ]
then
    echo -e "[ $ltime - $3 ] $B_red Usage: $0 第一参数不能为空 {-p|-c} $B_end" >>$K_LOG/kiserverd.log
    exit 1
elif [ -z $2 ]
then
    echo -e "[ $ltime - $3 ] $B_red Usage: $0 第二参数不能为空 {tomcat|jindie} $B_end" >>$K_LOG/kiserverd.log
    exit 2
elif [ -z $3 ]
then
    echo -e "[ $ltime - $3 ] $B_red Usage: $0 第三参数不能为空 请输入您的关键词，亲 $B_end" >>$K_LOG/kiserverd.log
    exit 3
elif [ -z $4 ]
then
    echo -e "[ $ltime - $3 ] $B_red Usage: $0 第四参数不能为空 {start|stop|restart|status} $B_end" >>$K_LOG/kiserverd.log
    exit 4
else
    xunhuan $*
fi
}


immediately() {
I_unzip_check=(`find $K_MONITOR -type f|egrep -v nohup`)
if [ ! "$I_unzip_check" = "" ] ; then
    for n in ${I_unzip_check[*]} ; do
        I_unzip_name=${n/$K_MONITOR\//}
        I_unzip_name=${I_unzip_name%/*}
        I_tomcat_select=`cat $K_WORKTMP/tomcat_full_path.dir|grep "$I_unzip_name"`
        for i in ${I_tomcat_select[*]} ; do
            unzip -o $n -d $i/webapps
            [ $? -eq 0 ] && echo -e "$B_yellow 检索到文件：[ $n ] 已解压到 [ $i/webapps ] $B_end" || echo -e "$B_yellow 解压失败 $B_end"                                  
            case $2 in
                start)
                    $i/bin/startup.sh
                    sleep 1
                    I_start_pid=`ps -ef|grep "$i/"|egrep -v "grep|kiserverd"|awk '{printf $2}'`
                    echo $I_start_pid
                    ;;
                restart)
                    I_stop_pid=`ps -ef|grep "$i/"|egrep -v "grep|kiserverd"|awk '{printf $2}'`
                    kill -9 $I_stop_pid
                    echo -e "\033[034m  PID : $I_stop_pid   Killed $B_end"
                    $i/bin/startup.sh
                    sleep 1
                    I_start_pid=`ps -ef|grep "$i/"|egrep -v "grep|kiserverd"|awk '{printf $2}'`
                    echo -e "\033[034m  PID : $I_start_pid   Started $B_end"
                    ;;
               *)
            esac
        done
        rm -rf $n
    done
else
    echo "没有搜索到文件，请检查"
fi
}

# 自适应计算
auto_wide() {
    blackspace=" "
    min=0
    for n1 in ${TOMCAT_FULL_PATH[*]}
    do
        n_1=`echo ${n1##*/}`
        max=`echo ${n_1}|wc -L`
        if [ $min -lt $max ]
        then
            min=$max
        fi
    done
    maxdepth=$[$min+1]
    
    # echo $maxdepth
    rung_server_name="-"
    for ((i=0;i<$[$maxdepth+1];i++))
    do
        rung_server_name=${rung_server_name}-
    done 
        rung_server_name=+$rung_server_name+
}
# echo "₍ᐢ •̥ ̫ •̥ ᐢ₎"
status() {
    echo 
    echo "╔══╯╔╮╔╮╔══╗　╗╠══╗  ╭╮　╭══╮╭╮╭╮╭══╮"
    echo "╠══╗║║╠═║　║╚╠╔═══╗  ║║  ║╭╮║║║║║║╭═╯"
    echo "╠══╣╝╚╚╦╠══╣╭╠║　╮║  ║║　║║║║║║║║║╰═╮"
    echo "╠══╯╔╗╔╠╠══╯║║║　║║  ║║　║║║║║║║║║╭═╯"
    echo "╠══╗║║╚║║═╠╮║║╠═ ╠╣  ║╰═╮║╰╯║╰╮╭╯║╰═╮"
    echo "╯╰═╝╰╩╰╚╯ ╚╝╚╚╚═══╯  ╰══╯╰══╯ ╰╯ ╰══╯"

case "$1" in
    -status)

       auto_wide
       for n3 in ${TOMCAT_FULL_PATH[*]}
        do
            max=`echo $n3|wc -L`
            if [ $min -lt $max ]
            then
                min=$max
            fi
        done
            maxdepth_path=$[$min+1]
 
        for n2 in ${TOMCAT_FULL_PATH[*]}
        do
               
            # 取出tomcat的http,shutdown,ajp的端口号
            [ -f ${n2}/conf/server.xml ] && {
            http_prot=`egrep "Connector" ${n2}/conf/server.xml |egrep "$B_include_httpprot"|awk -F '"' '{print $2}'`
            shutdown_prot=`sed -n '/shutdown="SHUTDOWN"/p' ${n2}/conf/server.xml |awk -F '"' '{print $2}'`
            ajp_prot=`egrep "Connector" ${n2}/conf/server.xml |grep 'protocol="AJP/1.3"'|awk -F '"' '{print $2}'`
            } || {
            http_prot="端口异常 "
            shutdown_prot="端口异常 "
            ajp_prot="端口异常 "
            }
               
            tomcat_pid=`ps -ef|grep "${n2}/"|egrep -v "$B_exclude_process"|awk '{print $2}'`
            
            server_name=`echo  ${n2##*/}`

            while [ `echo "$server_name"|wc -L` -lt $maxdepth ]
            do
                server_name=$server_name$blackspace
            done

            rung_server_name=" "
            rung_num=`echo -e "| $server_name |"|wc -L`
            # rung_num=$[$maxdepth-17]
            for ((i=0;i<$[$maxdepth-7];i++))
            do
                rung_server_name=${rung_server_name}$blackspace
            done
                server_name_blackspace=$rung_server_name

            auto_wide
            . $K_CONF/status.conf
            tomcat_pid=""
 
            # while [ `echo "$n2"|wc -L` -lt $[$maxdepth_path-1] ]
            # do
            #     n2=$n2$blackspace
            # done

            if [ "$title_num" = "" ] ; then
                title_num=1
                echo $rung_server_name$rung_interlayer_path$rung_tomcat_pid$rung_tomcat_state$rung_estab$rung_http_prot$rung_shutdown_prot$rung_ajp_prot$rung_tomcat_server_path
                echo -e "| \033[1m服务名\033[0m$server_name_blackspace |$title_interlayer_path$title_tomcat_pid$title_tomcat_state$title_estab$title_http_prot$title_shutdown_prot$title_ajp_prot$titile_tomcat_server_path"
                echo $rung_server_name$rung_interlayer_path$rung_tomcat_pid$rung_tomcat_state$rung_estab$rung_http_prot$rung_shutdown_prot$rung_ajp_prot$rung_tomcat_server_path
            fi

                echo -e "| $server_name |$INTERLAYER_PATH$TOMCAT_PID$TOMCAT_RUNSTATE$ESTABLISHED$HTTP_PROT$SHUTDOWN_PROT$AJP_PROT$TOMCAT_SERVER_PATH"
        done
            echo $rung_server_name$rung_interlayer_path$rung_tomcat_pid$rung_tomcat_state$rung_estab$rung_http_prot$rung_shutdown_prot$rung_ajp_prot$rung_tomcat_server_path
        ;;
    *)
        echo -e "\033[033m 请输入参数 \033[0m"
esac
}

kiserverd_process() {
    touch $K_WORKTMP/monitor_process.tmp
    local clear=true
    kiserverd_process_pid=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $2}'`
    kiserverd_process_pid_num=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $2}'|wc -l`
    if [ "$kiserverd_process_pid" != "" ]
    then
        kiserverd_process_keyword=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $12}'|sed -n "${kiserverd_process_num}p"`
        max=0
        for i in ${kiserverd_process_keyword[*]}
        do
            min=${#i}
            if [ "$max" -lt "$min" ];then
                max=$min
            fi
        done
        rung_server_name=-
        while [ ${#rung_server_name} -lt "$[$max+6]"  ]
        do
            rung_server_name=$rung_server_name-
        done
        server_name_title=" server name "
        while [ `echo "$server_name_title"|wc -L` -lt "$[$max+6]" ]
        do
            server_name_title="$server_name_title "
            server_name_title_n="$server_name_title_n "
        done
        rung_control_dir=-
        while [ ${#rung_control_dir} -lt "$[$max+28]"  ]
        do
            rung_control_dir=$rung_control_dir-
        done
        control_dir_title="     CONTROL DIR "
        while [ `echo "$control_dir_title"|wc -L` -lt "$[$max+28]" ]
        do
            control_dir_title="$control_dir_title "
            control_dir_title_n="$control_dir_title_n "
        done
        echo ""
        echo -e "\033[036m    < KISERVER-MONITOR PROCESS >\033[0m                            $message"
        for ((kiserverd_process_num=1;kiserverd_process_num<=$kiserverd_process_pid_num;kiserverd_process_num++))
        do
            kiserverd_process_pid=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $2}'|sed -n "${kiserverd_process_num}p"`
            kiserverd_process_keyword=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $12}'|sed -n "${kiserverd_process_num}p"`
            kiserverd_process_server=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $11}'|sed -n "${kiserverd_process_num}p"`
            kiserverd_process_mode=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $13}'|sed -n "${kiserverd_process_num}p"`
            kiserverd_process_control=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $14}'|sed -n "${kiserverd_process_num}p"`
            kiserverd_process_control_time1=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $15}'|sed -n "${kiserverd_process_num}p"`
            kiserverd_process_control_time2=`ps -ef|grep kiserverd|egrep -v "grep|process|tail|log|-m"|awk '{print $16}'|sed -n "${kiserverd_process_num}p"`
            if [ `sed -n "/$kiserverd_process_pid/p" $K_WORKTMP/monitor_process.tmp|wc -l` -gt 0 ];then
                kiserverd_process_state="WAITING"
            else
                kiserverd_process_state="RUNGING"
            fi
            [[ $clear == true ]]                                                        && \
            echo +$rung_server_name+---------+--------+---------+---------+-------+$rung_control_dir+ && \
            echo "| SERVER NAME $server_name_title_n|  STATE  |  PID   | ST      | CONTROL | TIME  |     CONTROL DIR $control_dir_title_n|" && \
            echo +$rung_server_name+---------+--------+---------+---------+-------+$rung_control_dir+
            if [ "$kiserverd_process_state" = "WAITING" ];then 
                printf_blue="\e[36m"
                printf_B_end="\e[0m"
            fi
            if [ "$kiserverd_process_mode" = "null" ];then
                kiserverd_process_mode="NOTHING"
            fi
            if [ "$kiserverd_process_control" = "" ];then
                kiserverd_process_control="NULL"
            fi
            if [ "$kiserverd_process_control_time1" = "" ];then
                kiserverd_process_control_time3="NULL "
            else
                kiserverd_process_control_time3="$kiserverd_process_control_time1:$kiserverd_process_control_time2"
            fi
            if [ "$kiserverd_process_control" = "fixed" ];then
                if [ "$kiserverd_process_control_time1" -le `date +%H` ];then
                    if [ "$kiserverd_process_control_time2" -le `date +%M` ];then
                        printf_B_yellow="\e[33m"
                        printf_B_end="\e[0m"
                    fi
                fi
            fi
            printf "%s %-$((${max}+4))s %s $printf_blue%s$printf_B_end %s %-6s %s %-7s %s %-7s %s $printf_B_yellow%s$printf_B_end %s %-$((${max}+26))s %s %s\n"                   \
                   "|" "$kiserverd_process_keyword"                                          \
                   "|" "$kiserverd_process_state"                                            \
                   "|" "$kiserverd_process_pid"                                              \
                   "|" "$kiserverd_process_mode"                                             \
                   "|" "$kiserverd_process_control  "                                        \
                   "|" "$kiserverd_process_control_time3"                                    \
                   "|" "/${kiserverd_process_server}_file/monitor/$kiserverd_process_keyword"        \
                   "|"
                printf_blue=""
                printf_B_yellow=""
                printf_B_end="" 
           [[ $clear == true ]] && clear=false
        done
           echo +$rung_server_name+---------+--------+---------+---------+-------+$rung_control_dir+
    else
        echo -e "\033[036m<状态信息>\033[0m"
        echo -e "运行状态：\033[031m\033[5m 未运行 \033[0m\033[0m"
    fi
}

kiserverd_process_kill() {
    kiserverd_process_pid=`ps -ef|grep kiserverd|egrep -v "grep|process"|awk '{print $2}'`
    if [ "$kiserverd_process_pid" != "" ]
    then
        kill $kiserverd_process_pid

        [ $? -eq 0 ] && {
        echo -e "\033[032m\033[1m 监控已关闭 \033[0m\033[0m"
        } || {
        echo -e "\033[031m\033[1m 服务异常 \033[0m\033[0m"
        }
    else
        echo -e "\033[031m\033[1m 服务未运行 \033[0m\033[0m"
    fi
}

kiserverd_process_log() {
    tail -${tail_num}f $K_LOG/kiserverd.log
}

cat_tomcat_log() {
    if [ "$2" = "" ] ; then
        if [ `kiserverd --process|wc -L` -lt 100 ] ; then echo ">>>>>  There are no monitoring processes running " && exit ; fi
    fi
    if [ "$mul_conf" = "custom" ] ; then 
        T_mul_F="-F $K_CONF/multitail.conf"
        T_mul_cS="-cS $mul_schema"
    fi
    if [ "$mul_conf" = "defaults" ] ; then
        T_mul_F=""
        T_mul_cS="-c"
    fi
    if [ "$mul_conf" = "null" ] ; then 
        T_mul_F=""
        T_mul_cS=""
    fi
    if [[ "$mul_divider" = "2" ]] ; then
        T_mul_s="-s"
        if [[ ! "$mul_divider_num" =~ 0|1|null ]] ;then
            T_mul_s="-s $mul_divider_num"
            echo $T_mul_s
            if [[ ! "$mul_divider_range" =~ 0|1|null ]] ; then
                T_mul_sn="-sn $mul_divider_range"
                echo $T_mul_sn
            fi
        fi
    fi
    if [ ! "$mul_inside_label" = "null" ] ;then
        T_mul_label="--label $mul_inside_label"
    fi
    if [ ! "$mul_outer_label" = "null" ] ; then
        T_mul_t="-t $mul_outer_label"
    fi
    if [ ! "$mul_command" = "null" ] ; then
        T_mul_l="-l \"$mul_command\""
        if [[ ! "$mul_command_time" =~ 0|null ]] ;then
            T_mul_R="-R $mul_command_time"
        fi
    fi
    
    # if [ "$1" = "^-[0-9]*l$" ] ; then
    if [[ ! "$1" =~ ^-l ]] ; then
        if [ "$2" != "" ] ; then
            tomcat_log=`find /opt/ -type d -maxdepth 2 2>/dev/null |grep tomcat|grep $2|egrep -v "$B_exclude_values"`
            tail -${tail_num}f ${tomcat_log}/logs/catalina.out
            exit 0
        else
            kiserverd_process_keyword=`ps -ef|grep kiserverd|egrep -v "grep|process"|awk '{print $12}'`
            tomcat_log=`find /opt/ -type d -maxdepth 2 2>/dev/null |grep tomcat|grep $kiserverd_process_keyword|egrep -v "$B_exclude_values"`
        tail -${tail_num}f ${tomcat_log}/logs/catalina.out
        exit 0
        fi
    fi
    if [ "$1" = -l ] ; then
        process_keyword="$2|$3|$4"
        if [ "$4" = "" ] ; then
           process_keyword="$2|$3"
           if [ "$3" = "" ] ; then
               process_keyword="$2"
               if [ "$2" = "" ] ; then
                   process_keyword=(`ps -ef|grep kiserverd|egrep -v "grep|process"|awk '{print $12}'`)
               fi
           fi
        fi
    fi
    if [[ ! "$mul_buffer_num" =~ null|100 ]] ; then
        T_mul_m="-m $mul_buffer_num"
    elif [ ! "$T_mul_mb" = "null" ] ; then
        T_mul_mb="-mb $mul_buffer_size"
    else
        T_mul_m=""
        T_mul_mb=""
    fi

    mul_tomcat_log=(`find /opt/ -type d -maxdepth 2 2>/dev/null |grep tomcat|egrep "$process_keyword"|egrep -v "$B_exclude_values"`)
    mul_values_n=(`for i in ${mul_tomcat_log[*]} ; do
        local n=$(echo "$T_mul_cS $T_mul_m $T_mul_mb $T_mul_label $T_mul_t $i/logs/catalina.out")      
        echo $n ; done`)
    echo "multitail $T_mul_F $T_mul_s $T_mul_sn ${mul_values_n[*]} $T_mul_R $T_mul_l"
    eval multitail $T_mul_F $T_mul_s $T_mul_sn ${mul_values_n[*]} $T_mul_R "$T_mul_l"
    exit 0

}

edit_conf() {
    vim $K_CONF/kiserverd.conf 
    . $K_CONF/kiserverd.conf

    if [ "$S_shutdown" = "on" ] ; then
       [ `sed -n "6,12p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "6,12s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_shutdown" = "off" ] ; then
       [ `sed -n "6,12p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "6,12s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_ajp" = "on" ] ; then
       [ `sed -n "16,22p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "16,22s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_ajp" = "off" ] ; then
       [ `sed -n "16,22p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "16,22s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_http" = "on" ] ; then
       [ `sed -n "26,41p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "26,41s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_http" = "off" ] ; then
       [ `sed -n "26,41p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "26,41s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_pid" = "on" ] ; then
       [ `sed -n "45,62p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "45,62s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_pid" = "off" ] ; then
       [ `sed -n "45,62p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "45,62s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_interlayer_path" = "on" ] ; then
       [ `sed -n "66,79p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "66,79s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_interlayer_path" = "off" ] ; then
       [ `sed -n "66,79p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "66,79s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_state" = "on" ] ; then
       [ `sed -n "83,91p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "83,91s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_state" = "off" ] ; then
       [ `sed -n "83,91p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "83,91s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_estab" = "on" ] ; then
       [ `sed -n "95,109p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "95,109s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_estab" = "off" ] ; then
       [ `sed -n "95,109p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "95,109s/^/# &/g" $K_CONF/status.conf
       }
    fi
    if [ "$S_server_path" = "on" ] ; then
       [ `sed -n "112,123p" $K_CONF/status.conf |grep "# "|wc -l` -gt 1 ] && {
           sed -i "112,123s/# //g" $K_CONF/status.conf
       }
    fi
    if [ "$S_server_path" = "off" ] ; then
       [ `sed -n "112,123p" $K_CONF/status.conf |grep "# "|wc -l` -lt 1 ] && {
           sed -i "112,123s/^/# &/g" $K_CONF/status.conf
       }
    fi


}

# 取出tomcat服务路径，端口，进程号，服务名 
select_value() {
. $K_CONF/kiserverd.conf
tomcat_path=(`find $server_path -type d -maxdepth 2 2>/dev/null |grep tomcat|egrep -v "$B_exclude_values"`)
http_prot=(`for n in ${tomcat_path[*]} ; do
    [ -f ${n}/conf/server.xml ]  && { 
    local nn=$(egrep "Connector" ${n}/conf/server.xml |egrep "$B_include_httpprot"|awk -F '"' '{print $2}')
    } || { 
    local nn="NO_HTTP_PROT" ; }
    echo $nn
done`)
     
tomcat_pid=(`for n in ${tomcat_path[*]} ; do
    local nn=$(ps -ef|grep "${n}/"|egrep -v "grep|tail"|awk '{print $2}')
    [ "$nn" = "" ] && nn="NO_PID"
    echo $nn
done`)
server_name=(`for n in ${tomcat_path[*]} ; do
    local nn=${n##*/}
    echo $nn
done`)
}

# 时间解析
time_pro() {
    YMD_time=`date +"%Y-%m-%d"`
    H_time=`date +"%H"`
    MS_time=`date +":%M:%S"`
    W_time=`date +"%w"`
    if [ $H_time -lt 8 ] ; then 
         time_status="$B_red$B_highlight 修仙时间 $B_end$B_end" 
    elif [ $H_time -lt 11 ] ; then 
         time_status="$B_green$B_highlight 上午 $B_end$B_end" 
    elif [ $H_time -lt 14 ] ; then 
         time_status="$B_yellow$B_highlight 中午 $B_end$B_end" 
    elif [ $H_time -lt 18 ] ; then 
         time_status="$B_green$B_highlight 下午 $B_end$B_end" 
    elif [ $H_time -lt 23 ] ; then 
         time_status="$B_yellow$B_highlight 晚上 $B_end$B_end" 
    else 
         time_status="$B_red$B_highlight 修仙时间 $B_end$B_end" 
    fi
}

# 监测服务
tomcat_monitor() {
auto_wide
local clear=true
while true ; do
    #光标移动到0.0的位置
    printf "\033[0;0H"
    #打印头部菜单
    [[ $clear == true ]] && printf "\033[2J" 
    time_pro 
    printf    "%s %s - %s%s   星期%s\n" "TIME:" "$YMD_time" "$H_time" "$MS_time" "$W_time"
    printf    "\033[1;70H"
    echo -e "$time_status"
    [[ $clear == true ]] && \
    echo    "$message                                                      fate by god" && \
    echo -e "$B_highlight                             Tomcat real time monitoring $B_end" && \
    M_T_SERVER_NAME=`echo -e "$B_highlight SERVER NAME $B_end"` && \
    M_T_PID=`echo -e "$B_highlight PID $B_end"`                 && \
    M_T_PROT=`echo -e "$B_highlight PROT $B_end"`               && \
    M_T_ESTAB=`echo -e "${B_highlight}ESTAB$B_end"`             && \
    M_T_RSS=`echo -e "$B_highlight RSS $B_end"`                 && \
    M_T_MEM=`echo -e "$B_highlight  %MEM $B_end"`               && \
    M_T_CPU=`echo -e "$B_highlight %CPU $B_end"`                && \
    echo -e "$rung_server_name---------+--------+-------+----------+---------+--------+" && \
    printf "%s %-$((${maxdepth}+8))s %s %s %s %s %s %s %s %s %s %s %s %s %s\n"  \
           "|" "$M_T_SERVER_NAME"              \
           "|" "$M_T_PID  "                    \
           "|" "$M_T_PROT"                     \
           "|" "$M_T_ESTAB"                    \
           "|" "$M_T_RSS   "                   \
           "|" "$M_T_MEM"                      \
           "|" "$M_T_CPU"                      \
           "|"                              && \
    echo    "$rung_server_name---------+--------+-------+----------+---------+--------+"
    #取出ESTAB
    ESTAB=(`for n in ${http_prot[*]} ; do
        [ ! "$n" = "NO_HTTP_PROT" ] && {
        local nn=$(ss -na | grep ESTAB | grep $n | wc -l) ; } || {
        local nn="NO_HTTP_PROT" ; }
        echo $nn
        done`)
    #取出CPU占比
    server_cpu=(`for n in ${tomcat_path[*]} ; do
        local nn=$(ps aux|grep ${n}/|egrep -v "grep|tail" |awk '{print $3}')
        [ "$nn" = "" ] && {
        local nn="NO_PID" ; }
        echo $nn 
        done`)
    #光标移动到.1
    printf "\033[7;1H"
    for ((i=0;i<${#tomcat_pid[*]};i++)) ; do
        [ ! "${tomcat_pid[i]}" = "NO_PID" ] && {
        # 内存取值
        [ -f /proc/${tomcat_pid[i]}/status ] && {
        Mem=`cat /proc/${tomcat_pid[i]}/status |awk -F "[ ]+" '/VmRSS/{print $2}'`
        Memp=`echo $Mem $Mem_systotal|awk '{print  $1 / $2 * 100}'`
        Mempro=`printf "%0.1f" "$Memp"` ; } || { 
        flase_status=1 
        break 2 ; }
        #清除当前行
        printf "\033[K"
        #打印监测内容
        printf "%-$((${maxdepth}+2))s %-9s %-8s %-7s %-10s %s %7s %s %6s %s\n" \
               "| ${server_name[i]}"                 \
               "|  ${tomcat_pid[i]}"                 \
               "|  ${http_prot[i]}"                  \
               "|  ${ESTAB[i]}"                      \
               "| $(bit_to_human_readable $Mem)"     \
               "|" "$Mempro "                        \
               "|" "${server_cpu[i]} " "|"; }
    done
    echo    "$rung_server_name---------+--------+-------+----------+---------+--------+"
    sleep 2
    #对比有无进程新增或消失
    tomcat_pid_ex=(`for n in ${tomcat_path[*]} ; do
    local nn=$(ps -ef|grep "${n}/"|egrep -v "grep|tail"|awk '{print $2}')
    [ "$nn" = "" ] && nn="NO_PID"
    echo $nn
    done`)
    [ ! "${tomcat_pid_ex[*]}" = "${tomcat_pid[*]}" ] && { 
    flase_status=1 ; break ; }
    [[ $clear == true ]] && clear=false
done
# 重新进入检测
[ "$flase_status" = 1 ] && { 
    false_status=0 
    select_value 
    tomcat_monitor
}
}


sshpasswddone() {
    path_pass=`echo $PATH|grep "\/usr\/local\/bin" |wc -l`
    [ "$path_pass" -eq 0 ] && echo "export PATH=$PATH:/usr/local/bin" >> /etc/profile
    source /etc/profile
    SSH_hs=(`sed -n "/hostname/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}'`)
    SSH_ssh_passwd_done=$(sed -n "/ssh_passwd_done/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}')
    SSH_take_effect_server=$(sed -n "/take_effect_server/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}')
    [ "$SSH_ssh_passwd_done" -ne "1" ] && echo "please write the conf file corectly !" && exit 1
    rm -f /root/.ssh/id_rsa
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa >/dev/null 2>&1
    for ((i=0;i<${#SSH_hs[*]};i++)) ; do
        /usr/local/bin/sshpass -p '${SSH_global_pw:-${SSH_pw[i]}}' ssh-copy-id -i /root/.ssh/id_rsa.pub "-o StrictHostKeyChecking=no ${SSH_hs[i]}"
        [ $? -eq 0 ] && echo "<${SSH_hs[i]}> done " || echo "<${SSH_hs[i]}> error "
    done
    
}

sshcheck() {
    SSH_hs=(`sed -n "/hostname/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}'`)
    if [ $# -lt 2 ];then
    echo "places input one agrs"
    exit 1
    fi
    for ((i=0;i<${#SSH_hs[*]};i++)) ; do
        echo ===== info ${SSH_hs[i]}  $2 =====
        ssh ${SSH_hs[i]} $2 $3 $4 $5 $6
        echo ""
    done

}

sshinstalls() {
    [ $# -lt 2 ] && echo "please input 2 values !" && exit 1
    SSH_hs=(`sed -n "/hostname/p" $K_CONF/ssh_control.conf |awk -F "=" '{print $2}'`) 
    [ "`echo $2 |grep 'toolsdir='|wc -l`" -ne 1 ] && echo "please input the correct values !" && exit 1
    [ "`echo $2 |grep "kiserverd"|wc -l`" -ne 1 ] && echo "please select the correct tools_file !" && exit 1
    # [ "`echo $2 |grep "tar"|wc -l`" -ne 1 ] && echo "please select the correct tools_file !" && exit 1
    toolsdir=${2#--toolsdir=}
    tartoolsname=${2##*/}
    # toolsname=${tartoolsname%.tar}
    for ((i=0;i<${#SSH_hs[*]};i++)) ; do
        # ssh ${SSH_hs[i]} mkdir -p /server/scripts
        scp -r $toolsdir ${SSH_hs[i]}:/root/
        # ssh ${SSH_hs[i]} "tar xf - -C /" < /server/scripts/$tartoolsname
        # ssh ${SSH_hs[i]} "tar xf /server/scripts/$tartoolsname -C /"
        ssh ${SSH_hs[i]} sh  /root/$tartoolsname
        sleep 1
        ssh ${SSH_hs[i]} .  /etc/profile
        echo "<${SSH_hs[i]}> install complete >>>"
    done
}

# 服务控制主控模块
    
yym() {
    daemon_process &>/dev/null
    case "$1" in
        -p)
            Provinces $*
            ;;
	    -clean)
	        clear_path
	        ;;
	    -pd)
	        daemon_module $*
	        ;;
		-status)
		    status $*
			;;
        --version)
            cat /tomcat_file/version.info
            ;;
        --process)
            kiserverd_process
            ;;
        --process-kill)
            kiserverd_process_kill
            ;;
        --*log)
            kiserverd_process_log $*
            ;;
        -*l)
            cat_tomcat_log $*
            ;;
        --conf)
            edit_conf
            ;;
        -m)
            select_value 
            tomcat_monitor
            ;;
        --help)
            tail -100f $K_CONF/kiserverd.help
            ;;
        --ssh_passwd_done)
            . $K_CONF/.aes.cnf
            aes 
            sshpasswddone
            ;;
        --ssh_check)
            sshcheck $*
            ;;
        --ssh_installs)
            echo -e "\033[036m < START INSTALL > \033[0m"
            sshinstalls $*
            ;;
        -i|-immediately)
            immediately $*
            ;;
        *)
            echo -e "[ $ltime - $3 ] $B_red Usage : $0 : {-p|-c} You must to select a module ! $B_end"
    esac
}
if expr "$1" : ".*log" &>/dev/null
then
    [ $? -eq 0 ] && [ "$1" != "--log" ] && {
            tail_num=${1:2:3}
    }
elif expr "$1" : ".*l" &>/dev/null
then
    [ $? -eq 0 ] && [ "$1" != ".*l" ] && {
            tail_num=${1:1:3}
    }
else
    :
fi

echo $$ >$K_WORKTMP/kiserverd.pid
yym $*
>$K_TMP/tomcat_server_name.dir.ex
>$K_TMP/tomcat_server_name.dir

EOF
chmod +x $K_COMMAND

kiserverd_monitor=/usr/bin/kiserverd-monitor
touch $kiserverd_monitor
cat > $kiserverd_monitor <<'EOF'
#!/bin/bash
. /tomcat_file/conf/yym.cnf 
. $K_CONF/kiserverd.conf
. $K_CONF/basics.conf
. $K_BIN/tomcat_server_monitor.sh
[ ! "$3" = "" ] && tomcat_select=(`echo $TOMCAT_FULL_PATH|grep $3`)
tomcat_server_monitor_ex() {
        # echo $*
        for n in $@
        do
            if [ "$control_status" = "now" ];then
                nohup /usr/bin/kiserverd -pd tomcat $n restart $control_status &
            elif [ "$control_status" = "null" ];then
                nohup /usr/bin/kiserverd -pd tomcat $n null &
            else
                nohup /usr/bin/kiserverd -pd tomcat $n restart $control_status $control_time_h $control_time_m &
            fi
            sleep 0.5
        done
        >$K_TMP/tomcat_server_name.dir.ex
        >$K_TMP/tomcat_server_name.dir
        exit 0
}

normal_monitor_null() {
    echo ""
    for ((i=0;i<${#TOMCAT_FULL_PATH[*]};i++))
    do
        echo -e "\033[036m- $[$i+1] -\033[0m ${TOMCAT_SERVER_NAME[i]}"
    done
    echo ""    
    read -t 30 -p "Please select the Tomcat services you want to monitor  :  " -a tomcat_server_monitor	

    for n in ${tomcat_server_monitor[*]}
    do
        echo "${TOMCAT_SERVER_NAME[$[$n-1]]}" >>$K_TMP/tomcat_server_name.dir.ex 2>/dev/null                            
    done
    tomcat_server_monitor_dir=(`cat $K_TMP/tomcat_server_name.dir.ex`)
    tomcat_server_monitor_ex ${tomcat_server_monitor_dir[*]}
}

control_monitor() {
    echo -e "\033[036m- 1 -\033[0m Now Restart"
    echo -e "\033[036m- 2 -\033[0m Fixed Time Restart"
    echo -e "\033[036m- 3 -\033[0m Delay Time Restart"
    echo -e "\033[036m- 4 -\033[0m No Restart"
    read -t 30 -p "Please select the mode you want to control :  " control_values
    case $control_values in
        1|now)
            control_status=now
            main
            ;;
        2|fixed)
            control_status=fixed
            read -t 30 -p "When will you restart the service? :  " control_time_h control_time_m
            main
            ;;
        3|delay)
            control_status=delay
            read -t 30 -p "How soon will you restart the service? :  " control_time_h control_time_m
            main
            ;;
        4|no)
            control_status=null
            main
            ;;
        *)
            echo "you must input true values"
    esac
}    

main() {
    case $1 in
        "")
            normal_monitor_null
            ;;
        -c|--control)
            control_monitor
            ;;
        *)
            nohup /usr/bin/kiserverd -pd tomcat $1 $2 now &
esac
}

main $*
EOF
chmod +x $kiserverd_monitor

tomcat_server_monitor_conf=$K_BIN/tomcat_server_monitor.sh
cat >$tomcat_server_monitor_conf <<'EOF'
#!/bin/bash
    find $server_path -type d -maxdepth 2 2>/dev/null |grep "$B_check_values"|egrep -v "$B_exclude_values" >$K_WORKTMP/tomcat_full_path.dir
    TOMCAT_FULL_PATH=(`cat $K_WORKTMP/tomcat_full_path.dir`)

    for ((i=0;i<${#TOMCAT_FULL_PATH[*]};i++))
    do
        echo "${TOMCAT_FULL_PATH[i]##*\/}" >>$K_TMP/tomcat_server_name.dir
    done
        TOMCAT_SERVER_NAME=(`cat $K_TMP/tomcat_server_name.dir`)
EOF

tomcat_server_bash_complete=/etc/bash_completion.d/tomcat_server_bash_complete.bash
cat >$tomcat_server_bash_complete <<'EOF'
#!/bin/bash:/bin/csh
. /tomcat_file/conf/yym.cnf
. $K_CONF/kiserverd.conf
. $K_CONF/basics.conf
function _cmd_kiserverd() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ ${cur} == --log* ]] ; then
        local opts="123 456"
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur#--log}) )
        return 0
    else
        local options="-l
                      -99l
                      -999l
                      --log
                      --99log
                      --999log
                      --help
                      -p
                      --process
                      --process-kill
                      -status
                      --version
                      --conf
                      --ssh_passwd_done
                      --ssh_check
                      --ssh_installs
                      -m
                      -i
                      -immediately"
        COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
        return 0
    fi
}

function _cmd_--ssh_installs() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts="--toolsdir="
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

function _cmd_-p() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts="tomcat"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

function _cmd_-l() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts=${TOMCAT_SERVER_NAME[*]}
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

function _cmd_-99l() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts=${TOMCAT_SERVER_NAME[*]}
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
function _cmd_-999l() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts=${TOMCAT_SERVER_NAME[*]}
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
function _cmd_--log() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts=${TOMCAT_SERVER_NAME[*]}
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
function _cmd_--99log() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts=${TOMCAT_SERVER_NAME[*]}
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
function _cmd_--999log() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local opts=${TOMCAT_SERVER_NAME[*]}
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

function _cmd_tomcat() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local options=${TOMCAT_SERVER_NAME[*]}

    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) ) 
}

function _cmd_status() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local options="start "
    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
}

function _cmd_HUB() {
    case $COMP_CWORD in
    0)
        ;;
    1)  
        eval _cmd_${COMP_WORDS[0]}
        ;;
    2) 
        eval _cmd_${COMP_WORDS[1]}
        ;;
    3)
        [ ${COMP_WORDS[COMP_CWORD-1]} = "-l" ] && { 
        exit 1
        } || { 
        eval _cmd_${COMP_WORDS[2]}
        }
        ;;                                                                                                                          
    4) 
        eval _cmd_status
        ;;
    5)
        eval _cmd_status
        ;; 
    *)
        ;;  
    esac
}
. $K_BIN/tomcat_server_monitor.sh
complete -F _cmd_HUB kiserverd
EOF

tomcat_monitor_bash_complete=/etc/bash_completion.d/tomcat_monitor_bash_complete.bash
cat >$tomcat_monitor_bash_complete <<'EOF'
#!/bin/bash:/bin/csh
. /tomcat_file/conf/yym.cnf
. $K_CONF/kiserverd.conf
. $K_CONF/basics.conf
. $K_BIN/tomcat_server_monitor.sh
function _cmd_kiserverd-monitor() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local options="${TOMCAT_SERVER_NAME[*]} -c --control"
    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
    return 0
}

function _cmd_status() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local options="start restart stop"
    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
    return 0
}

function _cmd_monitor() {
    case $COMP_CWORD in
    0)
        ;;
    1)  
        eval _cmd_${COMP_WORDS[0]}
        ;;
    2) 
        eval _cmd_status
        ;;
    *)
        ;;  
    esac
}
complete -F _cmd_monitor kiserverd-monitor
EOF

    server_complete_source=`cat /etc/profile |grep tomcat_server_bash_complete.bash|wc -l`
    [ "$server_complete_source" -eq 0 ] && {
        echo "source /etc/bash_completion.d/tomcat_server_bash_complete.bash" >>/etc/profile
    } 

    monitor_complete_source=`cat /etc/profile |grep tomcat_monitor_bash_complete.bash|wc -l`
    [ "$monitor_complete_source" -eq 0 ] && {
        echo "source /etc/bash_completion.d/tomcat_monitor_bash_complete.bash" >>/etc/profile
    }


# shc -e 01/01/2021 -m "已过期" -r -T -f /usr/bin/kiserverd
# rm -f /usr/bin/kiserverd
# rm -f /usr/bin/kiserverd.x.c
# mv /usr/bin/kiserverd.x /usr/bin/kiserverd
# shc -e 01/01/2021 -m "已过期" -r -f /usr/bin/kiserverd-monitor
# rm -f /usr/bin/kiserverd-monitor
# rm -f /usr/bin/kiserverd-monitor.x.c
# mv /usr/bin/kiserverd-monitor.x /usr/bin/kiserverd-monitor
# shc -e 01/01/2021 -m "已过期" -r -f /tomcat_file/conf/.aes.cnf
# rm -f /tomcat_file/conf/.aes.cnf
# rm -f /tomcat_file/conf/.aes.cnf.x.c
# mv /tomcat_file/conf/.aes.cnf.x /tomcat_file/conf/.aes.cnf

echo "[ kiserverd ] INFO installation is complete >>>"
