# == Class: tomcat
#
# Copyright 2015 rajeev.sharma9@cognizant.com, unless otherwise noted.
#
class tomcat {
  package { 'java-1.8.0':
    ensure => present
  }

  package { 'net-tools':
    ensure => present
  }

  package { 'tar':
    ensure => present
  }

  package { 'wget':
    ensure => present
  }

  exec {'download tomcat pakcage':
    cwd     => '/opt',
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz' 
  }  

  exec { 'tar -xvf apache-tomcat-8.0.32.tar.gz; mv apache-tomcat-8.0.32 tomcat':
    cwd    => '/opt',
    path   => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    unless => 'test -d /opt/tomcat'
  }
  
  file { '/etc/profile.d/tomcat.sh':
    ensure => present,
    source => 'puppet:///modules/tomcat/tomcat_variable.sh',
    mode   => '0755'
  }

  file { '/opt/tomcat/conf/tomcat-users.xml':
    ensure => present,
    source => 'puppet:///modules/tomcat/tomcat-users.xml',
    mode   => '0644'
  }

  file {'/etc/init.d/tomcat':
    ensure => present,
    source => 'puppet:///modules/tomcat/tomcat.init',
    mode   => '0755'
  }

  service {'start tomcat':
    name   => 'tomcat',
    ensure => running,
  }


  #exec { 'start tomcat':
  #  command => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat start',
  #  unless  => "/usr/bin/ps -f | grep -v grep | grep tomcat"
  #}
}
