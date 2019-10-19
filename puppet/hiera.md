# Hiera setup: 
- Make changes in following 3 files  
1. hiera global settings 
> cat /etc/puppetlabs/puppet/hiera.yaml
```
---
# Hiera 5 Global configuration file
version: 5
hierarchy: []
```

2. Hiera environment level settings

> cat /etc/puppetlabs/code/environments/production/hiera.yml
```
---
version: 5
defaults:
  datadir:  /etc/puppetlabs/code/environments/production/data
  data_hash: yaml_data
hierarchy:
  - name: "Per-node data (yaml version)"
    path: "nodes/puppet-agent.yaml"
  - name: "Other YAML hierarchy levels"
    paths:
      - "common.yaml"
```

3. Set your variables and values in hiera data directory  
> cat data/nodes/puppet-agent.yaml 
```
---
sample::create_user::user_name: 'user1'
sample::create_user::user_id: '4001'
```

- Execute sample::create_user on puppet-agent node. 

Note: Facter variables can be used in Hiera hierarchy paths.  
> e.g. path: "nodes/$::hostname.yaml"  
above path will interpolate into the specific hostname.yaml where puppet run is happening.  
