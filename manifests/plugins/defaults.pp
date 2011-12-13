class jenkins::plugins::defaults {
  jenkins::plugin { "cvs": }
  jenkins::plugin { "javadoc": }
  jenkins::plugin { "ant": }
  jenkins::plugin { "maven-plugin": }
  jenkins::plugin { "ssh-slaves": }
  jenkins::plugin { "subversion": }
  jenkins::plugin { "translation": }
  jenkins::plugin { "git": }
  jenkins::plugin { "github": }
}
