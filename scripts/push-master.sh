#!/bin/bash

# This script is for the update of the oe-core and bitbake master
# branches, which are nothing more than replicas from the upstream.

(
    cd layers/oe-core && \
    git fetch git://git.openembedded.org/openembedded-core "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/oe-core origin/master:master
)

(
    cd layers/bitbake && \
    git fetch git://git.openembedded.org/bitbake "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/bitbake origin/master:master
)

# Additional upstream master updates
(
    cd layers/meta-intel && \
    git fetch https://git.yoctoproject.org/git/meta-intel "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-intel origin/master:master
)
(
    cd layers/meta-openembedded && \
    git fetch git://git.openembedded.org/meta-openembedded "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-openembedded origin/master:master
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-openembedded origin/master-next:master-next
)
(
    cd layers/meta-virtualization && \
    git fetch  git://git.yoctoproject.org/meta-virtualization "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-virtualization origin/master:master
)
(
    cd layers/meta-cloud-services && \
    git fetch  git://git.yoctoproject.org/meta-cloud-services "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-cloud-services origin/master:master
)
(
    cd layers/meta-security && \
    git fetch  git://git.yoctoproject.org/meta-security "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-security origin/master:master
)
(
    cd layers/meta-dpdk && \
    git fetch  git://git.yoctoproject.org/meta-dpdk "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-dpdk origin/master:master
)
(
    cd layers/meta-iot-cloud && \
    git fetch  https://github.com/intel-iot-devkit/meta-iot-cloud.git "+refs/heads/*:refs/remotes/origin/*"
    git push --tags -f git@github.com:WindRiver-OpenSourceLabs/meta-iot-cloud origin/master:master
)
