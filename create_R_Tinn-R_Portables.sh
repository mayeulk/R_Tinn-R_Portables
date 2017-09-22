#!/bin/bash
# Licence de ce script: GPL v2 ou ultérieurement
# Auteur: Mayeul KAUFFMANN
# Pour rendre ce script exécutable, faire:
# chmod a+x ./creer_R_Tinn-R_Portables_2009-03-25
# Historique:
# 2009-02-26 Première version
# 2009-03-25 Ajout du paquet rgrs. Suppression de "chtml ," dans la ligne où R (via wine) installe le programme de base (bug sur disque réseau). Commentaires.


# Ce script exécutable sous GNU/Linux nécessite quelques outils, que l'on peut installer sous Debian et Ubuntu avec :
# sudo apt-get install wget wine zip unzip

########################################
# Commentaire sur l'usage de ce script #
########################################
# EXTRAITS de rw-FAQ.html (Version for R-2.8.1), http://cran.r-project.org/bin/windows/base/rw-FAQ.html
# [This] will only run on Windows 2000 or later
# Your file system must allow case-honouring long file names (as is likely except perhaps for some network-mounted systems).
# Running R does need access to a writable temporary directory and to a home directory, and in the last resort these are taken to be the current directory. This should be no problem on a properly configured version of Windows, but otherwise does mean that it may not be possible to run R without creating a shortcut in a writable folder. 
# Installing to a network share (a filepath starting with \\machine\...) is not supported: such paths will need to mapped to a network drive. 

# A utiliser avec précaution: écrasera toute installation précédemment faite dans le même dossier

interface="SILENT"
# Décommenter la ligne suivante pour l'installation sans fenêtre de suivi (utile pour utilisation sans serveur X ?)
# interface="VERYSILENT"

### MODIFIER LA LIGNE SUIVANTE SI UNE VERSION DE R PLUS RECENTE EXISTE
dernierR="R-2.8.1" # nom (sans extension ni "-win32") du fichier .exe téléchargeable sur http://cran.r-project.org/bin/windows/base/

mirroir="http://cran.cict.fr"

aujourdhui=`date +%Y-%m-%d`
pathUNIX='/home/'$USER'/.wine/drive_c/RTinnRPortables'$aujourdhui'/'
echo $pathUNIX

mkdir --verbose --parents $pathUNIX"temp"
mkdir --verbose --parents $pathUNIX$dernierR"TinnR-portables"
cd $pathUNIX"temp"
#Télécharger R pour Windows sur http://cran.r-project.org/bin/windows/base/
#L'executable est dans notre cas: R-2.8.1-win32.exe

wget $mirroir/bin/windows/base/$dernierR-win32.exe

# dossier d'installation
pathWIN='RTinnRPortables'$aujourdhui'\'$dernierR'TinnR-portables\'$dernierR
echo $pathWIN

# installation
wine $dernierR-win32.exe /DIR='"'$pathWIN'"' /$interface /COMPONENTS="main,  html, html/help, manuals, manuals/basic, manuals/technical, manuals/refman, tcl, Rd, trans"

# Cette dernière ligne revient à peu près à faire à la main ce qui suit:Lancer l'executable d'installation. Choisir la langue (français), <OK>, <Suivant>, <Suivant>.Comme dossier de destination, choisir un dossier quelconque (pas nécessairement dans Program Files). Valider (<Suivant>). Choisir ensuite "Installation utilisateur" au minimum (soit 52,3Mo; si l'on n'est pas à 14Mo près en plus, prendre "Installation utilisateur complète", qui revient à cocher toutes les cases: 66,5Mo). [TODO: la correspondance entre ces options et celles de la ligne de commande ci-dessus est incertaine, cf. http://cran.r-project.org/bin/windows/base/rw-FAQ.html#Can-I-customize-the-installation_003f]. Valider (<Suivant>). A la question "Voulez-vous personnaliser les options de démarrage?" Répondre, Non, <Suivant>. Cocher <Ne pas créer de dossier dans le menu Démarrer> (sauf pour créer l'icône de lancement sur ce poste, mais celle-ci ne sert à ren pour la version portable). Valider (<Suivant>). "Tâches supplémentaires": décocher les 4 cases. <Suivant> <Terminer>.


# Tinn-R (editeur de Texte bien incorporé à R)
# Télécharge Tinn-R sur http://www.sciviews.org/Tinn-R/ en prenant la version "Tinn-R, last runnable version without installer (1.15.1.7) (.zip, 2.9 Mb)." (ce n'est pas la version la plus récente, mais la dernière portable)

wget http://www.sciviews.org/Tinn-R/Tinn-R%201.15.1.7%20stable.zip
mv Tinn-R\ 1.15.1.7\ stable.zip   Tinn-R_1.15.1.7_stable.zip
unzip -q Tinn-R_1.15.1.7_stable.zip 
#Décompresser Tinn-R dans le dossier /RTinnRPortables/. L'executable est alors /RTinnRPortables/Tinn-R/bin/Tinn-R.exe
mv ./Tinn-R $pathUNIX$dernierR"TinnR-portables"

# Crée la commande qui sera exécutée dans R pour installer les paquets. repos=choix d'un dépot parmi http://cran.r-project.org/mirrors.html
# TODO: vérifier qu'il ne vaudrait pas mieux définir l'option "type =" (paraît bon, cf. R-admin.pdf, section "6.3.1 Windows")
echo 'install.packages(pkgs=c("abind", "aplpack", "Cairo", "cairoDevice", "car", "chron", "cluster", "codetools", "compositions", "date", "DBI", "Design", "effects", "foreign", "gdata", "gplots", "gtools", "Hmisc", "iplots", "its", "JavaGD", "JGR", "lattice", "latticeExtra", "lmtest", "mapdata", "mapproj", "maps", "maptools", "mgcv", "misc3d", "multcomp", "nlme", "pscl", "Rcmdr", "RcmdrPlugin.epack", "RcmdrPlugin.Export", "RcmdrPlugin.FactoMineR", "RcmdrPlugin.HH", "RcmdrPlugin.IPSUR", "RcmdrPlugin.TeachingDemos", "relimp", "rgl", "rJava", "RMySQL", "RODBC", "rpart", "RPostgreSQL", "RSQLite", "sqldf", "SQLiteDF", "survival", "TSdbi", "TSSQLite", "rgrs"), repos="'$mirroir'", dependencies=c("Depends", "Imports"), destdir="c:/RTinnRPortables'$aujourdhui'/temp", clean=F)' > AjoutPaquets.R
# Optionnel: écrire c("Depends", "Imports","Suggests") au lieu de c("Depends", "Imports")   ce qui rajouterait de nombreux paquets:  total d'environ 300 Mo au lieu de 150Mo.

# Exécute AjoutPaquets.R dans R.
wine $pathUNIX$dernierR"TinnR-portables/$dernierR"/bin/R.exe CMD BATCH 'c:\RTinnRPortables'$aujourdhui'\temp\AjoutPaquets.R' log_AjoutPaquets.txt


cd $pathUNIX$dernierR"TinnR-portables"
wget http://jgr.markushelbig.org/Download_files/jgr.exe
#JGR, à lancer avec --rhome=xxx (le chemin); ne marche pas dans toutes les configurations. Cf. http://jgr.markushelbig.org/JGR_Installation.html
cd $pathUNIX

if [ -e "$dernierR"TinnR-portables.zip ] # si l'archive existe...
then
  echo "Le fichier "$dernierR"TinnR-portables.zip existe déjà. Supprimez-le ou déplacez-le maintenant, sinon il vous faudra le créer ultérieurement avec la commande: zip -rq "$dernierR"TinnR-portables.zip "$dernierR"TinnR-portables"

  rm -iv $dernierR"TinnR-portables.zip" # propose de supprimer le fichier

  if [ -e "$dernierR"TinnR-portables.zip ] # s'il existe toujours...
  then
    echo "L'archive zip n'a pas été re-créée."
  else
    zip -rq $dernierR"TinnR-portables".zip $dernierR"TinnR-portables"
    echo "Archive "$dernierR"TinnR-portables.zip créée dans le dossier:
    "$pathUNIX
  fi

else
  zip -rq $dernierR"TinnR-portables".zip $dernierR"TinnR-portables"
  echo "Archive "$dernierR"TinnR-portables.zip créée dans le dossier:
  "$pathUNIX
fi

echo "
Décompresser l'archive zip vers une
clé USB ou un autre support (disque réseau).
Utilisation: Lancer /Tinn-R/bin/Tinn-R.exe
A la première utilisation de TinnR, faire un clic-droit
sur les barres d'icônes de Tinn-R pour enlever celles qui
ne sont pas indispensables: ne garder que 'R' et 'File'.
Cliquer le menu [R] -> [Initiate / Close R-Gui].
Désigner l'emplacement du fichier Rgui.exe.
Si on utilise le même dossier sur une autre machine et que
la lettre de la clé USB n'est plus la même, il faut la
redéfinir avec:
Menu [Options] -> [Main] -> [Application].

Si Tinn-R est sur un disque réseau et partagé entre plusieurs
utilisateurs, et/ou sur un support non inscriptible (CD-ROM...),
déplacer son dossier sur un autre support, ou bien choisir le
Menu [Options] -> [Main] -> [Application] puis décocher deux des
trois cases de la section R:
[x] R resources visibles
[ ] Tips always showed
[ ] Enable
"



# Notes (brouillon):
#########################################
#NB: Le fichier dbRPCP.DBF contient une base de données de complétion automatique des noms de fonction, qui permet aussi d'afficher des infobulles
# dbRPCP= "database of the R parameters completion proposal"
# Si Tinn-R est sur un disque réseau et partagé entre plusieurs utilisateurs, et/ou sur un support non inscriptible, on a un message d'erreur concernant ce fichie dès qu'on essaie d'appeler une fonction R dans Tinn-R.

# EXTRAITS de rw-FAQ.html (Version for R-2.8.1), http://cran.r-project.org/bin/windows/base/rw-FAQ.html
# 4.10 Help is not shown for some of the packages
# Is this for Compiled HTML help (the default)? If a help viewer appears but says the page cannot be displayed, this may be due to a Windows security patch (http://support.microsoft.com/kb/896358). Either apply the workarounds given at that URL or choose another form of help as the default (on installation or by editing R_HOME\etc\Rprofile.site).
# If you are installing to a network drive, you should consider changing the default form of help during the install not to be Compiled HTML help: See "Help is not shown for some of the packages".
# 2.6 Can I run R from a CD or USB drive?  Yes, with care. A basic R installation is relocatable, so you can burn an image of the R installation on your hard disc or install directly onto a removable storage device such as a flash-memory USB drive. (If you have installed packages into a private library, their absolute paths will appear in the HTML packages list.)

# 5 Windows Features
# 5.1 What should I expect to behave differently from the Unix version of R?
#     * R commands can be interrupted by <Esc> in Rgui.exe and <Ctrl-break> or <Ctrl-C> in Rterm.exe: <Ctrl-C> is used for copying in the GUI version.
#     * Command-line editing is always available, but is simpler than the readline-based editing on Unix. For Rgui.exe, the menu item `Help | Console' will give details. For Rterm.exe see file README.rterm.
#     * Using help.start() does not automatically send help requests to the browser: use options(htmlhelp=TRUE) to turn this on.
#     * The HTML help system has limitations in supporting cross-library links.
#     * Paths to files (e.g. in source()) can be specified with either "/" or "\\".
#     * system() is slightly different: see its help page and that of shell(). 

