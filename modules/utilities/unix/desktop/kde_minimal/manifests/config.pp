class kde_minimal::config {
  $secgen_params = secgen_functions::get_parameters($::base64_inputs_file)
  $accounts = $secgen_params['accounts']
  $autologin_user = $secgen_params['autologin_user'][0]
  $autostart_konsole = str2bool($secgen_params['autostart_konsole'][0])

  # Create auto-resolution script
  file { '/opt/auto-resolution':
    ensure => directory,
  } ->
  file { '/opt/auto-resolution/auto-resolution.sh':
    ensure  => file,
    source  => 'puppet:///modules/kde_minimal/auto-resolution.sh',
    mode    => '0755',
  }

  case $operatingsystemrelease {
    /^12.*/: { # do 10.x buster|bookworm stuff
      if $autologin_user != "false" {
        file { "/etc/sddm.conf":
          ensure  => file,
          content => template('kde_minimal/bookworm-sddm.conf.erb'),
        }
      }
    }
    /^10.*/: { # do 10.x buster|bookworm stuff
      if $autologin_user != "false" {
        file { "/etc/sddm.conf":
          ensure  => file,
          content => template('kde_minimal/minimal-sddm.conf.erb'),
        }
      }
    }
    /^9.*/: { # do 9.x stretch stuff
      if $autologin_user != "false" {
        file { "/etc/sddm.conf":
          ensure  => file,
          content => template('kde_minimal/sddm.conf.erb'),
        }
      }
    }
    /^7.*/: { #do 7.x wheezy stuff
      if $autologin_user != "false" {
        file { "/etc/kde4/kdm/kdmrc":
          ensure  => file,
          content => template('kde_minimal/kdmrc.erb'),
        }
      }
    }
  }

  unless $accounts == undef {
    $accounts.each |$raw_account| {
      $account = parsejson($raw_account)
      $username = $account['username']

      file { ["/home/$username/", "/home/$username/.config/", "/home/$username/.config/autostart/"]:
        ensure => directory,
        owner  => $username,
        group  => $username,
      } ~>
      # automatically refresh screen resolution everytime it changes
      file { "/home/$username/.config/autostart/auto-resolution.desktop":
        ensure => file,
        source => 'puppet:///modules/kde_minimal/auto-resolution.desktop',
        owner  => $username,
        group  => $username,
      }

      # autostart konsole
      if $autostart_konsole {
        file { "/home/$username/.config/autostart/org.kde.konsole.desktop":
          ensure => file,
          source => 'puppet:///modules/kde_minimal/org.kde.konsole.desktop',
          owner  => $username,
          group  => $username,
        }
      }
      if $operatingsystemrelease =~ /^12.*/ { # Disable window shadows, power management
        file { "/home/$username/.config/breezerc":
          ensure  => file,
          source  => 'puppet:///modules/kde_minimal/breezerc',
          owner   => $username,
          group   => $username,
          require => File["/home/$username/.config/"],
        }

        file { "/home/$username/.config/powermanagementprofilesrc":
          ensure  => file,
          source  => 'puppet:///modules/kde_minimal/powermanagementprofilesrc',
          owner   => $username,
          group   => $username,
          require => File["/home/$username/.config/"],
        }

      }
      if $operatingsystemrelease =~ /^(9|10).*/ { # Disable stretch auto screen lock (not needed for our new templates)
        file { "/home/$username/.config/kscreenlockerrc":
          ensure  => file,
          source  => 'puppet:///modules/kde_minimal/kscreenlockerrc',
          owner   => $username,
          group   => $username,
          require => File["/home/$username/.config/"],
        }
      }
    }
  }
}
