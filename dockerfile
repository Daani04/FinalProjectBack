# Dockerfile
FROM php:8.2-cli

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    curl \
    libpq-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia los archivos del proyecto
WORKDIR /app
COPY . .

# Instala dependencias de Symfony
RUN composer install --no-interaction --no-progress --prefer-dist

# Expone el puerto para Render
EXPOSE 8080

# Render asigna el puerto a $PORT
ENV PORT=8080

# Comando para ejecutar el servidor Symfony
CMD php -S 0.0.0.0:$PORT -t public
