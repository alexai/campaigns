#
# Cookbook Name:: campaigns
# Recipe:: default
# Author:: Jayasimhan Masilamani
# Updated by :: 
#
# Copyright 2013, Intuit Inc.
#
# All rights reserved - Do Not Redistribute
# 
#
include_recipe "dfwebapps::jdk"

# Load Artifactory module
::Chef::Recipe.send(:include, DF::ARTIFACTORY)

# This recipe will deploy Demandforce Recurring Campaigns CDM
if node.chef_environment == "qa-rc" || node.chef_environment == "d3-stg" || node.chef_environment == "production-rc"
		Chef::Log.info("Entering production...")
               		
		#Each project
		init_search(node['artifactory']['url'], node['dfcampaigns']['release_month'], node['dfcampaigns']['release_candidate'])	
                dfcampaigns_url = search_release_candidates('campaigns-')
		Chef::Log.info("#{dfcampaigns_url}")

                remote_file "#{Chef::Config[:file_cache_path]}/#{node['campaigns']['artifact_name']}-#{node['campaigns']['version']}-SNAPSHOT-distribution.#{node['campaigns']['file_type']}" do

	             Chef::Log.info("#{dfcampaigns_url}")
                     source   "#{dfcampaigns_url}"
                     owner    "root"
                     mode     "0644"
                     notifies :stop, "service[campaigns]", :immediately
                     notifies :run, "script[deploy campaigns]", :immediately
                end
else

                 remote_file "#{Chef::Config[:file_cache_path]}/#{node['campaigns']['artifact_name']}-#{node['campaigns']['version']}-SNAPSHOT-distribution.#{node['campaigns']['file_type']}" do
               
                     Chef::Log.info("#{node['artifactory']['url']}/#{node['artifactory']['repo_name']}/#{node['campaigns']['artifact_path']}/#{node['campaigns']['artifact_name']}-#{node['campaigns']['version']}-SNAPSHOT-distribution.#{node['campaigns']['file_type']}")
                 
                     source   "#{node['artifactory']['url']}/#{node['artifactory']['repo_name']}/#{node['campaigns']['artifact_path']}/#{node['campaigns']['artifact_name']}-#{node['campaigns']['version']}-SNAPSHOT-distribution.#{node['campaigns']['file_type']}"

                     owner    "root"
                     mode     "0644"
                     notifies :stop, "service[campaigns]", :immediately
                     notifies :run, "script[deploy campaigns]", :immediately
                 end
end

script "deploy campaigns" do
  interpreter "bash"
  user        "root"
  cwd         "#{node['campaigns']['base_dir']}"
  action      :nothing
  code <<-EOH
    if [ -d cdm ]; then
	    if [ -d cdm-bak ]; then
	    	rm -rf cdm-bak
	    fi    	
      	mv -f cdm cdm-bak
    fi
    mkdir cdm
    mkdir cdm/config
    pwd
    unzip -d cdm #{Chef::Config[:file_cache_path]}/#{node['campaigns']['artifact_name']}-#{node['campaigns']['version']}-SNAPSHOT-distribution.#{node['campaigns']['file_type']}
  EOH
end

cookbook_file "/etc/init.d/campaigns" do
   source "etc/init.d/campaigns"
   owner  "root"
   mode   "0755"
   action :create
end

cookbook_file "/etc/sysconfig/campaigns" do
   source "etc/sysconfig/campaigns"
   owner  "root"
   mode   "0644"
   action :create
end

if ( node.chef_environment =~ /production(.*)/ )
   # Deploy config files
   cookbook_file "#{node['campaigns']['config_dir']}/cdm.properties" do
      source "#{node.chef_environment}/cdm.properties"
      owner  "root"
      mode   "0644"
      action :create
   end
end

cookbook_file "#{node['campaigns']['config_dir']}/log4j.properties" do
   source "#{node.chef_environment}/log4j.properties"
   owner  "root"
   mode   "0644"
   action :create
end

cookbook_file "#{node['campaigns']['base_dir']}/cdm/campaigns.sh" do
   source "#{node.chef_environment}/campaigns.sh"
   owner  "root"
   mode   "777"
   action :create
end

cookbook_file "#{node['campaigns']['config_dir']}/jndi.xml" do
  source "#{node.chef_environment}/jndi.xml"
  owner  "root"
  mode   "0644"
  action :create
end

# jmxremote.password
cookbook_file "/root/jmxremote.password" do
  source "jmxremote.password"
  owner  "root"
  mode   "0400"
  action :create_if_missing
end

service "campaigns" do
  supports :start => true, :stop => true, :status => true
  action [ :enable, :start ]
end
