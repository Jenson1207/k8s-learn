docker network create app-tier --driver bridge

docker run -d --name zookeeper-server -p 2181:2181 --cpus 2 --memory 512M --network app-tier -e ALLOW_ANONYMOUS_LOGIN=yes bitnami/zookeeper:latest

docker run -d --name kafka-server --network app-tier -p 9092:9092 --cpus 2 --memory 4G -e ALLOW_PLAINTEXT_LISTENER=yes -e KAFKA_CFG_ZOOKEEPER_CONNECT=192.168.0.10:2181 -e KAFKA_BROKER_ID=0 -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://192.168.0.10:9092 -v /etc/localtime:/etc/localtime -v /home/kafka:/bitnami/kafka bitnami/kafka:latest


docker run -it --rm --network app-tier -e KAFKA_CFG_ZOOKEEPER_CONNECT=192.168.0.10:2181 bitnami/kafka:3.2 kafka-topics.sh --list  --bootstrap-server 192.168.0.10:9092
