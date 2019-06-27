source /root/env.sh
namespace="metal3"
cd /root
git clone https://github.com/metal3-io/baremetal-operator
cd baremetal-operator
kubectl create ns $namespace
sed -i "s/namespace: .*/namespace: $namespace/g" deploy/role_binding.yaml

kubectl apply -f deploy/service_account.yaml --namespace=$namespace
kubectl apply -f deploy/role.yaml --namespace=$namespace
kubectl apply -f deploy/role_binding.yaml
kubectl apply -f deploy/crds/metal3_v1alpha1_baremetalhost_crd.yaml
kubectl apply -f deploy/operator.yaml --namespace=$namespace
cat /root/provider-components.yaml | kubectl apply -f - --namespace=$namespace
