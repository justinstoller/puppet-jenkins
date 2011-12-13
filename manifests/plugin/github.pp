define jenkins::plugin::github (
  $job_name = $title,
  $url
) {
  
  file {
    "/var/lib/jenkins/puppet/${job_name}/github.yml":
      require => Jenkins::Jobs::Setup["${job_name}"],
      content => "
        actions:
        description:
        keepDependencies:
        properties:
          com.coravy.hudson.plugins.github.GithubProjectProperty
            projectUrl: ${url}
        scm:
          parent_class: 'hudson.plugins.git.GitSCM'
        canRoam: true
        disabled: false
        blockBuildWhenDownstreamBuilding: false
        blockBuildWhenUpstreamBuilding: false
        triggers:
          parent_class: 'vector'
          com.cloudbees.jenkins.GitHubPushTrigger:
            spec:
        concurrentBuild: false
        axes:
        builders:
        publishers:
        buildWrappers: "
  }
}
