# Cookbooks:
- Chef Cookbooks is a unit that holds the configuration and policy details to bring a node into a particular state. Cookbooks are created on a workstation and then uploaded to Chef server. A cookbook is then assigned to nodes “run-list” which is a sequential list of actions that are to be run on a node to bring the node into the desired state.

**Create a Simple Chef Cookbooks:**
- In this portion, we will create a simple cookbook to install and configure an Apache web server.
- Log into your Chef workstation, go to your ~/chef-repo/cookbooks directory. 
> cd ~/chef-repo/cookbooks/
> chef generate cookbook httpd
> cd httpd/recipes

- To begin, let’s add a resource for installing apache package. (edit default.rb)
```
package 'httpd' do
  action :install
end

service 'httpd' do
  action [ :enable, :start ]
end

cookbook_file "/var/www/html/index.html" do
  source "index.html"
  mode "0644"
end
```

- Creating the Index File:

Since we have defined a "cookbook_file" resource, we need to create a source file “index.html” inside files subdirectory of your cookbook.
> cd ~/chef-repo/cookbooks

Create a subdirectory "files" under your cookbook.
> mkdir httpd/files

Add a simple text into the index.html.
> echo "Installed and Setup Using Chef" > httpd/files/index.html

**Upload the cookbook**
- Once your cookbook is complete, you can upload them on to your Chef server
> knife cookbook upload httpd

- Check whether you can list the cookbook that you just have been uploaded.
> knife cookbook list

- To remove the cookbook (optional).
> knife cookbook delete cookbook_name

**Add the Cookbook to your node:**

- You can add a cookbook to the run_list of a particular node using the following command. Replace <chef client node> with your client node name.

> knife node run_list add 'chef client node' httpd

- To remove the particular recipe from run_list (optional).
> knife node run_list remove 'chef client node' recipe[cookbook_name]

**Apply the cookbook or configuration**
- Login to the client node where Chef client software is running.
Run the chef-client command on the client node to check with Chef server for any new run_list and run those run_list that has been assigned to it.

> chef-client

- You can verify that this works by visiting your node’s IP address or domain name over a web browser.

http://your-ip-address/
