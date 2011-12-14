
define jenkins::plugin::git (
  $job_name = $title,
  $url,
  $branch = "master"
) {
  
  file {
    "/var/lib/jenkins/puppet/${job_name}/git.yml":
      require => Jenkins::Jobs::Setup["${job_name}"],
      notify => Jenkins::Jobs::Writer["${job_name}"],
      content => "
        actions:
        description:
        keepDependencies:
        properties:
        scm:
          parent_class: 'hudson.plugins.git.GitSCM'
          configVersion: '2'
          userRemoteConfigs:
            hudson.plugins.git.UserRemoteConfig:
              name:
              refspec:
              url: ${url}
          branches:
            hudson.plugins.git.BranchSpec:
              name: ${branch}
          disableSubmodules: false
          recursiveSubmodules: false
          doGenerateSubmoduleConfigurations: false
          authorOrCommitter: false
          clean: false
          wipeOutWorkspace: false
          pruneBranches: false
          remotePoll: false
          buildChooser:
            parent_class: 'hudson.plugins.git.util.DefaultBuildChooser'
          gitTool: Default
          submoduleCfg: 
            parent_class: 'list'
          relativeTargetDir:
          reference:
          excludedRegions:
          excludedUsers:
          gitConfigName:
          gitConfigEmail:
          skipTag: false
          scmName:
        canRoam: true
        disabled: false
        blockBuildWhenDownstreamBuilding: false
        blockBuildWhenUpstreamBuilding: false
        triggers:
          parent_class: 'vector'
        concurrentBuild: false
        axes:
        builders:
        publishers:
        buildWrappers: "
  }
}
