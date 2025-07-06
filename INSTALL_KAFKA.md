 kubectl run kafka-producer -ti --rm --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 -n kafka --   bin/kafka-console-producer.sh     --bootstrap-server my-cluster-kafka-bootstrap:9092     --topic my-first-topic


 kubectl run kafka-consumer -ti --rm --image=quay.io/strimzi/kafka:0.41.0-kafka-3.7.0 -n kafka --   bin/kafka-console-consumer.sh     --bootstrap-server my-cluster-kafka-bootstrap:9092     --topic my-first-topic     --from-beginning