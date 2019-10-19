class tomcat::jenkinsapp {

  exec { 'stop to deploy jenkins app':
    command => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat stop'
  }

  #file { '/opt/tomcat/webapps/jenkins.war':
  #  ensure => file,
  #  content => 'puppet:///moodules/tomcat/jenkins.war',
  #}
  exec {'download jenkins.war':
    path    => '/usr/bin/:/bin/:/sbin:/usr/sbin',
    cwd     => '/opt/tomcat/webapps/',
    command => 'wget http://ftp-nyc.osuosl.org/pub/jenkins/war/2.189/jenkins.war'
  }


  exec {'lets take a pause':
    path  => '/usr/bin/:/bin/:/sbin:/usr/sbin', 
    command => 'sleep 10'
  }
 
  exec { 'start to deploy jenkins app':
    command => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat start'
  }
}
