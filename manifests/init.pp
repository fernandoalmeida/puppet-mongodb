# == Class: mongodb
#
# A Puppet module for installing and configuring MongoDB.
#
# === Examples
#
#  class { mongodb:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Fernando Almeida <fernando@fernandoalmeida.net>
# 
# === Copyright
# 
# Copyright 2013 Fernando Almeida, unless otherwise noted.
#
class mongodb {
  
  exec {"mongodb-apt-key":
    command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
    unless  => "apt-key list | grep 10gen",
  }
  
  file {'mongodb-10gen.list':
    ensure  => file,
    path    => '/etc/apt/sources.list.d/10gen.list',
    content => 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen',
    require => Exec['mongodb-apt-key'],
    notify  => Exec['mongodb-apt-get-update'],
  }
  
  exec {'mongodb-apt-get-update':
    command     => "apt-get update",
    refreshonly => true,
    require     => [ Exec['mongodb-apt-key'], File['mongodb-10gen.list'] ],
  }
  
  package {'mongodb-10gen':
    ensure  => installed,
    require => [ Exec['mongodb-apt-key'], File['mongodb-10gen.list'] ],
  }
  
  service {'mongodb':
    ensure  => running,
    pattern => 'mongod',
  }
  
}
