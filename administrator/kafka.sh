kubectl create namespace kafka
curl -L https://github.com/strimzi/strimzi-kafka-operator/releases/download/$KAFKA_VERSION/strimzi-cluster-operator-$KAFKA_VERSION.yaml \
  | sed 's/namespace: .*/namespace: kafka/' \
  | kubectl -n kafka apply -f -
kubectl apply -f https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/$KAFKA_VERSION/examples/kafka/kafka-persistent-single.yaml -n kafka
