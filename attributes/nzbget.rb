default['media_server']['nzbget'] = {
  'install_method' => 'source',
  'tag' => 'v16.0',
  'configuration' => '--with-libxml2-includes=/usr/include/libxml2 \
                      --with-libxml2-libraries=/usr/lib/x86_64-linux-gnu/libxml2.so',
  'dependencies' => %w(libxml2-dev libssl-dev libncurses5-dev build-essential git)
}
