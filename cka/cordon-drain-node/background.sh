kubectl create ns 012963bd

kubectl -n 012963bd create deploy nginx --image nginx --replicas 5

kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-