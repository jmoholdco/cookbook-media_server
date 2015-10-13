#
# Cookbook Name:: media_server
# Recipe:: ohai
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

ohai 'reload_nginx' do
  plugin 'nginx'
  action :nothing
end

template "#{node['ohai']['plugin_path']}/nginx.rb" do
  source 'plugins/nginx.rb.erb'
  owner 'root'
  group node['root_group']
  mode '0755'
  notifies :reload, 'ohai[reload_nginx]', :immediately
end

include_recipe 'ohai::default'
