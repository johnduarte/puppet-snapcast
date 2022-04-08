# @summary Manages snapserver
#
# Manages package, configuration, and service for snapserver, the server
# component of the [Snapcast, https://mjaggard.github.io/snapcast/]
# real-time audio streamer.
#
# @example
#   class { 'snapcast::server':
#     user_opts => '--user snapserver:snapserver',
#     opts => '-d -s pipe:///tmp/snapfifo?buffer_ms=20&codec=flac&name=default&sampleformat=48000:16:2',
#   }
class snapcast::server (
  $package_ensure   = 'present',
  $start            = 'true',
  $user_opts        = undef,
  $opts             = undef
  ) {

  case $::osfamily {
    'Debian': {
      $package_name     = 'snapserver'
      $service_name     = 'snapserver'
      $config_file      = '/etc/default/snapserver'
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
    content => epp('snapcast/snapserver.epp'),
  }
  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File[$config_file],
  }
}
