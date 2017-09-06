#!/bin/bash

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
