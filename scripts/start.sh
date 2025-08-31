#!/usr/bin/env bash

echo "Starting Laravel Web Application..."

# Set working directory
cd /var/www/html

# Generate application key if not set
if [ -z "$APP_KEY" ]; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

# Run Laravel deployment script
echo "Running Laravel deployment tasks..."
bash /var/www/html/scripts/00-laravel-deploy.sh

# Run migrations (uncommented for production)
echo "Running migrations..."
php artisan migrate --force

# Clear and cache everything for production
echo "Clearing and caching for production..."
php artisan config:clear
php artisan config:cache
php artisan route:clear  
php artisan route:cache
php artisan view:clear
php artisan view:cache

# Set up Laravel Passport if needed
echo "Setting up Laravel Passport..."
php artisan passport:keys --force

# Configure nginx to use the PORT environment variable
echo "Configuring nginx for port $PORT..."
sed -i "s/listen 80;/listen $PORT;/" /etc/nginx/sites-available/default
sed -i "s/listen \[::\]:80;/listen [::]:$PORT;/" /etc/nginx/sites-available/default

# Start supervisord which manages nginx and php-fpm
echo "Starting web server on port $PORT..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
