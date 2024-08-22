
# New commands (In development)
```bash
./doravel local up -d
./doravel local [bash|ash|sh]
./doravel local test
./doravel local down
./doravel local ports [list|shuffle]
./doravel local [artisan|composer|tinker|npm|node|php]
./doravel local timestamp
# ENVIRONMENT
./doravel local env init
./doravel local env destroy
# DEPLOY
./doravel local deploy init
./doravel local deploy destroy
# TAIL
./doravel local tail # selecciona uno de los archivos de log
# SUPERVISOR
./doravel local supervisor start
./doravel local supervisor program list
./doravel local supervisor program create name
./doravel local supervisor program rm name
# PACKAGE
./doravel package create name
./doravel package test
./doravel package init
# PROJECT
./doravel project create name
./doravel project init
# DORAVEL
./doravel compose
./doravel upgrade
./doravel update
./doravel x bash
```