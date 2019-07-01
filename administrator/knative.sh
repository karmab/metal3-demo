KNATIVE_VERSION="v0.6.0"
kubectl apply --selector knative.dev/crd-install=true \
   --filename https://github.com/knative/serving/releases/download/$KNATIVE_VERSION/serving.yaml \
   --filename https://github.com/knative/build/releases/download/$KNATIVE_VERSION/build.yaml \
   --filename https://github.com/knative/eventing/releases/download/$KNATIVE_VERSION/release.yaml \
   --filename https://github.com/knative/eventing-sources/releases/download/$KNATIVE_VERSION/eventing-sources.yaml \
   --filename https://github.com/knative/serving/releases/download/$KNATIVE_VERSION/monitoring.yaml \
   --filename https://raw.githubusercontent.com/knative/serving/$KNATIVE_VERSION/third_party/config/build/clusterrole.yaml

kubectl apply --filename https://github.com/knative/serving/releases/download/$KNATIVE_VERSION/serving.yaml --selector networking.knative.dev/certificate-provider!=cert-manager \
   --filename https://github.com/knative/build/releases/download/$KNATIVE_VERSION/build.yaml \
   --filename https://github.com/knative/eventing/releases/download/$KNATIVE_VERSION/release.yaml \
   --filename https://github.com/knative/eventing-sources/releases/download/$KNATIVE_VERSION/eventing-sources.yaml \
   --filename https://github.com/knative/serving/releases/download/$KNATIVE_VERSION/monitoring.yaml \
   --filename https://raw.githubusercontent.com/knative/serving/$KNATIVE_VERSION/third_party/config/build/clusterrole.yaml
