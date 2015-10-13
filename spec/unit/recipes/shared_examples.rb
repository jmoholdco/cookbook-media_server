RSpec.shared_examples 'converges successfully' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end

RSpec.shared_examples 'the default recipe' do
  subject { chef_run }
  it { is_expected.to include_recipe 'media_server::nzbget' }
  it { is_expected.to create_directory('/usr/local/src') }
  it { is_expected.to create_directory('/var/media_server') }
  it { is_expected.to include_recipe 'apt' }
  it { is_expected.to include_recipe 'bluepill' }
  it { is_expected.to include_recipe 'nfs::client4' }
  it { is_expected.to include_recipe 'media_server::nginx' }
  it { is_expected.to include_recipe 'media_server::sonarr' }
  it { is_expected.to include_recipe 'media_server::bluepill' }
end
