FROM dunglas/frankenphp:1.1-php8.3-alpine

# Install PCNTL extension which is required by Laravel Octane
RUN docker-php-ext-install pcntl

# Copy Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy application files
COPY . .

# Install production dependencies
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Expose Octane's default port
EXPOSE 8000

# Production environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_KEY=base64:xJ5eXh3S6k8tW0m3b2N1c4vP7qR9uY8zT0aB1c2D3e4=
ENV OCTANE_SERVER=frankenphp

# Run Laravel Octane
CMD ["php", "artisan", "octane:start", "--host=0.0.0.0", "--port=8000"]
