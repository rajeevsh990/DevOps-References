========== puppet commands ===========
- To change console password
> puppet infra console_password --password=

- To checkout the configuration
> puppet config print

- To list all the facters on the agent node
> facter  

- To validate the manifests
> puppet parser validate init.pp

========= Puppet code =========
- To test your first code put the following code in your site.pp (/etc/puppetlabs/code/environments/production/manifests/site.pp) and run 'puppet agent -t' on remote server. 

**Example 1 [site.pp]:** 
```
node default {
notify {'hello world': }
}
```

**Example 2 [site.pp]:**
```
user { 'dev-user':
  ensure => present,
  uid    => '3001',
  home   => '/home/dev-user',
  shell  => '/bin/bash',
}
```

**Example 3 [site.pp]:**
```
exec {'os version':
  path    => '/usr/bin:/usr/sbin:/bin',
  command => 'cat /etc/os-release',
}
```


**Example 4 [site.pp]:**
```
- install apache2 package
package { 'httpd':
  ensure => installed,
}

- ensure apache2 service is running
service { 'httpd':
  ensure => running,
  require => Package['httpd'],
}
```


** Create your first module **  
> puppet module generate rajeev/hello  

===== Puppet examples: =====

** Example 1: Create user ** 
- put following code in hello/manifests/init.pp
```
class hello {
group { 'devs':
  ensure => present,
  gid    => 3000,
}

user { 'dev-user':
  ensure => present,
  uid    => '3001',
  home   => '/home/dev-user',
  shell  => '/bin/bash',
  groups => ['devs'],
}
}
```  

- Execute puppet agent on remote node. You observe nothing happened. Because you have not declared your code. Well, this could be done either using site.pp or PE Console. 
- In site.pp, go to the node block and declare the module.  
> include 'hello'

** Example 2: Run service **
```
class hello {
## install apache2 package
package { 'httpd':
  ensure => installed,
}

## ensure apache2 service is running
service { 'httpd':
  ensure => running,
  require => Package['httpd'],
}
}
```
