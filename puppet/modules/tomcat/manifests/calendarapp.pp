class tomcat::calendarapp {


  file { '/opt/tomcat/webapps/Calendar.war':
    ensure => file,
    content => 'puppet:///moodules/tomcat/Calendar.war'
  }


  exec { 'restart to deploy calendarapp':
    command => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat restart'
  }

}
