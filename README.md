# Experimenting the most github-starred `Ethereum` recipe

A quick dive, to see if https://github.com/vincentchu/eth-private-net  actually works

# Warning

All below tests were run inside a `VirtualBox` Virutal Machine, on a debian stretch Host, which is a physical machine having no other GRaphics Controller than the one embedded on my PC's motherboard.

A `VirtualBox` Virutal Machine, for which :
* I setup the `3D acceleration` feature (`Settings => Display`), setting memory usage limit to  `128 MB` (the maximum allowed/supported by `Virtual Box`), and the `Graphics Controller` to `VMSVGA`.
* The maximum allowed/supported by `Virtual Box` is an issue realated to running `miners` _enodes_  I'll deal with in a private repo, given the unclear pratices, at least as far as I can tell today, of current (`2019`), the blockchain players. Because that part of a blockchain is its production most critical point. And probably the most interesting challenge in the very near future. With strategic issues, of which discussion go way beyond the present work. 
* I provisioned a `Debian OS` : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ uname -a
Linux poste-devops-typique 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux
```

I Used Virtual Box for the following purposes : 
* because it's one of the most spread virt. tooling among developers
* because it has enough features to build up a proper prototype / poc of a product I'm working on.

# Diving session 1 : bulk automation (Before Ansible Playbook)

* Pre-requisites : 
  * installing `geth`. Here I have a problem, which that ethereum go-client only supports Ubuntu, so I'll first try and build the `go-ethereum` implementation on my debian stretch bas machine. Otherwise, I'll just switch to docker containers. update : I succeded build from source `geth`, on debian, and it seems to work ok, just [the Smart Card driver issue remaining](#about-the-smartcard-socket-not-found-disabling----errstat-runpcscdpcscdcomm-no-such-file-or-directory-error). 
  * installing the _Smart Card driver_ `pc sc lite`, on Debian Stretch
  * installing `GNU / gcc / make` classical dev env. on Debian Stretch
  * running Mr. Chu's recipe

### Executing the test 

```bash
export OPS_HOME=~/.ethereum-test/
export TEST_SOURCE_CODE_GIT_URI=https://github.com/Jean-Baptiste-Lasselle/ethereum-test

mkdir -p $OPS_HOME
cd $OPS_HOME
git clone "$TEST_SOURCE_CODE_GIT_URI" .

chmod +x ./operations.sh
./operations.sh
```


## (Un)Expected Outputs

#### For the provisioning

* I ran the initialization script, and got the same error, `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory`, for each of the three "parties" in the blockchain, involved in mister Chu's e2e test proposal : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net init
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

## About the `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory` error

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

Here is an example of a Smart Card reader on ebay (Has your boss ever given you a card you need to slip up your machine, to authenticate to the OS, making use of a Kerberos server...?) :

![example Smart Card reader](https://github.com/Jean-Baptiste-Lasselle/ethereum-test/raw/master/images/SMART_CARDS_EXAMPLES_EBAY_2019-06-21%2007-23-56.png)

Well that kind of hardware certainly isn't  capable of OpenCL or CUDA, like most `GPU` on the market. So **i don't see yet what role** does **the smart card plays in `ethereum` infra**, and why it pops up in this test.

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
  * Okay, so my worry about not finding anything about the required  `bootnode`, in the logs, where completely justified. Not that am happy to be right, there, I'd so much have preferred to be wrong. 
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

I just temporarily stop this analysis here, will go further later on. My net try will be to try and install the `pc sc lite` on Debian, using https://salsa.debian.org/debian/pcsc-lite/blob/master/INSTALL , which is pretty much the official source code  distribution channel for the  `pc sc lite` package on Debian.


Source of informations : 

* https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751745 : contact `Ludovic Rousseau <ludovic.rousseau@free.fr>` definitely looks like a LSB module / Linux driver issue, might be `Debian` specific, and not happening on Ubuntu which Mr. Chu probably used for his tests
* https://ludovicrousseau.blogspot.com/2011/11/pcscd-auto-start-using-systemd.html : Again, Mr. `Ludovic Rousseau <ludovic.rousseau@free.fr>` 
* https://github.com/LudovicRousseau/pcsc-tools : Welln, Mr. Ludovic Rousseau seems to be a Debian contirbutor...
* https://wiki.debian.org/Smartcards
* https://pcsclite.apdu.fr/  (seems to be the official reference website on the Smart Card driver `pcscd`)

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


#### Install the `pc sc lite` on Debian

Using instructions at official https://salsa.debian.org/debian/pcsc-lite/blob/master/INSTALL

Well the procedure is quite simple, it's a good old "Build from source", in the FSF / GNU / Debian pure spirit : 

```bash
export OPS_HOME=~/.ethereum-test
export PACKAGE_SOURCE_GIT_URI=https://salsa.debian.org/debian/pcsc-lite.git

mkdir -p $OPS_HOME/.pcsc-lite
cd $OPS_HOME/.pcsc-lite
git clone "$PACKAGE_SOURCE_GIT_URI" .

# Briefly, the shell command './configure && make && make install'  should configure, build, AND install this package.
# see. https://salsa.debian.org/debian/pcsc-lite/blob/master/INSTALL

sudo apt-get install -y systemd-dev*
sudo ./configure && sudo make && sudo make install

```
At first execution of that script, I get the following error :

```bash
configure: error: install libsystemd-dev or use --disable-libsystemd
```
<!--
* Sur le sujet, une issue dans laquelle Ludovic Rousseau traite de la question : https://github.com/LudovicRousseau/PCSC/issues/2
-->
* About that error, I found an issue on `pc sc lite` official git repo : https://github.com/LudovicRousseau/PCSC/issues/2
* Unfortunately for me, MR. Rousseau's  answer is pretty much take care : 

_(Mr. Rousseau I guess, is the lead Debian developer for `pc sc lite` driver)_

> 
> Debian provides systemd version 228 and libudev-dev is still provided.
libsystemd-dev does not provide the pkg-config file libudev.pc used by the check in configure.
> 
> Packages names and content will depend on every Linux distribution. I do not plan to write a complete INSTALL documentation in the configure error message. I don't think this proposal is a good idea.
> 
> As a developer building pcsc-lite you should be smart enough to know what package to install :-)
> 


But I got saved by some [@shearl](https://github.com/shearl) (thanks so much, Keith, for your `sudo apt-get install -y systemd-dev*` tip ...) :

* `sudo apt-get install -y libsystemd-dev` and re-running `sudo ./configure && sudo make && sudo make install`, got me to the same error, but this time it's `libudev` that is suggested missing and should be installed. 
* Installing both `sudo apt-get install -y libsystemd-dev libudev`, gives us just one more error, and we are trapped in a dependency resolution loop. Tricky, if we're down to reparing a build from source, of a driver, to see if by any chance... well.
* Finally, running `sudo apt-get install -y systemd-dev*` ([many thanks to Keith Shearl, and Ludovic Rousseau](https://github.com/LudovicRousseau/PCSC/issues/2#issuecomment-504243393) ), and re-running `sudo ./configure && sudo make && sudo make install` finally brought me the :+1: first build from source of the `pcsc-lite` driver : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/.pcsc-lite$ sudo systemctl status pcscd
[sudo] password for jbl: 
● pcscd.service - PC/SC Smart Card Daemon
   Loaded: loaded (/lib/systemd/system/pcscd.service; indirect; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:pcscd(8)
jbl@poste-devops-typique:~/.ethereum-test/.pcsc-lite$ # Ouh, and btw : 
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ uname -a
Linux poste-devops-typique 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux
```

So wow, great now I can re-run Mister Chu's `./eth-private-net init`, with  `pcscd` surely presnet on the system (and it was tricky, to make sure it is...) : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ uname -a
Linux poste-devops-typique 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net clean
Cleaning geth/ directory from alice
Cleaning geth/ directory from bob
Cleaning geth/ directory from lily
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net init
Initializing genesis block for alice
INFO [06-20|20:36:36.363] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:36:36.363] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|20:36:36.365] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:36:36.381] Writing custom genesis block 
INFO [06-20|20:36:36.382] Persisted trie from memory database      nodes=3 size=409.00B time=114.148µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:36:36.383] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:36:36.384] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:36:36.395] Writing custom genesis block 
INFO [06-20|20:36:36.395] Persisted trie from memory database      nodes=3 size=409.00B time=93.182µs  gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:36:36.396] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for bob
INFO [06-20|20:36:36.451] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:36:36.451] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|20:36:36.453] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:36:36.462] Writing custom genesis block 
INFO [06-20|20:36:36.462] Persisted trie from memory database      nodes=3 size=409.00B time=98.065µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:36:36.463] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:36:36.463] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:36:36.483] Writing custom genesis block 
INFO [06-20|20:36:36.484] Persisted trie from memory database      nodes=3 size=409.00B time=138.035µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:36:36.484] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for lily
INFO [06-20|20:36:36.530] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:36:36.530] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|20:36:36.531] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:36:36.548] Writing custom genesis block 
INFO [06-20|20:36:36.548] Persisted trie from memory database      nodes=3 size=409.00B time=144.575µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:36:36.549] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:36:36.549] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:36:36.567] Writing custom genesis block 
INFO [06-20|20:36:36.568] Persisted trie from memory database      nodes=3 size=409.00B time=66.919µs  gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:36:36.568] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ uname -a
Linux poste-devops-typique 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ systemctl status pcscd
● pcscd.service - PC/SC Smart Card Daemon
   Loaded: loaded (/lib/systemd/system/pcscd.service; indirect; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:pcscd(8)
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl enable pcscd.socket 
[sudo] password for jbl: 
Created symlink /etc/systemd/system/sockets.target.wants/pcscd.socket → /lib/systemd/system/pcscd.socket.
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl enable pcscd.service
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl daemon-reload
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net clean
Cleaning geth/ directory from alice
Cleaning geth/ directory from bob
Cleaning geth/ directory from lily
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net init
Initializing genesis block for alice
INFO [06-20|20:42:32.536] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:42:32.536] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|20:42:32.538] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:42:32.551] Writing custom genesis block 
INFO [06-20|20:42:32.552] Persisted trie from memory database      nodes=3 size=409.00B time=103.62µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:42:32.553] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:42:32.553] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:42:32.563] Writing custom genesis block 
INFO [06-20|20:42:32.568] Persisted trie from memory database      nodes=3 size=409.00B time=4.36146ms gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:42:32.569] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for bob
INFO [06-20|20:42:32.624] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:42:32.624] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|20:42:32.625] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:42:32.635] Writing custom genesis block 
INFO [06-20|20:42:32.638] Persisted trie from memory database      nodes=3 size=409.00B time=96.715µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:42:32.638] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:42:32.638] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:42:32.657] Writing custom genesis block 
INFO [06-20|20:42:32.657] Persisted trie from memory database      nodes=3 size=409.00B time=68.863µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:42:32.657] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for lily
INFO [06-20|20:42:32.699] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:42:32.699] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory"
INFO [06-20|20:42:32.700] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:42:32.713] Writing custom genesis block 
INFO [06-20|20:42:32.713] Persisted trie from memory database      nodes=3 size=409.00B time=101.983µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:42:32.714] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:42:32.714] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:42:32.734] Writing custom genesis block 
INFO [06-20|20:42:32.734] Persisted trie from memory database      nodes=3 size=409.00B time=69.079µs  gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:42:32.735] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ systemctl status pcscd
● pcscd.service - PC/SC Smart Card Daemon
   Loaded: loaded (/lib/systemd/system/pcscd.service; indirect; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:pcscd(8)
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ systemctl status pcscd.socket 
● pcscd.socket - PC/SC Smart Card Daemon Activation Socket
   Loaded: loaded (/lib/systemd/system/pcscd.socket; enabled; vendor preset: enabled)
   Active: inactive (dead)
   Listen: /var/run/pcscd/pcscd.comm (Stream)
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ cat /lib/systemd/system/pcscd.socket 
[Unit]
Description=PC/SC Smart Card Daemon Activation Socket

[Socket]
ListenStream=/var/run/pcscd/pcscd.comm
SocketMode=0666

[Install]
WantedBy=sockets.target
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ cat /lib/systemd/system/pcscd.service 
[Unit]
Description=PC/SC Smart Card Daemon
Requires=pcscd.socket
Documentation=man:pcscd(8)

[Service]
ExecStart=/usr/local/sbin/pcscd --foreground --auto-exit
ExecReload=/usr/local/sbin/pcscd --hotplug

[Install]
Also=pcscd.socket
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ 


```

Ouch, I AGAIN :@:, find the  `Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: no such file or directory` error. There, I just stop investigating any further the error raised by Mr. Chu recipe : 
* I found what the problem is, which is `geth` looking up for pcscd.socker inside a subfolder of `/run`, while my driver socket was installed at `/var/run/pcscd/pcscd.socket`... I'll try symplinks there...? (changing the soft, or its provisioning recipe, and as little change as possible to the system). ANd Indeed, I had a change in the logs : 

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo ln -s /run/pcscd/pcscd.comm /var/run/pcscd/pcscd.comm
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo ls -allh /run/pcscd
total 0
drwxr-xr-x  2 root root  60 Jun 20 20:56 .
drwxr-xr-x 25 root root 860 Jun 20 20:56 ..
lrwxrwxrwx  1 root root  21 Jun 20 20:56 pcscd.comm -> /run/pcscd/pcscd.comm
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net clean
Cleaning geth/ directory from alice
Cleaning geth/ directory from bob
Cleaning geth/ directory from lily
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net init
Initializing genesis block for alice
INFO [06-20|20:59:50.663] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:59:50.663] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: too many levels of symbolic links"
INFO [06-20|20:59:50.665] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:59:50.797] Writing custom genesis block 
INFO [06-20|20:59:50.798] Persisted trie from memory database      nodes=3 size=409.00B time=133.292µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:59:50.798] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:59:50.798] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:59:50.910] Writing custom genesis block 
INFO [06-20|20:59:50.910] Persisted trie from memory database      nodes=3 size=409.00B time=104.618µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:59:50.910] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for bob
INFO [06-20|20:59:50.970] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:59:50.970] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: too many levels of symbolic links"
INFO [06-20|20:59:50.971] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:59:50.983] Writing custom genesis block 
INFO [06-20|20:59:50.983] Persisted trie from memory database      nodes=3 size=409.00B time=94.6µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:59:50.984] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:59:50.985] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:59:51.002] Writing custom genesis block 
INFO [06-20|20:59:51.003] Persisted trie from memory database      nodes=3 size=409.00B time=82.739µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:59:51.003] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for lily
INFO [06-20|20:59:51.052] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-20|20:59:51.052] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: too many levels of symbolic links"
INFO [06-20|20:59:51.053] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|20:59:51.063] Writing custom genesis block 
INFO [06-20|20:59:51.063] Persisted trie from memory database      nodes=3 size=409.00B time=75.441µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:59:51.064] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|20:59:51.064] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|20:59:51.077] Writing custom genesis block 
INFO [06-20|20:59:51.078] Persisted trie from memory database      nodes=3 size=409.00B time=85.818µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|20:59:51.078] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ 
```
* Okay, so there we have no more error, just the same problem transformed a bit : Now It's SystemD complaining about the hacky dirty symbolic link that I set up  :

```bash
INFO [06-20|20:59:50.663] Smartcard socket not found, disabling    err="stat /run/pcscd/pcscd.comm: too many levels of symbolic links"
```

* Right, so Now I think I should change only little to have geth finding /run/pcscd/pcscd.comm

```bash
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo systemctl status pcscd.socket 
● pcscd.socket - PC/SC Smart Card Daemon Activation Socket
   Loaded: loaded (/lib/systemd/system/pcscd.socket; enabled; vendor preset: enabled)
   Active: inactive (dead)
   Listen: /var/run/pcscd/pcscd.comm (Stream)
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo ln -s /lib/systemd/system/pcscd.socket /run/pcscd/pcscd.comm
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ sudo ls -allh  /run/pcscd/pcscd.comm 
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net clean
Cleaning geth/ directory from alice
Cleaning geth/ directory from bob
Cleaning geth/ directory from lily
jbl@poste-devops-typique:~/.ethereum-test/abovetest/provisioning$ ./eth-private-net init
Initializing genesis block for alice
INFO [06-20|21:11:00.383] Maximum peer count                       ETH=50 LES=0 total=50
ERROR[06-20|21:11:00.384] Invalid smartcard daemon path            path=/run/pcscd/pcscd.comm type=-rw-r--r--
INFO [06-20|21:11:00.385] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|21:11:00.405] Writing custom genesis block 
INFO [06-20|21:11:00.405] Persisted trie from memory database      nodes=3 size=409.00B time=107.048µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|21:11:00.406] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|21:11:00.406] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/alice/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|21:11:00.420] Writing custom genesis block 
INFO [06-20|21:11:00.420] Persisted trie from memory database      nodes=3 size=409.00B time=129.043µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|21:11:00.421] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for bob
INFO [06-20|21:11:00.475] Maximum peer count                       ETH=50 LES=0 total=50
ERROR[06-20|21:11:00.475] Invalid smartcard daemon path            path=/run/pcscd/pcscd.comm type=-rw-r--r--
INFO [06-20|21:11:00.477] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|21:11:00.485] Writing custom genesis block 
INFO [06-20|21:11:00.485] Persisted trie from memory database      nodes=3 size=409.00B time=77.755µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|21:11:00.486] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|21:11:00.486] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/bob/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|21:11:00.509] Writing custom genesis block 
INFO [06-20|21:11:00.509] Persisted trie from memory database      nodes=3 size=409.00B time=75.875µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|21:11:00.509] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398
Initializing genesis block for lily
INFO [06-20|21:11:00.555] Maximum peer count                       ETH=50 LES=0 total=50
ERROR[06-20|21:11:00.555] Invalid smartcard daemon path            path=/run/pcscd/pcscd.comm type=-rw-r--r--
INFO [06-20|21:11:00.556] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/chaindata cache=16.00MiB handles=16
INFO [06-20|21:11:00.571] Writing custom genesis block 
INFO [06-20|21:11:00.572] Persisted trie from memory database      nodes=3 size=409.00B time=77.265µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|21:11:00.572] Successfully wrote genesis state         database=chaindata hash=a528ae…08b398
INFO [06-20|21:11:00.573] Allocated cache and file handles         database=/home/jbl/.ethereum-test/abovetest/provisioning/lily/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-20|21:11:00.596] Writing custom genesis block 
INFO [06-20|21:11:00.597] Persisted trie from memory database      nodes=3 size=409.00B time=71.975µs gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [06-20|21:11:00.597] Successfully wrote genesis state         database=lightchaindata hash=a528ae…08b398

```
Just a bloody hell to have `geth` properly using the SmartCArd driver SystemD service... But I'm sure there is a way, or a major incompatibility of `geth` with recent versions of `pc sc lite` Smart Card Driver, cause I can't fathom why I get that error from `geth` : 

```bash
ERROR[06-20|21:11:00.384] Invalid smartcard daemon path            path=/run/pcscd/pcscd.comm type=-rw-r--r--
```

# POINT BLOCAGE/REPRISE

Bon,là, je ne vois qu'une seule chose raisonnable à faire pour aller au plus loin : essayer de re-définir complètement le service SystemD pour `pc sc lite`, et vérifeir que tout va bien dans le définition de serice, car l'à d=j'ai encore une erreur de path, et il va falloir que je revoie en détail, le setup d'un service et ses dépendances, avec `SystemD`.


* So I'll now just try and run the same thing, but on a bare metal machine with an nvidia , Debian stretch, and the NVIDIA driver for my `os` / `proc arch`


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
