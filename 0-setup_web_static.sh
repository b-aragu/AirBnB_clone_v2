#!/bin/env bash

# Install Nginx if not already installed
sudo apt-get update
sudo apt-get -y install nginx

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared

# Create fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" | sudo tee /data/web_static/releases/test/index.html

# Create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership to ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_content="server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location /hbnb_static {
        alias /data/web_static/current/;
    }

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=dQw4w9WgXcQ;
    }

    location / {
        add_header X-Served-By $HOSTNAME;
        proxy_pass http://localhost:5000;
    }
}"
echo "$config_content" | sudo tee /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart

exit 0

