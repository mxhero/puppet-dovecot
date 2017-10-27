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
    $disable_plaintext_auth     = true,
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
    $mail_home                  = undef,
    $mail_fsync                 = undef,
    $mail_location              = undef,
    $mail_uid                   = undef,
    $mail_gid                   = undef,
    $mail_nfs_index             = undef,
    $mail_nfs_storage           = undef,
    $mail_privileged_group      = undef,
    $mail_plugins               = undef,
    $mmap_disable               = undef,
    $dotlock_use_excl           = undef,
    $include_inbox_namespace    = undef,
    # 10-master.conf
    $default_process_limit      = undef,
    $default_client_limit       = undef,
    $auth_listener_userdb_mode   = undef,
    $auth_listener_userdb_user   = undef,
    $auth_listener_userdb_group  = undef,
    $auth_listener_postfix       = false,
    $auth_listener_postfix_mode  = undef,
    $auth_listener_postfix_user  = undef,
    $auth_listener_postfix_group = undef,
    $imap_login_process_limit   = undef,
    $imap_login_client_limit    = undef,
    $imap_login_service_count   = undef,
    $imap_login_process_min_avail = undef,
    $imap_login_vsz_limit       = undef,
    $pop3_login_service_count   = undef,
    $pop3_login_process_min_avail = undef,
    $default_vsz_limit          = undef,
    $auth_listener_default_user = undef,
    $imaplogin_imap_port         = 143,
    $imaplogin_imaps_port        = 993,
    $imaplogin_imaps_ssl         = false,
    $lmtp_unix_listener          = undef,
    $lmtp_unix_listener_mode     = undef,
    $lmtp_unix_listener_user     = undef,
    $lmtp_unix_listener_group    = undef,
    $lmtp_socket_group          = undef,
    $lmtp_socket_mode           = undef,
    $lmtp_socket_path           = undef,
    $lmtp_socket_user           = undef,
    # 10-ssl.conf
    $ssl                        = undef,
    $ssl_cert                   = '/etc/pki/dovecot/certs/dovecot.pem',
    $ssl_key                    = '/etc/pki/dovecot/private/dovecot.pem',
    $ssl_cipher_list            = undef,
    $ssl_protocols              = undef,
    $ssl_dh_parameters_length   = undef,
    # 15-lda.conf
    $postmaster_address         = undef,
    $hostname                   = undef,
    $lda_mail_plugins           = undef,
    $lda_mail_location          = undef,
    $lda_mailbox_autocreate     = undef,
    $lda_mailbox_autosubscribe  = undef,
    # 20-imap.conf
    $write_imap_conf            = true,
    $imap_listen_port            = '*:143',
    $imaps_listen_port           = '*:993',
    $imap_mail_plugins          = undef,
    $imap_client_workarounds    = undef,
    # 20-lmtp.conf
    $lmtp_mail_plugins          = undef,
    $lmtp_save_to_detail_mailbox = false,
    # 20-pop3.conf
    $pop3_mail_plugins          = undef,
    $pop3_uidl_format           = undef,
    $pop3_client_workarounds    = undef,
    # 20-managesieve.conf
    $manage_sieve               = undef,
    $managesieve_service         = false,
    $managesieve_service_count   = 0,
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
    $sieve_extensions            = undef,
    $recipient_delimiter         = undef,
    # 90-plugin.conf
    $fts                        = undef,
    # 90-quota.conf
    $quota                      = undef,
    $quota_warnings             = [],
    # auth-passwdfile.conf.ext
    $auth_passwdfile_passdb     = undef,
    $auth_passwdfile_userdb     = undef,
    # auth-sql.conf.ext
    $auth_sql_userdb_static     = undef,
    $auth_sql_path              = '/etc/dovecot/dovecot-sql.conf.ext',
    # auth-ldap.conf.ext
    $auth_ldap_userdb_static    = undef,
    $auth_master_separator      = '*',
    $mail_max_userip_connections = 512,
    $first_valid_uid             = false,
    $last_valid_uid              = false,

    $manage_service              = true,
    $custom_packages             = undef,
    $ensure_packages             = 'installed',

    $ldap_uris                   = undef,
    $quota_enabled               = false,
    $acl_enabled                 = false,
    $replication_enabled         = false,
    $shared_mailboxes            = false,
    $options_plugins             = {},
) {

    validate_array($plugins)
    # dovecot.conf
    validate_string($protocols)
    validate_string($listen)
    validate_string($login_greeting)
    validate_string($login_trusted_networks)


    # 10-auth.conf
    validate_bool($disable_plaintext_auth)
    validate_string($auth_username_chars)
    validate_string($auth_mechanisms)
    validate_array($auth_include)
    # 10-mail.conf
    validate_string($mail_home)
    validate_string($mail_location)
    validate_string($mail_uid)
    validate_string($mail_gid)
    validate_string($mail_plugins)
    # 10-master.conf
    validate_string($default_process_limit)
    validate_string($default_client_limit)
    validate_string($auth_master_separator)
    validate_string($auth_listener_userdb_mode)
    validate_string($auth_listener_userdb_user)
    validate_string($auth_listener_userdb_group)
    validate_bool($auth_listener_postfix)
    validate_string($auth_listener_postfix_mode)
    validate_string($auth_listener_postfix_user)
    validate_string($auth_listener_postfix_group)
    validate_integer($imaplogin_imap_port)
    validate_integer($imaplogin_imaps_port)
    validate_bool($imaplogin_imaps_ssl)
    validate_string($lmtp_unix_listener)
    validate_string($lmtp_unix_listener_mode)
    validate_string($lmtp_unix_listener_user)
    validate_string($lmtp_unix_listener_group)
    # 10-ssl.conf
    validate_string($ssl)
    validate_string($ssl_cert)
    validate_string($ssl_key)
    validate_string($ssl_key)
    # 15-lda.conf
    validate_string($postmaster_address)
    validate_string($hostname)
    validate_string($lda_mail_plugins)
    validate_string($imap_mail_plugins)
    # 20-imap.conf
    validate_bool($write_imap_conf)
    # 20-lmtp.conf
    validate_bool($lmtp_save_to_detail_mailbox)
    validate_string($lmtp_mail_plugins)
    # 20-managesieve.conf
    validate_bool($managesieve_service)
    validate_integer($managesieve_service_count)
    # 90-sieve.conf
    validate_string($sieve)
    validate_string($sieve_dir)
    validate_string($sieve_extensions)
    validate_string($recipient_delimiter)
    #Plugins
    validate_string($ldap_uris)

    validate_bool($quota_enabled)
    validate_bool($acl_enabled)
    validate_bool($shared_mailboxes)
    validate_bool($replication_enabled)

    validate_hash($options_plugins)
    if($replication_enabled) {
        validate_hash($options_plugins[replication])
        validate_string($options_plugins[replication][mail_replica])
        validate_string($options_plugins[replication][dsync_remote_cmd])
        validate_string($options_plugins[replication][replication_full_sync_interval])
        validate_string($options_plugins[replication][replication_dsync_parameters])
    }

    if $custom_packages == undef {
      case $::operatingsystem {
        'RedHat', 'CentOS': {
            $packages = ['dovecot','dovecot-pigeonhole']
        }
        /^(Debian|Ubuntu)$/:{
            $packages = ['dovecot-common','dovecot-imapd', 'dovecot-pop3d', 'dovecot-managesieved', 'dovecot-mysql', 'dovecot-ldap', 'dovecot-lmtpd']
        }
        'FreeBSD' : {
          $packages  = 'mail/dovecot2'
        }
        default: { fail("OS $::operatingsystem and version $::operatingsystemrelease is not supported.")
        }
      }
    } else {
      $packages = $custom_packages
    }

    case $::operatingsystem {
    'RedHat', 'CentOS': { 
        $directory = '/etc/dovecot'
        $prefix    = 'dovecot'
    } 
    /^(Debian|Ubuntu)$/:{
        $directory = '/etc/dovecot'
        $prefix    = 'dovecot'
    }
    'FreeBSD': {
        $directory = '/usr/local/etc/dovecot'
        $prefix    = 'mail/dovecot2'
    }
    default: { fail("OS $::operatingsystem and version $::operatingsystemrelease is not supported") }
    }

    # All files in this scope are dovecot configuration files
    if $manage_service {
      File {
        notify  => Service['dovecot'],
        require => Package[$packages],
      }
    }
    else {
      File {
        require => Package[$packages],
      }
    }

    # Install plugins (sub-packages)
    dovecot::plugin { $plugins: before => Package[$packages], prefix => $prefix }

    # Main package and service it provides
    package { $packages: ensure => $ensure_packages }
    if $manage_service {
      service { 'dovecot':
        enable    => true,
        ensure    => running,
        hasstatus => true,
        require   => File["${directory}/dovecot.conf"],
      }
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
    file { "${directory}/conf.d/10-director.conf":
        content => template('dovecot/conf.d/10-director.conf.erb'),
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
    file { "${directory}/conf.d/15-lda.conf":
        content => template('dovecot/conf.d/15-lda.conf.erb'),
    }
    file { "${directory}/conf.d/15-mailboxes.conf":
        content => template('dovecot/conf.d/15-mailboxes.conf.erb'),
    }
    if $write_imap_conf {
      file { "${directory}/conf.d/20-imap.conf":
          content => template('dovecot/conf.d/20-imap.conf.erb'),
      }
    } else {
      file { "${directory}/conf.d/20-imap.conf":
        ensure => absent,
      }
    }
    file { "${directory}/conf.d/20-lmtp.conf":
        content => template('dovecot/conf.d/20-lmtp.conf.erb'),
    }
    file { "${directory}/conf.d/20-managesieve.conf":
        content => template('dovecot/conf.d/20-managesieve.conf.erb'),
    }
    file { "${directory}/conf.d/20-pop3.conf":
        content => template('dovecot/conf.d/20-pop3.conf.erb'),
    }
    
    if $manage_sieve {
      file { "${directory}/conf.d/20-managesieve.conf":
          content => template('dovecot/conf.d/20-managesieve.conf.erb'),
      }
    }
    
    file { "${directory}/conf.d/90-sieve.conf":
        content => template('dovecot/conf.d/90-sieve.conf.erb'),
    }
    file { "${directory}/conf.d/90-quota.conf":
        content => template('dovecot/conf.d/90-quota.conf.erb'),
    }
    file { "${directory}/conf.d/90-plugin.conf":
        content => template('dovecot/conf.d/90-plugin.conf.erb'),
    }

    if($replication_enabled) {
      file { "${directory}/conf.d/99-replicator.conf":
          content => template('dovecot/conf.d/99-replicator.conf.erb'),
      }
    } else {
      file { "${directory}/conf.d/99-replicator.conf":
          ensure => absent
      }
    }

    file { "${directory}/conf.d/auth-passwdfile.conf.ext" :
        content => template('dovecot/conf.d/auth-passwdfile.conf.ext.erb'),
    }
    file { "${directory}/conf.d/auth-sql.conf.ext" :
        content => template('dovecot/conf.d/auth-sql.conf.ext.erb'),
    }
    file { '/etc/dovecot/conf.d/auth-ldap.conf.ext':
        content => template('dovecot/conf.d/auth-ldap.conf.ext.erb'),
    }
}

