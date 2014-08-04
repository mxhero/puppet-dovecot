# Define: dovecot::sql
#
define dovecot::sql (
  $db_driver   = 'mysql',
  $db_host     = 'localhost',
  $db_name     = 'dovecot',
  $db_pass     = 'dovecot',
  $db_table    = 'users',
  $db_user     = 'dovecot',
  $pass_scheme = 'MD5',
) {
  dovecot::file { 'dovecot-sql.conf.ext':
    content => template('dovecot/dovecot-sql.conf.ext.erb'),
  }
}

