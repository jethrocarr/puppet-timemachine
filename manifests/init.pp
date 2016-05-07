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

  class { '::timemachine::install': }


}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
