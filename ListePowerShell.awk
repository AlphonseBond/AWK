#! /usr/bin/awk

# Les données dans le fichierListeFichiersImages.txt sont organisé ainsi:
# $1: Le type de fichier et Les autorisations de fichier. ([-|d]([-|r][-|w][-|x]){3})
# $2: Nombre de liens durs vers le fichier (toujours 1).
# $3: Propriétaire de fichier (toujours 'TO45610').
# $4: Groupe utilisateur (toujours '1049089').
# $5: Taille du fichier en octet
# $6: Mois de la date (mmmm.).
# $7: Date du jour (dd)
# $8: Heure si la date est en 2022 (hh:mm) ou année de la date (yyyy) 
# $9: Nom de fichier.

# le but est de formater la liste de fichier pour utiliser la commande 'touch -t [AAMMJJhhmm] fichier' 
# Un nouveau fichier "ListeFichiersImages_LongIso.txt" est le résultat de la cmde ls -lR --time-style=full-iso > ...


BEGIN {
#    Il n'est pas necessaitre de déclarer les variable dans la partie BEGIN sauf pour les compteur
    i = 0;
    j = 0;
	FS = "[[:space:]]+";
}
# Récupération du répertoire courant correspondant à la liste dsitué en dessous mais n'arrive pas à identifier ".:"
$1 ~ /^\..*:/ {
    STRING_LENGTH = length($1);
    FOLDER_NAME = substr($1,1,STRING_LENGTH-2); # Récupération du nom du répertoire
}

# Identification de la taille du répertoire courant
$1 ~ /^total [:digit:]+/{
    STRING_LENGTH = length($1);
    FOLDER_SIZE = substr($1,7,STRING_LENGTH-8);
}
# Récupération des données concernant les fichiers et répertoire
$1 ~ /^(-|d)[-rwx]{9}/ {
    tab_Type[i] = substr($1,1,1);
    tab_Auth[i] = substr($1,2,10);
    tab_Folder[i] = FOLDER_NAME # + "(" + FOLDER_SIZE+ ")";
    tab_Owner[i] = $3;
    tab_Group[i] = $4;
    tab_Taille[i] = $5;
<<<<<<< HEAD
    tab_Fuseau[i] = $8;
    tab_Date[i] = $6;
    tab_Heure[i] = $7;
# La concaténation de caractère se fait sans opérateur 
    for (j = 9 ; j <= NF ; j++ ) {
        tab_Nom[i] = tab_Nom[i] $j " ";
=======
    tab_Mois[i] = $6;
    tab_Date[i] = $7;
    tab_Heure[i] = $8;
    tab_Nom[i] = $9;
# Modifier en fonction de la liste date full-iso
    if (match(tab_Heure[i],/[:digit:]d{4}/) != 0) {
        tab_Year[i] = tab_Heure[i];
        tab_Heure[i] = "";
>>>>>>> b7dcdde32cca83448d5c52fdb1e60db2dbe01855
    }
    tab_Ligne[i] = NF " - "  $NF;
    tab_Num_Ligne[i] = NR;
    i++;
}	

<<<<<<< HEAD
END { 
#    print "Le répertoire racine vaut " FOLDER_ROOT;
    Limit = length(tab_Nom);  #length(tab_nom) n'est pas calculer dans l'interpretation de la boucle, il faut le stcker dans une variable avant.
    for (i=0; i < Limit ;i++) {
	    print tab_Folder[i], "|", tab_Type[i], "|", tab_Auth[i],"|", tab_Owner[i], "|", tab_Group[i], "|", tab_Taille[i] "|", tab_Date[i] ,  tab_Heure[i], tab_Fuseau[i], "|", tab_Nom[i];}
}
=======
    

END { print "Le répertoire racine vaut " FOLDER_ROOT;
    for (i=0; i < 100; i++) {
	print i, " : ", tab_Num_Ligne[i], "= ", tab_Folder[i], " | ", tab_Type[i], " | ", " - ", tab_Auth[i]," (", tab_Owner[i], "; ", tab_Group[i], ") ", tab_Date[i], " ", tab_Mois[i], " ", tab_Year[i], " ", tab_Heure[i], tab_Taille[i], " Octets ", tab_Nom[i];}
}
>>>>>>> b7dcdde32cca83448d5c52fdb1e60db2dbe01855
