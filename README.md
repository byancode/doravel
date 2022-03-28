# Doravel

Integrando Doravel en tu proyecto, no necesitas crear imagenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

---

**¿ que es doravel ?**
Es una imagen con todo lo necesario para tener laravel funcionando junto con un mecanismo para omitir varios procedimientos a la hora de instalar en el servidor

# crear y registra las claves ssh para tu proyecto

Instala en tu servidor **Fedora** de manera rapida y segura

```bash
bash <(curl https://raw.githubusercontent.com/byancode/doravel/main/init)
```

# comandos basicos

encender proyecto

```bash
.doravel/start
```

reiniciar laravel

```bash
.doravel/restart
```

refrescar octane

```bash
.doravel/reload
```

detener proyecto

```bash
.doravel/stop
```

reparar permiso de archivos

```bash
.doravel/fix
```
