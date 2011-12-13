define jenkins::jobs::setup($job_type = "matrix-project") {

  file {
    "/var/lib/jenkins/puppet/${title}":
      require => File["/var/lib/jenkins/puppet"],
      ensure => directory,
  }

  file {
    "/var/lib/jenkins/puppet/${title}/default.yml":
      require => File["/var/lib/jenkins/puppet/$title"],
      content => "
        actions:
        description:
        keepDependencies:
        properties:
        scm:
          parent_class: 'hudson.scm.NullSCM'
        canRoam: true
        disabled: false
        blockBuildWhenDownstreamBuilding: false
        blockBuildWhenUpstreamBuilding: false
        triggers:
          parent_class: 'vector'
        concurrentBuild: false
        axes:
          hudson.matrix.LabelAxis:
            name:
            values:
        builders:
        publishers:
        buildWrappers: ",
  }

  file {
    "/var/lib/jenkins/jobs/${title}":
      ensure => directory,
  }

  file {
    "/var/lib/jenkins/puppet/${title}/compiled.xml":
      ensure => present,
      content => template("jenkins/xml_builder"),
  }

  file {
    "/var/lib/jenkins/jobs/${title}/config.xml":
      ensure => present,
      source => "/var/lib/jenkins/puppet/${title}/compiled.xml",
      owner => "jenkins",
      group => "jenkins",
  }

#  exec {
#    "compile_$title":
#      subscribe => File["/var/lib/jenkins/puppet/${title}"],
#      require => File["/var/lib/jenkins/puppet/${title}"],
#      cmd => "/opt/puppet/bin/ruby /etc/puppetlabs/puppet/modules/jenkins/files/
#  }
}
