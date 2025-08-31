#!/usr/bin/env bash

echo "Running Laravel Scheduler..."

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

# Run the Laravel scheduler
echo "Executing scheduled tasks..."
php artisan schedule:run --verbose

echo "Scheduler execution completed."
