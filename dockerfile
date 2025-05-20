# Usamos una imagen oficial PHP con extensiones comunes
FROM php:8.2-apache

# Instalamos dependencias necesarias
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip mbstring

# Activar mod_rewrite de Apache para Symfony
RUN a2enmod rewrite

# Instalamos Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalamos Symfony CLI (opcional, pero aquí te pongo cómo hacerlo)
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Copiamos todo el proyecto al contenedor
COPY . /var/www/html/

# Fijamos permisos para que Apache pueda leer/escribir (ajusta según usuario)
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Instalamos dependencias PHP con Composer
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Exponemos el puerto 80 para HTTP
EXPOSE 80

# Arrancamos Apache en primer plano
CMD ["apache2-foreground"]
