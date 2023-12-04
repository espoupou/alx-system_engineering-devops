#!/usr/bin/pup
# Install flask 2.1.0

exec { 'puppet-lint':
  command => 'pip3 install flask==2.1.0',
}

#package {'flask':
#  ensure   => '2.1.0',
#  provider => 'pip3'
#}
