Quick start instructions to build Wind River Pulsar Linux
for Advantech UTX-3117 (Intel Atom) project

For more guides, examples and information please see:
https://knowledge.windriver.com/?cid=pulsar_lx

For official images, please visit:
http://pulsar.windriver.com

############## Quick start clip here ###################
git clone -b pulsar-8 --recurse-submodules https://github.com/WindRiver-OpenSourceLabs/wr-core
cd wr-core

######### The first time only, check for required host packages #########
./scripts/host_package_install.sh --install --yes
#########################################################################

. init-advantech-utx-3117-env
bitbake cube-dom0 cube-essential cube-gw

#Build an installer image with Gateway support
sudo ../overc-installer/sbin/cubeit --force --installer --config `pwd`/../install_templates/Advantech-UTX-3117/utx-3117-gw-live.sh --target-config `pwd`/../install_templates/Advantech-UTX-3117/utx-3117-gw-live.sh --artifacts `pwd`/tmp/deploy/images/intel-corei7-64 pulsar8-UTX-3117-gw-installer.img

#Once the image is created, please dd it on a USB stick, then 
# plug this USB installer stick into target, boot it up and run the
# installation(Here suppose the storage device you want to install to is $DEV):
cd /opt/installer
./sbin/cubeit-installer -b images/cube-essential-* $DEV
# After installation, reboot the target and unplug the usb installer stick, Pulsar will
# boot up from installed local storage device

### login: root  password: incendia

