class jenkins::service {
  service {
    'jenkins':
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => Jenkins::Package['present'],
      subscribe => File["/var/lib/jenkins/plugins"],
  }
}
