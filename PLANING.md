
# New commands (In development)
```bash
./doravel local up -d
./doravel local [bash|ash|sh]
./doravel local test
./doravel local down
./doravel local init
./doravel local destroy
./doravel local [artisan|composer|tinker|npm|node|php]
./doravel local timestamp
# PORTS
./doravel local ports [list|shuffle]
./doravel local ports show [service]
# DEPLOY
./doravel local deploy init
./doravel local deploy push
./doravel local deploy destroy
# DEBUG
./doravel local debug logs
./doravel local debug swoole
# SUPERVISOR
./doravel local supervisor start
./doravel local supervisor program list
./doravel local supervisor program rm name
./doravel local supervisor program add name
# SERVICE
./doravel local service add minio
./doravel local service rm minio
# PACKAGE
./doravel package create name
./doravel package test
./doravel package init
# DORAVEL
./doravel compose
./doravel upgrade
./doravel update
./doravel new [name]
./doravel fix
./doravel x
```

# TODO

- [ ] integrar gh (github cli), doctl (digitalocean cli)
- [ ] implementar deploy key en el comando `./doravel local deploy init`
- [ ] definir un servidor de despliegue en el comando `./doravel local deploy init`