# Doravel

Integrando Doravel en tu proyecto, no necesitas crear imagenes privadas, puedes ejecutar tu proyecto de forma segura mediante tu repositorio git privado

---

**¿ que es doravel ?**
Es una imagen con todo lo necesario para tener laravel funcionando junto con un mecanismo para omitir varios procedimientos a la hora de instalar en el servidor ( *fedora* | *ubuntu* )

# beneficios
- [x] trabaja con varios entonos en el mismo proyecto
- [x] configura php, mysql y demas desde los archivos .env
- [x] auto configuracion de nginx
- [x] actualiza tu repositorio git cada 5 segundos
- [x] ejecuta tus comandos laravel con supervisord


# paso 1
> copia y pega en la terminal de tu projecto laravel
> con eso podras obtener el instalador junto a las
> funcionalidades que te brinda DORAVEL

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/byancode/doravel/main/bin/init)
```

# comandos

```bash
./doravel up --env prod
./doravel down --env prod
./doravel restart --env prod
```

# docker install - optional


```bash
bash <(curl -fsSL https://raw.githubusercontent.com/byancode/doravel/main/bin/docker)
```