CREATE DATABASE IF NOT EXISTS cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'cinder';
FLUSH PRIVILEGES;
