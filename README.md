# ethereum-test
A quick dive, to see if https://github.com/vincentchu/eth-private-net  actually works

# Diving session 1 : bulk automation (Before Ansible Playbook)

* Pre-requisites : installing `geth`. Here I have a problem, which that ethereum go-client only supports Ubuntu, so I'll first try and build the `go-ethereum` implementation on my debian stretch bas machine. Otherwise, I'll just switch to docker containers 

```bash
export OPS_HOME=~/.ethereum-test
export RECIPE_UNDER_TEST=https://github.com/vincentchu/eth-private-net
export GO_ETH_CLIENT_SOURCE_CODE_REF=https://github.com/ethereum/go-ethereum


# now we need make installed, with probably a few addisional tools for build; VErsioning the build system doesn't seem to bother much the ethereum team, so well let's assume they support ascending migrations, and dive with latest debians (which are pretty reliable, due to debian's release policy)


# ------------------------------------------------
# GOLANG installation
# https://golang.org/doc/install#install
# ------------------------------------------------
# export GOLANG_VERSION=1.12.6 
# 1.12.6 which is latest, but https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide#go-environment mentions we need go [1.8]
export GOLANG_VERSION=1.8
# because of 
export MACHINE_OS=linux
export MACHINE_PROCESSOR_ARCH=amd64
export GOLANG_BINARY_DWLD_URI=https://dl.google.com/go/go$GOLANG_VERSION.$MACHINE_OS-$MACHINE_PROCESSOR_ARCH.tar.gz
export GOLANG_OPS_HOME=~/.golang

# you get the link for your OS distrib. and your proc. at Official Golang download page https://golang.org/dl/
# 1. Installing Golang Env., with GOPATH set. https://golang.org/doc/install#install
# 
wget $GOLANG_BINARY_DWLD_URI
tar -C /usr/local -xzf go$GOLANG_VERSION.$MACHINE_OS-$MACHINE_PROCESSOR_ARCH.tar.gz
export PATH=$PATH:/usr/local/go/bin
# 
# For a persistent configuration (after restarting the machine) : 
echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.profile
# But we just need the environement set for one execution, and forget about all of it.
# Just one purpose might be relevant here : for debugging quickly, so basically keep this one commented for produciton envronnements (actual pipelines).




# ------------------------------------------------
# Classic GCC / Make installation env. on Debian Stretch
# A./ Because I wanna try on Debian instead of recommended Ubuntu
# B./ Because the bloody ethereum Team won't mention any version numbers about the build stack here : https://github.com/ethereum/go-ethereum#building-the-source see 
# ------------------------------------------------

sudo apt-get install -y build-essential
# Just the rock solid manpage documentation 
sudo apt-get install -y manpages-dev
whereis gcc make
gcc -v
make -v


# ------------------------------------------------
# ------------------------------------------------
# `geth` build on debian stretch (finally !! :p...)
# 
# Additional Infos on Build Stack of go-ethereum : 
# https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide
# https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide#building-and-testing
# ------------------------------------------------

# ------------------------------------------------
mkdir -p $OPS_HOME/build

git clone "$GO_ETH_CLIENT_SOURCE_CODE_REF" $OPS_HOME/build

# Bugging Constraint we have for the build, just won't care to fix that just now : 
# [You must have your working copy under $GOPATH/src/github.com/ethereum/go-ethereum]
# So I'll try this : 
sudo mkdir -p $GOPATH/src/github.com/ethereum/go-ethereum
export THATS_WHOIAM=$(whoami)
ln -s $OPS_HOME/build $GOPATH/src/github.com/ethereum/go-ethereum
# just to ckeck : 
ls -allh $GOPATH/src/github.com/ethereum/go-ethereum

cd $OPS_HOME/build

# Now, we should be able to run the build with : 
# go install -v ./...
# But instead, we'll try and use the Makefile (don't Ethereum DEveloper Team recommend using make/ Makefiles to developers?... puzzling, nevermind) : 

cd $OPS_HOME/build
make all 

# Never the less, this incredible requirement, should be more a [go get github.com/ethereum/go-ethereum], which would immediately properly place the lib where it should be for the build...(Do the guys who write the READMees know anything about `go`...?)



```

* 
