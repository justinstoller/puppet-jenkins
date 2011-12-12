class jenkins::job::factor {
  $job_name = "Factor (master)"

  jenkins::jobs::setup { 
    $job_name:
      type => "matrix-project",
  }

  jenkins::jobs::build_step {
    $job_name:
      action => "rake spec",
  }
}
