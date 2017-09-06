#!/bin/bash

#ca
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

##etcd server
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server.json | cfssljson -bare server


##etcd peer
index=0
#NOTE change server ips
for SERVER in "192.168.8.20" "192.168.8.21" "192.168.8.22"
do
cat <<EOF | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer - | cfssljson -bare server${index}
{
    "CN": "infra${index}",
    "hosts": [
        "etcd",
        "$SERVER",
        "127.0.0.1"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "O": "ETCD"
        }
    ]
}
EOF
index=`expr $index + 1`
done

##etcd client k8s
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client

##etcd client flannel
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client flannel.json | cfssljson -bare flannel

#kube-apiserver
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server kube-apiserver.json | cfssljson -bare apiserver

##kube-proxy
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client kube-proxy.json | cfssljson -bare proxy

##kube-master
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client kube-master.json | cfssljson -bare master
