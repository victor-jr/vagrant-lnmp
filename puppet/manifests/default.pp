exec { 'apt-get update': 
	command => '/usr/bin/apt-get update',
}

package { 'dotnet-sdk-2.1.3':
	ensure => present,
}

package { 'nginx': 
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php-cli':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'nodejs':
	ensure => present,
	require => Exec['apt-get update'],
}

service { 'nginx':
	ensure => running,
	require => Package['nginx'],
}

service { 'php7.0-fpm':
	ensure => running,
	require => Package['php'],
}


file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/vagrant',
	ensure => file,
	require => Package['nginx'],
	source => 'puppet:///modules/nginx/vagrant',
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable'],
	],
}
