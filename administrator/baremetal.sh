export KUBECONFIG=/root/.kube/config
cd /root
git clone https://github.com/metal3-io/baremetal-operator
cd baremetal-operator
kubectl create ns metal3
sed -i "s/namespace: .*/namespace: metal3/g" deploy/role_binding.yaml
kubectl apply -f deploy/service_account.yaml --namespace=metal3
kubectl apply -f deploy/role.yaml --namespace=metal3
kubectl apply -f deploy/role_binding.yaml
kubectl apply -f deploy/crds/metal3_v1alpha1_baremetalhost_crd.yaml
#kubectl apply -f deploy/operator.yaml --namespace=metal3
#sed -e "s/172.22.0.1\([^0-9]\)/172.22.0.2\1/" -e "s/ens3/eth1/" -e "s/localhost/172.22.0.2/" deploy/ironic_bmo_configmap.yaml | kubectl apply -f - --namespace=metal3
sed -e "s/172.22.0.1/172.22.0.2/" deploy/operator.yaml | kubectl apply -f - --namespace=metal3
cat /root/provider-components.yaml | kubectl apply -f - --namespace=metal3
kubectl config set-context kubernetes-admin@kubernetes --namespace=metal3
