# Doravel

Integrando Doravel en tu proyecto, no necesitas crear imagenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

---

**¿ que es doravel ?**
Es una imagen con todo lo necesario para tener laravel funcionando junto con un mecanismo para omitir varios procedimientos a la hora de instalar en el servidor

# crear y registra las claves ssh para tu proyecto

con esto tendremos una facil instalacion en el servidor y de la forma mas segura dado que la clave solo puede tener permiso de lectura

```bash
bash <(curl https://raw.githubusercontent.com/byancode/doravel/main/init)
```

# comandos basicos

encender proyecto

```bash
.doravel/start
```

detener proyecto

```bash
.doravel/stop
```
