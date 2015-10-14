default['media_server']['source_dir'] = '/usr/local/src'
default['media_server']['services'] = {
  'home' => '/var/media_server'
}

if node['platform_version'].to_f >= 15.0
  default['nfs']['service']['lock'] = 'rpc-statd'
  default['nfs']['service']['idmap'] = 'nfs-client.target'
  default['nfs']['service_provider']['idmap'] = Chef::Provider::Service::Systemd
  default['nfs']['service_provider']['portmap'] = Chef::Provider::Service::Systemd # rubocop:disable Metrics/LineLength
  default['nfs']['service_provider']['lock'] = Chef::Provider::Service::Systemd
end

default['media_server']['sonarr']['user'] = 'sonarr'
default['media_server']['init_style'] = if node['platform_version'].to_f >= 15
                                          'systemd'
                                        else
                                          'default'
                                        end
