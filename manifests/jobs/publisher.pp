define jenkins::jobs::publisher (
  $job_name = $title,
  $recipients,
  $not_every_unstable = false,
  $individuals = false
) {
  
  file {
    "/var/lib/jenkins/puppet/${job_name}/publisher.yml":
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
        publishers:
          hudson.tasks.Mailer:
            recipients: '${recipients}'
            dontNotifyEveryUnstableBuild: $not_every_unstable
            sendToIndividuals: $individuals
        buildWrappers: "
  }
}
