#
# Cookbook Name:: rackspace_holland
# Recipe:: mysqldump
#
# Copyright 2014, Rackspace, US Inc.
#
# All rights reserved - Do Not Redistribute
#

node.default['rackspace_mysql']['install_root_my_cnf'] = true

include_recipe 'rackspace_mysql::client'
include_recipe 'rackspace_holland::common'

case node['platform']
when 'redhat', 'centos'
  package 'holland-mysqldump'
when 'ubuntu', 'debian'
  remote_file "#{Chef::Config[:file_cache_path]}/#{node['rackspace_holland']['install']['mysqldump']}" do
    source "#{node['rackspace_holland']['install']['container']}/#{node['rackspace_holland']['install']['mysqldump']}"
    action :create_if_missing
  end

  package 'holland-mysqldump' do
    source source "#{Chef::Config[:file_cache_path]}/#{node['rackspace_holland']['install']['mysqldump']}"
    provider Chef::Provider::Package::Dpkg
  end
end

template '/etc/holland/holland.conf' do
  source 'holland.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
    backupsets: 'default'
  )
end

template '/etc/holland/backupsets/default.conf' do
  source 'backupsets/default.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
    plugin: 'mysqldump',
    keep: '7',
    hollpasswd: node['rackspace_holland']['server_holland_password']
  )
end

template '/etc/holland/holland.sql' do
  source 'holland.sql.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables hollpasswd: node['rackspace_holland']['server_holland_password']
end

execute 'holland-install-privileges' do
  command '/usr/bin/mysql -u root < /etc/holland/holland.sql'
  action :run
end

template '/etc/cron.d/holland' do
  source 'holland.cron.erb'
  mode 0644
  owner 'root'
  group 'root'
end
