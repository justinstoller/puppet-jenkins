define jenkins::plugin($name, $version=0) {
  $plugin     = "${name}.hpi"
  $plugin_dir = "/var/lib/jenkins/plugins"

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = "http://updates.jenkins-ci.org/latest/"
  }

  user {
    "jenkins" :
      ensure => present,
  }

  exec {
    "download-${name}" :
      command  => "wget --no-check-certificate ${base_url}${plugin}",
      cwd      => "${plugin_dir}",
      require  => File["${plugin_dir}"],
      path     => ["/usr/bin", "/usr/sbin",],
      user     => "jenkins",
      unless   => "test -f ${plugin_dir}/${plugin}",
  }


  file {
    "${plugin_dir}/${plugin}" :
      owner => 'jenkins',
      ensure => present,
      require => Exec["download-${name}"],
      mode => '644',
      notify => Class['jenkins::service'],
  }

  file {
    "${plugin_dir}/${name}" :
      owner => 'jenkins',
      ensure => 'directory',
      require => Class['jenkins::service'],
      mode => 755,
  }
}

