#!/bin/bash
#############################################################################
# File Name     : linux system config
# description    : This script is used to set linux system
#############################################################################
. /etc/init.d/functions

IP=`/sbin/ifconfig |awk -F '[ :]+' 'NR==2{print $4}'`

# Defined result functions
function Msg(){
		if [ $? -eq 0 ];then
			action "$1" /bin/true
		else
			action "$1" /bin/false
		fi
}

#  Defined Close selinux Functions
function selinux(){
		[ -f "/etc/selinux/config" ] && {
			sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
			 setenforce 0
			 Msg "Close selinux"
		}
}

# Defined add Ordinary user Functions
function AddUser(){
                id caijinxu &>/dev/null
                if [ $? -ne 0 ];then
                useradd caijinxu &>/dev/null            
                echo "123456"|passwd --stdin caijinxu &>/dev/null &&\
                sed -if '98a caijinxu ALL=(ALL)  NOPASSWD:ALL' /etc/sudoers &&\
                visudo -c &>/dev/null
                Msg "AddUser caijinxu"
                else
                        echo "caijinxu user is exit."
                fi
}

# Defined Hide the system version number Functions
function HideVersion(){
		[ -f "/etc/issue" ] && >/etc/issue
		[ -f "/etc/issue.net" ] && >/etc/issue.net
		Msg "Hide sys info."
}

# Defined SSHD config Functions
function sshd(){
		sshd_file=/etc/ssh/sshd_config
		if  [ `grep "52123" $sshd_file |wc -l` -eq 0 ];then
		sed -ir "13 iPort 52123\nPermitRootLogin no\nPermitEmptyPasswords no\nUseDNS no\nGSSAPIAuthentication no" $sshd_file
		sed -i 's@#LinstenAddress 0.0.0.0@LinstenAddress '${IP}':52123@g' $sshd_file
		/etc/init.d/sshd restart >/dev/null 2>&1
		Msg "sshd config"
		fi
}

# Defined OPEN FILES Functions
function openfiles(){
		if [ `grep "nofile 65535" /etc/security/limits.conf|wc -l` -eq 0 ];then
			echo '*	-	nofile	65535' >> /etc/security/limits.conf
			ulimit -SHn 65535
			Msg "set open files"

		fi
}
function hosts(){
		if	[ ! -f /server/scripts/host ];then
			echo "/server/scripts/host is notexit,please solve this question"
			sleep 300
			exit 1
		fi
		/bin/cp /server/scripts/host /etc/hosts
		Msg "change host"
}

# Defined System Startup Services Functions
function boot(){
		export LANG=en
		for i in `chkconfig --list|grep "3:on" |awk '{print $1}'|grep -vE "crond|network|rsyslog|sshd|sysstat"`
					do
					chkconfig $i off
					done
					Msg "BOOTconfig"
}

# Defined Time Synchronization Functions
function Time(){
		grep "time.nist.gov" /var/spool/cron/root > /dev/null 2&>1
		if [ $? -ne 0 ];then
		echo "#time sync by caijinxu at $(date +%F)">>/var/spool/cron/root
		echo '* /5 * * * * /usr/sbin/nrpdate time.nist.gov &>/dev/null'>>/var/spool/cron/root
		fi
		Msg "Time Synchronization"
}

# Defined Kernel parameters Functions
function kernel(){
		/bin/cp /etc/sysctl.conf /etc/sysctl.conf.$RANDOM
		/bin/cp /server/scripts/sysctl.conf /etc/hosts
		Msg "kernel"
}
function iptables(){
		/etc/init.d/iptables stop
		/etc/init.d/iptables stop
		Msg "iptables stop"
}
function hostname(){
		ip=`/sbin/ifconfig |awk -F '[ :]+' 'NR==2{print $4}'`
		name=`grep -w "$ip" /etc/hosts |awk '{print $2}'`
		sed -i 's/HOSTNAME=*/HOSTNAME='"$name"'/g' /etc/sysconfig/network
		/bin/hostname $name
		Msg "hostname"
}

# Defined main Functions
function main(){
		selinux
		AddUser
		HideVersion
		sshd
		openfiles
		hosts
		boot
		Time
		kernel
		iptables
		hostname
}
main
