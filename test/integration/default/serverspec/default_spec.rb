require 'spec_helper'

RSpec.describe 'media_server::default' do
  describe file('/usr/local/src') do
    it { is_expected.to be_directory }
    it { is_expected.to exist }
  end

  describe file('/usr/local/bin/nzbget') do
    it { is_expected.to be_file }
    it { is_expected.to be_executable }
  end

  describe file('/usr/local/src/nzbget') do
    it { is_expected.to be_directory }
  end

  describe service('nginx') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe service('sonarr') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe service('nzbget') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
