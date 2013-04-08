# chef-bahamut [![Build Status](https://secure.travis-ci.org/bflad/chef-bahamut.png?branch=master)](http://travis-ci.org/bflad/chef-bahamut)

## Description

Installs/Configures Bahamut IRC daemon. Please see [COMPATIBILITY.md](COMPATIBILITY.md) for more information about Bahamut releases that are tested and supported by this cookbook and its versions.

* [Bahamut website](http://www.dal.net/?page=bahamut)
* [Bahamut Github repository](https://github.com/epiphani/bahamut)

## Requirements

### Platforms

* CentOS 6
* RedHat 6
* Ubuntu 12.04

### Cookbooks

Required [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [build-essential](https://github.com/opscode-cookbooks/build-essential)

## Attributes

These attributes are under the `node['confluence']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | SHA256 checksum for Bahamut install | String | auto-detected (see attributes/default.rb)
configure_flags | Flags for Bahamut ./configure | String | auto-detected (see attributes/default.rb)
home_path | Location for Bahamut user home | String | `/home/#{node['bahamut']['user']}`
install_path | Location for Bahamut installation | String | `#{node['bahamut']['home_path']/bahamut`
url | URL for Bahamut install | String | auto-detected (see attributes/default.rb)
user | user running Bahamut | String | ircd
version | Bahamut version to install | String | 2.0.5

## Recipes

* `recipe[bahamut]` Installs/configures Bahamut
* `recipe[bahamut::configuration]` Configures Bahamut
* `recipe[bahamut::source_installation]` Compiles and installs Bahamut from source

## Usage

### Bahamut Configuration Data Bag

For securely configuring Bahamut on Hosted Chef, create a `ircd/bahamut` encrypted data bag with the model below. Chef Solo can override the same attributes with a `ircd/bahamut` unencrypted data bag of the same information.

Documentation for Bahamut configuration: https://github.com/epiphani/bahamut/blob/master/doc/reference.conf

_required:_
* `['global']['info'] server info
* `['global']['name'] server name
* `['port']` Array of port Hashes
  * `['port']` port number

_optional:_
* `['admin']` Hash of admin Strings
  * `['line1']` _required_
  * `['line2']`
  * `['line3']`
* `['allow']` Array of allow Hashes
  * ['host'] _required if no ipmask_
  * ['ipmask'] _required if no host_
  * ['class']
  * ['flags']
  * ['passwd']
  * ['port']
* `['class']` Array of class Hashes
  * ['maxsendq'] _required_
  * ['name'] _required_
  * ['pingfreq'] _required_
  * ['connfreq']
  * ['maxclones']
  * ['maxlinks']
  * ['maxrecvq']
  * ['maxusers']
* `['connect']` Array of connect Hashes (will skip Hash if `name` matches `node['fqdn']`)
  * ['apasswd'] _required_
  * ['cpasswd'] _required only if no apasswd for connect server_
  * ['host'] _required_
  * ['name'] _required_
  * ['bind']
  * ['class']
  * ['flags']
  * ['port']
* `['global']['dpass']`
* `['global']['rpass']`
* `['options'] Hash of options
  * `['key']: value`
* `['include']` path to include another configuration file
* `['kill']` Array of kill Hashes
  * `['mask']` _required_
  * `['reason']`
* `['modules']['autoload']` Array of modules
* `['modules']['path']`
* `['oper']` Array of oper Hashes
  * ['access'] _required_
  * ['host'] _required_ Array of masks
  * ['name'] _required_
  * ['passwd'] _required_
  * ['class']
* `['port']` Array of port Hashes
  * `['bind']`
  * `['ipmask']`
  * `['flags']`
* `['restrict']` Array of restrict Hashes
  * `['mask']` _required_
  * `['type']` _required_
  * `['reason']`
* `['super']` Array of super servers

Repeat for Chef environments as necessary. Use a FQDN key to override attributes. Example:

    {
      "id": "bahamut",
      /* Example of per-FQDN settings */
      "irc1.example.com": {
        "admin": {
          "line1": "Managed by admins from here"
        }
      },
      "irc2.example.com": {
        "admin": {
          "line1": "Managed by admins from there"
        }
      },
      /* Example of shared per-environment settings */
      "production": {
        /* cpasswd will automatically generate if necessary */
        "connect": [
          {
            "apasswd": "irc2.apasswd",
            "host": "W.X.Y.Z",
            "name": "irc1.example.com",
            "port": 7325
          },
          {
            "apasswd": "irc1.apasswd",
            "host": "W.X.Y.Z",
            "name": "irc2.example.com",
            "port": 7325
          }
        ]
        "global": {
          "info": "Example IRC Server",
          "name": "irc.example.com"
        },
        "oper": [
          {
            "access": "*Aa",
            "class": "opers",
            "host": [ "ident@hostmask" ],
            "name": "johndoe",
            "passwd": "mypassword"
          }
        ]
        "port": [
          {
            "flags": "i",
            "port": 6667
          },
          {
            "flags": "ni",
            "port": 7325
          },
          {
            "flags": "iS",
            "port": 7777,
          },
        ]
      }
    }

### Bahamut Installation

The simplest method is via the default recipe.

* Create required (un)encrypted data bag for configuration
  * `knife data bag create ircd`
  * `knife data bag edit ircd bahamut --secret-file=path/to/secret`
* Add `recipe[bahamut]` to your node's run list.

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

    git clone git://github.com/bflad/chef-bahamut.git
    cd chef-bahamut
    vagrant plugin install berkshelf # if not already installed
    vagrant up BOX # BOX being centos6 or ubuntu1204

Add the following hosts entries to your workstation:

* 33.33.33.10 bahamut-centos-6
* 33.33.33.11 bahamut-ubuntu-1204

The running Bahamut server is accessible from:

CentOS 6 Box:
* IRC: bahamut-centos-6:6667
* IRC (SSL): bahamut-centos-6:7777

Ubuntu 12.04 Box:
* IRC: bahamut-ubuntu-1204:6667
* IRC (SSL): bahamut-ubuntu-1204:7777

You can then SSH into the running VM using the `vagrant ssh` command.
The VM can easily be stopped and deleted with the `vagrant destroy`
command. Please see the official [Vagrant documentation](http://vagrantup.com/v1/docs/commands.html)
for a more in depth explanation of available commands.

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing on the Vagrant boxes.

## License and Author

Author:: Brian Flad (<bflad417@gmail.com>)

Copyright:: 2013

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
