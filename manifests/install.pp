# Installation class for the netatalk software
class timemachine::install (
  $package_netatalk   = $::timemachine::package_netatalk,
  $service_netatalk   = $::timemachine::service_netatalk,
) inherits ::timemachine {

  # Compatibility Checks
  if ($::operatingsystem != "Debian" and $::operatingsystem != "Ubuntu") {
    fail("Sorry, only Debian or Ubuntu distributions are supported by the timemachine module at this time. PRs welcome")
  }

  # Nasty Hack - Unfortunatly Debian 8 lacks a netatalk package entirely, the
  # only way we can get it is to either build from source, or grab a version
  # from a later version of Debian (like unstable). Grabbing a single package
  # from a more recent OS version is actually bit of a PITA with Apt, since you
  # can't simply define the repo and include a single package :-(

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }
 
  if ($::operatingsystem == 'Debian') {
    if ($::operatingsystemrelease =~ /^8/) {

      # Netatalk from Debian Sid
      $download_version = "2.2.5-1+b1"
      $download_url     = "http://ftp.us.debian.org/debian/pool/main/n/netatalk/netatalk_${::download_version}_${::architecture}.deb"

      # Download and install the software.
      exec { 'netatalk_package_download':
        creates   => "/tmp/netatalk-${download_version}.deb",
        command   => "wget -nv ${download_url} -O /tmp/netatalk-${download_version}.deb",
        unless    => "dpkg -s netatalk | grep -q \"Version: ${download_version}\"", # Download new version if not already installed.
        logoutput => true,
        notify    => Exec['netatalk_package_install'],
      }

      exec { 'netatalk_package_install':
        # Ideally we'd use "apt-get install package.deb" but this only become
        # available in apt 1.1 and later. Hence we do a bit of a hack, which is
        # to install the deb and then fix the deps with apt-get -y -f install.
        # TODO: When Debian 9 is out, check if we can migrate to the better approach?
        command     => "bash -c 'dpkg -i /tmp/netatalk-${download_version}.deb; apt-get -y -f install'",
        require     => Exec['netatalk_package_download'],
        before      => Package[ $package_netatalk ], # Make sure we do this manual install, before Puppet tries to
        logoutput   => true,
        refreshonly => true,
      }
    }
  }


  # Install the package
  package { $package_netatalk:
    ensure   => 'latest',
  }

  # We need to define the service and make sure it's set to launch at startup.
  service { $service_netatalk:
    ensure  => running,
    enable  => true,
    require => Package[ $package_netatalk ],
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
