export KUBECONFIG=/root/.kube/config
export ISTIO_VERSION="1.1.3"
export HELM_VERSION="v2.14.1"
wget https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz
tar zxvf helm-$HELM_VERSION-linux-amd64.tar.gz
mv linux-amd64/helm /usr/bin/
chmod u+x /usr/bin/helm

cd /root
curl -L https://git.io/getLatestIstio | sh -
cd istio-${ISTIO_VERSION}
for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: istio-system
  labels:
    istio-injection: disabled
EOF

# A template with sidecar injection enabled.
helm template --namespace=istio-system \
--set sidecarInjectorWebhook.enabled=true \
--set sidecarInjectorWebhook.enableNamespacesByDefault=true \
--set global.proxy.autoInject=disabled \
--set global.disablePolicyChecks=true \
--set prometheus.enabled=false \
`# Disable mixer prometheus adapter to remove istio default metrics.` \
--set mixer.adapters.prometheus.enabled=false \
`# Disable mixer policy check, since in our template we set no policy.` \
--set global.disablePolicyChecks=true \
`# Set gateway pods to 1 to sidestep eventual consistency / readiness problems.` \
--set gateways.istio-ingressgateway.autoscaleMin=1 \
--set gateways.istio-ingressgateway.autoscaleMax=1 \
--set gateways.istio-ingressgateway.resources.requests.cpu=500m \
--set gateways.istio-ingressgateway.resources.requests.memory=256Mi \
`# More pilot replicas for better scale` \
--set pilot.autoscaleMin=2 \
`# Set pilot trace sampling to 100%` \
--set pilot.traceSampling=100 \
install/kubernetes/helm/istio \
> ./istio.yaml
kubectl apply -f istio.yaml
