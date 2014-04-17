# Class: dovecot
#
# Install, enable and configure the Dovecot IMAP server.
# Options:
#  $plugins:
#    Array of plugin sub-packages to install. Default: empty
#
class dovecot (
    $plugins                    = [],
    # dovecot.conf
    $protocols                  = undef,
    $listen                     = undef,
    $login_greeting             = undef,
    $login_trusted_networks     = undef,
    $verbose_proctitle          = undef,
    $shutdown_clients           = undef,
    # 10-auth.conf
    $disable_plaintext_auth     = undef,
    $auth_username_chars        = undef,
    $auth_mechanisms            = 'plain',
    $auth_include               = [ 'system' ],
    # 10-logging.conf
    $log_path                   = undef,
    $log_timestamp              = undef,
    $auth_verbose               = undef,
    $auth_debug                 = undef,
    $mail_debug                 = undef,
    # 10-mail.conf
    $mail_fsync                 = undef,
    $mail_location              = undef,
    $mail_nfs_index             = undef,
    $mail_nfs_storage           = undef,
    $mail_privileged_group      = undef,
    $mail_plugins               = undef,
    $mmap_disable               = undef,
    $dotlock_use_excl           = undef, 
    # 10-master.conf
    $default_process_limit      = undef,
    $default_client_limit       = undef,
    $imap_login_process_limit   = undef,
    $imap_login_client_limit    = undef,
    $imap_login_service_count   = undef,
    $imap_login_process_min_avail = undef,
    $imap_login_vsz_limit       = undef,
    $pop3_login_service_count   = undef,
    $pop3_login_process_min_avail = undef,
    $auth_listener_userdb_mode  = undef,
    $auth_listener_userdb_user  = undef,
    $auth_listener_userdb_group = undef,
    $auth_listener_postfix      = false,
    $auth_listener_postfix_mode = '0666',
    $auth_listener_postfix_user = undef,
    $auth_listener_postfix_group = undef,
    $auth_listener_default_user = undef,
    $lmtp_socket_group          = undef,
    $lmtp_socket_mode           = undef,
    $lmtp_socket_path           = undef,
    $lmtp_socket_user           = undef,
    # 10-ssl.conf
    $ssl                        = undef,
    $ssl_cert                   = '/etc/pki/dovecot/certs/dovecot.pem',
    $ssl_key                    = '/etc/pki/dovecot/private/dovecot.pem',
    $ssl_cipher_list            = undef,
    # 15-lda.conf
    $postmaster_address         = undef,
    $hostname                   = undef,
    $lda_mail_plugins           = undef,
    $lda_mail_location          = undef,
    $lda_mailbox_autocreate     = undef,
    $lda_mailbox_autosubscribe  = undef,
    # 20-imap.conf
    $imap_mail_plugins          = undef,
    $imap_client_workarounds    = undef,
    # 20-lmtp.conf
    $lmtp_mail_plugins          = undef,
    $lmtp_save_to_detail_mailbox = undef,
    # 20-pop3.conf
    $pop3_mail_plugins          = undef,
    $pop3_uidl_format           = undef,
    $pop3_client_workarounds    = undef,
    # 90-sieve.conf
    $sieve                      = '~/.dovecot.sieve',
    $sieve_after                = undef,
    $sieve_before               = undef,
    $sieve_dir                  = '~/sieve',
    $sieve_max_actions          = undef,
    $sieve_max_redirects        = undef,
    $sieve_max_script_size      = undef,
    $sieve_quota_max_scripts    = undef,
    $sieve_quota_max_storage    = undef,
    # 90-quota.conf
    $quota                      = undef,
    $quota_warnings             = [],
    # auth-passwdfile.conf.ext
    $auth_passwdfile_passdb     = undef,
    $auth_passwdfile_userdb     = undef,
    # auth-sql.conf.ext
    $auth_sql_userdb_static     = undef,
    $auth_sql_path              = '/etc/dovecot/dovecot-sql.conf.ext',
    $auth_master_separator      = '*',
    $mail_max_userip_connections = 512,
    $first_valid_uid             = false,
    $last_valid_uid              = false

) {

    case $::operatingsystem {
    'RedHat', 'CentOS': { 
        $directory = '/etc/dovecot'
        $packages  = 'dovecot'
        $prefix    = 'dovecot'
    } 
    /^(Debian|Ubuntu)$/:{
        $directory = '/etc/dovecot'
        $packages = ['dovecot-common','dovecot-imapd', 'dovecot-pop3d', 'dovecot-mysql', 'dovecot-lmtpd']
        $prefix    = 'dovecot'
    }
    'FreeBSD': {
        $directory = '/usr/local/etc/dovecot'
        $packages  = 'mail/dovecot2'
        $prefix    = 'mail/dovecot2'
    }
    default: { fail("OS $::operatingsystem and version $::operatingsystemrelease is not supported") }
    }

    # All files in this scope are dovecot configuration files
    File {
        notify  => Service['dovecot'],
        require => Package[$packages],
    }

    # Install plugins (sub-packages)
    dovecot::plugin { $plugins: before => Package[$packages], prefix => $prefix }

    # Main package and service it provides
    package { $packages: ensure => installed }
    service { 'dovecot':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => File["${directory}/dovecot.conf"],
    }

    # Main configuration directory
    file { "${directory}":
        ensure => 'directory',
    }
    file { "${directory}/conf.d":
        ensure => 'directory',
    }

    # Main configuration file
    file { "${directory}/dovecot.conf":
        content => template('dovecot/dovecot.conf.erb'),
    }

    # Configuration file snippets which we modify
    file { "${directory}/conf.d/10-auth.conf":
        content => template('dovecot/conf.d/10-auth.conf.erb'),
    }
    file { "${directory}/conf.d/10-logging.conf":
        content => template('dovecot/conf.d/10-logging.conf.erb'),
    }
    file { "${directory}/conf.d/10-mail.conf":
        content => template('dovecot/conf.d/10-mail.conf.erb'),
    }
    file { "${directory}/conf.d/10-master.conf":
        content => template('dovecot/conf.d/10-master.conf.erb'),
    }
    file { "${directory}/conf.d/10-ssl.conf":
        content => template('dovecot/conf.d/10-ssl.conf.erb'),
    }
    file { "${directory}/conf.d/20-imap.conf":
        content => template('dovecot/conf.d/20-imap.conf.erb'),
    }
    file { "${directory}/conf.d/20-pop3.conf":
        content => template('dovecot/conf.d/20-pop3.conf.erb'),
    }
    file { "${directory}/conf.d/15-lda.conf":
        content => template('dovecot/conf.d/15-lda.conf.erb'),
    }
    file { "${directory}/conf.d/90-sieve.conf":
        content => template('dovecot/conf.d/90-sieve.conf.erb'),
    }
    file { "${directory}/conf.d/90-quota.conf":
        content => template('dovecot/conf.d/90-quota.conf.erb'),
    }
    file { "${directory}/conf.d/auth-passwdfile.conf.ext" :
        content => template('dovecot/conf.d/auth-passwdfile.conf.ext.erb'),
    }
    file { "${directory}/conf.d/auth-sql.conf.ext" :
        content => template('dovecot/conf.d/auth-sql.conf.ext.erb'),
    }

}

