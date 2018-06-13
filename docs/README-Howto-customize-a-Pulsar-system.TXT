					How to customize a Pulsar system

Pulsar provides an interface allowing user to customize a system based on official release.

Prerequisites:
1. A target board deployed with official released Pulsar system
2. A Ubuntu 18.04 or latest Fedora host, on which the package ostree and http service are installed


A brief description for this: 
1. Deploy an official Pulsar image on a target board, and use DNF/RPM to install the additional packages.
2. Zip and copy the new rootfs to an linux server and commit the new rootfs to ostree repository.
3. The new ostree repository can be used for massive deployment via "ostree admin upgrade".

The following are detailed steps:

1. Upgrade the system to dev branch. All DNF/RPM database have been trimmed on default system, so if you want to install packages via DNF/RPM, switch to dev branch, like following:

	#ostree admin set-origin pulsar-linux <remote_ostree_repo> cube-gw-ostree-runtime-dev
	#ostree admin upgrade

2. Reboot and we will enter the system with DNF/RPM database installed. However, some system
   directories(/usr,/bin,/lib/, etc) of Pulsar are readonly, which means user is not allowed to do any changes to them unless running:
   
	#ostree admin unlock --hotfix
	
3. On the target, setup package feed properly(https://wiki.yoctoproject.org/wiki/TipsAndTricks/EnablingAPackageFeed), and use dnf or rpm utilities to customize the system.

4. After all packages are done, use the following tool to archive and zip the root filesystem into a tarball:

	#system-export
	
   Then you will get the tarball file in current directory with the name "pulsar-linux-cube-gw-ostree-runtime.tar.gz"
   
5. Transfer the tarball file into a host(via scp or removable media)
	
6. On host, extract the tarball as following:

	$ mkdir rootfs
	$ sudo tar --xattrs --xattrs-include='*' -xzvf pulsar-linux-cube-gw-ostree-runtime.tar.gz -C /path/to/rootfs

7. (optional)Initialize OSTree repo if you don't have one

    $ mkdir -p ostree_repo
    $ ostree init --repo=/path/to/ostree_repo --mode archive
	
8. Prepare GPG key(take sample key as example) as following:
	$ wget https://raw.githubusercontent.com/WindRiver-OpenSourceLabs/wrlabs-integration/WRLINUX_10_17_LTS/files/sample-keys/rpm_keys/RPM-GPG-PRIVKEY-Wind-River-Pulsar-Sample
	$ mkdir ./.gnupg
    $ gpg --homedir /path/to/.gnupg --import /path/to/RPM-GPG-PRIVKEY-Wind-River-Pulsar-Sample

9. Commit the customized system to OSTree repo:
    $ sudo ostree commit --repo=/path/to/ostree_repo --tree="dir=/path/to/rootfs" --skip-if-unchanged --gpg-sign=Wind-River-Pulsar-Sample --gpg-homedir=/path/to/.gnupg/ --branch=cube-gw-ostree-runtime  --subject="Commit-id:customized cube-gw-ostree-runtime system"
	
10. On other targets, set remote repository as the ostree repo in step 9, and it can be used for massive deployment.


