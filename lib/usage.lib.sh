###
# Usage du module WEBAPP
# ==============================================================================
# @package olixsh
# @module webapp
# @author Olivier <sabinus52@gmail.com>
##



###
# Usage principale  du module
##
function module_webapp_usage_main()
{
    logger_debug "module_webapp_usage_main ()"
    stdout_printVersion
    echo
    echo -e "Gestion des applications web"
    echo
    echo -e "${CBLANC} Usage : ${CVIOLET}$(basename ${OLIX_ROOT_SCRIPT}) ${CVERT}webapp ${CJAUNE}ACTION${CVOID}"
    echo
    echo -e "${CJAUNE}Liste des ACTIONS disponibles${CVOID} :"
    echo -e "${Cjaune} create  ${CVOID}  : Initialisation et création d'une nouvelle application"
    echo -e "${Cjaune} install ${CVOID}  : Installation de l'application depuis un autre serveur"
    echo -e "${Cjaune} help    ${CVOID}  : Affiche cet écran"
    echo -e "${CJAUNE}Liste des ACTIONS disponibles pour une webapp donnée${CVOID} :"
    echo -e "${Cjaune} config  ${CVOID}  : Visualise et modifie la configuration de l'application sur ce serveur"
    echo -e "${Cjaune} origin  ${CVOID}  : Visualise ou affecte un nouveau dépôt d'origine des sources"
    echo -e "${Cjaune} backup  ${CVOID}  : Fait une sauvegarde de l'application (base+fichiers)"
}


###
# Usage de l'action CREATE
##
function module_webapp_usage_create()
{
    logger_debug "module_webapp_usage_create ()"
    stdout_printVersion
    echo
    echo -e "Initialisation et création d'une nouvelle application"
    echo
    echo -e "${CBLANC} Usage : ${CVIOLET}$(basename ${OLIX_ROOT_SCRIPT}) ${CVERT}webapp ${CJAUNE}create${CVOID}"
}


###
# Usage de l'action INSTALL
##
function module_webapp_usage_install()
{
    logger_debug "module_webapp_usage_install ()"
    stdout_printVersion
    echo
    echo -e "Installation d'une application et copie des sources depuis un autre serveur"
    echo
    echo -e "${CBLANC} Usage : ${CVIOLET}$(basename ${OLIX_ROOT_SCRIPT}) ${CVERT}webapp ${CJAUNE}install${CVOID} ${CBLANC}[USER]@[HOST]:[PATH] [OPTIONS]${CVOID}"
    echo
    echo -e "${Ccyan}OPTIONS${CVOID}"
    echo -en "${CBLANC} --env=${OLIX_MODULE_WEBAPP_ENVIRONMENT} ${CVOID}"; stdout_strpad "--env=${OLIX_MODULE_WEBAPP_ENVIRONMENT}" 20 " "; echo " : Environnement (${OLIX_MODULE_WEBAPP_LISTENV})"
    echo -en "${CBLANC} --port=22 ${CVOID}"; stdout_strpad "--port=22" 20 " "; echo " : Port de connexion au host"
    echo
    echo -e "${CJAUNE}[USER]@[HOST]:[PATH]${CVOID} :"
    echo -e "${Cjaune} user ${CVOID} : Nom de l'utilisateur de connexion au serveur"
    echo -e "${Cjaune} host ${CVOID} : Host du serveur"
    echo -e "${Cjaune} path ${CVOID} : Chemin complet du fichier de configuration webapp.yml"
    echo -e "    Exemple : toto@domain.tld:/home/toto/conf/webapp.yml"
}


###
# Usage de l'action CONFIG
##
function module_webapp_usage_config()
{
    logger_debug "module_webapp_usage_config ()"
    stdout_printVersion
    echo
    echo -e "Visualise et modifie la configuration d'une application (l'installation doit être faite auparavant)"
    echo
    echo -e "${CBLANC} Usage : ${CVIOLET}$(basename ${OLIX_ROOT_SCRIPT}) ${CVERT}webapp ${CJAUNE}config${CVOID} ${CBLANC}<application>${CVOID}"
    echo
    echo -e "${CJAUNE}Liste des APPLICATIONS disponibles${CVOID} :"
    for I in $(module_webapp_getListApps); do
        echo -en "${Cjaune} ${I} ${CVOID}"
        stdout_strpad "${I}" 20 " "
        echo " : Application $(module_webapp_getLabel ${I})"
    done
}


###
# Usage de l'action ORIGIN
##
function module_webapp_usage_origin()
{
    logger_debug "module_webapp_usage_origin ()"
    stdout_printVersion
    echo
    echo -e "Visualise ou affecte un nouveau dépôt d'origine des sources"
    echo
    echo -e "${CBLANC} Usage : ${CVIOLET}$(basename ${OLIX_ROOT_SCRIPT}) ${CVERT}webapp ${CJAUNE}origin${CVOID} ${CBLANC}<application> [nouveau depot]${CVOID}"
    echo
    echo -e "${CJAUNE}Liste des APPLICATIONS disponibles${CVOID} :"
    for I in $(module_webapp_getListApps); do
        echo -en "${Cjaune} ${I} ${CVOID}"
        stdout_strpad "${I}" 20 " "
        echo " : Application $(module_webapp_getLabel ${I})"
    done
}


###
# Usage de l'action BACKUP
##
function module_webapp_usage_backup()
{
    logger_debug "module_webapp_usage_backup ()"
    stdout_printVersion
    echo
    echo -e "Installation d'une application et copie des sources depuis un autre serveur"
    echo
    echo -e "${CBLANC} Usage : ${CVIOLET}$(basename ${OLIX_ROOT_SCRIPT}) ${CVERT}webapp ${CJAUNE}backup${CVOID} ${CBLANC}<application> [OPTIONS]${CVOID}"
    echo
    echo -e "${Ccyan}OPTIONS${CVOID}"
    echo -en "${CBLANC} --env=${OLIX_MODULE_WEBAPP_ENVIRONMENT} ${CVOID}"; stdout_strpad "--env=${OLIX_MODULE_WEBAPP_ENVIRONMENT}" 20 " "; echo " : Environnement (${OLIX_MODULE_WEBAPP_LISTENV})"
    echo
    echo -e "${CJAUNE}Liste des APPLICATIONS disponibles${CVOID} :"
    for I in $(module_webapp_getListApps); do
        echo -en "${Cjaune} ${I} ${CVOID}"
        stdout_strpad "${I}" 20 " "
        echo " : Application $(module_webapp_getLabel ${I})"
    done
}


###
# Retourne les paramètres de la commandes en fonction des options
# @param $@ : Liste des paramètres
##
function module_webapp_usage_getParams()
{
    logger_debug module_webapp_usage_getParams
    local PARAM

    while [[ $# -ge 1 ]]; do
        case $1 in
            --env=*)
                IFS='=' read -ra PARAM <<< "$1"
                OLIX_MODULE_WEBAPP_ENVIRONMENT=${PARAM[1]}
                ;;
            --port=*)
                IFS='=' read -ra PARAM <<< "$1"
                OLIX_MODULE_WEBAPP_ORIGIN_PORT=${PARAM[1]}
                ;;
            *)
                [[ -z ${OLIX_MODULE_WEBAPP_CODE} ]] && OLIX_MODULE_WEBAPP_CODE=$1
                ;;
        esac
        shift
    done
    logger_debug "OLIX_MODULE_WEBAPP_ENVIRONMENT=${OLIX_MODULE_WEBAPP_ENVIRONMENT}"
    [[ -n ${OLIX_MODULE_WEBAPP_ENVIRONMENT} ]] && ! core_contains "${OLIX_MODULE_WEBAPP_ENVIRONMENT}" "${OLIX_MODULE_WEBAPP_LISTENV}" && logger_error "Paramètre environnement '--env=${OLIX_MODULE_WEBAPP_ENVIRONMENT}' invalide"
}
