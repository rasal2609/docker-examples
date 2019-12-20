#!/bin/bash
#
##########################################################
#
# ras - Sep 2018- Initial
#
# Anlegen von Benutzern mit unterschiedlichen Privilegien
#
# Vorbereitung: Zweite PuTTY-Session notwendig
#
##########################################################

echo "Skript zur Demonstration verschiedener Benutzer-Privilegien."
echo "Zunächst werden die Privilegien für eine Verbindung an den MySQL-Server demonstriert."
##########################################################
### 1 Clean Up, falls Benutzer schon vorhanden
##########################################################
mysql -uroot -v -e "DROP USER 'jeffrey'@'localhost'; DROP USER 'jeffrey'@'192.168.56.102';"

# Anlegen eines lokalen Benutzers
mysql -uroot -v -e "CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'jeffrey';"
echo "Benutzer 'jeffrey'@'localhost' mit dem Passwort 'jeffrey' wurde angelegt..."
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s

# Testverbdindung mit dem neuen Benutzer an den MySQL-Server
echo '###########'
echo 'Kommando: mysql -ujeffrey -pjeffrey -v -e "status"'
echo ' ###########'

mysql -ujeffrey -pjeffrey -v -e "status"
echo "Anmeldung an den MySQL-Server von localhost funktioniert."
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s

# Testverbdindung mit dem neuen Benutzer an den MySQL-Server über Socket und Port
echo '###########'
echo 'Kommando: mysql -ujeffrey -pjeffrey --socket=/tmp/mysql01.sock --port=3306 -v -e "status"'
echo ' ###########'
mysql -ujeffrey -pjeffrey --socket=/tmp/mysql01.sock --port=3306 -v -e "status"
echo "Anmeldung an den MySQL-Server von localhost funktioniert auch bei direkter Angabe von Socket und Port."
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s

# Testverbdindung mit dem neuen Benutzer an den MySQL-Server über Hostname und Port
echo '###########'
echo 'Kommando: mysql -ujeffrey -pjeffrey -h 192.168.56.102 -P 3306 -v -e "status"'
echo ' ###########'
mysql -ujeffrey -pjeffrey -h 192.168.56.102 -P 3306 -v -e "status"
echo "Anmeldung an den MySQL-Server über den Hostname und Port funktioniert nicht."
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s

# Anlegen eines neuen Benutzers
mysql -uroot -v -e "CREATE USER 'jeffrey'@'192.168.56.102' IDENTIFIED BY 'jeffrey';"
echo "Benutzer 'jeffrey'@'192.168.56.102' mit dem Passwort 'jeffrey' wurde angelegt..."
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s

# Erneute Testverbindung an den MySQL-Server über Hostname und Port
echo '###########'
echo 'Kommando: mysql -ujeffrey -pjeffrey -h 192.168.56.102 -P 3306 -v -e "status"'
echo ' ###########'
mysql -ujeffrey -pjeffrey -h 192.168.56.102 -P 3306 -v -e "status"
echo "Anmeldung an den MySQL-Server über den Hostname und Port funktioniert nun."
echo "Hinweis: SSL wird bei der Verbindung über das Netzwerk (Hostname und Port) verwendet."
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s

# Zusammenfassung der Benutzer
echo '###########'
echo 'Kommando: mysql -uroot -v -e "select user, host from mysql.user where user = 'jeffrey'"'
echo ' ###########'
mysql -uroot -v -e "select user, host from mysql.user where user = 'jeffrey';"
read -p "Bestätigen Sie zum fortfahren... `echo $'\n '`" -n1 -s
