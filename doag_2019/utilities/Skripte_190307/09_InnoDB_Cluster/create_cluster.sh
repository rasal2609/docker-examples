#
# Matthias Jung, Raphael Salguero / ORDIX AG
#
#!/bin/bash

# Deleting instances

echo "Vorhandene Instanzen löschen.. "
if [ -d "/opt/mysql/box/3311" ]; then
	mysqlsh --execute="dba.killSandboxInstance(3311, {sandboxDir: '/opt/mysql/box'})"
	mysqlsh --execute="dba.deleteSandboxInstance(3311, {sandboxDir: '/opt/mysql/box'})"
fi

if [ -d "/opt/mysql/box/3312" ]; then
    mysqlsh --execute="dba.killSandboxInstance(3312, {sandboxDir: '/opt/mysql/box'})"
	mysqlsh --execute="dba.deleteSandboxInstance(3312, {sandboxDir: '/opt/mysql/box'})"
fi

if [ -d "/opt/mysql/box/3313" ]; then
    mysqlsh --execute="dba.killSandboxInstance(3313, {sandboxDir: '/opt/mysql/box'})"
	mysqlsh --execute="dba.deleteSandboxInstance(3313, {sandboxDir: '/opt/mysql/box'})"
fi

echo "vorhandene Instanzen gelöscht."

# Creating instances

read -p "Drücken Sie [Enter] um forzusetzen..."
echo "Instanzen erstellen .."

mysqlsh --execute="dba.deploySandboxInstance(3311, {password: 'root', sandboxDir: '/opt/mysql/box'})"

mysqlsh --execute="dba.deploySandboxInstance(3312, {password: 'root', sandboxDir: '/opt/mysql/box'})"

mysqlsh --execute="dba.deploySandboxInstance(3313, {password: 'root', sandboxDir: '/opt/mysql/box'})"

echo "Instanzen erfolgreich erstellt."

# Cluster erstellen

read -p "Drücken Sie [Enter] um fortzusetzen..."
echo "Cluster wird erstellt .."

mysqlsh --file=/home/ordix/Skripte/09_InnoDB_Cluster/cluster.js
sleep 2
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.status()" -i

echo "Cluster erfolgreich erstellt."

# Instanz 3313 stoppen

read -p "Drücken Sie [Enter] um fortzusetzen..."
echo "Instanz 3312 und 3313 werden gestoppt.."

mysqlsh --execute="dba.killSandboxInstance(3313, {sandboxDir: '/opt/mysql/box'})"
sleep 2
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.status()" -i

# Instanz 3312 stoppen
mysqlsh --execute="dba.killSandboxInstance(3312, {sandboxDir: '/opt/mysql/box'})"
sleep 5
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.status()" -i

echo "Instanzen erfolgreich gestoppt."

## Instanzen erneut starten

read -p "Drücken Sie [Enter] um fortzusetzen..."
echo "Instanzen werden wieder hochgefahren .."

mysqlsh --execute="dba.startSandboxInstance(3312, {sandboxDir: '/opt/mysql/box'})"
mysqlsh --execute="dba.startSandboxInstance(3313, {sandboxDir: '/opt/mysql/box'})"
sleep 5
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.status()" -i

echo "Die Instanzen sind gestartet, der Cluster ist allerdings 'kaputt'."
read -p "Drücken Sie [Enter] um fortzusetzen..."
echo "Cluster auf Basis von localhost:3311 wiederherstellen .."

mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.forceQuorumUsingPartitionOf('root:root@localhost:3311')"
sleep 5
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.status()" -i

echo "Cluster ist wieder vorhanden, die Member sind allerdings offline."

# Rejoin der Instanzen
read -p "Drücken Sie [Enter] um fortzusetzen..."
echo "Die Instanzen werden wieder hinzugefügt .."

mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.rejoinInstance('localhost:3312')"
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.rejoinInstance('localhost:3313')"
sleep 5
mysqlsh --cluster=ORDIX --uri=root@localhost:3311 --execute="cluster.status()" -i
