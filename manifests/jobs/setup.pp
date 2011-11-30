define jenkins::jobs::setup() {

  file {
    "/var/lib/jenkins/puppet/${title}":
      require => Jenkins::Package["present"],
      ensure => directory,
  }

  file {
    "/var/lib/jenkins/jobs/${title}":
      ensure => directory,
      require => Jenkins::Package["present"],
      owner => "jenkins",
  }
}
