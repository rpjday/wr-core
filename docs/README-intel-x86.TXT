Quick start instructions to build Wind River Pulsar Linux for Intel x86 board

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

Init the environment
$. init-intel-x86-env

Build the images
$bitbake cube-gw-ostree-runtime

Once build succeeds, you can locate the image at:
<build dir>/tmp/deploy/images/intel-corei7-64/cube-gw-ostree-runtime-intel-corei7-64.wic

Then dd it to an usb stick or sd card and boot up Pulsar directly on target

### login: root  password: incendia

###### Deploy/Install the Pulsar system onto target local storage device######
The cube-gw-ostree-runtime wic image built out by "bitbake cube-gw-ostree-runtime"
is a bootable live image but also has installation functionality, which means
you can directly use it as your target os, and also can use it as installer and
deploy Pulsar onto other local storage device on the target.

There's a sample deploy configure file in /var directory named as wic.wks.sample.
This sample file will instruct the pulsar's installer to deploy Pulsar system to
sda device by default. The install command is as below:

#installer create /var/wic.wks.sample

Once the command finishes successfully, you can reboot the target, unplug live
image usb stick and boot it from installed local storage device. 

<Note: This command will format your sda device before deploying Pulsar system
onto it, make sure there is no useful data before you do it>

###### How to use OStree Repository ######

The upgrade and rollback of Pulsar system rely on OStree repository. If you have
some changes to the wr-core source code and want to apply these changes to your
system which has been deployed on the target, you can reuse old project or create
a new project to build the image cube-gw-ostree-runtime again, the successful build
will produce an OStree repository and a http configure file which helps you deploy
this OStree repository easily. Suppose you have apache running on your machine,
you simply need to drop this configure file to /etc/apache2/sites-enabled/ and
restart apache. Take my host for example:

$sudo cp <project dir>/tmp/deploy/images/intel-corei7-64/cube-gw-ostree-runtime-intel-corei7-64.rootfs.ostree.http.conf /etc/apache2/sites-enabled/
$sudo apachectl restart

Next we need to let the Pulsar system on the target know about the repository.
This can be done with the following command:
(If you're unsure about correctness of URI and filesystem paths, take peek inside
the http.conf file please)

#ostree remote add pulsar-linux http://<your build host IP>/pulsar-linux/intel-corei7-64 --no-gpg-verify
#ostree admin set-origin pulsar-linux http://<your build host IP>/pulsar-linux/intel-corei7-64

Then you can use the following command to update/upgrade your system now:

#ostree admin upgrade 

Once the update/upgrade completes, reboot is needed. And there is alway a rollback
boot option in grub menu, which allow you to roll back your system if there is
anything wrong with the upgrade.

###### Setup a development environment on Pulsar system ######

Pulsar is based on the OStree, thus its rootfs is readonly and you cannot do
any changes to key system components like "/usr", "/bin" and "/lib" at runtime.
If you want to add/install any other packages by rpm/dnf command, you should
unlock the ostree first. There are two types of unlocks: "unlock temporarily"
and "unlock with hotfix". The difference between them is that: "unlock temporarily"
will not keep the changes after the system reboots; On the contrary, "unlock with hotfix"
will retain changes across reboots. 

To do the "unlock temporarily", please run command:
#ostree admin unlock

To do the "unlock with hotfix", please run command:
#ostree admin unlock --hotfix

Once you do the unlock, you can install any packages in the system by rpm/dnf commands.

###### Security Features Available ######

On intel-x86 architecture, by now the following four security features have been supported:
1) Integrity Measurement Architecture (IMA)
2) UEFI Secure Boot
3) Disk Encryption based on TPM2.0
4) GPG signing and verifying for OSTree commits and RPM packages

To build a project including these security features, please initialize your project
with init-intel-x86-secure-env:

$ . init-intel-x86-secure-env

Then build your project as usual:

$bitbake cube-gw-ostree-runtime

Please check docs in https://github.com/WindRiver-OpenSourceLabs/meta-secure-core
if you want to know more about these security features, but following notes need
your attention here:

IMA: xfs filesystem doesn't support IMA signing, please don't build your project
on xfs filesystem for now. The ext3/ext4 filesystem are preferred.

Disk Encryption: the encrypted data partition will be created and initialized at
the system's first boot. For example, the third partition which is mounted to
/var directory in live image is encrypted by default. If you want other partitions
to be encrypted during installation, please label them with prefix of "luks_" in
your installer configure file /var/wic.wks.sample, similar to what we did for /var partition:

part /var --source rootfs --rootfs-dir=/ostree/deploy/pulsar-linux/var  --ondisk sda --fstype=ext4 --label luks_fluxdata --active --align 4

This line requests installer to create /var partition and label it as "luks_fluxdata",
then the installed system will make it as luks partition and encrypt it by using
TPM2.0 module at the system's first boot. 

This feature works with TPM2.0 module only for now. If there is no TPM2.0 module
available on the target, all partitions with labels prefixed by "luks_" will be
relabeled without "luks_" and don't to any encryption operation.
