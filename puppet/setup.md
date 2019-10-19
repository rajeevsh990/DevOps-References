# Installation pre-requisites
- Create a server with 2core CPU and 4 GB RAM
- Server can't be installed on windows machine
- Ensure to open ports 8140, 8142, 443, 22 on Puppet master server


# Download PE installation and installation:

1. Navigate to page: https://puppet.com/download-puppet-enterprise
2. Click on 'download' button and Fill your details
3. Navigate to: https://puppet.com/misc/pe-files/previous-releases/2018.1.3
4. Click on 'download now' for centos7/centos6 will give you a link https://d2getqyrpmrvl0.cloudfront.net/released/2018.1.3/puppet-enterprise-2018.1.3-el-7-x86_64.tar.gz

4. Once you have tar ball downloaded place it into /opt and execute following:
> wget https://d2getqyrpmrvl0.cloudfront.net/released/2018.1.3/puppet-enterprise-2018.1.3-el-7-x86_64.tar.gz

> tar -zxf puppet-enterprise-2018.1.3-el-7-x86_64.tar.gz

> mv puppet-enterprise-2018.1.3-el-7-x86_64 puppet-enterprise

> cd puppet-enterprise

> ./puppet-enterprise-installer  
- Select Express Install [1] and press Enter.
Note: it will take around 5-10 mins to complete the setup. 

Once finished, run following command:
> puppet agent -t

Note: in case agent fails, check following:
- check all services up and running, ports are listening and reachable. 
- add 'puppet' against servers column in /etc/hosts


# Services to checkout
> systemctl start/status/stop pe-puppetserver.service  
> systemctl status/start/stop pe-puppetdb


# Install puppet agent on remote node.
- There are 2 ways to do this:
**Manual**  
- Download the compatible version from https://puppet.com/misc/pe-files/previous-releases/2018.1.3
- Untar the file and execute the setup.
- Enter following lines in /etc/puppetlabs/puppet/puppet.conf 
[server]  
server = master fqdn
certname = master fqdn  
- Once you save the file run puppet agent to request CSR to master  
> puppet agent -t  
- Now go to console and accept/sign the CSR.  

**Using PE Console**  
- On the left hand pane navigate to Setup -> Unsigned certs  
- Copy the curl command and execute on remote agent server (please note the agent server should be same arch and os as master)
