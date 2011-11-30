class jenkins::job::factor {
  jenkins::jobs::setup { 
    "Factor (master)":
      type => "matrix-project",
  }
}

