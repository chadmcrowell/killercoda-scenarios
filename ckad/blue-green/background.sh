wget https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_03/deploy-spring-boot-blue.yaml

wget https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_03/deploy-spring-boot-green.yaml

wget https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_03/svc-spring-boot-blue.yaml

wget https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_03/svc-spring-boot-green.yaml

kubectl create -f deploy-spring-boot-blue.yaml

kubectl create -f deploy-spring-boot-green.yaml

kubectl create -f svc-spring-boot-blue.yaml

kubectl create -f svc-spring-boot-green.yaml

