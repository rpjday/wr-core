Quick start instructions to build Wind River Pulsar Linux
for the Intel NUC and Adlink MXE 21x boards

For a more guides, examples and information please see:
https://knowledge.windriver.com/?cid=pulsar_lx

For official images please visit:
http://pulsar.windriver.com

############## Quick start clip here ###################
git clone -b pulsar-lts-17 --recurse-submodules https://github.com/WindRiver-OpenSourceLabs/wr-core
cd wr-core

######### The first time only, check for required host packages #########
./scripts/host_package_install.sh --install --yes
#########################################################################

# Init the environment with security features enabled
. init-intel-x86-secure-env

# Build the images
bitbake cube-desktop cube-dom0 cube-essential

# Build an installer image (pick WR sample keys under artifacts directory for IMA signature)

sudo ../overc-installer/sbin/cubeit --force --config `pwd`/../install_templates/IntelCubeDesktop/IntelCubeDesktop-live.sh --target-config IntelCubeDesktop-live.sh --artifacts `pwd`/tmp/deploy/images/intel-corei7-64 --installer --ima-sign --ima-key-pass pulsar <pulsar-installer-image>

# dd the image file into a storage media
sudo dd if=<pulsar-installer-image> of=/dev/sdx

# Then install the storage media on target, boot the target from it and run the
# install instructions(Here suppose the storage device you want to install to is $DEV):
cd /opt/container
./installers/cubeit-installer -b images/cube-essential-* $DEV

# After installation, reboot the target and unplug the usb installer stick, Pulsar will
# boot up from installed local storage device

### login: root  password: incendia

### Optionally simulate the image with kvm/qemu

kvm -drive file=pulsar-intelcubedesktop.img,if=virtio -m 2000 -nographic -vnc :3 -serial mon:stdio -vga vmware -net user,hostfwd=tcp::4440-10.0.2.15:22,hostfwd=tcp::4441-10.0.2.15:2222 -net nic -usbdevice tablet

# Note: The terminal is your serial port, and you can access the
#       grapics console by starting: vncviewer $YOUR_SERVER_IP:3

# Note: Audio controls with Pulse Audio
#       From command line run: alsamixer
#       For UI run: pavucontrol
#       For UI desktop control add the PulseAudio control pannel:
#          Right click in the middle of the bar at the top of the screen
#          Panel->Add New Items->PulseAudio Plugin ## then click Add
