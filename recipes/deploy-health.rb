Chef::Log.info("*******Configuring Campaigns Zabbix monitoring***********")

$script_file= "campaigns-health.rb"
$conf_file= "zabbix-campaigns.conf"

#install ruby
package 'ruby' do
    retries 20
    action :install
end

template "#{node['zabbix']['agent']['scripts_dir']}/#{$script_file}" do
    source "#{$script_file}.erb"
    owner "zabbix"
    group "zabbix"
    mode "0755"
end

template "#{node['zabbix']['agent']['scripts_dir']}/campaigns-openfiles.rb" do
    source "campaigns-openfiles.rb.erb"
    owner "zabbix"
    group "zabbix"
    mode "0755"
end

template "#{node['zabbix']['agent']['conf_dir']}/#{$conf_file}" do
    source "#{node['campaigns']['zabbix']['conf_file']}.erb"
    owner "zabbix"
    group "zabbix"
    mode "0400"
    variables({
        :scriptfile => $script_file
    })
end
