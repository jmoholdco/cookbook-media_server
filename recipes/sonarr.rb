#
# Cookbook Name:: media_server
# Recipe:: sonarr
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'sonarr::default'

directory '/usr/local/etc/sonarr' do
  recursive true
end

group 'sonarr'

user 'sonarr' do
  action :create
  home '/usr/local/etc/sonarr'
  gid 'sonarr'
  system true
end

if node['media_server']['init_style'] == 'systemd'
  template '/lib/systemd/system/sonarr.service' do
    source 'sonarr_init.service.erb'
    mode 0644
    owner 'root'
    group 'root'
  end

else
  template '/etc/init.d/sonarr' do
    source 'sonarr_init.lsb.erb'
    mode 0755
    owner 'root'
    group 'root'
  end
end
