class tomcat::params{
  $extractPath =	'/opt'
  $serverPort =		8005
  $connectorPort =	8009
  $redirectPort =	8443
  $hostname = 		$facts['hostname']
}
