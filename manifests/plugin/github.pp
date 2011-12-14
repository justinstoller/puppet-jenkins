define jenkins::plugin::github (
  $job_name = $title,
  $url
) {
  
  file {
    "/var/lib/jenkins/puppet/${job_name}/github.yml":
      require => Jenkins::Jobs::Setup["${job_name}"],
      notify => Jenkins::Jobs::Writer["${job_name}"],
      content => "
        properties:
          com.coravy.hudson.plugins.github.GithubProjectProperty:
            projectUrl: ${url}
        triggers:
          parent_class: 'vector'
          com.cloudbees.jenkins.GitHubPushTrigger:
            spec: ",
  }
}
