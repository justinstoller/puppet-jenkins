define jenkins::jobs::setup($type = "matrix-project") {

  file {
    "/var/lib/jenkins/puppet/$title":
      require => File["/var/lib/jenkins/puppet"],
      ensure => directory,
  }

  file {
    "/var/lib/jenkins/puppet/${title}/default.yml":
      require => File["/var/lib/jenkins/puppet/$title"],
      content => "
${type}:
  - actions:
  - description:
  - keepDependencies:
  - properties:
  - scm:
    - parent_class: 'hudson.scm.NullSCM'
  - canRoam: true
  - disabled: false
  - blockBuildWhenDownstreamBuilding: false
  - blockBuildWhenUpstreamBuilding: false
  - triggers:
    - parent_class: 'vector'
  - concurrentBuild: false
  - axes:
    - hudson.matrix.LabelAxis:
      - name:
      - values:
  - builders:
  - publishers:
  - buildWrappers:
",
  }
}
