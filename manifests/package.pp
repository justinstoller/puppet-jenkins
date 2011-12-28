define jenkins::package() {

  $status = $jenkins::package::title ? {
    'present' => 'directory',
    'purged'  => 'absent',
  }

  package {
    'jenkins' :
      ensure => $jenkins::package::title;
  }

  user {
    'jenkins' :
      ensure  => 'present',
      require => Package['jenkins'],
  }

  group {
    'nogroup':
      ensure => 'present',
  }

  file {
    '/var/lib/jenkins/puppet/xml_builder':
      source  => 'puppet:///modules/jenkins/xml_builder',
      require => File['/var/lib/jenkins/puppet'],
  }

  file {
    '/var/lib/jenkins/plugins' :
      ensure  => $status,
      owner   => 'jenkins',
      group   => 'nogroup',
      require => [ Package['jenkins'], User['jenkins'] ],
      purge   => 'true',
      force   => 'true',
      backup  => 'false',
      recurse => 'true',
  }

  file {
    '/var/lib/jenkins/puppet':
      ensure  => $status,
      require => Package['jenkins'],
  }
}

