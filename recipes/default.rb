#
# Cookbook Name:: media_server
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'apt' if platform_family? 'debian'
if node['platform']['version'].to_f >= 15.0
  include_recipe 'nfs::client'
else
  include_recipe 'nfs::client4'
end

directory node['media_server']['source_dir'] do
  recursive true
end

directory node['media_server']['services']['home'] do
  recursive true
end

mount '/mnt' do
  device 'nfs.jmorgan.org:/srv'
  fstype 'nfs'
  options 'rw'
  action [:mount, :enable]
end

include_recipe 'media_server::nginx'
include_recipe 'media_server::nzbget'
include_recipe 'media_server::sonarr'
