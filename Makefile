#███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗██╗      ██████╗     ██████╗
#████╗ ████║██╔═══██╗██╔══██╗██║   ██║██║     ██╔═══██╗    ╚════██╗
#██╔████╔██║██║   ██║██║  ██║██║   ██║██║     ██║   ██║     █████╔╝
#██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██║     ██║   ██║     ╚═══██╗
#██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝███████╗╚██████╔╝    ██████╔╝
#╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝ ╚═════╝     ╚═════╝

build:
	mvn clean package -DskipTests
	docker-compose build

up:
	docker-compose up -d
	@echo "Aguardando Kafka inicializar..."
	@sleep 10
	@echo "✅ Serviços iniciados!"
	@echo "Execute 'make logs' para ver os logs"

down:
	docker-compose down

logs:
	docker-compose logs -f kafka-consumer

logs-all:
	docker-compose logs -f

test-send:
	@echo "Digite suas mensagens (Ctrl+C para sair):"
	@docker exec -it kafka kafka-console-producer \
		--bootstrap-server localhost:9092 \
		--topic meu-topico

test-receive:
	@docker exec -it kafka kafka-console-consumer \
		--bootstrap-server localhost:9092 \
		--topic meu-topico \
		--from-beginning

list-topics:
	@docker exec kafka kafka-topics \
		--list \
		--bootstrap-server localhost:9092

create-topic:
	@docker exec kafka kafka-topics \
		--create \
		--if-not-exists \
		--bootstrap-server localhost:9092 \
		--replication-factor 1 \
		--partitions 3 \
		--topic meu-topico
	@echo "✅ Tópico criado!"

restart: down up

clean: down
	docker-compose down -v
	docker system prune -f
	mvn clean

.PHONY: help build up down logs test-send clean restart
