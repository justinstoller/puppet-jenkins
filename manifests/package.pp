define jenkins::package() {
  package {
    "jenkins" :
      ensure => $title;
  }

  file {
    "/var/lib/jenkins/plugins" :
      owner  => "jenkins",
      ensure => directory,
      require => Package["jenkins"],
      notify => Class["jenkins::service"],
      purge => true,
      force => true,
      backup => false,
      recurse => true,
  }
}

