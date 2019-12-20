shell.connect('root@localhost:3311')
var cluster = dba.createCluster('ORDIX')
cluster.addInstance('root:root@localhost:3312')
cluster.addInstance('root:root@localhost:3313')
