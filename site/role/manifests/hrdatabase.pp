class role::hrdatabase {

  include ::profile::baseline

  class { '::profile::mysqlserver':
    rootpassword => '123',
  }

}
