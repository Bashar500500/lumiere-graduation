# Laravel Deployment on Render.com - Standard Plan

This document outlines the deployment configuration for your Laravel application on Render.com with Standard plan support for queue jobs and cron jobs.

## Deployment Structure

Your application is configured to deploy as three separate services:

1. **Web Service** (`lumiere-web`) - Main Laravel application (Standard plan)
2. **Queue Worker** (`lumiere-queue-worker`) - Background job processing (Starter plan)
3. **Scheduler** (`lumiere-scheduler`) - Cron job execution (Cron service)
4. **Database** (`lumiere-db`) - PostgreSQL database (Starter plan)

## Required Environment Variables

### Essential Variables
Set these in your Render.com dashboard for all services:

```
APP_NAME=Lumiére
APP_ENV=production
APP_KEY=base64:your-generated-key-here
APP_DEBUG=false
APP_URL=https://your-app-name.onrender.com

LOG_CHANNEL=stderr
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=pgsql
DB_HOST=your-postgres-host
DB_PORT=5432
DB_DATABASE=lumiere_production
DB_USERNAME=lumiere_user
DB_PASSWORD=your-database-password

QUEUE_CONNECTION=database
SESSION_DRIVER=database
SESSION_LIFETIME=120
CACHE_DRIVER=database
```

### Optional Variables (configure as needed)
```
MAIL_MAILER=smtp
MAIL_HOST=your-mail-host
MAIL_PORT=587
MAIL_USERNAME=your-mail-username
MAIL_PASSWORD=your-mail-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS="noreply@yourdomain.com"
MAIL_FROM_NAME="${APP_NAME}"

# For file storage (if using S3)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket-name
AWS_USE_PATH_STYLE_ENDPOINT=false

# For broadcasting (if using Pusher)
BROADCAST_DRIVER=pusher
PUSHER_APP_ID=your-pusher-app-id
PUSHER_APP_KEY=your-pusher-key
PUSHER_APP_SECRET=your-pusher-secret
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

# Firebase configuration (if using)
FIREBASE_PROJECT_ID=your-firebase-project-id
```

## Deployment Steps

1. **Commit your changes:**
   ```bash
   git add .
   git commit -m "Add Render.com deployment configuration"
   git push origin main
   ```

2. **In Render.com Dashboard:**
   - Go to your existing service
   - Upgrade to Standard plan
   - Update environment variables
   - Deploy the updated configuration

3. **Or create new deployment:**
   - Create new service from GitHub repo
   - Choose "Blueprint" and select the `render.yaml` file
   - Configure environment variables
   - Deploy

## Files Added/Modified

- `render.yaml` - Main Render.com configuration
- `scripts/queue-worker.sh` - Queue worker startup script
- `scripts/scheduler.sh` - Scheduler startup script
- `start.sh` - Updated main web service startup script
- `RENDER_DEPLOYMENT.md` - This documentation

## Queue Configuration

The queue is configured to use the database driver by default. You can switch to Redis later by:
1. Adding a Redis service in `render.yaml`
2. Changing `QUEUE_CONNECTION=redis` environment variable
3. Redeploying the services

## Monitoring

With the Standard plan, you'll have:
- 24/7 uptime (no sleeping)
- Better performance metrics
- Support for background workers
- Scheduled job execution

## Troubleshooting

- Check service logs in Render dashboard
- Verify environment variables are set correctly
- Ensure database migrations run successfully
- Monitor queue worker for job processing
