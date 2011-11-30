class jenkins::plugins {
  jenkins::plugin {
    'chucknorris':
      name => 'chucknorris',
      ensure => present,
  }
}
