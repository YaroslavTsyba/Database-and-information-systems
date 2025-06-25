CREATE USER admin_user WITH PASSWORD 'admin123';
CREATE USER moderator_user WITH PASSWORD 'mod123';
CREATE USER client_user WITH PASSWORD 'client123';

GRANT ALL PRIVILEGES ON DATABASE hospital TO admin_user;
GRANT CONNECT ON DATABASE hospital TO moderator_user;
GRANT CONNECT ON DATABASE hospital TO client_user;