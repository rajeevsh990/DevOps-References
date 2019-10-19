class tomcat::sampleapp{
   file { '/opt/tomcat/webapps/clusterjsp.war':
    ensure => file,
    content => 'puppet:///modules/tomcat/clusterjsp.war'
  }

  exec { 'restart to deploy clusterapp':
    command => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat restart'
  }


}
