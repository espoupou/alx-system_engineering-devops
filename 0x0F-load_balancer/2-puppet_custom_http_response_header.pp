# Automation: creates a custom HTTP header response with Puppet.
exec { 'command':
  command  => sprintf('apt-get -y update;
  apt-get -y install nginx;
  sudo sed -i "/listen 80 default_server;/a add_header X-Served-By %s;" /etc/nginx/sites-available/default;
  service nginx restart', $HOSTNAME),
  provider => shell,
}
