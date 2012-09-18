define jenkins::jobs::writer ($job_type = 'matrix-project') {

  file {
    "/var/lib/jenkins/jobs/${jenkins::jobs::writer::title}/config.xml":
      ensure  => 'present',
      source  =>
        "/var/lib/jenkins/puppet/${jenkins::jobs::writer::title}/compiled.xml",
      owner   => 'jenkins',
      group   => 'nogroup',
      notify  => Class['jenkins::service'],
      require => [
        Jenkins::Jobs::Setup[$jenkins::jobs::writer::title],
        File["/var/lib/jenkins/puppet/${jenkins::jobs::writer::title}" +
          '/compiled.xml']
                 ],
  }

  file {
    "/var/lib/jenkins/puppet/${jenkins::jobs::writer::title}/compiled.xml":
      ensure    => 'present',
      notify    =>
        File["/var/lib/jenkins/jobs/${jenkins::jobs::writer::title}" +
          '/config.xml'],
      require   => Jenkins::Jobs::Setup[$jenkins::jobs::writer::title],
      subscribe => File['/var/lib/jenkins/puppet/' +
        $jenkins::jobs::writer::title],
  }

  exec {
    "write_${jenkins::jobs::writer::title}":
      command     => '/var/lib/jenkins/puppet/xml_builder ' +
        "'/var/lib/jenkins/puppet/${jenkins::jobs::writer::title}/config.xml'" +
        " '${jenkins::jobs::writer::title}' ${job_type}",
      refreshonly => 'true',
      require     => Jenkins::Jobs::Setup[$jenkins::jobs::writer::title],
      subscribe   =>
        File["/var/lib/jenkins/puppet/${jenkins::jobs::writer::title}"],
      notify      =>
        File["/var/lib/jenkins/jobs/${jenkins::jobs::writer::title}" +
          '/config.xml'],
  }
}
