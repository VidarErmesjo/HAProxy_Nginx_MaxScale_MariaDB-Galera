ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass';
#UPDATE mysql.user SET Password=PASSWORD('rootpass') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='maxscaleuser' AND Host NOT IN ('maxscale', 'localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
