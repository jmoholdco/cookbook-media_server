#
# Cookbook Name:: media_server
# Recipe:: nzbget
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

source_dir = node['media_server']['source_dir']
conf_opts = node['media_server']['nzbget']['configuration']
dependencies = node['media_server']['nzbget']['dependencies']
service_user_dir = node['media_server']['services']['home']

dependencies.each do |dep|
  package dep
end

user 'nzbget' do
  action :create
  home "#{service_user_dir}/nzbget"
  gid 'nogroup'
  system true
end

git "#{source_dir}/nzbget" do
  repository 'https://github.com/nzbget/nzbget'
  revision node['media_server']['nzbget']['tag']
  action :sync
  notifies :run, 'bash[install_nzbget_git]', :immediately
end

bash 'install_nzbget_git' do
  cwd "#{source_dir}/nzbget"
  code <<-EOH
  touch aclocal.m4 configure Makefile.in config.h.in
  (./configure #{conf_opts} && make && make install)
  EOH
  action :nothing
  creates '/usr/local/nzbget'
end
