#class jenkins {
#  include jenkins::plugins
#
#  jenkins::plugin::chucknorris {
#    'chuck':
#      beard => 'true',
#      roundhouse => 'always',
#  }
#}
#
#class jenkins::plugins {
#  include jenkins::plugin
#}
#
#class jenkins::plugin::action {
#  file {
#    '/root/jenkins.xml':
#       ensure => file,
#       content => template('jenkins/config_writer'),
#  }
#}
#
#class jenkins::plugin::state {
#
#  $plugin = [ ]
#  $base_array = [{
#                 project => [
#                   { actions => '' },
#                   { description => 'description' },
#                   { plugins => [
#                     { name => $plugin }
#                   ]}
#                 ]
#               }]
#}
#
#class jenkins::plugin {
#
#  define chucknorris ($beard = 'blah', $roundhouse = 'blah') {
#    include jenkins::plugin::state
#    $plugin = 'chucknorris'
#
#    $jenkins::plugin::state::plugin += $plugin
#
#    $jenkins::plugin::state::base_array += [{
#                 project => [
#                   { beard => $beard },
#                   { roundhouse => $roundhouse }
#                 ]
#               }]    
#
#    $configs = $jenkins::plugin::state::base_array
#    include jenkins::plugin::action
#  }
#}
#

class jenkins {
  include jenkins::upstream

  jenkins-plugin {
    'chucknorris':
      name => 'chucknorris',
      ensure => present,
  }
}

class jenkins::upstream {
  include jenkins::repo
  include jenkins::package

  Class["jenkins::repo"] -> Class["jenkins::package"]
}

class jenkins::package {
  package {
    "jenkins" :
      ensure => installed;
  }

  service {
    'jenkins':
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => Package['jenkins'],
  }
}

class jenkins::repo {
  file {
      "/etc/apt/sources.list.d" :
          ensure => directory;

      "/etc/apt/sources.list.d/jenkins.list" :
          ensure => present,
          notify => [
                      Exec["install-key"],
                      Exec["refresh-apt"],
                    ],
          source => "puppet:///modules/jenkins/apt.list",
  }

  file {
      "/root/jenkins-ci.org.key" :
          source => "puppet:///modules/jenkins/jenkins-ci.org.key",
          ensure => present;
  }

  exec {
      "refresh-apt" :
          refreshonly => true,
          require => [
                      File["/etc/apt/sources.list.d/jenkins.list"],
                      Exec["install-key"],
                      ],
          path    => ["/usr/bin", "/usr/sbin"],
          command => "apt-get update";

      "install-key" :
          notify => Exec["refresh-apt"],
          require => [
                      File["/etc/apt/sources.list.d/jenkins.list"],
                      File["/root/jenkins-ci.org.key"],
                      ],
          # Don't install the key unless it's not already installed
          unless  => "/usr/bin/apt-key list | grep 'D50582E6'",
          command => "/usr/bin/apt-key add /root/jenkins-ci.org.key";
  }
}

define jenkins-plugin($name, $version=0, $ensure=present) {
  $plugin     = "${name}.hpi"
  $plugin_dir = "/var/lib/jenkins/plugins"

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = "http://updates.jenkins-ci.org/latest/"
  }

  if (!defined(File["${plugin_dir}"])) {
    file {
      "${plugin_dir}" :
        owner  => "jenkins",
        ensure => directory,
        recurse => true,
        purge => true,
        backup => false,
        force => true,
    }
  }

  if (!defined(User["jenkins"])) {
    user {
      "jenkins" :
        ensure => present;
    }
  }

  exec {
    "download-${name}" :
      command  => "wget --no-check-certificate ${base_url}${plugin}",
      cwd      => "${plugin_dir}",
      require  => File["${plugin_dir}"],
      path     => ["/usr/bin", "/usr/sbin",],
      user     => "jenkins",
      creates   => "${plugin_dir}/${plugin}",
      onlyif => $ensure ? {
        present => 'test -n "1"',
        absent => 'test -n ""',
      },
  }

  file { 
    "${plugin_dir}/${plugin}":
      owner => 'jenkins',
      ensure => $ensure,
      require => Exec["download-${name}"],
      mode => '640',
      notify => Service['jenkins'],
      backup => false,
  }

  file {
    "${plugin_dir}/${name}":
      ensure => $ensure ? {
        'present' => 'directory',
        'absent' => 'absent',
      },
      backup => false,
      force => true,
  }
}

# vim: ts=2 et sw=2 autoindent
