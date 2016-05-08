# puppet-timemachine

## Overview

This Puppet module setups an AFP share using netatalk specifically configured
to act like an Apple TimeCapsule device, to allow for easy backups from MacOS
to a GNU/Linux server.


## Usage

Simply configure where to store the backups and optionally how many MB to
limit each user's backup to.

  class { 'timemachine':
    location     => "/mnt/backup/timemachine',
    volsizelimit => '1000000', # 1TB per user backing up
  }

By default this module will create directories for each real user on the server
in the configured location as well as configuring a firewall rule. These can be
disabled if desired, eg:

  class { 'timemachine':
    location           => "/mnt/backup/timemachine',
    volsizelimit       => '1000000', # 1TB per user backing up
    manage_location    => false,
    manage_firewall_v4 => false,
    manage_firewall_v6 => false,
  }

Refer to `manifests/params.pp` for all options and information on each one.


## Requirements

Supported host operating systems:
* Debian

Note that this module manages netatalk and will cause issues if you are also
using netatalk for general purpose AFP shares. It is recommend that you move
any file shares to Samba, given that from Mavericks onwards AFP is deprecated
in favour of SMB2 - although Time Machine seems to not have recieved this memo
hence this module using netatalk/AFP :-)


# Development

Contributions in the form of Pull Requests (or beer donations) are always
welcome. Additional host OS support PRs particularly welcome.


# License

This module is licensed under the Apache License, Version 2.0 (the "License").
See the LICENSE or http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

