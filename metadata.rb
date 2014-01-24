name             'campaigns'
maintainer       'Intuit Corporation'
maintainer_email 'eng_ops@demandforce.com'
license          'All rights reserved'
description      'Installs/Configures campaigns'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.4'
depends          "dfartifactory"
depends          "dfwebapps" 

supports "centos"
supports "ubuntu"
supports "redhat"

recipe "campaigns::default","Install cdm"

attribute "artifactory/url",
	:required => 'optional',
	:default => 'http://172.16.2.157/artifactory'
attribute "artifactory/repo_name",
	:required => 'optional',
	:default => 'release-candidates'
attribute "artifactory/binaries_repo",
	:required => 'optional',
	:default => 'demandforce/campaigns/Release-SNAPSHOT'
attribute "artifactory/config_repo",
	:required => 'optional',
	:default => 'config'
attribute "artifactory/branch",
	:required => 'optional',
	:default => 'release-D3-2014-01'
attribute "artifactory/ending",
	:required => 'optional',
	:default => 'zip'
attribute "nfs/gid",
	:required => 'optional',
	:default => '5000'
attribute "campaigns/base_dir",
	:required => 'optional',
	:default => '/usr/local'
attribute "campaigns/install_dir",
	:required => 'optional',
	:default => '/usr/local/cdm'
attribute "campaigns/config_dir",
	:required => 'optional',
	:default => '/usr/local/cdm/config'
attribute "campaigns/artifact_path",
	:required => 'optional',
	:default => 'demandforce/campaigns/Release-SNAPSHOT'
attribute "campaigns/artifact_name",
	:required => 'optional',
	:default => 'campaigns'
attribute "campaigns/version",
	:required => 'optional',
	:default => 'release-D3-2014-01'
attribute "campaigns/file_type",
	:required => 'optional',
	:default => 'zip'
attribute "campaigns/zabbix/conf_file",
	:required => 'optional',
	:default => 'zabbix-campaigns.conf'
attribute "zabbix/agent/scripts_dir",
	:required => 'optional',
	:default => '/etc/zabbix/scripts'
attribute "zabbix/agent/conf_dir",
	:required => 'optional',
	:default => '/etc/zabbix/zabbix_agentd.conf.d'
