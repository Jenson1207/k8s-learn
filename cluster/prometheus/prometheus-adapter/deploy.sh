#!/usr/bin/env bash


function install(){
  kubectl create namespace custom-metrics &>/dev/null
  kubectl -n custom-metrics create -f cm-adapter-serving-certs.yaml
  kubectl apply -f manifests/.
}

function uninstall(){
  kubectl -n custom-metrics delete -f cm-adapter-serving-certs.yaml
  kubectl delete -f manifests/.
  kubectl delete namespace custom-metrics &>/dev/null
}

case $1 in
  "install")
     install
  ;;
  "uninstall")
     uninstall
  ;;
  *)
    echo "bash deploy.sh install|uninstall"
  ;;
esac
