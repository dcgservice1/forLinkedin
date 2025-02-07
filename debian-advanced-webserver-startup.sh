#!/bin/bash

# Update package list and handle errors
apt-get update
if [ $? -ne 0 ]; then
  echo "Error: apt-get update failed"
  exit 1
fi

# Install Nginx and handle errors
apt-get install -y nginx
if [ $? -ne 0 ]; then
  echo "Error: apt-get install nginx failed"
  exit 1
fi

# More robust HTML modification (idempotent)
sed -i -- 's/<title>Welcome to nginx<\/title>/<title>Google Cloud Platform - '"\$HOSTNAME"'<\/title>/' /var/www/html/index.nginx-debian.html

# Start Nginx
service nginx start

echo "Nginx started and configured."
