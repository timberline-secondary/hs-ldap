# hs_ldap
ldap scripts for Timberline's Hackerspace

Student uid start: yy000 (where yy is the two digit year the student account was created)

list users: `getent passwd`

### Bulk user import
Use `ldapbulkimport` script:

`sudo ./ldapbulimport`

### Reminders

Check users or a user: `getent passwd [username]`

Searching: [ldapsearch](https://web.archive.org/web/20131017105152/http://ldapmaven.com/2011/07/27/mastering-ldapsearch/)

[ldap user and group management](http://www.meso.northwestern.edu/intranet/recipies/useful-computer-files-and-programs/configuring-group-linux-servers-and-terminals-with-ldap-kerberos-and-nfs/ldap-user-and-group-management)


