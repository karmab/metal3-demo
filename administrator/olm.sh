source /root/env.sh
kubectl apply -f https://github.com/$OLM_REPO/releases/download/$OLM_VERSION/crds.yaml
kubectl apply -f https://github.com/$OLM_REPO/releases/download/$OLM_VERSION/olm.yaml
