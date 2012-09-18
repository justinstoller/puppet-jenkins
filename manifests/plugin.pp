define jenkins::plugin($version=0) {
  $plugin     = "${jenkins::plugin::title}.hpi"
  $plugin_dir = '/var/lib/jenkins/plugins'

  if ($version != 0) {
    $base_url =
      'http://updates.jenkins-ci.org/download/plugins/' +
      "${jenkins::plugin::title}/${version}/"
  } else {
    $base_url   = 'http://updates.jenkins-ci.org/latest/'
  }

  exec {
    "download-${jenkins::plugin::title}" :
      command  => "wget --no-check-certificate ${base_url}${plugin}",
      cwd      => $plugin_dir,
      require  => File[$plugin_dir],
      path     => [ '/usr/bin', '/usr/sbin' ],
      user     => 'jenkins',
      unless   => "test -f ${plugin_dir}/${plugin}",
      notify   => Class['jenkins::service'],
  }


  file {
    "${plugin_dir}/${plugin}" :
      ensure  => 'present',
      owner   => 'jenkins',
      require => Exec["download-${name}"],
      mode    => '0644',
  }

  file {
    "${plugin_dir}/${jenkins::plugin::title}" :
      ensure  => 'directory',
      owner   => 'jenkins',
      require => Class['jenkins::service'],
      mode    => '0755',
  }
}

