#! /usr/bin/awk

# Traitement du fichier ListeFichiersForTouch.txt, le fichier est organisé ainsi:
# Dir.|[d,-]] | auth.     | Owner   | Group   | Octets| Date format full                    | Nom du fichier 
#./2002-0 | - | rw-r--r-- | TO45610 | 1049089 | 136712| 2002-09-20 07:50:02.000000000 +0200 | Anerkennung.jpg 
# Les fichiers seront récupérer dans un seul répertoire et il faudra les réallouer dans leurs répertoires d'origines

# Ce programme a pour but de récréer l'arboresence des répertoires contenant les fichiers
# En leur donnant également  leur date de dernière modif initiale.


BEGIN {
    i = 0;
    j = 0;
    FS = "|"; 
}

# La liste des répertoire à copier vont etre stocker dans le tableau tab_Rep
$1 ~ /\./ && $2 ~ /d/ {
     tab_Rep[i] =gensub(/ *([^ ]+)/,"\\1","g", $8); #supprime l'espace devant le nom de répertoire
     tab_Date[i]= $7;
    i++;
}

END {
    Destination = "/media/marc/PHILIPS\\ UFD/Pictures/"; # rajout d'un '\' supplémentaire pour échaper l'autre '\'
    Origine = "/home/marc/Documents/RecupDataZBook";
# Création des répertoires sous le chemin destination
    Limit = length(tab_Rep);
    NbRepCreer =  Limit;
    for (i = 0 ; i < 5 ; i++) {
	Cmd = "mkdir " Destination tab_Rep[i];
	test = system(Cmd);
	if (test == 0) {  # La commande à réussi il faut redonner au répertoire sa date de création initiale
	    Cmd = "touch -m --date='" tab_Date[i] "' " Destination "/" tab_Rep[i];
	    test = system(Cmd);
	    print Cmd, " Résultat -> ", test
	    if (test !=0) {
		print "La modification de la date de dernière modification du Répertoire ", tab_Rep[i], " à échouée!";
	    }
	} else {   # La commande mkdir à échoué
	    print "Le Répertoire ", tab_Rep[i] , " n'a pas pu etre créer! ";
	    NbRepCreer = NbRepCreer - 1;
	}
    }
    print NbRepCreer , " répertoires crées, pour un objectif de " Limit, " répertoires.";
}
