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
echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.profile
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

mkdir -p $OPS_HOME/build
cd $OPS_HOME/build

git clone "$GO_ETH_CLIENT_SOURCE_CODE_REF" .

# Bugging Constraint we have for the build, just won't care to fix that just now : 
# [You must have your working copy under $GOPATH/src/github.com/ethereum/go-ethereum]
# So I'll try this : 
sudo mkdir -p $GOPATH/src/github.com/ethereum/go-ethereum
export THATS_WHOIAM=$(whoami)
sudo -u $THATS_WHOIAM ln -s $OPS_HOME/build/* $GOPATH/src/github.com/ethereum/go-ethereum
# just to ckeck : 
ls -allh $GOPATH/src/github.com/ethereum/go-ethereum
ls -allh $OPS_HOME/build/*


# Now, we should be able to run the build with : 
# go install -v ./...
# But instead, we'll try and use the Makefile (don't Ethereum DEveloper Team recommend using make/ Makefiles to developers?... puzzling, nevermind) : 

cd $OPS_HOME/build
make all 

# Never the less, this incredible requirement, should be more a [go get github.com/ethereum/go-ethereum], which would immediately properly place the lib where it should be for the build...(Do the guys who write the READMees know anything about `go`...?)

# Now setting up all built executable Folder to the PATH
ls -allh $OPS_HOME/build/build/bin
echo "export PATH=\$PATH:\$OPS_HOME/build/build/bin" >> ~/.profile
export PATH=$PATH:$OPS_HOME/build/build/bin
ls -allh $OPS_HOME/build/bin
echo "You Will now find all built  executable, including [geth], in [$OPS_HOME/build/build/bin] "
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

```


## (Un)Expected Outputs

#### For the provisioning

* I ran the initialization script, and got the same error, `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory`, for each of the three "parties" in the blockchain, involved in mister Chu's e2e test proposal : 

```bash
jibl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net init
Initializing genesis block for alice
INFO [06-20|17:34:52.507] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|17:34:52.507] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|17:34:52.509] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|17:34:52.579] Writing custom genesis block 
INFO [06-20|17:34:52.579] Persisted trie from memory database      nodes=3 size=409.00B time=104.49µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|17:34:52.580] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|17:34:52.580] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|17:34:52.591] Writing custom genesis block 
INFO [06-20|17:34:52.591] Persisted trie from memory database      nodes=3 size=409.00B time=90.892µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|17:34:52.592] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for bob
INFO [06-20|17:34:52.645] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|17:34:52.646] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|17:34:52.647] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|17:34:52.660] Writing custom genesis block 
INFO [06-20|17:34:52.660] Persisted trie from memory database      nodes=3 size=409.00B time=198.943µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|17:34:52.661] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|17:34:52.661] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|17:34:52.672] Writing custom genesis block 
INFO [06-20|17:34:52.672] Persisted trie from memory database      nodes=3 size=409.00B time=104.994µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|17:34:52.672] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for lily
INFO [06-20|17:34:52.720] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|17:34:52.721] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|17:34:52.722] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|17:34:52.866] Writing custom genesis block 
INFO [06-20|17:34:52.866] Persisted trie from memory database      nodes=3 size=409.00B time=155.136µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|17:34:52.875] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|17:34:52.875] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|17:34:52.887] Writing custom genesis block 
INFO [06-20|17:34:52.888] Persisted trie from memory database      nodes=3 size=409.00B time=109.506µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|17:34:52.889] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ 
```

I am afraid this error, `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory`, involves that all three nodes are unsable, _disabled_. Plsu What I am sruprised not to see here, is : 
* that we have a readable log for all three `Bob`, `Alice` and their third friend, 
* but where are the logs for the `bootnode` ? (required for the `enodes` to be able to discover each other, according to the official documentation) 

_**About the `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory` error**_

So first things first, questions : 

* What are  `Smart Cards`?
Well, Thank you Debian Wiki, we have a full explanation on Debian's Wiki https://wiki.debian.org/Smartcards : 

> 
> Smartcard (also known as chip card, or integrated circuit card (ICC)) 
> 
> Smartcards are used with cryptographic keys to ensure that their private half is never on any hard disk or other general storage device, and therefore that it cannot possibly be stolen (because there's only one possible copy of it). Most physical key "dongles" also implement a chip card interface device (CCID) and so can be used as smartcards, even though you can never remove the smartcard from the "reader". 
> 
To sum that all up, it's a crypto utility, ensuring integrity and privacy of a private key, using hardware and software trickes (not just software alone, with standard hardware).

Even more concisely, it's a utility the `Ethereum` Blockchain needs

_Howdi, Is there not an NVIDIA missing here...? (or `OpenCL / Smart Card` ... might be that)..._


* What is the `pcscd` executable?  Well its an executable supposed to be a driver for a _SmartCard_

* So what the Heck does this error message means? Well it's about the `pcscd` executable, the SmartCard driver. And I have a feeling I will have to send [Ludovic Rousseau](https://ludovicrousseau.blogspot.com/2011/11/pcscd-auto-start-using-systemd.html) some big thanks, soon...
<!-- terminating its execution, which just tells us he could not find the `SmartCard's Socket`, therefore can't do what it has to do. Actually, given the `socket` term, I assume the communication between the `SmartCard` and the `pcscd` driver daemon, is impossible, which obviously makes it difficult to work with a SMartCArd, even if you're a Rock Solid Debian. 
-->

* Before investigating Mr. Ludovic Rousseau's publications on `pcscd` driver service, Let's scrub a bit Mr. Chu `./eth-private-net` script, and : 
  * Here I highlight the part running if the `init` arg is supplied to `./eth-private-net` : 

```bash
case $CMD in
  init)
    for IDENTITY in ${IDENTITIES[@]}; do
      echo "Initializing genesis block for $IDENTITY"
      geth --datadir=./$IDENTITY $FLAGS init genesis.json
    done
;;
```
  * And if you `Ctrl + F / grep` into the `./eth-private-net`, searching for the `bootnode` string, or even the `boot` string, well you will have .... `zero` results. 
  * Okay, so my worry about not finding anything about the required  `bootnode`, in the logs, where completely justified. Not that am happy to be right, there, I'd have so preferred to be worng. 
  * All in all, one probable cause here is : Mr. Chu worked on a version of `Ethereum` a long time ago, and has probably not worked on latest versions of `Ethereum` (as of `June 2019`). Indeed, Mr. Chu made 28 commits , and zero issues were opened, just as many closed. That is really not a lot of work, and zero collaboration.
  * Eventually, I'll try the same recipe of mine, on a bare metal debian on alienware with NVIDIA, we'll see if the `SmartCard's Socket` error disapears, just because I switched hardware, but it might just as well the bootnode's setup missing part, that's supposed to spun up / open a `SmartCard Socket` 
  

Now,, let's investigate o bit more on Ludovic Roussseau's precious informations : 
* he speaks about a _SystemD_ `pcscd.service` that's supposed to be involved here, so I tried and find this service definition, look up its status :  

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo ls -allh /lib/systemd/system/|grep pcsc
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl status p
packagekit-offline-update.service  plymouth-quit.service              polkit.service                     printer.target                     proc-sys-fs-binfmt_misc.mount      
packagekit.service                 plymouth-quit-wait.service         poweroff.target                    procps.service                     
paths.target                       plymouth-start.service             pppd-dns.service                   proc-sys-fs-binfmt_misc.automount  
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl status pcscd.service
Unit pcscd.service could not be found.
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl status pcscd
Unit pcscd.service could not be found.
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl status pcsc
Unit pcsc.service could not be found.
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl enable pcscd.service
Failed to enable unit: File pcscd.service: No such file or directory
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ 
```
So well, anyway, there no such `pcscd.service` on my machine

* Now my logs speak about a file named `pcscd.comm`, not `pcscd.service`, so I checked if the file exists on my system : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo ls -allh /run/pcscd/pcscd.comm
ls: cannot access '/run/pcscd/pcscd.comm': No such file or directory
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ 
```

Okay, the `/run/pcscd/pcscd.comm` does not exist. So the diagnosis is that Mr. Chu's script `./eth-private-net`, launches a command (which one?) which execution throws this error, that the `/run/pcscd/pcscd.comm` does not exist. I looked up MR. Chu 's `./eth-private-net`, and I see no particular command, but the `geth` command, that can trigger an invocation of a SmartCard driver. 

I just temporarily stop this analysis here, will go further later on.

Source of informations : 

* https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751745 : contact `Ludovic Rousseau <ludovic.rousseau@free.fr>` definitely looks like a LSB module / Linux driver issue, might be `Debian` specific, and not happening on Ubuntu which Mr. Chu probably used for his tests
* https://ludovicrousseau.blogspot.com/2011/11/pcscd-auto-start-using-systemd.html : Again, Mr. `Ludovic Rousseau <ludovic.rousseau@free.fr>` 
* https://github.com/LudovicRousseau/pcsc-tools : Welln, Mr. Ludovic Rousseau seems to be a Debian contirbutor...
* https://wiki.debian.org/Smartcards


#### An experiment starting an `enode`, despite the `Smartcard socket not found` error

Well, despite the `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory` error, I wanted to try starting an `enode`, using Mr. Chu's Script.. And well it starts with no errors : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net start alice
Starting node for alice on port: 40301, RPC port: 8101. Console logs sent to ./alice/console.log
Welcome to the Geth JavaScript console!

instance: Geth/v1.9.0-unstable-25c3282c-20190620/linux-amd64/go1.9.7
coinbase: 0xdda6ef2ff259928c561b2d30f0cad2c2736ce8b6
at block: 0 (Wed, 31 Dec 1969 19:00:00 EST)
 datadir: /home/jbl/.ethereum-test/abovetest/provisioning/alice
 modules: admin:1.0 debug:1.0 eth:1.0 ethash:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

> eval('3 * 4')
12
> exit
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ cat ./alice/console.log
DEBUG[06-20|19:01:56.182] Sanitizing Go's GC trigger               percent=100
INFO [06-20|19:01:56.186] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|19:01:56.186] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
DEBUG[06-20|19:01:56.186] FS scan times                            list=49.963µs set=5.382µs diff=3.58µs
INFO [06-20|19:01:56.188] Starting peer-to-peer node               instance=Geth/v1.9.0-unstable-25c3282c-20190620/linux-amd64/go1.9.7
INFO [06-20|19:01:56.188] Allocated trie memory caches             clean=256.00MiB dirty=256.00MiB
INFO [06-20|19:01:56.188] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata cache=512.00MiB handles=524288
DEBUG[06-20|19:01:56.278] Chain freezer table opened               database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata/ancient table=receipts items=0 size=0.00B
DEBUG[06-20|19:01:56.282] Chain freezer table opened               database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata/ancient table=diffs    items=0 size=0.00B
DEBUG[06-20|19:01:56.286] Chain freezer table opened               database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata/ancient table=headers  items=0 size=0.00B
DEBUG[06-20|19:01:56.290] Chain freezer table opened               database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata/ancient table=hashes   items=0 size=0.00B
DEBUG[06-20|19:01:56.295] Chain freezer table opened               database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata/ancient table=bodies   items=0 size=0.00B
INFO [06-20|19:01:56.295] Opened ancient database                  database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata/ancient
INFO [06-20|19:01:56.295] Initialised chain configuration          config="{ChainID: 15 Homestead: 0 DAO: <nil> DAOSupport: false EIP150: <nil> EIP155: 0 EIP158: 0 Byzantium: <nil> Constantinople: <nil>  ConstantinopleFix: <nil> Engine: unknown}"
INFO [06-20|19:01:56.295] Disk storage enabled for ethash caches   dir=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/ethash count=3
INFO [06-20|19:01:56.295] Disk storage enabled for ethash DAGs     dir=/home/jbl/.ethash count=2
INFO [06-20|19:01:56.295] Initialising Ethereum protocol           versions="[63 62]" network=8888 dbversion=<nil>
WARN [06-20|19:01:56.295] Upgrade blockchain database version      from=<nil> to=7
DEBUG[06-20|19:01:56.296] Current full block not old enough        number=0 hash=a528ae…08b398 delay=90000
INFO [06-20|19:01:56.362] Loaded most recent local header          number=0 hash=a528ae…08b398 td=400000 age=50y2mo1w
INFO [06-20|19:01:56.362] Loaded most recent local full block      number=0 hash=a528ae…08b398 td=400000 age=50y2mo1w
INFO [06-20|19:01:56.362] Loaded most recent local fast block      number=0 hash=a528ae…08b398 td=400000 age=50y2mo1w
DEBUG[06-20|19:01:56.362] Reinjecting stale transactions           count=0
INFO [06-20|19:01:56.362] Regenerated local transaction journal    transactions=0 accounts=0
INFO [06-20|19:01:56.369] Allocated fast sync bloom                size=512.00MiB
INFO [06-20|19:01:56.370] Initialized fast sync bloom              items=3 errorrate=0.000 elapsed=225.985µs
DEBUG[06-20|19:01:56.370] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:01:56.429] InProc registered                        namespace=admin
DEBUG[06-20|19:01:56.429] InProc registered                        namespace=admin
DEBUG[06-20|19:01:56.429] InProc registered                        namespace=debug
DEBUG[06-20|19:01:56.429] InProc registered                        namespace=web3
DEBUG[06-20|19:01:56.429] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.429] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] TCP listener up                          addr=[::]:40301
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=txpool
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=debug
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=debug
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=personal
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=ethash
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.430] InProc registered                        namespace=miner
DEBUG[06-20|19:01:56.431] InProc registered                        namespace=eth
DEBUG[06-20|19:01:56.431] InProc registered                        namespace=admin
DEBUG[06-20|19:01:56.431] InProc registered                        namespace=debug
DEBUG[06-20|19:01:56.431] InProc registered                        namespace=debug
DEBUG[06-20|19:01:56.431] InProc registered                        namespace=net
DEBUG[06-20|19:01:56.431] IPC registered                           namespace=admin
DEBUG[06-20|19:01:56.431] IPC registered                           namespace=admin
DEBUG[06-20|19:01:56.431] IPC registered                           namespace=debug
INFO [06-20|19:01:56.431] New local node record                    seq=1 id=620455236b5658c5 ip=127.0.0.1 udp=0 tcp=40301
INFO [06-20|19:01:56.431] Started P2P networking                   self="enode://ed498ce264631c4255105b19355c1314cc73ae6a492935ece9a3691390a9d583005c9646cdc0a9799bf54523bf82af89bba152018ffd4a14ad40be8bc6b482ac@127.0.0.1:40301?discport=0"
DEBUG[06-20|19:01:56.431] IPC registered                           namespace=web3
DEBUG[06-20|19:01:56.431] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.431] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=txpool
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=debug
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=debug
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=personal
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=ethash
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=miner
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=eth
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=admin
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=debug
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=debug
DEBUG[06-20|19:01:56.432] IPC registered                           namespace=net
INFO [06-20|19:01:56.433] IPC endpoint opened                      url=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth.ipc
DEBUG[06-20|19:01:56.543] Served rpc_modules                       reqid=1 t=80.495µs
DEBUG[06-20|19:01:56.553] Served web3_clientVersion                reqid=2 t=48.732µs
INFO [06-20|19:01:56.553] Etherbase automatically configured       address=0xDda6eF2fF259928c561b2D30F0caD2C2736Ce8b6
DEBUG[06-20|19:01:56.553] Served eth_coinbase                      reqid=3 t=90.634µs
DEBUG[06-20|19:01:56.553] Served eth_blockNumber                   reqid=4 t=32.919µs
DEBUG[06-20|19:01:56.554] Served eth_blockNumber                   reqid=5 t=20.177µs
DEBUG[06-20|19:01:56.556] Served eth_getBlockByNumber              reqid=6 t=323.878µs
DEBUG[06-20|19:01:56.561] Served admin_datadir                     reqid=7 t=27.116µs
DEBUG[06-20|19:01:56.561] Served rpc_modules                       reqid=8 t=23.135µs
INFO [06-20|19:01:58.632] Mapped network port                      proto=tcp extport=40301 intport=40301 interface="UPNP IGDv1-IP1"
DEBUG[06-20|19:02:16.370] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:02:36.371] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:02:56.297] Current full block not old enough        number=0 hash=a528ae…08b398 delay=90000
DEBUG[06-20|19:02:56.371] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:03:16.371] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:03:36.372] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:03:56.297] Current full block not old enough        number=0 hash=a528ae…08b398 delay=90000
DEBUG[06-20|19:03:56.372] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:04:16.372] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:04:36.373] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:04:56.297] Current full block not old enough        number=0 hash=a528ae…08b398 delay=90000
DEBUG[06-20|19:04:56.373] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:05:16.373] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:05:36.374] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:05:56.298] Current full block not old enough        number=0 hash=a528ae…08b398 delay=90000
DEBUG[06-20|19:05:56.374] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:06:16.408] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:06:36.431] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:06:56.325] Current full block not old enough        number=0 hash=a528ae…08b398 delay=90000
DEBUG[06-20|19:06:56.432] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:07:16.432] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
DEBUG[06-20|19:07:36.432] Recalculated downloader QoS values       rtt=20s confidence=1.000 ttl=1m0s
INFO [06-20|19:07:46.600] IPC endpoint closed                      url=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth.ipc
DEBUG[06-20|19:07:46.600] RPC server shutting down 
INFO [06-20|19:07:46.600] Blockchain manager stopped 
INFO [06-20|19:07:46.600] Stopping Ethereum protocol 
INFO [06-20|19:07:46.600] Ethereum protocol stopped 
INFO [06-20|19:07:46.600] Transaction pool stopped 
DEBUG[06-20|19:07:46.600] Reset ancient limit to zero 
DEBUG[06-20|19:07:46.601] Read error                               err="accept tcp [::]:40301: use of closed network connection"
DEBUG[06-20|19:07:46.601] Deleting port mapping                    proto=tcp extport=40301 intport=40301 interface="UPNP IGDv1-IP1"
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ 

```

Oh but wait, starting the Alice `enode`, I again, find the  `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory` error. Kind of logic, at least. Still, I note that the Javsript Console is up n running, see the `eval()` execution above.
Well knowing that Ethereum has a virtual machine conept with Intermediary Representations (bytecode and stuff..), I'll just guess this Javascript Console is pretty much alike the well known ECMAScripts engines embedded in the `Java Virtual Machine`.





# Annoying `Ethereum` Documentation top of the pops

* Excuse-me : Documentation on Ethereum _IS_ terrible ! : I just ran the `make all` build command on source, and well, after I read, and complied with, the `1.8` Golang version requirement [from the very official Developer Doc.](https://github.com/ethereum/go-ethereum/wiki/Developers%27-Guide#go-environment), guess what first error messgae I got ? : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/build$ make all
build/env.sh go run build/ci.go install
ci.go:205: You have Go version go1.8
ci.go:206: go-ethereum requires at least Go version 1.9 and cannot
ci.go:207: be compiled with an earlier version. Please upgrade your Go installation.
exit status 1
Makefile:20: recipe for target 'all' failed
make: *** [all] Error 1
jbl@poste-devops-typique:~/.ethereum-test/build$ 
# you *!/\-/-*X
```
Are there any left developers on that project? Cause Actually I really hope they will have a better work env. soon, and I certainly wonder if there is going to be a contributors rush on Ethereum, in such a context...

* résultat : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/build$ ./build/bin/geth version
INFO [06-20|13:19:48.849] Bumping default cache on mainnet         provided=1024 updated=4096
WARN [06-20|13:19:48.849] Sanitizing cache to Go's GC limits       provided=4096 updated=2662
Geth
Version: 1.9.0-unstable
Git Commit: 25c3282cf1260bdc68c4ba9075c2bcc2f8136ea5
Git Commit Date: 20190620
Architecture: amd64
Protocol Versions: [63 62]
Network Id: 1
Go Version: go1.9.7
Operating System: linux
GOPATH=
GOROOT=/usr/local/go
jbl@poste-devops-typique:~/.ethereum-test/build$ 
```
