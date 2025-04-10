class wordpress_2x {
  $secgen_parameters = ::secgen_functions::get_parameters($::base64_inputs_file)
  $version = $secgen_parameters['version'][0]
  $blog_title = $secgen_parameters['blog_title'][0]
  $admin_email = $secgen_parameters['admin_email'][0]
  $admin_password = $secgen_parameters['admin_password'][0]
  $username = $secgen_parameters['username'][0]
  $ip_address = $secgen_parameters['IP_address'][0]
  $port = $secgen_parameters['port'][0]
  $https = str2bool($secgen_parameters['https'][0])

  class { '::mysql::server': }
  class { '::mysql::bindings': php_enable => true, }

  class { '::apache':
    default_vhost => false,
    overwrite_ports => false,
  }
  class {'::apache::mod::rewrite': }

  if $https {
    ::apache::vhost { 'wordpress':
      docroot => '/var/www/wordpress',
      port    => '80',
      redirect_status => 'permanent',
      redirect_dest   => "https://$ip_address/"
    }

    ::apache::vhost { 'wordpress-ssl':
      docroot => '/var/www/wordpress',
      port    => '443',
      ssl     => true,
    }
  } else {
    ::apache::vhost { 'wordpress':
      docroot => '/var/www/wordpress',
      port    => $port,
    }
  }

  case $operatingsystemrelease {
    /^(9|1[0-9]).*/: { # do 9.x stretch stuff
      exec { 'a2enmod php5.6':
        command => '/usr/sbin/a2enmod php5.6',
        require => Class['::apache']
      }
    }
    /^7.*/: { #do 7.x wheezy stuff
      exec { 'a2enmod php5':
        command => '/usr/sbin/a2enmod php5',
        require => Class['::apache']
      }
    }
  }

  class { '::wordpress':
    install_dir => '/var/www/wordpress',
    version => $version,
  } ~>
  file { '/wordpress_conf.sh':
    owner   => 'root',
    group   => 'root',
    ensure  => present,
    mode    => '0755',
    content => template('wordpress/wordpress_conf.sh.erb'),
  }
  ~>
  cron { 'run wordpress config script':
    command => '/bin/bash /wordpress_conf.sh',
    minute => [0, 5,10,15,20,25,30,35,40,45,50,55]
  }

  ensure_resource('tidy','wp remove default site', {'path'=>'/etc/apache2/sites-enabled/000-default.conf'})
}
