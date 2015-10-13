#
# Cookbook Name:: media_server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'
require_relative 'shared_examples'

RSpec.describe 'media_server::nginx' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  supported_platforms = {
    'debian' => %w(8.1 8.0 7.8 7.7 7.6),
    'ubuntu' => %w(15.10 15.04 14.10 14.04)
  }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        before do
          stub_command('which nginx').and_return(nil)
        end
        let(:opts) { { platform: platform, version: version } }
        include_examples 'converges successfully'
        subject { chef_run }
        it { is_expected.to include_recipe 'media_server::ohai' }

        it 'adds the upstream repo' do
          expect(chef_run).to add_apt_repository('nginx').with(
            uri: "http://nginx.org/packages/#{platform}",
            components: %w(nginx),
            deb_src: true,
            key: 'http://nginx.org/keys/nginx_signing.key'
          )
        end

        it { is_expected.to install_package('nginx') }
        it { is_expected.to enable_service('nginx') }

        describe 'setting up the directory structure' do
          it { is_expected.to create_directory('/etc/nginx') }
          it { is_expected.to create_directory('/var/log/nginx') }
          it { is_expected.to create_directory('/var/run') }
          it { is_expected.to create_directory('/etc/nginx/sites-available') }
          it { is_expected.to create_directory('/etc/nginx/sites-enabled') }
          it { is_expected.to create_directory('/etc/nginx/conf.d') }
        end

        describe 'nxscripts' do
          it 'creates /usr/sbin/nxensite' do
            expect(chef_run).to create_template('/usr/sbin/nxensite').with(
              source: 'nxensite.erb',
              mode: '0755',
              owner: 'root'
            )
          end

          it 'creates /usr/sbin/nxdissite' do
            expect(chef_run).to create_template('/usr/sbin/nxdissite').with(
              source: 'nxdissite.erb',
              mode: '0755',
              owner: 'root'
            )
          end
        end
        # it 'installs the package nginx' do
        #   expect(chef_run).to install_package 'nginx'
        # end

        it 'creates the nginx.conf template' do
          expect(chef_run).to create_template('/etc/nginx/nginx.conf').with(
            source: 'nginx.conf.erb',
            owner: 'root',
            mode: '0644'
          )
        end

        it 'creates the default site template' do
          expect(chef_run).to create_template(
            '/etc/nginx/sites-available/default').with(
              source: 'reverse-proxy.erb',
              owner: 'root',
              mode: '0644'
            )
        end

        it 'enables the site' do
          expect(chef_run).to run_execute('nxensite default').with(
            command: '/usr/sbin/nxensite default'
          )
        end

        describe 'notifications' do
          let(:conf) { chef_run.template('/etc/nginx/nginx.conf') }
          let(:site) { chef_run.template('/etc/nginx/sites-available/default') }
          let(:ensite) { chef_run.execute('nxensite default') }

          describe 'the configuration template' do
            it 'notifies the service to reload' do
              expect(conf).to notify('service[nginx]').to(:reload).delayed
            end
          end

          describe 'the site template' do
            it 'notifies the service to reload' do
              expect(site).to notify('service[nginx]').to(:reload).delayed
            end
          end

          describe 'enabling the site' do
            it 'notifies the service to reload' do
              expect(ensite).to notify('service[nginx]').to(:reload).delayed
            end
          end
        end
      end
    end
  end
end
