# This class sets up a TimeCapsule-like TimeMachine network target for
# backups from MacOS. See the README for more information and usage examples.

class timemachine (
  $package_netatalk   = $::timemachine::params::package_netatalk,
  $service_netatalk   = $::timemachine::params::service_netatalk,
  $manage_firewall_v4 = $::timemachine::params::manage_firewall_v4,
  $manage_firewall_v6 = $::timemachine::params::manage_firewall_v6,
  $manage_location    = $::timemachine::params::manage_location,
  $volsizelimit       = $::timemachine::params::volsizelimit,
  $location           = $::timemachine::params::location,
) inherits ::timemachine::params {

  # Install netatalk software
  class { '::timemachine::install':
  }

  # Define Firewall
  class { '::timemachine::firewall':
  }

  # Configure netatalk to act as a TimeCapsule
  file { '/etc/default/netatalk':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('timemachine/netatalk.conf.erb'),
    notify  => Service[$service_netatalk],
    require => Package[$package_netatalk],
  }

  file { '/etc/netatalk/afpd.conf':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('timemachine/afpd.conf.erb'),
    notify  => Service[$service_netatalk],
    require => Package[$package_netatalk],
  }

  file { '/etc/netatalk/AppleVolumes.default':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('timemachine/AppleVolumes.default.erb'),
    notify  => Service[$service_netatalk],
    require => Package[$package_netatalk],
  }


  # Create the directories for the backup location
  file { $location:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  # If requested, create the dirs for each user. Netatalk needs the directories
  # to exist (it can't create on the fly) so this is generally a useful feature
  if ($manage_location) {

    # Yes this is a pretty evil creation. Essentially we are discovering all
    # the non-system user accounts (by checking against UID_MIN) and then
    # creating directories for them if they don't already exist. TODO: there is
    # probably good cause to turn this into a fact.

    exec { 'timemachine_manage_user_dirs':
      path      => "/bin:/sbin:/usr/bin:/usr/sbin",
      command   => "getent passwd | tr \":\" \" \" | awk \"\$3 >= $(grep UID_MIN /etc/login.defs | cut -d \" \" -f 2) { print \$1 }\" | sort| uniq|sed -e 's/nobody//g' | xargs -L1 -I % sh -c 'mkdir -m 0700 -p ${location}/%; chown %:% ${location}/%'",
      unless    => "getent passwd | tr \":\" \" \" | awk \"\$3 >= $(grep UID_MIN /etc/login.defs | cut -d \" \" -f 2) { print \$1 }\" | sort| uniq|sed -e 's/nobody//g' | xargs -L1 -I % ls -1 ${location}/% || false",
      logoutput => true,
      require   => File[$location],
    }
  }


}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
