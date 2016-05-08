# Define all default parameters here. You should never fork the module and
# have to make changes here, instead use Hiera to override the params passed
# to the classes.

class timemachine::params {

  # TODO: This will be Debian specific
  # Define all the packages we require
  $package_netatalk = 'netatalk'

  # TODO: This will (probably) be Debian specific
  # Define the name of the service.
  $service_netatalk = 'netatalk'

  # By default, we should manage the firewall. Ideally the user will be taking
  # advantage of puppetlabs/firewall to manage their ruleset, but if another
  # firewall module or technology is being used (eg AWS security groups) it's
  # easy enough to disable our management of the firewall.
  $manage_firewall_v4 = true
  $manage_firewall_v6 = true

  # If set to true, create a directory inside of $location for each real
  # user on the server (ie non-system users)
  $manage_location = true

  # Define the default location for backups, but most users will want to change it
  # to suit their storage arrangement.
  $location = '/home/timemachine'

  # Default volume size limit
  $volsizelimit = undef # no limit by default
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
