define jenkins::jobs::build_step (
  $job_name = $title,
  $step = "01",
  $action,
  $type = "Shell"
) {

  case $type {
    Shell,shell,Sh,sh: { $build_type = "Shell" }
  }

  file {
    "/var/lib/jenkins/puppet/$job_name/${step}_build_step.yml":
      require => Jenkins::Jobs::Setup["${job_name}"],
      notify => Jenkins::Jobs::Writer["${job_name}"],
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
          hudson.tasks.${build_type}:
            command: '${action}'
        publishers:
        buildWrappers: ",
  }
}
