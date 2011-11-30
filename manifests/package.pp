define jenkins::package() {
  package {
    "jenkins" :
      ensure => $title;
  }

  user {
    "jenkins" :
      ensure => present,
      require => Package["jenkins"],
  }

  file {
    "/var/lib/jenkins/puppet/xml_builder":
      source => "puppet:///modules/jenkins/xml_builder",
      require => File["/var/lib/jenkins/puppet"],
  }

  file {
    "/var/lib/jenkins/plugins" :
      owner  => "jenkins",
      ensure => $title ? {
        "present" => "directory",
        "purged" => "absent",
      },
      require => [ Package["jenkins"], User["jenkins"] ],
      purge => true,
      force => true,
      backup => false,
      recurse => true,
  }

  file {
    "/var/lib/jenkins/puppet":
      ensure => $title ? {
        "present" => "directory",
        "purged" => "absent",
      },
      require => Package["jenkins"],
  }
}

