# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include snapcast::client
# @summary Manages snapclient
#
# Manages package, configuration, and service for snapclient, the client
# component of the [Snapcast, https://mjaggard.github.io/snapcast/]
# real-time audio streamer.
#
# @example
#   class { 'snapcast::client':
#     user_opts => '--user snapclient:audio',
#   }
class snapcast::client (
  $package_ensure   = 'present',
  $start            = 'true',
  $user_opts        = undef,
  $opts             = undef
  ) {

  case $::osfamily {
    'Debian': {
      $package_name     = 'snapclient'
      $service_name     = 'snapclient'
      $config_file      = '/etc/default/snapclient'
    }
    default: {
      fail('$(::osfamily) is not supported.')
    }
  }

  package { $package_name:
    ensure => $package_ensure,
    name   => $package_name,
    before => File[$config_file],
  }
  file { $config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('snapcast/snapclient.epp'),
  }
  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File[$config_file],
  }
}
