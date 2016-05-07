# This class sets up a TimeCapsule-like TimeMachine network target for
# backups from MacOS. See the README for more information and usage examples.

class timemachine (
  $package_netatalk   = $::timemachine::params::package_netatalk,
  $service_netatalk   = $::timemachine::params::service_netatalk,
  $manage_firewall_v4 = $::timemachine::params::manage_firewall_v4,
  $manage_firewall_v6 = $::timemachine::params::manage_firewall_v6,
  $volsizelimit       = $::timemachine::params::vpn_name,
  $location           = $::timemachine::params::vpn_range_v4,
) inherits ::timemachine::params {

  # Install netatalk software
  class { '::timemachine::install':
  }

  # Configure netatalk to act as a TimeCapsule
  file { '/etc/default/netatalk':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('timemachine/netatalk.conf.erb'),
    notify  => Service[$service_netatalk],
    require => Class['::timemachine::install'],
  }

  file { '/etc/netatalk/afpd.conf':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('timemachine/afpd.conf.erb'),
    notify  => Service[$service_netatalk],
    require => Class['::timemachine::install'],
  }

  file { '/etc/netatalk/AppleVolumes.default':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('timemachine/AppleVolumes.default.erb'),
    notify  => Service[$service_netatalk],
    require => Class['::timemachine::install'],
  }


}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
