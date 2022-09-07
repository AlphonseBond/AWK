#! /usr/bin/awk

# Traitement du fichier ListeFichiersForTouch.txt, le fichier est organisé ainsi:
# Dir.|[d,-]] | auth.     | Owner   | Group   | Octets| Date format full                    | Nom du fichier 
#./2002-0 | - | rw-r--r-- | TO45610 | 1049089 | 136712| 2002-09-20 07:50:02.000000000 +0200 | Anerkennung.jpg 
# Les fichiers seront récupérer dans un seul répertoire et il faudra les réallouer dans leurs répertoires d'origines
# Il faudra également leur redonner leur date de dernière modif initiale.
# Certain fichier contiennent des blanc dans leur nom on ne les changera pas dans ce prg car il faudra comparer 
# le contenue de la clé USB avec le répertoire original avec Behinf Compare
# Un premier prg doi etre lancé avant CreatDirRecopie.awk, qui créer l'arborsence de répertoire
# Dans la section BEGIN on récupère l'arborsence créer et on la stocke dans un tableau




BEGIN {
    i = 0;
    DernierRep = "";
    # j = 0;
    FS = "|"; 
}

# La liste des répertoire à copier vont etre stocker dans le tableau tab_Rep
# $1 ~ /\./ && $2 ~ /d/ {
#      tab_RepCreat[i] =gensub(/ *([^ ]+)/,"\\1","g", $8); #supprime l'espace de vant le nom de répertoire
#     i++;
# }

#La liste des fichiers à recopier vont etre stocker dans 8 tableaux diférents
$1 ~ /\.\/.+/ && $2 ~ /-/ {
    tab_Rep[i] = $1;
    tab_Nom[i] = $8;
    tab_Auth[i] = $3;
    tab_Owner[i] = $4;
    tab_Group[i] = $5;
    tab_Taille[i] = $6;
    tab_Date[i] = $7;
    tab_LigneNb[i] = NR;
    i++;
}

# END {
#     Destination = "/media/marc/PHILIPS\\ UFD/Pictures"; # rajout d'un '\' supplémentaire pour échaper l'autre '\'
#     Origine = "/home/marc/Documents/RecupDataZBook";
# # Création des répertoires sous le chemin destination
#     Limit = length(tab_RepCreat);
#     print Limit;
#     Cmd = "mkdir " Destination tab_RepCreat[0];
#     print Cmd;
#     test = system(Cmd);
#     print test;
    
#      for (i = 0 ; i< Limit; i++) {
# 	 Cmd = "mkdir " Destination tab_Rep[i];
# 	 test = system(Cmd);
# 	 if (test) {
#             test = system("chown " tab_Auth[i] );
#             if (!test) {
#                 print "On ne peut modifier les authorisation concernant", tab_Nom[i];
#                 exit 2;
#             }
#         } else {
#             print tab_Nom[i], " ne peut pas être crée !";
#             exit 1;
#         }
#     }

END {
# Recopie des fichiers dans chacun des répertoires crées juste avant
     Limit = length(tab_Nom);
     for (i = 0 ; i< Limit; i++) {
	 if (tab_Rep[i] != Dernier_Rep) {
	     Dernier_Rep = tab_Rep[i];
	     test = system("cd " Destination Dernier_Rep);
	     if (test != 0) {
		 print "Le répertoire ", Dernier_Rep, " est absent de " Destination;
		 print "Le programme va s'arreter à la ligne n°", tab_LigneNb[i];
		 exit 1;
	     }
	 }
         test = system("mv " Origine tab_Nom[i] " " Destination tab_Rep[i] "\\"  )
         if (test != 0) {
             print "Le fichier ", tab_Nom[i] , "n'a pas pu être déplacé vers", Destination;
	     print "Le programme va s'arreter à la ligne n°", tab_LigneNb[i];
             exit 3
         }
     }

}
