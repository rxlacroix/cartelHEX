#' @title Charger la couche cartographique adaptée à vos données
#' @name loadMap
#' @description Charger la couche cartographique adaptée à vos données en indiquant l'année du code officiel géographique (COG) ainsi que le niveau géographique (communal ou supra-communal) souhaités
#' @param destfile indique le "path" où sera enregistrée la couche cartographique téléchargée (4 fichiers shp,shx,prj et dbf). Par défaut vaut tempfile() (répertoire temporaire)
#' @param COG indique l'année de COG de la table communale considérée. (exemple 2017). Années possibles : de 2015 à 2019. Par défaut, vaut annee_ref.
#' @param nivsupra est une chaîne de caractères qui indique le nom du niveau supra-communale souhaité. Plus précisément :
#' - "DEP" : départements
#' - "REG" : régions
#' - "EPCI" : EPCI au 01/01/20XX
#' - "ARR" : arrondissements au 01/01/20XX
#' - "CV" : cantons-villes au 01/01/20XX
#' - "ZE2010" : zones d'emploi 2010
#' - "UU2010" : unités urbaines 2010
#' - "AU2010" : aires urbaines 2010
#' - "BV2012" : bassins de vie 2012
#' @param enlever_PLM vaut TRUE si on souhaite enlever de la carte les arrondissements municipaux de Paris, Lyon et Marseille si nivsupra="COM (fonctionne pour les millésimes postérieurs à 2019 en raison de modification des fichiers IGN). Par défaut, vaut annee_ref.
#' @param donnees_insee vaut TRUE si les données manipulées sont produites par l'Insee. En effet, quelques rares modifications communales (la défusion des communes Loisey et Culey au 1er janvier 2014 par exemple) ont été prises en compte dans les bases de données communales de l'Insee plus tard que la date officielle.
#' @details
#' La fonction renvoie une couche cartographique de type "sf"
#'
#' Le code officiel géographique le plus récent du package est actuellement celui au 01/01/2019. \cr
#'
#' Les millésimes des COG qui peuvent être utilisés sont à ce stade les suivants : 2015, 2016, 2017, 2018 et 2019. \cr
#' @references
#' \itemize{
#' \item{\href{http://professionnels.ign.fr/adminexpress}{couches cartographiques Admin-Express (IGN)}}
#' \item{\href{http://professionnels.ign.fr/geofla}{couches cartographiques GEOFLA (IGN)}}}
#' @export
#' @examples
#' ## Exemple 1
#' \dontrun{
#' ## Traitement long a tourner (telecharge les fichiers dans tempdir())
#'  reg_sf <- loadMap(COG=2016,nivsupra="REG")
#'  par(mar=c(0,0,0,0))
#'  plot(sf::st_geometry(reg_sf))
#' }
#'
#' #' ## Exemple 2
#' \dontrun{
#' ## Traitement long a tourner (telecharge les fichiers dans tempdir())
#'  com_sf_sansPLM <- loadMap(COG=2019,nivsupra="COM",enlever_PLM=TRUE)
#'  com_sf_avecPLM <- loadMap(COG=2019,nivsupra="COM",enlever_PLM=FALSE)
#'  par(mar=c(0,0,0,0))
#'  plot(sf::st_geometry(com_sf_sansPLM %>% filter(substr(INSEE_COM,1,2)%in%c("75")) ))
#'  plot(sf::st_geometry(com_sf_avecPLM %>% filter(substr(INSEE_COM,1,2)%in%c("75")) ))
#' }
#'
#' @encoding UTF-8
#' @importFrom dplyr %>% filter
#' @importFrom utils download.file
#'


loadMap <- function(destfile=tempdir(),COG=annee_ref,nivsupra,enlever_PLM=TRUE,donnees_insee=F){
    url <- paste0("https://raw.githubusercontent.com/rxlacroix/cartelHEX/master/couches_carto/COG",COG,"/")
    download.file(paste0(url,nivsupra,"_",COG,"_cartelHEX.gpkg"),destfile = paste0(destfile,"/",nivsupra,"_",COG,"_cartelHEX.gpkg"),method="auto",mode="wb")


    couche <- sf::st_read(dsn=paste0(destfile,"/",nivsupra,"_",COG,"_cartelHEX.gpkg"),stringsAsFactors = F)

    return(couche)

  }

