# 🛠️ Doravel (en desarrollo)

Integrando Doravel en tu proyecto, no necesitas crear imagenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

---

**¿ que es doravel ?**
Es una imagen con todo lo necesario para tener laravel funcionando junto con un mecanismo para omitir varios procedimientos a la hora de instalar en el servidor ( *fedora* | *ubuntu* | *centos* )

# 😄 Beneficios
- [x] trabaja con varios entonos en el mismo proyecto
- [x] configura php, mysql y demas desde los archivos .env
- [x] auto configuracion de nginx
- [x] actualiza tu repositorio git cada 5 segundos
- [x] ejecuta tus comandos laravel con supervisord


# 👣 Paso 1
> copia y pega en la terminal de tu projecto laravel
> con eso podras obtener el instalador junto a las
> funcionalidades que te brinda DORAVEL

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/byancode/doravel/main/bin/init)
```

# 💻 Comandos

```bash
./doravel up --env prod
./doravel down --env prod
./doravel restart --env prod
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

## Docker run
```bash
docker run -p 80:80 byancode/doravel:php
```