## Docker-Compose 部署Kafka集群
注意：需要三台机器,无法在一台机器上运行
1. 节点首先部署Docker/Docker-Compose
2. 创建zookeeper/kafka数据目录, mkdir -p /data/zookeeper/{data,datalog} && mkdir -p /data/kafka && chmod -R 755 /data
3. 启动zookeeper/kafka, docker-compose -f  kafka-1.yaml up -d  每台节点启动即可
4. 关闭zookeeper/kafka，docker-compose -f kafka-1.yaml down
