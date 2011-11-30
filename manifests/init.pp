
class jenkins {
  include jenkins::repo
  jenkins::package { "present": }

  if (defined(Jenkins::Package["present"])) {

    Class["jenkins::repo"] -> Jenkins::Package["present"]

    jenkins::plugin { "chuck":
      name => "chucknorris",
    }
  }
}

# vim: ts=2 et sw=2 autoindent
