export KUBECONFIG=/root/.kube/config
VERSION="0.12.0"
kubectl create namespace kafka
curl -L https://github.com/strimzi/strimzi-kafka-operator/releases/download/$VERSION/strimzi-cluster-operator-$VERSION.yaml \
  | sed 's/namespace: .*/namespace: kafka/' \
  | kubectl -n kafka apply -f -
kubectl apply -f https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/$VERSION/examples/kafka/kafka-persistent-single.yaml -n kafka
