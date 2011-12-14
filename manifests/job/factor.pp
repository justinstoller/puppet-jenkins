class jenkins::job::factor {
  $job_name = "Factor (master)"

  jenkins::jobs::setup { 
    $job_name:
      job_type => "matrix-project",
  }

  jenkins::plugin::git {
    $job_name:
      url => "git://github.com/justinstoller/facter.git",
  }

  jenkins::plugin::github {
    $job_name:
      url => "https://github.com/justinstoller/facter",
  }

  jenkins::jobs::build_step {
    $job_name:
      action => "rake spec",
  }

  jenkins::jobs::publisher {
    $job_name:
      recipients => 'justin@puppetlabs',
      not_every_unstable => true,
  }

  jenkins::jobs::writer { $job_name: }
}
