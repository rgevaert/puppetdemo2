class role::webserver {
  include ::profile::baseline
  include ::profile::apache_server
  include ::profile::mysql_server
  include ::profile::php
}
