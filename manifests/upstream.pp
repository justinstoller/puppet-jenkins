class jenkins::upstream {
  include jenkins::repo
  include jenkins::package

  Class["jenkins::repo"] -> Class["jenkins::package"]
}

