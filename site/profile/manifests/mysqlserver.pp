class profile::mysqlserver ( $rootpassword ) {

  class { '::mysql::server':
    root_password           => $profile::mysqlserver::rootpassword,
    remove_default_accounts => true,
  }

}
