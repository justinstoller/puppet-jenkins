class jenkins::job::puppet {
  $job_name = "Puppet (master)"

  jenkins::jobs::setup {
    $job_name:
      type => "matrix-project",
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
}
