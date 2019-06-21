export OPS_HOME=~/.ethereum-test
export RECIPE_UNDER_TEST=https://github.com/vincentchu/eth-private-net
export GO_ETH_CLIENT_SOURCE_CODE_REF=https://github.com/ethereum/go-ethereum


# now we need make installed, with probably a few addisional tools for build; VErsioning the build system doesn't seem to bother much the ethereum team, so well let's assume they support ascending migrations, and dive with latest debians (which are pretty reliable, due to debian's release policy)


# ------------------------------------------------
# Classic GCC / Make installation env. on Debian Stretch
# A./ Because I wanna try on Debian instead of recommended Ubuntu
# B./ Because the bloody ethereum Team won't mention any version numbers about the build stack here : https://github.com/ethereum/go-ethereum#building-the-source see 
# ------------------------------------------------

mkdir -p $OPS_HOME/.gcc-provisioning
cd $OPS_HOME/.gcc-provisioning

sudo apt-get install -y build-essential
# Just the rock solid manpage documentation 
sudo apt-get install -y manpages-dev

# Checks
whereis gcc make
gcc -v
make -v


# ------------------------------------------------
# GOLANG installation
# https://golang.org/doc/install#install
# ------------------------------------------------
# export GOLANG_VERSION=1.12.6 
# [1.12.6] is latest when I write this, but https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide#go-environment mentions we need to go [1.8] 

export GOLANG_VERSION=1.9.7
export MACHINE_OS=linux
export MACHINE_PROCESSOR_ARCH=amd64
export GOLANG_BINARY_DWLD_URI=https://dl.google.com/go/go$GOLANG_VERSION.$MACHINE_OS-$MACHINE_PROCESSOR_ARCH.tar.gz
# https://github.com/golang/go/wiki/SettingGOPATH#bash
# I'll have a go workspace in $OPS_HOME/geth-build/
export GOPATH=$OPS_HOME/geth-build/

# 
# And I still won't set the linux user's profile, unless I have to IAAC : 
# because I want this environment to be as volatileas possible.
# echo "export GOPATH=$OPS_HOME/geth-build/" >> ~/.bash_profile
# source ~/.bash_profile
# 

mkdir -p $OPS_HOME/.golang-provisioning
cd $OPS_HOME/.golang-provisioning

# you get the link for your OS distrib. and your proc. at Official Golang download page https://golang.org/dl/
# 1. Installing Golang Env., with GOPATH set. https://golang.org/doc/install#install
# 
wget $GOLANG_BINARY_DWLD_URI
sudo tar -C /usr/local -xzf go$GOLANG_VERSION.$MACHINE_OS-$MACHINE_PROCESSOR_ARCH.tar.gz
export PATH=$PATH:/usr/local/go/bin
# 
# For a persistent configuration (after restarting the machine) : 
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bash_profile
# But we just need the environement set for one execution, and forget about all of it.
# Just one purpose might be relevant here : for debugging quickly, so basically keep this one commented for produciton envronnements (actual pipelines).
# print go env. infos
go env



# ------------------------------------------------
# ------------------------------------------------
# `geth` build on debian stretch (finally !! :p...)
# 
# Additional Infos on Build Stack of go-ethereum : 
# https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide
# https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide#building-and-testing
# ------------------------------------------------
# ------------------------------------------------

mkdir -p $OPS_HOME/geth-build
cd $OPS_HOME/geth-build

git clone "$GO_ETH_CLIENT_SOURCE_CODE_REF" .

# Bugging Constraint we have for the build, just won't care to fix that just now : 
# [You must have your working copy under $GOPATH/src/github.com/ethereum/go-ethereum]
# So I'll try this : 
sudo mkdir -p $GOPATH/src/github.com/ethereum/go-ethereum
export THATS_WHOIAM=$(whoami)
sudo -u $THATS_WHOIAM ln -s $OPS_HOME/geth-build/* $GOPATH/src/github.com/ethereum/go-ethereum
# just to ckeck : 
ls -allh $GOPATH/src/github.com/ethereum/go-ethereum
ls -allh $OPS_HOME/geth-build/*


# Now, we should be able to run the build with : 
# go install -v ./...
# But instead, we'll try and use the Makefile (don't Ethereum DEveloper Team recommend using make/ Makefiles to developers?... puzzling, nevermind) : 

cd $OPS_HOME/geth-build
make all 

# Never the less, this incredible requirement, should be more a [go get github.com/ethereum/go-ethereum], which would immediately properly place the lib where it should be for the build...(Do the guys who write the READMees know anything about `go`...?)
# Actually, after a day of work, i am kind of flabergasted to see that this astonishing requirement is explained by the fact that ... The ethereum team has not used the `$GOPATH` env. variable... and less cared about explaining the basic env. setup for go developers) ...


# Now setting up all built executable Folder to the PATH
ls -allh $OPS_HOME/geth-build/build/bin
echo "export PATH=\$PATH:$OPS_HOME/geth-build/build/bin" >> ~/.profile
export PATH=$PATH:$OPS_HOME/geth-build/build/bin
ls -allh $OPS_HOME/geth-build/bin
echo "You Will now find all built  executable, including [geth], in [$OPS_HOME/geth-build/build/bin] "
# ./build/build/bin/geth version
geth version



# ------------------------------------------------
# ------------------------------------------------
# And At last, testing [Mr. Vincent Chu's recipe](https://github.com/vincentchu/eth-private-net)
# 
# So the tests are multiple, since Mr. Chu
# provides full use cases, kind of e2e tests, in
# addition to the provisioning recipe.
# So here 's how we'lldo all that : 
# 
# => [$OPS_HOME/abovetest/provisioning] : Run and Tests on provisioning recipe
# => [$OPS_HOME/abovetest/usecase1] : e2e Tests on use case 1
# => [$OPS_HOME/abovetest/usecase2] : e2e Tests on use case 2
# => [$OPS_HOME/abovetest/usecase3] : e2e Tests on use case 3 
# ------------------------------------------------
# ------------------------------------------------

# ------------------------------------------------
# 0. Provisioning the Smart Card driver
# 

# 
# Official [PC SC LITE] source code Git repository
# 
export SMART_CARD_PACKAGE_SOURCE_GIT_URI=https://salsa.debian.org/debian/pcsc-lite.git

mkdir -p $OPS_HOME/.pcsc-lite
cd $OPS_HOME/.pcsc-lite
git clone "$SMART_CARD_PACKAGE_SOURCE_GIT_URI" .

# Briefly, the shell command './configure && make && make install'  should configure, build, AND install this package.
# see. https://salsa.debian.org/debian/pcsc-lite/blob/master/INSTALL

sudo apt-get install -y systemd-dev*
sudo ./configure && sudo make && sudo make install


# ------------------------------------------------
# 1./ provisioning 
# 
mkdir -p $OPS_HOME/abovetest/provisioning
cd $OPS_HOME/abovetest/provisioning

git clone "$RECIPE_UNDER_TEST" .


chmod +x ./eth-private-net
./eth-private-net init

echo "  "
echo " To Tear down your private blockchain, just run  : "
echo "  "
echo "  cd $OPS_HOME/abovetest/provisioning && ./eth-private-net clean  "
echo "  "



# ------------------------------------------------
# 2./ use case 1 
# 
mkdir -p $OPS_HOME/abovetest/provisioning
cd $OPS_HOME/abovetest/provisioning

git clone "$RECIPE_UNDER_TEST" .


chmod +x ./eth-private-net
./eth-private-net init
