# 🛠️ Doravel (Beta)

Integrando Doravel en tu proyecto, no necesitas crear imagenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

---

**¿ que es doravel ?**
Es una imagen con todo lo necesario para tener laravel funcionando junto con un mecanismo para omitir varios procedimientos a la hora de instalar en el servidor ( *fedora* | *ubuntu* | *centos* | *wsl* )

# 😄 Beneficios
- [x] trabaja con varios entornos en el mismo proyecto
- [x] configura php, mysql y demás desde los archivos .env
- [x] auto configuración de nginx
- [x] ejecuta tus comandos laravel con supervisord

# 📦 Instalación
> copia y pega en consola de tu computadora
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/byancode/doravel/develop/scripts/install) && source ~/.bashrc
```

# 💻 Comandos

```bash
# local
./doravel up
./doravel down
# production
./doravel prod up
./doravel prod down
```

## Dockerfile
#### Variables de entorno
```env
# PHP
PHP_OPCACHE_ENABLED=true
PHP_UPLOAD_MAX_FILESIZE=1G
PHP_MAX_EXECUTION_TIME=60
PHP_POST_MAX_SIZE=1G
PHP_MEMORY_LIMIT=512M

# NPM
NPM_AUTO_INSTALL=true
NPM_AUTO_BUILD=true
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