
class jenkins {
  include jenkins::upstream
  include jenkins::plugins

  Class['jenkins::upstream'] -> Class['jenkins::plugins']
}

# vim: ts=2 et sw=2 autoindent
