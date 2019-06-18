VERSION="v0.6.0"

kubectl apply --selector knative.dev/crd-install=true \
   --filename https://github.com/knative/serving/releases/download/$VERSION/serving.yaml \
   --filename https://github.com/knative/build/releases/download/$VERSION/build.yaml \
   --filename https://github.com/knative/eventing/releases/download/$VERSION/release.yaml \
   --filename https://github.com/knative/eventing-sources/releases/download/$VERSION/eventing-sources.yaml \
   --filename https://github.com/knative/serving/releases/download/$VERSION/monitoring.yaml \
   --filename https://raw.githubusercontent.com/knative/serving/$VERSION/third_party/config/build/clusterrole.yaml

kubectl apply --filename https://github.com/knative/serving/releases/download/$VERSION/serving.yaml --selector networking.knative.dev/certificate-provider!=cert-manager \
   --filename https://github.com/knative/build/releases/download/$VERSION/build.yaml \
   --filename https://github.com/knative/eventing/releases/download/$VERSION/release.yaml \
   --filename https://github.com/knative/eventing-sources/releases/download/$VERSION/eventing-sources.yaml \
   --filename https://github.com/knative/serving/releases/download/$VERSION/monitoring.yaml \
   --filename https://raw.githubusercontent.com/knative/serving/$VERSION/third_party/config/build/clusterrole.yaml
