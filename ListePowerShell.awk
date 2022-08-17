#! /usr/bin/awk

BEGIN {
    print "Début du traitement";
	FOLDER_ROOT = "Vide";
	FOLDER_ROOT_LENGTH = 0;
	tab_Folder[0]= "";
	tab_Date[0] = "";
	# tab_Heure[0] = "";
	# tab_Taille[0] = "";
	# tab_Nom[0] = "";
	tab_Type[0] = "";
	tab_Length[0] = "";
	tab_Ligne[0] = "";
	tab_Num_Ligne[0] = 0;
	i = 0;
	j = 0;
	FS = "[[:space:]]+";
}
# Dans les séquence -a--- et d--- il y a des caractères invisible entre chaque lettre
#awk 'NR<200 && $1 ~ /-.*a/ || $1 ~ /d.*-/  {print NR, ":", $0}' ../Documents/ListeImages.txt 
$0 ~ / *R[^:]+/ {if (FOLDER_ROOT == "Vide") {
	#FOLFER_ROOT = gensub("/ *R[^:]+ (.+)/","\\1","g",$0);
        FOLDER_ROOT = $0;
	FOLDER_ROOT_LENGTH = length(FOLDER_ROOT);
    } else {
	tab_Folder[i] = substr($0,FOLDER_ROOT_LENGTH)
	i++;
	j = 0;}
}
#Essai avec split($0,/[[space]]/,tab,seps) avec bouclage sur tab pour remplir les champ (! il es possible qu'il y ai des caractères cachés dans les blanc
$1 ~ /d(.?-){5}/ {
    tab_Folder[i+j] = tab_Folder[i];
    tab_Length[i+j] = length($0);
    tab_Ligne[i+j] = $0;
    tab_Type[i+j] = substr($0, 1 , 11);
    tab_Date[i+j] = substr($0, 30, 20);
    # split($0, tab, "/[:space:]+/")
    # for (k in tab) {
    # 	tab_Ligne[i+j] = tab[k] + " | ";
    # }
    # tab_Heure[i+j] = $3;
    # tab_Nom[i+j] = $4;
    # tab_Type[i+j] = $1;
    # tab_Ligne[i+j] = $0;
    tab_Num_Ligne[i+j] = NR;
    j++;
}	
$1 ~ /-.a(.*-.*)*/ {
    tab_Folder[i+j] = tab_Folder[i]; 
    # tab_Date[i+j] = $2;
    # tab_Heure[i+j] = $3;
    # tab_Taille [i+j] = $4;
    # tab_Nom[i+j] = $5;
    # tab_Type[i+j] = $1;
    tab_Ligne[i+j] = $0;
    tab_Length[i+j] = length($0);
    tab_Ligne[i+j] = $0;
    tab_Type[i+j] = substr($0, 3 , 11);
    tab_Date[i+j] = substr($0, 32, 20);
    tab_Num_Ligne[i+j] = NR;
    j++;
}
    

END { print "Le répertoire racine vaut " FOLDER_ROOT;
    for (i=0; i < 10; i++) {
       # print , tab_Folder[i],"/",tab_Nom[i]," date:",tab_Date[i],"-",tab_Heure[i],"(",tab_Taille[i],",",tab_Type[i]")";}
	print i, " : ",tab_Num_Ligne[i], " - ", tab_Length[i],": ",tab_Ligne[i]," (", tab_Type[i], "; ", tab_Date[i], ")";}
}
