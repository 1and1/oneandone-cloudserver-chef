# Knife::Oneandone

## Description

1&amp;1 Chef Knife plugin for managing 1&1 Cloud servers. For more information on the 1&amp;1 Chef Knife plugin, see the [1&1 Community Portal](https://www.1and1.com/cloud-community/).

## Requirements

* Chef 12.3.0 or higher
* Ruby 2.1.x or higher

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'knife-oneandone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knife-oneandone


## Configuration

The 1&amp;1 Chef Knife plugin requires a valid 1&amp;1 API key. Add your 1&amp;1 API key in a ```knife.rb``` configuration file (for example in ```~/.chef/knife.rb```).

```ruby
knife[:oneandone_api_key] = '_YOUR_API_KEY_'
```

## Sub Commands

The following sub-commands are available with the plugin:

### knife oneandone appliance list

Lists all server appliances.

### knife oneandone datacenter list

Lists all data centers.

### knife oneandone firewall create

Creates a new firewall policy.

### knife oneandone firewall delete

Deletes one or more firewall policies.

### knife oneandone firewall list

Lists available firewall policies.

### knife oneandone ip list

Lists allocated public IPs.

### knife oneandone loadbalancer create

Creates a new load balancer.

### knife oneandone loadbalancer delete

Deletes one or more load balancers.

### knife oneandone loadbalancer list

Lists available load balancers.

### knife oneandone mp list

Lists available monitoring policies.

### knife oneandone server create

Creates a new server.

### knife oneandone server delete

Deletes one or more servers.

### knife oneandone server hdd add

Adds one or more hard disks to server.

### knife oneandone server hdd delete

Removes server's hard disk.

### knife oneandone server hdd list

Lists server's hard disks.

### knife oneandone server hdd resize

Resizes server's hard disk.

### knife oneandone server list

Lists available servers.

### knife oneandone server modify

Modifies server's hardware configuration: CPU/cores count, RAM amount and/or fixed server size.

### knife oneandone server reboot

Reboots one or more servers.

### knife oneandone server rename

Updates server's name and/or description.

### knife oneandone server size list

Lists available fixed-server-size configurations.

### knife oneandone server start

Starts one or more servers.

### knife oneandone server stop

Stops one or more servers.

### knife oneandone block storage create

Creates a new block storage.

### knife oneandone block storage list

Lists available block storages.

### knife oneandone block storage rename

Updates block storage's name and/or description.

### knife oneandone block storage delete

Deletes one or more block storages.

### knife oneandone block storage attach

Attaches a block storage to a server.

### knife oneandone block storage detach

Detaches a block storage from a server.

### knife oneandone ssh key create

Creates a new ssh key.

### knife oneandone ssh key list

Lists available ssh keys.

### knife oneandone ssh key rename

Updates ssh key's name and/or description.

### knife oneandone ssh key delete

Deletes one or more ssh keys.

## Usage

Before deploying a server to your 1&amp;1 Cloud environment, you may want set up a dedicated firewall policy or a load balancer for the server.

To create a firewall policy and allow the access from any IP address:

```
knife oneandone firewall create -n my-firewall -p TCP,UDP,ICMP --port-from 80,161 --port-to 80,162
```

A load balancer can be created as follows:

```
knife oneandone loadbalancer create -n my-LB -m ROUND_ROBIN \
  -p TCP,UDP --port-balancer 80,161 --port-server 8080,161
```

To restrict the access to a particular IP address or network, specify ```--source``` option for the load balancer and firewall policy. 

**Note:** When multiple (firewall or load balancer) rules are specified, make sure that the protocols, ports and sources are separated by a comma and in the same order. In a firewall policy create command, specify GRE, ICMP and IPSEC protocols last, for instance 
```--protocol TCP,TCP,UDP,TCP/UDP,GRE,ICMP,IPSEC```.


Furthermore, use the list commands to find out IDs of the fixed-size configurations, server appliances, monitoring policies, existing IPs, data centers etc.

```
knife oneandone server size list
ID                                Name  RAM (GB)  Processor No.  Cores per Processor  Disk Size (GB)
65929629F35BBFBA63022008F773F3EB  M     1         1              1                    40
591A7FEF641A98B38D1C4F7C99910121  L     2         2              1                    80
E903FA4F907B5AAF17A7E987FFCDCC6B  XL    4         2              1                    120
57862AE452473D551B1673938DD3DFFE  XXL   8         4              1                    160
3D4C49EAEDD42FBC23DB58FE3DEF464F  S     0.5       1              1                    30
6A2383038420110058C77057D261A07C  3XL   16        8              1                    240
EED49B709368C3715382730A604E9F6A  4XL   32        12             1                    360
EE48ACD55FEFE57E2651862A348D1254  5XL   48        16             1                    500
```

The format option may be used with the list commands to output JSON or yaml (e.g. ```-F json```, ```--format yaml```).


To create a cloud server, you can either specify a fixed-size ID or a flex configuration of the hardware. For baremetal servers, you have to specify a baremetal_model_id.

```
knife oneandone server create -n Demo-Server \
  --appliance-id  FF696FFE6FB96FC54638DB47E9321E25 \
  --datacenter-id 5091F6D8CBFEF9C26ACE957C652D5D49 \
  --fixed-size-id 65929629F35BBFBA63022008F773F3EB
Deploying, wait for the operation to complete...
        ID: D67F6B24C9C0AED76B8573D267B0EDAB
        Name: Demo-Server
        First IP: 109.228.53.48
        First Password: Qc9knjVAK1
done
```

```
knife oneandone server create -n chef-baremetal-server \
  --appliance-id 33352CCE1E710AF200CD1234BFD18862 \
  --datacenter-id 4EFAD5836CE43ACA502FD5B99BEE44EF \
  --baremetal-model-id 81504C620D98BCEBAA5202D145203B4B \
  --server-type baremetal
Deploying, wait for the operation to complete...
	ID: A022DD2CD1629BBCD7873086C113C1D4
	Name: chef-baremetal-server
	First IP: 82.165.251.137
	First Password: Ur37Ncwwpf
done
```

```
knife oneandone server create -n FS1 -I B5F778B85C041347BCDCFC3172AB3F3C -P 2 -C 1 -r 2 -H 40 -F yaml
Deploying, wait for the operation to complete...
---
id: 341EB3FF15E861309C4D1C3BC6A8B17B
cloudpanel_id: 23A0543
name: FS1
description: ''
datacenter:
  id: 908DC2072407C94C8054610AD5A53B8C
  country_code: US
  location: United States of America
creation_date: '2016-08-05T12:26:27+00:00'
first_password: Zf1jtd1WH9
rsa_key: 0
status:
  state: POWERED_ON
  percent:
hardware:
  fixed_instance_size_id:
  vcore: 2
  cores_per_processor: 1
  ram: 2
  hdds:
  - id: 430C1E70E1737690E5A71F9D63BE80B2
    size: 40
    is_main: true
image:
  id: B5F778B85C041347BCDCFC3172AB3F3C
  name: centos7-64std
dvd:
snapshot:
ips:
- id: DC9F635EA2B3144FC047532C6FD56B84
  ip: 62.151.178.250
  type: IPV4
  reverse_dns:
  firewall_policy:
    id: A4D6302FA44955C797772E34880CBA42
    name: centos7-64cpanel
  load_balancers: []
alerts: []
monitoring_policy:
private_networks:
```

To attach new hard disks to the server, specify a size for each new volume:

```
knife oneandone server hdd add 20 80 160 --server-id 341EB3FF15E861309C4D1C3BC6A8B17B
```

List the server disks in the following way:

```
knife oneandone server hdd list 341EB3FF15E861309C4D1C3BC6A8B17B
ID                                Size (GB)  Main
430C1E70E1737690E5A71F9D63BE80B2  40         true
26D593F10CF0FE666004A594A08B5C0A  20         false
602690CAA4BFE5724356148112918C79  80         false
BA5486B5C0F1861307F80DEB880A4041  160        false
```

Specify the ID of any server you intend to start, stop, reboot or delete. The next example shows a delete operation 
with auto-confirming all prompts for deletion.

```
knife oneandone server delete 341EB3FF15E861309C4D1C3BC6A8B17B D67F6B24C9C0AED76B8573D267B0EDAB -y
```

A block storage can be created as follows:

```
knife oneandone block storage create -n chef-blk -s 30 --description test_chef_blkstore -D 5091F6D8CBFEF9C26ACE957C652D5D49
```

An ssh key can be created as follows:

```
knife oneandone ssh key create -n chef-ssh-key --description test_chef_sshkey
```

To create a server with ssh keys, pass the comma-separated list of ssh key ids (or just a single id) using `--public-key` parameter:
```
knife oneandone server create -n chef-serverssh -I C5A349786169F140BCBC335675014C08 -P 2 -C 1 -r 2 -H 40 --public-key E07CA9CA5D8F09A2872FC27160EE28D2
``` 

## Development

After checking out the repository, run `bundle install` to install dependencies.

Use the bundler to run the tests. Declare ONEANDONE_API_KEY environment variable before running the tests.

    $ export ONEANDONE_API_KEY="_YOUR_API_KEY_"
    $ bundle exec rspec

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork the repository (`https://github.com/1and1/oneandone-cloudserver-chef/fork`).
2. Create a new feature branch (`git checkout -b my-new-feature`).
3. Commit the changes (`git commit -am 'New feature description'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new pull request.

Bug reports and pull requests are welcome.
