# snapcast

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with snapcast](#setup)
    * [Beginning with snapcast](#beginning-with-snapcast)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)

## Description

The snapcast module installs, configures, and manages the snapserver and
snapclient services for the [Snapcast][1] real-time audio streamer on the
Debian operating system.

## Setup

### Beginning with snapcast

To setup snapcast you will need to include the server and client classes.
```puppet
include snapcast::server
include snapcast::client
```

To pass in parameters to configure the server or client options use:
```puppet
class { 'snapcast::server':
  opts => '-d -s pipe:///tmp/snapfifo?buffer_ms=20&codec=flac&name=default&sampleformat=48000:16:2',
}
```

## Usage

### Install and enable snapserver
```puppet
include snapcast::server
```

### Install and enable snapclient
```puppet
include snapcast::client
```

### Specify snapserver USER_OPTS and SNAPSERVER_OPTS
```puppet
class { 'snapcast::server':
  user_opts => '--user snapserver:snapserver',
  opts      => '-d -s pipe:///tmp/snapfifo?buffer_ms=20&codec=flac&name=default&sampleformat=48000:16:2',
}
```

### Specify snapclient USER_OPTS and SNAPCLIENT_OPTS
```puppet
class { 'snapcast::client':
  user_opts => '--user snapclient:audio',
  opts      => '--player pulse',
}
```

## Limitations

This module has only been tested on Debian operating systems.

[1]: https://mjaggard.github.io/snapcast
