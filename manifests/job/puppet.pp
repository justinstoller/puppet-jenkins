class jenkins::job::puppet {
  $job_name = "Puppet (master)"

  jenkins::jobs::setup {
    $job_name:
      job_type => "matrix-project",
  }

  jenkins::jobs::build_step {
    $job_name:
      action => "rake unit",
      type => sh,
  }

  jenkins::jobs::publisher {
    $job_name:
      recipients => 'justin@puppetlabs.com',
  }
 
  jenkins::jobs::writer { $job_name: }
}
