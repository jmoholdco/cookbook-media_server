#
# Cookbook Name:: media_server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe 'media_server::default' do
  before { stub_command('which nginx').and_return nil }
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
        it_behaves_like 'the default recipe'
      end
    end
  end
end
