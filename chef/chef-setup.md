# Pre-requisites
- An x86_64 compatible system architecture; Red Hat Enterprise Linux and CentOS may require updates prior to installation
- A resolvable hostname that is specified using a FQDN or an IP address
- Ports 80 and 443 are open. 

HOST NAME		OS			CPU		MEMORY	DISK	PURPOSE
chefserver		CentOS 7	4		4 GB	40 GB	Chef Server
chefdk			CentOS 7	1		512 MB	NA		Chef Workstation (Chef Development Kit)
chefclient		CentOS 7	1		512 MB	NA		Chef Client

# Installation
1. Download the package from https://downloads.chef.io/chef-server/ to /opt directory  
2. As a root user, install the Chef Infra Server package on the server, using the name of the package provided by Chef.  
For Red Hat Enterprise Linux and CentOS:  
> sudo rpm -Uvh /opt/chef-server-core-<version>.rpm

3. Run the following to start all of the services:

> sudo chef-server-ctl reconfigure

4. Run the following command to create an administrator:  
> sudo chef-server-ctl user-create chefuser Chef User chefuser@example.com 'abc123' --filename /opt/janedoe.pem

5. Run the following command to create an organization:  
> sudo chef-server-ctl org-create cheforg 'BFS account' --association_user chefuser --filename /opt/4thcoffee-validator.pem

==========
# Chef Server
- Install pre-req packages
> yum install git vim wget -y

- Download the chef packages
> wget https://packages.chef.io/stable/el/7/chef-server-core-12.10.0-1.el7.x86_64.rpm

- Install Chef server components
> rpm -ivh chef-server-core-12.10.0-1.el7.x86_64.rpm

- Once the installation is complete, you must reconfigure the chef server components to make up the server to work together. 
> chef-server-ctl reconfigure

- Check the status of Chef Server components by using the following command.  
> chef-server-ctl status

** Create an Admin user and Organization **
- 	We need to create an admin user. This user will have access to make changes to the infrastructure components in the organization we will be creating. Below command will generate the RSA private key automatically and should be saved to a safe location.

> chef-server-ctl user-create admin admin admin admin@mydomain.internal admin123 -f /etc/chef/admin.pem

- It is the time for us to create an organization to hold the chef configurations.

> chef-server-ctl org-create cheforg 'BFS account' --association_user admin -f /etc/chef/cheforg-validator.pem

- As of now, you will have two .pem keys in /etc/chef directory. In our case, they will be called admin.pem and cheforg-validator.pem. Soon we will place these two files in Chef workstation machine.

# Chef Workstation  

A workstation is a computer that is configured to the author, test and maintain cookbooks. These cookbooks are then uploaded to Chef server. It is also used to bootstrapping a node that installs the chef-client on nodes.

**Setting up a Workstation**

> wget https://packages.chef.io/stable/el/7/chefdk-0.19.6-1.el7.x86_64.rpm

> rpm -ivh chefdk-0.19.6-1.el7.x86_64.rpm

> chef verify

- Set ruby binary path, append the output of 'chef shell-init bash' to .bash_profile  
> chef shell-init bash
- appned output in .bash_profile
- which ruby

**Create Chef Repo**  
> cd ~
> chef generate repo chef-repo

- Now, let’s create a hidden directory called “.chef” under the chef-repo directory. This hidden directory will hold the RSA keys that we created on the Chef server.

> mkdir -p ~/chef-repo/.chef

**Copy the RSA Keys to the Workstation**

cp /etc/chef/admin.pem ~/chef-repo/.chef/_
cp /etc/chef/cheorg-validator.pem ~/chef-repo/.chef/

**Create knife.rb File:**
vim ~/chef-repo/.chef/knife.rb

- paste the following info in this knife.rb file
```
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "admin"
client_key               "#{current_dir}/admin.pem"
validation_client_name   "cheforg-validator"
validation_key           "#{current_dir}/cheforg-validator.pem"
chef_server_url          "https://chef-infra.us-central1-a.c.onyx-sphere-238609.internal/organizations/cheforg"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntaxcache"
cookbook_path            ["#{current_dir}/../cookbooks"]
```

**Definition of knife.rb file attributes**

Adjust the following items to suit for your infrastructure.
- node_name: This the username with permission to authenticate to the Chef server. Username should match with the user that we created on the Chef server.
- client_key: The location of the file that contains user key that we copied over from the Chef server.
- validation_client_name: This should be your organization’s short name followed by -validator.
- validation_key: The location of the file that contains validation key that we copied over from the Chef server. This key is used when a chef-client is registered with the Chef server.
- chef_server_url: The URL of the Chef server. It should begin with https://, followed by IP address or FQDN of Chef server, organization name at the end just after /organizations/.
- {current_dir} represents ~/chef-repo/.chef/ directory, assuming that knife.rb file is in ~/chef-repo/.chef/. So you don’t have to write the fully qualified path.

**Testing Knife:**
- Now, test the configuration by running knife client list command. Make sure you are in ~/chef-repo/ directory.
> cd ~/chef-repo/
> knife client list

- You may get an error like 'SSL Validation failure connecting to host:' on your first attempt:
- To resolve this issue, we need to fetch the Chef server’s SSL certificate on our workstation beforehand running the above command.
> knife ssl fetch

- This command will add the Chef server’s certificate file to trusted certificate directory.
- Run client list again:
> knife client list
Output:
itzgeek-validator

