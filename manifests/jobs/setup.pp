define jenkins::jobs::setup($job_type = "matrix-project") {

  file {
    "/var/lib/jenkins/puppet/${title}":
      require => File["/var/lib/jenkins/puppet"],
      ensure => directory,
  }

  file {
    "/var/lib/jenkins/puppet/${title}/default.yml":
      require => File["/var/lib/jenkins/puppet/${title}"],
      notify => Jenkins::Jobs::Writer["${title}"],
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
      notify => Jenkins::Jobs::Writer["${title}"],
      subscribe => File["/var/lib/jenkins/puppet/${title}"],
  }
}
