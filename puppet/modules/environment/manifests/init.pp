class environment {

	package { 'bash-completion':
		ensure => latest,
		before => File['.bashrc'],
	}

	file { '.bashrc':
		path	=> '/root/.bashrc',
		ensure	=> file,
		source	=> 'puppet:///modules/environment/.bashrc',
		owner	=> root,
		mode	=> 0600,
	}

	file { '.bash_aliases':
		path	=> '/root/.bash_aliases',
		ensure	=> file,
		source	=> 'puppet:///modules/environment/.bash_aliases',
		owner	=> root,
		mode	=> 0600,
	}

	file { '.bash_logout':
		path	=> '/root/.bash_logout',
		ensure	=> file,
		source	=> 'puppet:///modules/environment/.bash_logout',
		owner	=> root,
		mode	=> 0600,
	}

	package { 'vim':
		ensure => latest,
		before => File['.vimrc'],
	}

	file { '.vimrc':
		path	=> '/root/.vimrc',
		ensure	=> file,
		source	=> 'puppet:///modules/environment/.vimrc',
		owner	=> root,
		mode	=> 0600,
	}

}
