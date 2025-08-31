#!/usr/bin/env bash

echo "Starting Laravel Queue Worker..."

# Set working directory
cd /var/www/html

# Generate application key if not set
if [ -z "$APP_KEY" ]; then
    echo "Generating application key..."
    php artisan key:generate --show
fi

# Cache configuration for performance
echo "Caching config..."
php artisan config:cache

# Clear any existing queue cache
echo "Clearing queue cache..."
php artisan queue:clear

# Start the queue worker with restart options
echo "Starting queue worker..."
php artisan queue:work \
    --verbose \
    --tries=3 \
    --timeout=90 \
    --memory=512 \
    --sleep=3 \
    --max-jobs=1000 \
    --max-time=3600
