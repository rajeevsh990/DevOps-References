class tomcat::cluster inherits ::tomcat::params {

  exec { '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat stop': 
    onlyif => "ps -f | grep -v grep | grep tomcat",
    path   => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"] 
  }
  
  file { "$extractPath/tomcat/conf/server.xml":
    owner   => 'root',
    mode    => '0664',
    content => template('tomcat/server.xml.erb')
  }
  
  exec { 'start cluster tomcat': 
    command   => '/etc/profile.d/tomcat.sh && /etc/init.d/tomcat start',
    unless    => "ps -f | grep -v grep | grep tomcat",
    path      => ["/usr/bin", "/usr/sbin"],
    subscribe => File["$extractPath/tomcat/conf/server.xml"]
  }
  
}
