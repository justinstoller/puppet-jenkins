
class jenkins {
  include jenkins::upstream

  jenkins-plugin {
    'chucknorris':
      name => 'chucknorris',
      ensure => present,
  }

  jenkins-plugin {
    'ant':
      name => 'ant',
      ensure => absent,
  }

  jenkins-plugin {
    'maven-plugin':
      name => 'maven-plugin',
      ensure => absent,
  }

  jenkins-plugin {
    'translation':
      name => 'translation',
      ensure => absent,
  }

  jenkins-plugin {
    'subversion':
      name => 'subversion',
      ensure => absent,
  }

  jenkins-plugin {
    'ssh-slaves':
      name => 'ssh-slaves',
      ensure => absent,
  }

  jenkins-plugin {
    'javadoc':
      name => 'javadoc',
      ensure => absent,
  }

  jenkins-plugin {
    'cvs':
      name => 'cvs',
      ensure => absent,
  }
}

class jenkins::upstream {
  include jenkins::repo
  jenkins::package { 'present': }

  if (defined(Jenkins::Package['present'])) {
    include jenkins::service
    include jenkins::plugins::defaults

    Class['jenkins::repo']
      -> Jenkins::Package['present']
      -> Class['jenkins::service']

    include jenkins::job::facter
    include jenkins::job::puppet
  }
}

# vim: ts=2 et sw=2 autoindent
