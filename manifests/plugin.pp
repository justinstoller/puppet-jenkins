define jenkins::plugin($name, $version=0, $ensure=present) {
  $plugin     = "${name}.hpi"
  $plugin_dir = "/var/lib/jenkins/plugins"

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = "http://updates.jenkins-ci.org/latest/"
  }

  if (!defined(File["${plugin_dir}"])) {
    file {
      "${plugin_dir}" :
        owner  => "jenkins",
        ensure => directory,
    }
  }

  if (!defined(User["jenkins"])) {
    user {
      "jenkins" :
        ensure => present;
    }
  }

  exec {
    "download-${name}" :
      command  => "wget --no-check-certificate ${base_url}${plugin}",
      cwd      => "${plugin_dir}",
      require  => File["${plugin_dir}"],
      path     => ["/usr/bin", "/usr/sbin",],
      user     => "jenkins",
      creates   => "${plugin_dir}/${plugin}",
      onlyif => $ensure ? {
        present => 'test -n "1"',
        absent => 'test -n ""',
      },
  }

  file { 
    "${plugin_dir}/${plugin}":
      owner => 'jenkins',
      ensure => $ensure,
      require => Exec["download-${name}"],
      mode => '640',
      notify => Service['jenkins'],
  }
}

