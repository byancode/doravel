# 🛠️ Doravel (Dev)

Integrando Doravel en tu proyecto, no necesitas crear imágenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

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
bash <(curl -fsSL "https://raw.githubusercontent.com/byancode/doravel/develop/bin/install")
```
> Implementa las siguientes lineas en tu archivo .bashrc, .zshrc, .shrc
```Shell
eval "$(doravel env)"
```
### Crea tu primer proyecto doravel
```bash
doravel new myproject
```
```bash
cd myproject
```
### Integra doravel en tu proyecto laravel existente
```bash
doravel setup
```

# 💻 Comandos

```bash
# local
doravel up -d
doravel down
# production
doravel prod up -d --build
doravel prod down
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