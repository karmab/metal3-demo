source /root/env.sh
kubectl create -f https://github.com/$CDI_REPO/releases/download/$CDI_VERSION/cdi-operator.yaml
kubectl create -f https://github.com/$CDI_REPO/releases/download/$CDI_VERSION/cdi-operator-cr.yaml
