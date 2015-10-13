#
# Cookbook Name:: media_server
# Recipe:: bluepill
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

template '/etc/bluepill/media_server.pill' do
  source 'media_server.pill.erb'
end

bluepill_service 'media_server' do
  action [:enable, :load, :start]
end
