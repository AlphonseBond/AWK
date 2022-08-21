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


BEGIN {
    print "Début du traitement";
	FOLDER_ROOT = "Vide";
    FOLDER_NAME = "";
	FOLDER_ROOT_LENGTH = 0;
    STRING_LENGTH = 0;
	tab_Folder[0]= "";
	tab_Date[0] = "";
	tab_Heure[0] = "";
	tab_Mois[0] = "";
	tab_Year[0] = "";
	tab_Taille[0] = "";
	tab_Nom[0] = "";
	tab_Type[0] = "";
    tab_Auth[0] = "";
    tab_Owner[0] = "";
    tab_Group[0] = "";
	#tab_Length[0] = "";
	#tab_Ligne[0] = "";
	tab_Num_Ligne[0] = 0;
	i = 0;
	j = 0;
	FS = "[[:space:]]+";
}
# Dans les séquence -a--- et d--- il y a des caractères invisible entre chaque lettre mais le fichier à été régénérer à patir de cmde linux (depuis git bash) et ces caractères on disparue.
#identification des répertoires
$1 ~ /^\..*:/ {
#    if (FOLDER_ROOT == "Vide") {
	#FOLFER_ROOT = gensub("/ *R[^:]+ (.+)/","\\1","g",$0);
    STRING_LENGTH = length($1);
    FOLDER_NAME = substr($1,1,STRING_LENGTH-2); # Récupération du nom du répertoire
	#FOLDER_ROOT_LENGTH = length(FOLDER_ROOT);
#    } else {
#	tab_Folder[i] = substr($0,FOLDER_ROOT_LENGTH)
#	i++;
#	j = 0;}
}

# Identification de la taille du répertoire courant
$1 ~ /^total [:digit:]+/{
    STRING_LENGTH = length($1);
    FOLDER_SIZE = substr($1,7,STRING_LENGTH-8);
}
#Essai avec split($0,/[[space]]/,tab,seps) avec bouclage sur tab pour remplir les champ (! il es possible qu'il y ai des caractères cachés dans les blanc
$1 ~ /^(-|d)[-rwx]{9}/ {
    tab_Type[i] = substr($1,1,1);
    tab_Auth[i] = substr($1,2,10);
    tab_Folder[i] = FOLDER_NAME + "(" + FOLDER_SIZE+ ")";
    tab_Owner[i] = $3;
    tab_Group[i] = $4;
    tab_Taille[i] = $5;
    #tab_Length[i+j] = length($0);
    tab_Mois[i] = $6;
    tab_Date[i] = $7;
    tab_Heure[i] = $8;
    tab_Nom[i] = $9;
    if (match(tab_Heure[i],/[:digit:]d{4}/) != 0) {
        tab_Year[i] = tab_Heure[i];
        tab_Heure[i] = "";
    }
    else {
        tab_Year[i] = "2022";    
        }
    tab_Ligne[i+j] = $0;
    #tab_Type[i+j] = substr($0, 1 , 11);
    #tab_Date[i+j] = substr($0, 30, 20);
    # split($0, tab, "/[:space:]+/")
    # for (k in tab) {
    # 	tab_Ligne[i+j] = tab[k] + " | ";
    # }
    # tab_Heure[i+j] = $3;
    # tab_Nom[i+j] = $4;
    # tab_Type[i+j] = $1;
    # tab_Ligne[i+j] = $0;
    tab_Num_Ligne[i] = NR;
    i++;
}	
#$1 ~ /-.a(.*-.*)*/ {
    # tab_Folder[i+j] = tab_Folder[i]; 
    # tab_Date[i+j] = $2;
    # tab_Heure[i+j] = $3;
    # tab_Taille [i+j] = $4;
    # tab_Nom[i+j] = $5;
    # tab_Type[i+j] = $1;
    # tab_Ligne[i+j] = $0;
    # tab_Length[i+j] = length($0);
    # tab_Ligne[i+j] = $0;
    # tab_Type[i+j] = substr($0, 3 , 11);
    # tab_Date[i+j] = substr($0, 32, 20);
    # tab_Num_Ligne[i+j] = NR;
    # j++;
# }
    

END { print "Le répertoire racine vaut " FOLDER_ROOT;
    for (i=0; i < 100; i++) {
       # print , tab_Folder[i],"/",tab_Nom[i]," date:",tab_Date[i],"-",tab_Heure[i],"(",tab_Taille[i],",",tab_Type[i]")";}
	print i, " : ", tab_Num_Ligne[i], "= ", tab_Folder[i], " | ", tab_Type[i], " | ", " - ", tab_Auth[i]," (", tab_Owner[i], "; ", tab_Group[i], ") ", tab_Date[i], " ", tab_Mois[i], " ", tab_Year[i], " ", tab_Heure[i], tab_Taille[i], " Octets ", tab_Nom[i];}
}