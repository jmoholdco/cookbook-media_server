#
# Cookbook Name:: media_server
# Recipe:: sonarr
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'sonarr::default'
service_user_dir = node['media_server']['services']['home']

user 'sonarr' do
  action :create
  home "#{service_user_dir}/sonarr"
  gid 'nogroup'
  system true
end
