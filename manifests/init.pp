
class jenkins {
  include jenkins::repo
  jenkins::package { "present": }

  if (defined(Jenkins::Package["present"])) {
    include jenkins::service
    include jenkins::plugins::defaults

    Class["jenkins::repo"] 
      -> Jenkins::Package["present"] 
      -> Class["jenkins::service"]
  }
}

# vim: ts=2 et sw=2 autoindent
