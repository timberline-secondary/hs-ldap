#!/bin/bash
# Evyn Baldwin, 9916616
# Timberline Secondary School 
Firstname=$1
Lastname=$2
Studentnum=$3
Number=0
folder="ldifffiles"

#Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
   mkdir $folder
else
   clear
fi



#CommandLine
if [ "$1" = "--help" ]
then
   echo "Syntex is './main.sh firstname, lastname, studentnumber'"
elif [ "$1" = "--gui" ]
then
#GUI
action=$(yad --width 300 --entry --title "Choose Option" \
--button="gtk-ok:0" --button="gtk-close:1" \
--text "Choose action:" \
--entry-text \
"Individual" "Mass")
ret=$?

[[ $ret -eq 1 ]] && exit 0

if [[ $ret -eq 2 ]]; then
	gdmflexiserver --startnew &
	exit 0
fi

case $action in
	Individual*) cmd="sh Files/Individual.sh" ;;
	Mass*) cmd="bash Files/Auto.sh" ;;
	*) exit 1 ;;    
esac

eval exec $cmd

else
clear
if [[ -z $Firstname || -z $Lastname || -z $Studentnum ]]; then
echo '************************************'
echo '************************************'
echo '           LDAP UTILITIES		  '
echo '      created by: Evyn Baldwin	  '
echo '************************************'
echo '************************************'
echo
echo 
echo '1) Add individual User'
echo '2) Auto User Creation'
echo '3) Reset Password'
echo ____________________________________
echo 
read -p "Number: " Number

if [ $Number == "3" ];
then

	echo 'Under Construction'
elif [ $Number == "2" ];
then

clear
#echo 'Place the class list in the root of the ldaputils folder'
uidNumber="$(date +'%y')000"
FILENAME=($RANDOM % 10 + 1)


#Handle Users from File
Handler1() {
	Text=$(sed "${Line}!d" $FILE)
	frmnum=$(echo $Text | cut -f1 -d",")
	frmfirst=$(echo $Text | cut -f2 -d"," | tr '[:lower:]' '[:upper:]')
	frmlast=$(echo $Text | cut -f3 -d"," | tr '[:lower:]' '[:upper:]')

	#check if exist

		if [ "$Line" -le "$Lines" ]; then
				Line=$((Line+1)) 
				echo $( Individual_User1 "$uidNumber" ) 
		else
				ldapadd -x -D cn=admin,dc=hackerspace,dc=tbl -W -f $folder/$FILENAME.csv.ldif
				echo 'Successfully added users to ldap'
		fi
}



Generate_Form1() {
#Form Data
File=""
read -p "filename: " FILE
Lines=$(wc -l "$FILE" | cut -d ' ' -f 1)
Line=1
Handler1;
}

#Make User File
Make1() {
#User Data
printf "dn: uid=$frmnum,ou=Users,dc=hackerspace,dc=tbl\n\
objectClass: inetOrgPerson\n\
objectClass: posixAccount\n\
objectClass: shadowAccount\n\
uid: $frmnum\n\
sn:$frmlast\n\
givenName:$frmfirst\n\
cn:$frmfirst$frmlast\n\
displayName:$frmfirst$frmlast\n\
uidNumber: $uidNumber\n\
gidNumber: 5000\n\
userPassword: wolf\n\
gecos:$frmfirst$frmlast\n\
loginShell: /bin/bash\n\
homeDirectory: /home/$frmnum\n\n\
" >> $folder/$FILENAME.csv.ldif
uidNumber=$((uidNumber+1))
Handler1;
}


Individual_User1() {
  USERINFO=$(getent passwd $uidNumber)
  #Check if user exists
  if [ "$USERINFO" ]; then
      uidNumber=$((uidNumber+1))
      echo $( Individual_User1 "$uidNumber" )
  else


	#Check if user exists
	if id -u "$frmnum" >/dev/null 2>&1; then
		Handler1;
		
	else
      		Make1;
	fi


  fi
}

echo $( Generate_Form1 )









elif [ $Number == "1" ];
then
clear
#Add User manually
read -e -p "Studentnum: " Studentnum

#Check if user exists
if id -u "$Studentnum" >/dev/null 2>&1; then
        echo "user exists"
else

read -e -p "Firstname: " Firstname
read -e -p "Lastname:  " Lastname

Firstname=$( echo $Firstname | tr '[:lower:]' '[:upper:]' )
Lastname=$( echo $Lastname | tr '[:lower:]' '[:upper:]' )

#User doesnt exist move on
uidNumber="$(date +'%y')000"
FILENAME=($RANDOM % 10 + 1)
Individual_User() {
  USERINFO=$(getent passwd $uidNumber)
  #Check if user exists
  if [ "$USERINFO" ]; then
      uidNumber=$((uidNumber+1))
      echo $( Individual_User "$uidNumber" )
  else
	
#User Data
printf "dn: uid=$Studentnum,ou=Users,dc=hackerspace,dc=tbl\n\
objectClass: inetOrgPerson\n\
objectClass: posixAccount\n\
objectClass: shadowAccount\n\
uid: $Studentnum\n\
sn:$Lastname\n\
givenName:$Firstname\n\
cn:$Firstname $Lastname\n\
displayName:$Firstname $Lastname\n\
uidNumber: $uidNumber\n\
gidNumber: 5000\n\
userPassword: wolf\n\
gecos:$Firstname $Lastname\n\
loginShell: /bin/bash\n\
homeDirectory: /home/$Studentnum\n\n\
" >> $folder/$Studentnum.csv.ldif

		if [ -f "$folder/$Studentnum.csv.ldif" ];
		then
		   ldapadd -x -D cn=admin,dc=hackerspace,dc=tbl -W -f $folder/$Studentnum.csv.ldif
		fi
		exit
	fi
}
echo $( Individual_User "$uidNumber" ) 
fi
fi


else
#Check if user exists
if id -u "$3" >/dev/null 2>&1; then
        echo "user exists"
else
Firstname=$( echo $Firstname | tr '[:lower:]' '[:upper:]' )
Lastname=$( echo $Lastname | tr '[:lower:]' '[:upper:]' )

uidNumber="$(date +'%y')000"
FILENAME=($RANDOM % 10 + 1)
Individual_User() {
  USERINFO=$(getent passwd $uidNumber)
  #Check if user exists
  if [ "$USERINFO" ]; then
      uidNumber=$((uidNumber+1))
      echo $( Individual_User "$uidNumber" )
  else
	
#User Data
printf "dn: uid=$Studentnum,ou=Users,dc=hackerspace,dc=tbl\n\
objectClass: inetOrgPerson\n\
objectClass: posixAccount\n\
objectClass: shadowAccount\n\
uid: $Studentnum\n\
sn:$Lastname\n\
givenName:$Firstname\n\
cn:$Firstname $Lastname\n\
displayName:$Firstname $Lastname\n\
uidNumber: $uidNumber\n\
gidNumber: 5000\n\
userPassword: wolf\n\
gecos:$Firstname $Lastname\n\
loginShell: /bin/bash\n\
homeDirectory: /home/$Studentnum\n\n\
" >> $folder/$Studentnum.csv.ldif

		if [ -f "$folder/$Studentnum.csv.ldif" ];
		then
		   ldapadd -x -D cn=admin,dc=hackerspace,dc=tbl -W -f $folder/$Studentnum.csv.ldif
		fi
		exit
	fi
}
echo $( Individual_User "$uidNumber" ) 
fi
fi
fi
