#!/usr/bin/env bash
#######################################
# Author:  jiayu
# Date: 2022-05-03
# Filename: k8s.sh
# Describe: 
#######################################
function start(){
    systemctl start kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet docker && exit 0 || exit 1
}

function stop(){
    systemctl stop kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet docker && exit 0 || exit 1
}

case $1 in
    "start")
        start
        if [ $? -eq 0 ]; then
            echo "k8s start ok"
        else
            echo "k8s start fail"
        fi
    ;;
    "stop")
        stop
        if [ $? -eq 0 ]; then
            echo "k8s stop ok"
        else
            echo "k8s stop fail"
        fi
    ;;
    *)
        echo "bash k8s.sh start|stop"
    ;;
esac
