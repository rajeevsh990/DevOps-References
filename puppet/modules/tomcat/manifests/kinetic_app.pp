class tomcat::kinetic_app{

 file { '/opt/tomcat/webapps/kinetic-task.war':
    ensure => present,
    source => 'puppet:///modules/tomcat/kinetic-task.war'
  }

  exec { 'start tomcat':
   command => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat start',
   #unless => "/usr/bin/ps -f | grep -v grep | grep tomcat"
  }
}
