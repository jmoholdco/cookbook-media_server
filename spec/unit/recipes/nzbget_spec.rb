#
# Cookbook Name:: media_server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'
require_relative 'shared_examples'
RSpec.shared_examples 'the media_server::nzbget recipe' do
  it 'installs all the dependencies' do
    %w(libxml2-dev libssl-dev libncurses5-dev build-essential git).each do |d|
      expect(chef_run).to install_package d
    end
  end

  it 'clones the git source' do
    expect(chef_run).to sync_git('/usr/local/src/nzbget').with(
      repository: 'https://github.com/nzbget/nzbget',
      revision: 'v16.0'
    )
  end

  it 'the git source clone notifies the install script to run' do
    git_src = chef_run.git('/usr/local/src/nzbget')
    expect(git_src).to notify('bash[install_nzbget_git]').to(:run).immediately
  end

  it 'adds a user for the service' do
    expect(chef_run).to create_user('nzbget').with(
      system: true,
      home: '/var/media_server/nzbget',
      gid: 'nogroup'
    )
  end
end

RSpec.describe 'media_server::nzbget' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  context 'When all attributes are default, on an unspecified platform' do
    let(:opts) { {} }
    include_examples 'converges successfully'
    it_behaves_like 'the media_server::nzbget recipe'
  end

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
