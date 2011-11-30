define jenkins::package() {
  package {
    "jenkins" :
      ensure => $title;
  }
}

