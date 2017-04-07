Quick start instructions to build Wind River Pulsar Linux
for the Intel Apollolake boards with secure full features supported.

For the secure full features, they include the following security 
features:

1. UEFI Secure Boot
2. MOK Secure Boot
3. TPM 1.2 & 2.0 
4. Storage Encryption
5. IMA

############## Quick start clip here ###################
git clone -b pulsar-8 --recurse-submodules https://github.com/WindRiver-OpenSourceLabs/wr-core
cd wr-core

######### The first time only, check for required host packages #########
./scripts/host_package_install.sh --install --yes
#########################################################################

. init-intel-apollolake-secure-full-feature-env
bitbake cube-desktop cube-dom0 cube-essential cube-gw

# To build an installer image or USB stick with Gateway support
#DEV=/dev/NBD_DEVICE  or a USB storage device
sudo ../overc-installer/sbin/cubeit --force --config `pwd`/../install_templates/Intel_Apollolake/Intel-Apollolake-gw-live.sh --target-config `pwd`/../install_templates/Intel_Apollolake/Intel-Apollolake-gw-live.sh --artifacts `pwd`/tmp/deploy/images/intel-corei7-64 $DEV

[Boot the installer image]
- Plug in the USB thumb drive on Intel NUC board
- Power up
- Press F2 to enter into BIOS setup
- Select Boot menu and  turn on "Boot USB Devices First" in Boot Configuration tag
- Select Boot menu and turn on "Secure Boot" and "Clear Secure Boot Data" in Secure Boot tag
- Press ESC and select Yes to save the BIOS settings
- A "Image Authorization Fail" error message appears up. Press ctrl-alt-del to reboot
- Automatically boot 'Automatic Certificate Provision' and then reboot
   This operation provisions the UEFI secure boot with the keys embedded in a LockDown.efi program. The keys are used to check the integrity of shim bootloader.
- Boot "OverC Installer"

[Install the runtime images]
- Login with root/incendia
- cd /opt/installer/sbin
- ./cubeit-installer -b --encrypt --ima-sign
/opt/installer/images/cube-essential-intel-corei7-64.tar.gz2 /dev/sda
   * Type "y" and "YES" according to the prompts
   * -b enables btrfs filesystem
   * --encrypt creates the encrypted rootfs
   * --ima-sign labels the filesystems in order to check the integrity of exec, firmware and kernel modules in runtime
- reboot
- Unplug the USB thumb drive

[pulsar runtime]
- Boot "OverC"
- Login with root/incendia

