# Default artifactory attributes (DEV) if no environment is specified
# Values are overriden if Chef environment is defined
#
default['artifactory']['url']="http://172.16.2.157/artifactory"
default['artifactory']['repo_name']="release-candidates"
default['artifactory']['binaries_repo']="demandforce/campaigns/Release-SNAPSHOT"
default['artifactory']['config_repo']="config"
default['artifactory']['branch']="release-D3-2014-01"
default['artifactory']['ending']="zip"
default['nfs']['gid']="5000"

# campaigns specific attributes
default['campaigns']['base_dir']="/usr/local"
default['campaigns']['install_dir']=default['campaigns']['base_dir']+"/cdm"

default['campaigns']['config_dir']="/usr/local/cdm/config"


#campaigns package specific attributes
default['campaigns']['artifact_path']="demandforce/campaigns/Release-SNAPSHOT"
default['campaigns']['artifact_name']="campaigns"
default['campaigns']['version']="release-D3-2014-01"
default['campaigns']['file_type']="zip"

default['campaigns']['zabbix']['conf_file'] = "zabbix-campaigns.conf"
default['zabbix']['agent']['scripts_dir']="/etc/zabbix/scripts"
default['zabbix']['agent']['conf_dir']="/etc/zabbix/zabbix_agentd.conf.d"

