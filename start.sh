#!/usr/bin/env bash

echo "Starting Laravel Web Service..."

# Set working directory
cd /var/www/html

# Install composer dependencies
echo "Installing composer dependencies..."
composer install --no-dev --optimize-autoloader

# Generate application key if not set
if [ -z "$APP_KEY" ]; then
    echo "Generating application key..."
    php artisan key:generate --show
fi

# Cache configuration for performance
echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Caching views..."
php artisan view:cache

# Run database migrations
echo "Running migrations..."
php artisan migrate --force

# Create jobs table for queue (if using database driver)
echo "Setting up queue tables..."
php artisan queue:table --create 2>/dev/null || echo "Queue table already exists or not needed"
php artisan queue:failed-table --create 2>/dev/null || echo "Failed jobs table already exists or not needed"

# Set up Laravel Passport (if using it)
if grep -q "laravel/passport" /var/www/html/composer.json; then
    echo "Setting up Laravel Passport..."
    php artisan passport:keys --force || echo "Passport keys already exist"
fi

# Publish any vendor assets
echo "Publishing vendor assets..."
php artisan vendor:publish --tag=public --force || echo "No vendor assets to publish"

# Clear and warm up caches
echo "Optimizing application..."
php artisan optimize

echo "Laravel web service startup completed!"
