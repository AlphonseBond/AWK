#! /usr/bin/awk

# Traitement du fichier ListeFichiersForTouch.txt, le fichier est organisé ainsi:
# Dir.|[d,-]] | auth.     | Owner   | Group   | Octets| Date format full                    | Nom du fichier 
#./2002-0 | - | rw-r--r-- | TO45610 | 1049089 | 136712| 2002-09-20 07:50:02.000000000 +0200 | Anerkennung.jpg 
# Les fichiers seront récupérer dans un seul répertoire et il faudra les réallouer dans leurs répertoires d'origines
# Il faudra également leur redonner leur date de dernière modif initiale.
# Certain fichier contiennent des blanc dans leur nom on ne les changera pas dans ce prg car il faudra comparer 
#le contenue de la clé USB avec le répertoire original avec Behinf Compare




BEGIN {
    i = 0;
    j = 0;
    FS = "|"; 
}

# La liste des répertoire à copier vont etre stocker dans le tableau tab_Rep
$1 ~ /\./ && $2 ~ /d/ {
    tab_Rep[i] = $8;
    i++;
}

#La liste des fichiers à recopier vont etre stocker dans 8 tableaux diférents
$1 ~ /\.\/.+/ && $2 ~ /-/ {
    tab_Rep[j] = $1;
    tab_Nom[j] = $8;
    tab_Auth[j] = $3;
    tab_Owner[j] = $4;
    tab_Group[j] = $5;
    tab_Taille[j] = $6;
    tab_Date[j] = $7;
}

END {
    Destination = "/media/marc/PHILIPS\ UFD"
    Origine = "/home/marc/Documents/RecupDataZBook";
# Création des répertoires sous le chemin destination
    Limit = length(tab_Rep);
     for (i = 0 ; i< Limit; i++) {
        test = system("mkdir " Origine tab_Nom[i] Destination tab)
        if (test) {
            test = system("chown " tab_Auth[i] );
            if (!test) {
                print "On ne peut modifier les authorisation concernant", tab_Nom[i];
                exit 2;
            }
        } else {
            print tab_Nom[i], " ne peut pas être crée !";
            exit 1;
        }
    }   
# Recopie des fichiers dans chacun des répertoires crées juste avant
    Limit = length(tab_Nom);
    for (i = 0 ; i< Limit; i++) {
        test = system("mv " Origine tab_Nom[i] Destination tab_Rep[i] "\\"  )
        if (!test) {
            print "Le fichier ", tab_Nom[i] , "n'a pas pu être déplacé vers", Destination;
            exit 3
        }
    }


}
