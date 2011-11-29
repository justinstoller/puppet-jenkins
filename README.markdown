# puppet-jenkins

This is intended to be a re-usable
[Puppet](http://www.puppetlabs.com/puppet/introduction/) module that you can
include in your own tree.


In order to add this module, run the following commands in your own, presumably
Git, puppet tree:

    % git submodule add git://github.com/rtyler/puppet-jenkins.git modules/jenkins
    % git submodule update --init

That should be all you need

### Depending on Jenkins

If you have any resource in Puppet that *depends* on Jenkins being present, add
the following `require` statement:

    exec {
        "some-exec" :
            require => Class["jenkins::package"],
            # ... etc
    }



### Installing Jenkins plugins


The Jenkins puppet module defines the `install-jenkins-plugin` resource which
will download and install the plugin "[by
hand](https://wiki.jenkins-ci.org/display/JENKINS/Plugins#Plugins-Byhand)"

The names of the plugins can be found on the [update
site](http://updates.jenkins-ci.org/download/plugins)

I added the ability to restart the Jenkins service after installing plugins, remove 
them with an "ensure => absent" and have begun working on recreating a default set of
plugins/further extending them.(see note!)


#### Latest

By default, the resource will install the latest plugin, i.e.:


    jenkins-plugin {
        "git-plugin" :
            name => "git";
    }



#### By version

If you need to peg a specific version, simply specify that as a string, i.e.:

    jenkins-plugin { # Note this is changed from RTyler's version!
        "git-plugin" :
            name    => "git,
            version => "1.1.11",
            ensure  => "present",
    }

#### Note!

I haven't yet figured out why this is happening, but when trying to manage the default
set of plugins Jenkins ships with, I get:

		root@ubuntu-beta:/etc/puppetlabs/puppet/modules# puppet agent -t
		info: Retrieving plugin
		info: Loading facts in facter_dot_d
		info: Loading facts in facter_dot_d
		info: Loading facts in facter_dot_d
		info: Loading facts in facter_dot_d
		info: Caching catalog for ubuntu-beta
		info: Applying configuration version '1322528871'
		info: /Stage[main]/Jenkins/Jenkins-plugin[subversion]/File[/var/lib/jenkins/plugins/subversion.hpi]: Filebucketed /var/lib/jenkins/plugins/subversion.hpi to main with sum fb036d47176fff20837a3c878dc5f165
		notice: /Stage[main]/Jenkins/Jenkins-plugin[subversion]/File[/var/lib/jenkins/plugins/subversion.hpi]/ensure: removed
		info: /var/lib/jenkins/plugins/subversion.hpi: Scheduling refresh of Service[jenkins]
		err: /Stage[main]/Jenkins/Jenkins-plugin[maven-plugin]/File[/var/lib/jenkins/plugins/maven-plugin.hpi]/ensure: change from file to absent failed: Could not back up /var/lib/jenkins/plugins/maven-plugin.hpi: Error 400 on SERVER: Could not intern from pson: regexp buffer overflow
		info: /Stage[main]/Jenkins/Jenkins-plugin[cvs]/File[/var/lib/jenkins/plugins/cvs.hpi]: Filebucketed /var/lib/jenkins/plugins/cvs.hpi to main with sum 97a39d6c2ea09d640124de1b6e54dc17
		notice: /Stage[main]/Jenkins/Jenkins-plugin[cvs]/File[/var/lib/jenkins/plugins/cvs.hpi]/ensure: removed
		info: /var/lib/jenkins/plugins/cvs.hpi: Scheduling refresh of Service[jenkins]
		info: /Stage[main]/Jenkins/Jenkins-plugin[translation]/File[/var/lib/jenkins/plugins/translation.hpi]: Filebucketed /var/lib/jenkins/plugins/translation.hpi to main with sum c93912861a2e9bfcf20056c9184808e3
		notice: /Stage[main]/Jenkins/Jenkins-plugin[translation]/File[/var/lib/jenkins/plugins/translation.hpi]/ensure: removed
		info: /var/lib/jenkins/plugins/translation.hpi: Scheduling refresh of Service[jenkins]
		info: /Stage[main]/Jenkins/Jenkins-plugin[javadoc]/File[/var/lib/jenkins/plugins/javadoc.hpi]: Filebucketed /var/lib/jenkins/plugins/javadoc.hpi to main with sum a9946fb0495567f3f89ff7589ce559c8
		notice: /Stage[main]/Jenkins/Jenkins-plugin[javadoc]/File[/var/lib/jenkins/plugins/javadoc.hpi]/ensure: removed
		info: /var/lib/jenkins/plugins/javadoc.hpi: Scheduling refresh of Service[jenkins]
		info: /Stage[main]/Jenkins/Jenkins-plugin[ssh-slaves]/File[/var/lib/jenkins/plugins/ssh-slaves.hpi]: Filebucketed /var/lib/jenkins/plugins/ssh-slaves.hpi to main with sum 06646158989cce5f79501a60aebc30fa
		notice: /Stage[main]/Jenkins/Jenkins-plugin[ssh-slaves]/File[/var/lib/jenkins/plugins/ssh-slaves.hpi]/ensure: removed
		info: /Stage[main]/Jenkins/Jenkins-plugin[ant]/File[/var/lib/jenkins/plugins/ant.hpi]: Filebucketed /var/lib/jenkins/plugins/ant.hpi to main with sum 77c360f0bd3e83d93a2fbed1175148c1
		notice: /Stage[main]/Jenkins/Jenkins-plugin[ant]/File[/var/lib/jenkins/plugins/ant.hpi]/ensure: removed
		info: /var/lib/jenkins/plugins/ant.hpi: Scheduling refresh of Service[jenkins]
		info: /var/lib/jenkins/plugins/ssh-slaves.hpi: Scheduling refresh of Service[jenkins]
		notice: /Stage[main]/Jenkins::Package/Service[jenkins]: Dependency File[/var/lib/jenkins/plugins/maven-plugin.hpi] has failures: true
		warning: /Stage[main]/Jenkins::Package/Service[jenkins]: Skipping because of failed dependencies
		notice: /Stage[main]/Jenkins::Package/Service[jenkins]: Triggered 'refresh' from 6 events
		notice: Finished catalog run in 21.68 seconds
