define jenkins::jobs::writer ($job_type = "matrix-project") {

  file {
    "/var/lib/jenkins/puppet/${title}/compiled.xml":
      ensure => present,
      content => template("jenkins/xml_builder"),
      subscribe => File["/var/lib/jenkins/puppet/${title}"]
  }
}
