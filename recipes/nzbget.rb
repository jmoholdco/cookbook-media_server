#
# Cookbook Name:: media_server
# Recipe:: nzbget
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node['media_server']['nzbget']['dependencies'].each do |dep|
  package dep
end

directory '/usr/local/etc/nzbget' do
  recursive true
end

group 'nzbget'

user 'nzbget' do
  action :create
  home '/usr/local/etc/nzbget'
  gid 'nzbget'
  system true
end

git "#{node['media_server']['source_dir']}/nzbget" do
  repository 'https://github.com/nzbget/nzbget'
  revision node['media_server']['nzbget']['tag']
  action :sync
  notifies :run, 'bash[install_nzbget_git]', :immediately
end

bash 'install_nzbget_git' do
  cwd "#{node['media_server']['source_dir']}/nzbget"
  code <<-EOH
  touch aclocal.m4 configure Makefile.in config.h.in
  (./configure #{node['media_server']['nzbget']['configuration']} &&
  make && make install && make install-conf)
  EOH
  action :nothing
  creates '/usr/local/bin/nzbget'
end

if node['media_server']['init_style'] == 'systemd'
  template '/lib/systemd/system/nzbget.service' do
    source 'nzbget_init.service.erb'
    mode 0644
    owner 'root'
    group 'root'
  end

else
  template '/etc/init.d/nzbget' do
    source 'nzbget_init.lsb.erb'
    mode 0755
    owner 'root'
    group 'root'
  end
end
