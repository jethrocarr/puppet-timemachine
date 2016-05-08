# Configure a firewall using puppetlabs/firewall module
class timemachine::firewall (
  $manage_firewall_v4   = $::timemachine::manage_firewall_v4,
  $manage_firewall_v6   = $::timemachine::manage_firewall_v6,
) inherits ::timemachine {


  if ($manage_firewall_v4) {
    firewall { '100 V4 Permit AFP':
      provider => 'iptables',
      proto    => 'tcp',
      dport    => '548',
      action   => 'accept',
    }
  }

  if ($manage_firewall_v6) {
    firewall { '100 V6 Permit AFP':
      provider => 'ip6tables',
      proto    => 'tcp',
      dport    => '548',
      action   => 'accept',
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
