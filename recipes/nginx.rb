#
# Cookbook Name:: media_server
# Recipe:: nginx
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

# Install the ohai plugin
include_recipe 'media_server::ohai'

# Set up the repos
apt_repository 'nginx' do
  uri "http://nginx.org/packages/#{node['platform']}"
  distribution node['lsb']['codename']
  components %w(nginx)
  deb_src true
  key 'http://nginx.org/keys/nginx_signing.key'
end

# Install the package
package 'nginx' do
  notifies :reload, 'ohai[reload_nginx]', :immediately
  not_if 'which nginx'
end

# Declare the service so chef knows about it
service 'nginx' do
  supports status: true, restart: true, reload: true
  action :enable
end

# Set up directory structure
#
directory node['nginx']['dir'] do
  owner 'root'
  group node['root_group']
  mode '0755'
  recursive true
end

directory node['nginx']['log_dir'] do
  mode node['nginx']['log_dir_perm']
  owner node['nginx']['user']
  action :create
  recursive true
end

directory ::File.dirname(node['nginx']['pid']) do
  owner 'root'
  group node['root_group']
  mode '0755'
  recursive true
end

%w(sites-available sites-enabled conf.d).each do |leaf|
  directory ::File.join(node['nginx']['dir'], leaf) do
    owner 'root'
    group node['root_group']
    mode '0755'
  end
end

# Add our little shell scripts to the system
#
%w(nxensite nxdissite).each do |nxscript|
  template "#{node['nginx']['script_dir']}/#{nxscript}" do
    source "#{nxscript}.erb"
    mode '0755'
    owner 'root'
    group node['root_group']
  end
end

# Add configuration files
#
template 'nginx.conf' do
  path "#{node['nginx']['dir']}/nginx.conf"
  source 'nginx.conf.erb'
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

template "#{node['nginx']['dir']}/sites-available/default" do
  source 'reverse-proxy.erb'
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

execute 'nxensite default' do
  command "#{node['nginx']['script_dir']}/nxensite default"
  notifies :reload, 'service[nginx]', :delayed
  not_if do
    ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/default") ||
      ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/000-default")
  end
end
