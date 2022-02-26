#!/bin/bash


function show_usage()
{
    printf "$0 : \n [-h : Help] \n [-V : verrouiller compte utilisateur] \n [-v : Auteurs && Version ] \n [-d : deverrouiller compte utilisateur] \n [-M : Modifier repertoire Utilisateur] \n [-m : Menu textuelle] \n [-g : Menu Graphique] \n" 1>&2; exit 1;
}

function verrouiller()
{
    echo "Donner le nom de l'utilisateur a verrouiller :"
    read user
    echo $user >> liste_user_v.txt
    sudo passwd -l "$user"
}


function deverrouiller()
{
    echo "Donner le nom de l'utilisateur a deverrouiller :"
    read user
    grep -v "$user" liste_user_v.txt > temp.txt
    
    mv temp.txt liste_user_v.txt

    sudo passwd -u "$user"
}




function modifier()
{
     echo "Donner le nom de l'utilisateur a modifier le repertoire :"
    read user
     echo "Donner la nouvelle repertoire de l'utilisateur:"
    read dir
    sudo usermod -m -d "$dir" $user
}

function verrouiller_g()
{
    
         user=$(dialog --clear \
                --title "Verrouiller" \
                --inputbox "Entrer le nom de l'utilisateur :" 8 40 \
                2>&1 1>&3)


    

    echo $user >> liste_user_v.txt
    sudo passwd -l "$user"

    dialog --title "Verrouiller " \
                --no-collapse \
                --msgbox "l'utilisateur $user est verrouillé" 20 150

                if [[ $? -eq $DIALOG_OK ]]; then
                menu_graphique
                fi
}


function deverrouiller_g()
{
    
     user=$(dialog --clear \
                --title "Deverroulier" \
                --inputbox "Entrer le nom de l'utilisateur :" 8 40 \
                2>&1 1>&3)

    grep -v "$user" liste_user_v.txt > temp.txt
    
    mv temp.txt liste_user_v.txt

    sudo passwd -u "$user"


     dialog --title "Deverrouiller " \
                --no-collapse \
                --msgbox "l'utilisateur $user est deverrouillé" 20 150

                if [[ $? -eq $DIALOG_OK ]]; then
                menu_graphique
                fi
}


function modifier_g()
{
    user=$(dialog --clear \
                --title "Modifier" \
                --inputbox "Entrer le nom de l'utilisateur :" 8 40 \
                2>&1 1>&3)

    rep=$(dialog --clear \
                --title "Repertoire" \
                --inputbox "Entrer le nom nouvelle repertoire pour l'utilisateur $user :" 8 40 \
                2>&1 1>&3)

    sudo usermod -m -d "$rep" $user

     dialog --title "Modifier " \
                --no-collapse \
                --msgbox "le repertoire personel de $user est maintenant $rep " 20 150

                if [[ $? -eq $DIALOG_OK ]]; then
                menu_graphique
                fi
}

function menu_textuel()
{
    while :
do
	clear
	echo " "
	echo "-------------------------------------"
	echo "            Main Menu "
	echo "-------------------------------------"
	echo "[1] Verroulier un compte utilisateur"
	echo "[2] Deverroulier un compte utilisateur"
	echo "[3] Modifier le reportoire personnel de l'utilisateur et copier le contenu de son ancien répertoire vers le nouveau"
    echo "[4] Auteurs et Version"
	echo "[5] Exit"
	echo "====================================="
	echo "Entrez votre choix : [1-5]: "
	read m_menu
	
	case "$m_menu" in

		1) verrouiller;;
		2) deverrouiller;;
		3) modifier;;
        4) echo "Auteurs : Aziz ben isamil && Skander Ouada ||  Version : v0.1"; read; ;;
		5) exit 0;;
		*) echo "Choix invalide";
		   echo "Tappez ENTER pour continuer..." ; read ;;
	esac
done
}

function Auteurs()
{

dialog --title "Auteurs et Version " \
                --no-collapse \
                --msgbox "Auteurs : Aziz ben isamil && Skander Ouada ||  Version : v0.1" 20 150

                if [[ $? -eq $DIALOG_OK ]]; then
                menu_graphique
                fi
}

function menu_graphique()
{
    
    HEIGHT=15
    WIDTH=125
    CHOICE_HEIGHT=4
    TITLE="Sujet 11"
    MENU="Veulliez choisir une option:"

    OPTIONS=(1 "Verroulier un compte utilisateur"
            2 "Deverroulier un compte utilisateur"
            3 "Modifier le reportoire personnel de l'utilisateur et copier le contenu de son ancien répertoire vers le nouveau"
            4 "Auteurs et Version")

    exec 3>&1

    CHOICE=$(dialog --clear \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 1>&3)

    clear
    case $CHOICE in
            1)
                verrouiller_g
                ;;
            2)
                deverrouiller_g
                ;;
            3)
               modifier_g
                ;;
            4)
            Auteurs
            ;;
    esac
}


function main()
{
   
 while getopts ":hVvdMmg" opt; do
 
    case "$opt" in

    h)
    cat help.txt
    exit 0;
    ;;

    

    v)
    echo "Auteurs : Aziz ben isamil && Skander Ouada ||  Version : v0.1"
    ;;

    V)
    verrouiller
    ;;

    d)
    deverrouiller
    ;;

    M)
    modifier
    ;;

    m)
    menu_textuel
    ;;

    g)
    menu_graphique
    ;;
    
    *)
    show_usage
    exit 0
    ;;
    esac





 done
 if [ $OPTIND -eq 1 ]; then show_usage exit 1 ; fi
}



main $*