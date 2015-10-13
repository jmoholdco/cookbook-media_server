#
# Cookbook Name:: media_server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'media_server::ohai' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  context 'When all attributes are default, on an unspecified platform' do
    let(:opts) { {} }
    include_examples 'converges successfully'
  end
  supported_platforms = {
    'ubuntu' => %w(12.04 14.04 15.10),
    'centos' => %w(7.0 7.1.1503)
  }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      let(:opts) { { platform: platform, version: version } }
      include_examples 'converges successfully'
    end
  end
end
