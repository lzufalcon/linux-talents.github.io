#!/bin/bash

mkdir -p /var/run/sshd

LAB_WORKDIR=/lab/
[ -z "$LAB_WORKDIR" ] && LAB_WORKDIR=$1
CONFIG_DIR=$LAB_WORKDIR/configs/

IMAGE=$(< $CONFIG_DIR/name)

LAB_SYSTEM=$CONFIG_DIR/system
LAB_UNIX_USER=$CONFIG_DIR/.unix_user
LAB_UNIX_PWD=$CONFIG_DIR/.unix_pwd
LAB_UNIX_UID=$CONFIG_DIR/.unix_uid
LAB_VNC_PWD=$CONFIG_DIR/.vnc_pwd
LAB_VNC_IDENTIFY=$CONFIG_DIR/.vnc_identify
LAB_UNIX_IDENTIFY=$CONFIG_DIR/.vnc_identify
LAB_SUDO_IDENTIFY=$CONFIG_DIR/.sudo_identify
LAB_HOST_NAME=$CONFIG_DIR/.host_name

UNIX_USER=ubuntu
[ -f $LAB_UNIX_USER ] && UNIX_USER=$(< $LAB_UNIX_USER)

UNIX_IDENTIFY=0
[ -f $LAB_UNIX_IDENTIFY ] && UNIX_IDENTIFY=$(< LAB_UNIX_IDENTIFY)

[ -f $LAB_UNIX_UID ] && UNIX_UID=$(< $LAB_UNIX_UID)
[ -z "$UNIX_UID" ] && UNIX_UID=1000
echo $UNIX_UID > $LAB_UNIX_UID

# create an ubuntu user

HOME=/home/$UNIX_USER/
DESKTOP=$HOME/Desktop/

id -u $UNIX_USER &>/dev/null || useradd --uid $UNIX_UID --create-home --shell /bin/bash --user-group --groups adm,sudo $UNIX_USER

# Install more system configuration files
sudo mkdir $DESKTOP

find $LAB_SYSTEM -type f | sed -e "s%$LAB_SYSTEM%%g" | xargs -i sudo cp $LAB_SYSTEM/{} {}

SYSTEM_SUDOERS_USER=`find $LAB_SYSTEM -type f -name "$UNIX_USER" | sed -e "s%$LAB_SYSTEM%%g" | grep sudoers.d`
SYSTEM_SUPERVISORD_CONF=`find $LAB_SYSTEM -type f -name "supervisord.conf" | sed -e "s%$LAB_SYSTEM%%g"`

sudo chmod 440 $SYSTEM_SUDOERS_USER
sudo chown $UNIX_USER:$UNIX_USER -R $HOME/

# Update locales
locale-gen --purge en_US.utf8
locale-gen --purge zh_CN.utf8

# Install desktop wallpapers

sudo -u $UNIX_USER -i bash -c "mkdir -p $HOME/.config/pcmanfm/LXDE/ \
    && cp /usr/share/doro-lxde-wallpapers/desktop-items-0.conf $HOME/.config/pcmanfm/LXDE/"

# Create password

UNIX_PASS=$(< $LAB_UNIX_PWD)
VNC_PASS=$(< $LAB_VNC_PWD)

[ -z "$UNIX_PASS" ] && UNIX_PASS=`pwgen -c -n -y -s -1 10` && echo $UNIX_PASS > $LAB_UNIX_PWD
[ -z "$VNC_PASS" ] && VNC_PASS=`pwgen -c -n -y -s -1 10` && echo $VNC_PASS > $LAB_VNC_PWD
sudo chown $UNIX_USER:$UNIX_USER $LAB_UNIX_PWD $LAB_VNC_PWD $LAB_UNIX_UID
sudo chmod a+w $LAB_UNIX_PWD $LAB_VNC_PWD $LAB_UNIX_UID

echo "User: $UNIX_USER Password: $UNIX_PASS VNC Password: $VNC_PASS"

# VNC OASS
sudo -u $UNIX_USER mkdir $HOME/.vnc/
sudo -u $UNIX_USER x11vnc -storepasswd $VNC_PASS $HOME/.vnc/passwd

# UNIX PASS
echo "$UNIX_USER:$UNIX_PASS" | chpasswd

# Lock UNIX Password?
[ $UNIX_IDENTIFY -eq 0 ] && passwd -l $UNIX_USER

# Disable the VNC login password
if [ -f $LAB_VNC_IDENTIFY ]; then
    VNC_IDENTIFY=$(< $LAB_VNC_IDENTIFY)
    HOST_NAME="localhost"
    [ -f $LAB_HOST_NAME ] && HOST_NAME=$(< $LAB_HOST_NAME)
    if [ $VNC_IDENTIFY -eq 0 -a "$HOST_NAME" == "localhost" ]; then
	sed -i -e "s% -rfbauth /home/.*$%%g" $SYSTEM_SUPERVISORD_CONF
    fi
fi

# Configure local ip address for some labs
lab_host_ip=$(ip addr show eth0 | head -3 | tail -1 | sed -e "s%.*inet \(.*\)/.*%\1%g")
sed -i -e "s% -H HOST_IP% -H $lab_host_ip%g" $SYSTEM_SUPERVISORD_CONF
sudo -u ubuntu sed -i -e "s%localhost%$lab_host_ip%g" $DESKTOP/local.desktop
echo "LOG: Local Web Site Address: http://$lab_host_ip/"

# Start web service
cd /web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf

if [ -f /bin/tini ]; then
	exec /bin/tini -- /usr/bin/supervisord -n
else
	exec /usr/bin/supervisord -n
fi
