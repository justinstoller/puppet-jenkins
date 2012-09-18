define jenkins::jobs::setup() {

  file {
    "/var/lib/jenkins/puppet/${jenkins::jobs::setup::title}":
      ensure  => 'directory',
      require => Jenkins::Package['present'],
  }

  file {
    "/var/lib/jenkins/jobs/${jenkins::jobs::setup::title}":
      ensure  => 'directory',
      require => Jenkins::Package['present'],
      owner   => 'jenkins',
      group   => 'nogroup',
  }
}
