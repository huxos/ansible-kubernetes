#!/bin/bash

CLUSTER_CIDR=10.20.0.0/16
SERVICE_CIDR=10.101.66.0/23
CLUSTER_DNS=10.101.66.2
CLUSTER_KUBERNETES=10.101.66.1
CLUSTER_DOMAIN=cluster.local
MAX_PODS=32
NODE_CIDR_MASK_SIZE=27
#head -c 16 /dev/urandom | od -An -t x | tr -d ' '
BOOTSTRAP=4abe3070e3e0b9a155654ce143e5c86a

KUBE_MASTERS="192.168.8.20 192.168.8.21 192.168.8.22"
KUBE_EXTERNAL_ADDR=https://192.168.8.20:6443

HYPERKUBE_IMAGE=gcr.io/google_containers/hyperkube:v1.7.3
POD_INFRA_CONTAINER_IMAGE=gcr.io/google_containers/pause-amd64:3.0
ETCD_IMAGE=quay.io/coreos/etcd:v3.2.3
KUBECTL_DOWNLOAD_URL=https://storage.googleapis.com/kubernetes-release/release/v1.7.3/bin/linux/amd64/kubectl
KUBECTL_CHECKSUM=md5:685c426a22fd1d82a5db45e1723ababd
KUBELET_DOWNLOAD_URL=https://storage.googleapis.com/kubernetes-release/release/v1.7.3/bin/linux/amd64/kubelet
KUBELET_CHECKSUM=md5:50414afce99e677f68e1fd3476577190

cat <<EOF > ../group_vars/k8s
cluster_cidr: $CLUSTER_CIDR
cluster_dns: $CLUSTER_DNS
cluster_kubernetes: $CLUSTER_KUBERNETES
cluster_domain: $CLUSTER_DOMAIN
max_pods: $MAX_PODS
node_cidr_mask_size: $NODE_CIDR_MASK_SIZE
service_cidr: $SERVICE_CIDR
bootstrap: $BOOTSTRAP
hyperkube_image: $HYPERKUBE_IMAGE
etcd_image: $ETCD_IMAGE
pod_infra_container_image: $POD_INFRA_CONTAINER_IMAGE
kubectl_download_url: $KUBECTL_DOWNLOAD_URL
kubelet_download_url: $KUBELET_DOWNLOAD_URL
kubectl_checksum: $KUBECTL_CHECKSUM
kubelet_checksum: $KUBELET_CHECKSUM
EOF

kubectl config set-cluster kubernetes \
    --certificate-authority=../cert/ca.pem \
    --embed-certs=true \
    --server=${KUBE_EXTERNAL_ADDR} \
    --kubeconfig=bootstrap-kubeconfig.yaml

kubectl config set-credentials kubelet-bootstrap \
    --token=${BOOTSTRAP} \
    --kubeconfig=bootstrap-kubeconfig.yaml

kubectl config set-context default \
    --cluster=kubernetes \
    --user=kubelet-bootstrap \
    --kubeconfig=bootstrap-kubeconfig.yaml

kubectl config use-context default --kubeconfig=bootstrap-kubeconfig.yaml

function generate_kubeconfig() {
    kubectl config set-cluster kubernetes \
      --certificate-authority=../cert/ca.pem \
      --embed-certs=true \
      --server=${2} \
      --kubeconfig=${1}-kubeconfig.yaml

    kubectl config set-credentials ${1} \
      --client-certificate=../cert/${1}.pem \
      --client-key=../cert/${1}-key.pem \
      --embed-certs=true \
      --kubeconfig=${1}-kubeconfig.yaml

    kubectl config set-context default \
      --cluster=kubernetes \
      --user=${1} \
      --kubeconfig=${1}-kubeconfig.yaml

    kubectl config use-context default --kubeconfig=${1}-kubeconfig.yaml
}

generate_kubeconfig proxy ${KUBE_EXTERNAL_ADDR}

echo -n ${BOOTSTRAP},kubelet-bootstrap,10001,system:kubelet-bootstrap > token.csv
