#
# Cookbook Name:: media_server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'
require_relative 'shared_examples'

RSpec.shared_examples 'the media_server::sonarr recipe' do
  it 'includes sonarr::default' do
    expect(chef_run).to include_recipe 'sonarr::default'
  end

  it 'adds a group for the service' do
    expect(chef_run).to create_group('sonarr')
  end

  it 'adds a user for the service' do
    expect(chef_run).to create_user('sonarr').with(
      system: true,
      home: '/usr/local/etc/sonarr',
      gid: 'sonarr'
    )
  end
end

RSpec.describe 'media_server::sonarr' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  supported_platforms = {
    'debian' => %w(8.1 8.0 7.8 7.7 7.6),
    'ubuntu' => %w(15.10 15.04 14.10 14.04)
  }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        include_examples 'converges successfully'
      end
    end
  end
end
