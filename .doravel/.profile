# ESTE ARCHIVO SE CARGARA AL EJECUTAR CUALQUIER SHELL
#
# EXPORT ENVIRONMENT VARIABLES
#
if [ -d "$APP_PATH/.doravel/bin" ]; then
    add_bin_path "$APP_PATH/.doravel/bin"
fi
#
# SET ALIAS FOR COMMANDS
#
alias d="doravel $APP_ENV"
alias a="doravel $APP_ENV artisan"
alias c="doravel $APP_ENV composer"
alias s="doravel $APP_ENV supervisorctl"