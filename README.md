# probebuild

This network probe build framework provides the following tools:

* Cacti (as a container)
* Smokeping (as a container)
* iperf 2 (as a service)
* iperf 3 (as a service)
* ntopng (as a container)
* tshark
* Cockpit (for management of the probe)

All data files for the containers are stored in */docker*.

### Getting started

Begin with a fresh CentOS 7 installation. This has not been tested with other distributions and is known not to work on CentOS 8 for all the tools.

Start with installing git:
```sh
$ yum install -y git
```
Next, clone the probebuild repo locally and run *./build.sh*:
```sh
$ git clone https://github.com/mcnc-clovett/probebuild.git
$ cd probebuild
$ ./build.sh
```

### Management

You can access most of the web-based services at *http://<probeip>*. However, the following are direct ports for each service.

| Service | Port |
| ------ | ------ |
| Cockpit | 9090 |
| Cacti | 8080, 443 |
| Smokeping | 8081 |
| iperf | 5001 |
| iperf3 | 5201 |
| ntopng | 3000, 3001 |

The default login for Cockpit is the same as your *root* user on the linux host. All other logins are admin/admin by default.
