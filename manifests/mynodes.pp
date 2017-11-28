node 'stretch' {
  include ::role::ldap_server
}

node 'stretch_old'{


  include ::ssh::server

  $p = ['openssh-server','vim', 'mailutils']
  ensure_packages($p)

  package { 'nano':
    ensure => present,
  }

  $p2 = [ 'ed']

  package { $p2:
    ensure => present,
  }


  class { 'apt':
    update => {
      'frequency' => 'always',
    },
    purge  => {
      'sources.list'   => true,
      'sources.list.d' => true,
      'preferences'    => true,
      'preferences.d'  => true,
    },
  }

  apt::source { 'puppetlabs':
    location => 'http://apt.puppetlabs.com',
    repos    => 'puppet5',
    key      => {
      'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
      'server' => 'pgp.mit.edu',
    },
  }

  if($facts[operatingsystem] == 'Debian') {
    apt::source { 'debian':
      ensure   => 'present',
      location => 'http://ftp.be.debian.org/debian',
      repos    => 'main non-free contrib',
    }
  }

  if($facts[operatingsystem] == 'Ubuntu') {
    apt::source { 'ubuntu':
      ensure   => 'present',
      location => 'http://be.archive.ubuntu.com/ubuntu/',
      repos    => 'main restricted universe multiverse ',
    }
  }

  class { '::postfix':
    config_file_template => "postfix/${::operatingsystem}/etc/postfix/main.cf.erb",
    relayhost            => 'smtp.ugent.be',
    recipient            => 'rudy.gevaert@ugent.be',
  }

  class { '::icinga2':
    confd     => false,
    features  => ['checker','mainlog'],
  }

#  class { '::icinga2::feature::api':
#    pki             => 'none',
#    accept_config   => true,
#    accept_commands => true,
#    endpoints       => {
#      'NodeName'              => {},
#      'satellite.example.org' => {
#        'host' => '172.16.2.11',
#      }
#    },
#    zones           => {
#      'ZoneName' => {
#        'endpoints' => ['NodeName'],
#        'parent'    => 'master',
#      },
#      'master'      => {
#        'endpoints' => ['icinga2.myhost.com'],
#      }
#    }
#  }
#
#  icinga2::object::zone { 'global-templates':
#    global => true,
#  }

}

node 'dns1' {
}

node 'www1' {
}

node /^proxy[1-9]/ {
  include baseline
}
