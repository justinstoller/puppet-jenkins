define jenkins::jobs::writer ($job_type = "matrix-project") {

  file {
    "/var/lib/jenkins/jobs/${title}/config.xml":
      ensure => present,
      source => "/var/lib/jenkins/puppet/${title}/compiled.xml",
      owner => "jenkins",
      group => "nogroup",
      notify => Class["jenkins::service"],
      require => [ Jenkins::Jobs::Setup["${title}"], File["/var/lib/jenkins/puppet/${title}/compiled.xml"] ]
  }

  file {
    "/var/lib/jenkins/puppet/${title}/compiled.xml":
      ensure => present,
      notify => File["/var/lib/jenkins/jobs/${title}/config.xml"],
      require => Jenkins::Jobs::Setup["${title}"],
      subscribe => File["/var/lib/jenkins/puppet/${title}"],
  }

  exec {
    "write_${title}":
      command => "/var/lib/jenkins/puppet/xml_builder '/var/lib/jenkins/puppet/${title}/config.xml' '${title}' ${job_type}",
      refreshonly => true,
      require => Jenkins::Jobs::Setup["${title}"],
      subscribe => File["/var/lib/jenkins/puppet/${title}"],
      notify => File["/var/lib/jenkins/jobs/${title}/config.xml"],
  }   
}
