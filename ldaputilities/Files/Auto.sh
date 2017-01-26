#!/bin/bash
# Evyn Baldwin, 9916616
# Timberline Secondary School 

#Individual User
#Sets starting uid number
uidNumber="$(date +'%y')000"
FILENAME=($RANDOM % 10 + 1)


#Handle Users from File
Handler() {
if [ "$Line" -le "$Lines" ]; then
Line=$((Line+1)) 

Text=$(sed "${Line}!d" $FILE)
frmnum=$(echo $Text | cut -f1 -d",")
frmfirst=$(echo $Text | cut -f2 -d",")
frmlast=$(echo $Text | cut -f3 -d",")
echo $( Individual_User "$uidNumber" ) 
else
Line=$((Line+1))
ldapadd -x -D cn=admin,dc=hackerspace,dc=tbl -W -f ldap/$FILENAME.csv.ldap
exit 1
fi
}



Generate_Form() {
#Form Data
FILE=`env DISPLAY=:0.0 zenity --title="Select a file" --file-selection`
Lines=$(wc -l "$FILE" | cut -d ' ' -f 1)
Line=0
echo $( Handler )
}

#Make User File
Make() {
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
" >> ldap/$FILENAME.csv.ldap
uidNumber=$((uidNumber+1))
echo $( Handler )
}


Individual_User() {
  USERINFO=$(getent passwd $uidNumber)
  #Check if user exists
  if [ "$USERINFO" ]; then
      uidNumber=$((uidNumber+1))
      echo $( Individual_User "$uidNumber" )
  else
      echo $( Make )
  fi
}

echo $( Generate_Form )
