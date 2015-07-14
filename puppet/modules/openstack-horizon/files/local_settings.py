import os

from django.utils.translation import ugettext_lazy as _
from openstack_dashboard import exceptions

DEBUG = False
TEMPLATE_DEBUG = DEBUG

# https://wiki.openstack.org/wiki/ReleaseNotes/Kilo#Key_New_Features_4
LAUNCH_INSTANCE_NG_ENABLED = True

HORIZON_CONFIG = {
	'dashboards': ('project', 'admin', 'settings',),
	'default_dashboard': 'project',
	'user_home': 'openstack_dashboard.views.get_user_home',
	'ajax_queue_limit': 10,
	'auto_fade_alerts': {
		'delay': 3000,
		'fade_duration': 1500,
		'types': ['alert-success', 'alert-info']
	},
	'help_url': "http://docs.openstack.org",
	'exceptions': {
        'recoverable': exceptions.RECOVERABLE,
        'not_found': exceptions.NOT_FOUND,
        'unauthorized': exceptions.UNAUTHORIZED
    },
}

LOCAL_PATH = os.path.dirname(os.path.abspath(__file__))

from horizon.utils import secret_key
SECRET_KEY = secret_key.generate_or_read_from_file('/etc/openstack-dashboard/secret_key')

SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
CACHES = {
   'default': {
	   'BACKEND' : 'django.core.cache.backends.memcached.MemcachedCache',
	   'LOCATION' : 'memcached.openstack.sj.ifsc.edu.br:11211',
   }
}

try:
	from ubuntu_theme import *
except ImportError:
	pass

LOGIN_URL='/horizon/auth/login/'
LOGOUT_URL='/horizon/auth/logout/'
LOGIN_REDIRECT_URL='https://openstack.sj.ifsc.edu.br/horizon/'
COMPRESS_OFFLINE = True
ALLOWED_HOSTS = '*'
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
OPENSTACK_HOST = "keystone.openstack.sj.ifsc.edu.br"
OPENSTACK_KEYSTONE_DEFAULT_ROLE = "_member_"

# Based on https://docs.hpcloud.com/helion/openstack/1.1/services/identity/configure/
OPENSTACK_API_VERSIONS = { "identity": 3, }
OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST

OPENSTACK_KEYSTONE_BACKEND = {
	'name': 'native',
	'can_edit_user': True,
	'can_edit_group': True,
	'can_edit_project': True,
	'can_edit_domain': True,
	'can_edit_role': True
}

OPENSTACK_HYPERVISOR_FEATURES = {
	'can_set_mount_point': False,
	'can_set_password': False,
}

OPENSTACK_CINDER_FEATURES = {
	'enable_backup': True,
}

OPENSTACK_NEUTRON_NETWORK = {
	'enable_lb': True,
	'enable_firewall': False,
	'enable_quotas': True,
	'enable_router': True,
	'enable_ipv6': True,
	'enable_distributed_router': False,
	'enable_ha_router': False,
	'enable_vpn': False,
	'profile_support': None,
	'supported_provider_types': ['*'],
}

IMAGE_CUSTOM_PROPERTY_TITLES = {
	"architecture": _("Architecture"),
	"kernel_id": _("Kernel ID"),
	"ramdisk_id": _("Ramdisk ID"),
	"image_state": _("Euca2ools state"),
	"project_id": _("Project ID"),
	"image_type": _("Image Type")
}

API_RESULT_LIMIT = 1000
API_RESULT_PAGE_SIZE = 20
TIME_ZONE = "UTC"

LOGGING = {
	'version': 1,
	'disable_existing_loggers': False,
	'handlers': {
		'null': {
			'level': 'DEBUG',
			'class': 'django.utils.log.NullHandler',
		},
		'console': {
			'level': 'INFO',
			'class': 'logging.StreamHandler',
		},
	},
	'loggers': {
		'django.db.backends': {
			'handlers': ['null'],
			'propagate': False,
		},
		'requests': {
			'handlers': ['null'],
			'propagate': False,
		},
		'horizon': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'openstack_dashboard': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'novaclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'cinderclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'keystoneclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'glanceclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'neutronclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'heatclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'ceilometerclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'troveclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'swiftclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'openstack_auth': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'nose.plugins.manager': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'django': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'iso8601': {
			'handlers': ['null'],
			'propagate': False,
		},
		'scss': {
			'handlers': ['null'],
			'propagate': False,
		},
	}
}

SECURITY_GROUP_RULES = {
	'all_tcp': {
		'name': _('All TCP'),
		'ip_protocol': 'tcp',
		'from_port': '1',
		'to_port': '65535',
	},
	'all_udp': {
		'name': _('All UDP'),
		'ip_protocol': 'udp',
		'from_port': '1',
		'to_port': '65535',
	},
	'all_icmp': {
		'name': _('All ICMP'),
		'ip_protocol': 'icmp',
		'from_port': '-1',
		'to_port': '-1',
	},
	'ssh': {
		'name': 'SSH',
		'ip_protocol': 'tcp',
		'from_port': '22',
		'to_port': '22',
	},
	'smtp': {
		'name': 'SMTP',
		'ip_protocol': 'tcp',
		'from_port': '25',
		'to_port': '25',
	},
	'dns': {
		'name': 'DNS',
		'ip_protocol': 'tcp',
		'from_port': '53',
		'to_port': '53',
	},
	'http': {
		'name': 'HTTP',
		'ip_protocol': 'tcp',
		'from_port': '80',
		'to_port': '80',
	},
	'pop3': {
		'name': 'POP3',
		'ip_protocol': 'tcp',
		'from_port': '110',
		'to_port': '110',
	},
	'imap': {
		'name': 'IMAP',
		'ip_protocol': 'tcp',
		'from_port': '143',
		'to_port': '143',
	},
	'ldap': {
		'name': 'LDAP',
		'ip_protocol': 'tcp',
		'from_port': '389',
		'to_port': '389',
	},
	'https': {
		'name': 'HTTPS',
		'ip_protocol': 'tcp',
		'from_port': '443',
		'to_port': '443',
	},
	'smtps': {
		'name': 'SMTPS',
		'ip_protocol': 'tcp',
		'from_port': '465',
		'to_port': '465',
	},
	'imaps': {
		'name': 'IMAPS',
		'ip_protocol': 'tcp',
		'from_port': '993',
		'to_port': '993',
	},
	'pop3s': {
		'name': 'POP3S',
		'ip_protocol': 'tcp',
		'from_port': '995',
		'to_port': '995',
	},
	'ms_sql': {
		'name': 'MS SQL',
		'ip_protocol': 'tcp',
		'from_port': '1433',
		'to_port': '1433',
	},
	'mysql': {
		'name': 'MYSQL',
		'ip_protocol': 'tcp',
		'from_port': '3306',
		'to_port': '3306',
	},
	'rdp': {
		'name': 'RDP',
		'ip_protocol': 'tcp',
		'from_port': '3389',
		'to_port': '3389',
	},
}

FLAVOR_EXTRA_KEYS = {
	'flavor_keys': [
		('quota:read_bytes_sec', _('Quota: Read bytes')),
		('quota:write_bytes_sec', _('Quota: Write bytes')),
		('quota:cpu_quota', _('Quota: CPU')),
		('quota:cpu_period', _('Quota: CPU period')),
		('quota:inbound_average', _('Quota: Inbound average')),
		('quota:outbound_average', _('Quota: Outbound average')),
	]
}
