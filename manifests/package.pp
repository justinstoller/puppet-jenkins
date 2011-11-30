class jenkins::package {
  package {
    "jenkins" :
      ensure => installed;
  }

  service {
    'jenkins':
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => Package['jenkins'],
  }
}

