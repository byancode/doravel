# 🛠️ Doravel (Beta)

Integrando Doravel en tu proyecto, no necesitas crear imagenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

---

**¿ que es doravel ?**
Es una imagen con todo lo necesario para tener laravel funcionando junto con un mecanismo para omitir varios procedimientos a la hora de instalar en el servidor ( *fedora* | *ubuntu* | *centos* | *wsl* )

# 😄 Beneficios
- [x] trabaja con varios entornos en el mismo proyecto
- [x] configura php, mysql y demás desde los archivos .env
- [x] auto configuración de NGINX
- [x] actualiza tu repositorio git cada 5 segundos
- [x] ejecuta tus comandos laravel con supervisor

# 📦 Instalación
> copia y pega en consola de tu computadora
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/byancode/doravel/main/scripts/install) && source ~/.bashrc
```

# 💻 Comandos

```bash
./doravel prod up
./doravel prod down
./doravel prod restart
```

## Dockerfile
#### Variables de entorno
```env
# PHP
PHP_OPCACHE_ENABLE=true
PHP_UPLOAD_MAX_FILESIZE=1G
PHP_MAX_EXECUTION_TIME=60
PHP_POST_MAX_SIZE=1G
PHP_MEMORY_LIMIT=512M

# LARAVEL
LARAVEL_AUTO_SCHEDULE=true

# NPM
NPM_AUTO_INSTALL=true
NPM_AUTO_BUILD=true

# GIT
GIT_AUTO_PULL=false
```

## Octane Config
config/octane.php
```php
<?php
return [
    # ...
    'swoole' => [
        'options' => [
            'log_file' => storage_path('logs/swoole_http.log'),
            'package_max_length' => 10 * 1024 * 1024,
            'upload_max_filesize' => -1,
        ],
    ],
];
```

## Docker run
```bash
docker run -p 80:80 byancode/doravel:php-8.2
```