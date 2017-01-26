#!/bin/bash
# Evyn Baldwin, 9916616
# Timberline Secondary School 

#Individual User
#Sets starting uid number
if [ $2 ]; then
  uidNumber="$2"
else
  uidNumber="$(date +'%y')000"
fi

Generate_Form() {
#Form Data
frmdata=$(yad --width=500 --height=300 --title "Student Registry" --form --field "Student Number:" --field="First Name:" --field="Last Name:")
frmnum=$(echo $frmdata | awk 'BEGIN {FS="|" } { print $1 }')
frmfirst=$(echo $frmdata | awk 'BEGIN {FS="|" } { print $2 }' | awk '{print tolower($0)}' | sed -r 's/\w+/\u&/g')
frmlast=$(echo $frmdata | awk 'BEGIN {FS="|" } { print $3 }' | awk '{print tolower($0)}' | sed -r 's/\w+/\u&/g')

#User Data
echo "dn: uid=$frmnum,ou=Users,dc=hackerspace,dc=tbl\n\
objectClass: inetOrgPerson\n\
objectClass: posixAccount\n\
objectClass: shadowAccount\n\
uid: $frmnum\n\
sn: $frmlast\n\
givenName: $frmfirst\n\
cn: "$frmfirst $frmlast"\n\
displayName: "$frmfirst $frmlast"\n\
uidNumber: $uidNumber\n\
gidNumber: 5000\n\
userPassword: wolf\n\
gecos: "$frmfirst $frmlast"\n\
loginShell: /bin/bash\n\
homeDirectory: /home/$frmnum\n\
" >> ldap/$frmnum.csv.ldif
}


Individual_User() {
  uidNumber=$1
  USERINFO=$(getent passwd $uidNumber)
  #Check if user exists
  if [ "$USERINFO" ]; then
      uidNumber=$((uidNumber+1))
      echo $( Individual_User "$uidNumber" )
  else
      echo "$uidNumber"
      echo $( Generate_Form )
  fi
}

echo $( Individual_User "$uidNumber" )
