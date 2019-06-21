source /root/env.sh
kubectl create -f https://github.com/$KUBEVIRT_REPO/releases/download/$KUBEVIRT_VERSION/kubevirt-operator.yaml
kubectl create -f https://github.com/$KUBEVIRT_REPO/releases/download/$KUBEVIRT_VERSION/kubevirt-cr.yaml
