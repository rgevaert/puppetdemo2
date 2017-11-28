class role::ldap_server {

  notice('role::dap_server')

  include ::profile::baseline

#  include ::profile::openldap
#  include ::profile::bind
#  include ::profile::proxy
}
