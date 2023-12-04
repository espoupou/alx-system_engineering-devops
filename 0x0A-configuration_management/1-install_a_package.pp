#!/usr/bin/pup
# Install flask 2.1.0

exec { 'flask':
  command => '/usr/bin/pip3 install flask==2.1.0 werkzeug==2.2.2',
}
