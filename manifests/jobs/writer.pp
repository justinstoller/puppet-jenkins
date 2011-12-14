define jenkins::jobs::writer {
  file {
    "/var/lib/jenkins/jobs/${title}/config.xml":
      ensure => present,
      source => "/var/lib/jenkins/puppet/${title}/compiled.xml",
      owner => "jenkins",
      group => "jenkins",
      notify => Class["jenkins::service"],
  }
}
