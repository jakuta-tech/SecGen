class gitlist_040::configure {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $leaked_files_path = '/home/git/repositories/secret_files'

  $images_to_leak = $secgen_parameters['images_to_leak']

  $strings_to_leak = $secgen_parameters['strings_to_leak']
  $leaked_filenames = $secgen_parameters['leaked_filenames']
  $strings_to_pre_leak = $secgen_parameters['strings_to_pre_leak']
  $pre_leaked_filenames = $secgen_parameters['pre_leaked_filenames']

  # when there are multiple strings to leak:
  #   leak the first one as a flag, requiring exploitation to access;
  #   leak the subsequent ones publically through the website;

  if $strings_to_leak.length == 0 {
    warning('No strings_to_leak provided!')
  }

  $git_args = '-c user.name="gitlist" -c user.email="git@list.com"'

  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  # Create /home/git/repositories
  file { ['/home/git', '/home/git/repositories']:
    ensure => directory,
    owner  => 'www-data',
  } ->

  file { $leaked_files_path:
    ensure => directory,
    owner => 'www-data',
    mode => '0700'
  } ->

  exec { 'create-repo-file_leak':
    cwd     => $leaked_files_path,
    command => "sudo -u www-data git init",
  } ->

  file { "$leaked_files_path/.git/description":
    content => "secret_files",
    owner => 'www-data'
  }

  ::secgen_functions::leak_files { 'gitlist_040-flag-leak':
    storage_directory => '/home/git',
    leaked_filenames  => $leaked_filenames,
    strings_to_leak   => $strings_to_leak,
    owner             => 'www-data',
    mode              => '0750',
    leaked_from       => 'gitlist_040',
    before            => Exec['initial_commit_leaked_files_repo']
  }

  ::secgen_functions::leak_files { 'gitlist_040-file-leak':
    storage_directory => $leaked_files_path,
    leaked_filenames  => $pre_leaked_filenames,
    strings_to_leak   => $strings_to_pre_leak,
    images_to_leak    => $images_to_leak,
    owner             => 'www-data',
    mode              => '0750',
    leaked_from       => 'gitlist_040',
    before            => Exec['initial_commit_leaked_files_repo']
  }

  exec { 'initial_commit_leaked_files_repo':
    cwd     => $leaked_files_path,
    command => "sudo -u www-data git $git_args add *; sudo -u www-data git $git_args commit -a -m 'initial commit'",
  }
}
