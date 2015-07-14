class openstack-horizon::common {

	package { 'memcached':
		ensure => installed,
	}

	package { 'python-memcache':
		ensure => installed,
		require => Package['memcached'],
	}

	file { 'memcached.conf':
		path => '/etc/memcached.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/memcached.conf',
		owner => root,
		group => memcache,
		mode => 0640,
		require => Package['memcached'],
	}

	service { 'memcached':
		ensure => running,
		enable => true,
		subscribe => File['memcached.conf'],
	}

	package { 'apache2':
		ensure => installed,
	}

	package { 'libapache2-mod-wsgi':
		ensure => installed,
		require => Package['apache2'],
	}

	file { 'etc:openstack-dashboard':
		path => '/etc/openstack-dashboard',
		ensure => directory,
		owner => root,
		group => horizon,
		mode => 0775,
	}

	# Created with http://strongpasswordgenerator.com.
	file { 'secret_key':
		path => '/etc/openstack-dashboard/secret_key',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/secret_key',
		owner => horizon,
		group => horizon,
		mode =>	0600,
		require => File['etc:openstack-dashboard'],
	}

	file { 'local_settings.py':
		path => '/etc/openstack-dashboard/local_settings.py',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/local_settings.py',
		owner => root,
		group => horizon,
		mode =>	0640,
		require => [
			Package['python-memcache'],
			File['etc:openstack-dashboard'],
			File['secret_key'],
		],
	}

	file { 'apache2.conf':
		path => '/etc/apache2/sites-available/horizon.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/apache2.conf',
		owner => root,
		group => www-data,
		mode => 0640,
		require => Package['apache2'],
	}

	exec { 'a2ensite horizon':
		command => '/usr/sbin/a2ensite horizon',
		creates => '/etc/apache2/sites-enabled/horizon.conf',
		require => File['apache2.conf'],
	}

	exec { 'a2dissite 000-default':
		command => '/usr/sbin/a2dissite 000-default',
		subscribe => Exec['a2ensite horizon'],
		refreshonly => true,
	}

}

class openstack-horizon::package inherits openstack-horizon::common {

	package { 'openstack-dashboard':
		ensure => installed,
	}

	package { 'openstack-dashboard-ubuntu-theme':
		ensure => absent,
	}

	File <| title == 'local_settings.py' |> {
		require => [
			Package['python-memcache'],
			Package['openstack-dashboard'],
			File['etc:openstack-dashboard'],
			File['secret_key'],
		],
	}

	exec { 'a2enmod:rewrite':
		command => '/usr/sbin/a2enmod rewrite',
		creates => '/etc/apache2/mods-enabled/rewrite.conf',
		require => Package['apache2'],
	}

	service { 'apache2':
		ensure => running,
		enable => true,
		subscribe => [
			File['secret_key'],
			File['local_settings.py'],
			File['apache2.conf'],
			Exec['a2ensite horizon'],
			Exec['a2dissite 000-default'],
			Exec['a2enmod:rewrite'],
		],
	}

}

class openstack-horizon::avos inherits openstack-horizon::common {

	package { 'openstack-dashboard':
		ensure => absent,
	}

	package { 'openstack-dashboard-ubuntu-theme':
		ensure => absent,
	}

	exec{ 'git:avos':
		command => 'git clone https://github.com/ciscosystems/avos.git /var/www/html/avos',
		creates => '/var/www/html/avos/.git',
		require => [
			Package['apache2'],
			Package['openstack-dashboard']
		],
	}

	File <| title == 'local_settings.py' |> {
		require => [
			Package['python-memcache'],
			Package['openstack-dashboard'],
			Exec['git:avos'],
			File['etc:openstack-dashboard'],
			File['secret_key'],
		],
	}

	file { 'local_setting.py:link':
		path => '/var/www/html/avos/openstack_dashboard/local/local_settings.py',
		ensure => link,
		target => '/etc/openstack-dashboard/local_settings.py',
		owner => root,
		group => www-data,
		require => [
			File['local_settings.py'],
			Exec['git:avos'],
		],
	}
	
	package { [
		'libpython-dev',
		'libffi-dev',
		'libssl-dev',
		'python-django',
		'python-pyscss',
		'python-django-pyscss',
		]:
		ensure => installed,
	}

	exec { 'pip:install:xstatic':
		command => 'pip install \
			XStatic \
			XStatic-Angular \
			XStatic-Angular-Cookies \
			XStatic-Angular-Mock \
			XStatic-Bootstrap-Datepicker \
			XStatic-Bootstrap-SCSS \
			XStatic-D3 \
			XStatic-Font-Awesome \
			XStatic-Hogan \
			XStatic-Jasmine \
			XStatic-jQuery \
			XStatic-JQuery-Migrate \
			XStatic-jquery-ui \
			XStatic-JQuery.quicksearch \
			XStatic-JQuery.TableSorter \
			XStatic-JSEncrypt \
			XStatic-QUnit \ 
			XStatic-Rickshaw \ 
			XStatic-Spin',
		subscribe => Package['python-django'],
		refreshonly => yes,
	}

	file { 'avos.conf':
		path => '/etc/init/avos.conf',
		
	}

	service { 'apache2':
		ensure => stopped,
		enable => false,
	}

	service { 'avos':
		ensure => running,
		enable => true,
		subscribe => [
			File['secret_key'],
			File['local_settings.py'],
			File['local_settings.py:link'],
			Exec['git:avos'],
			Exec['pip:install:xstatic'],
		],
	}

}