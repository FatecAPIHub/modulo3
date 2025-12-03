# Kafka Consumer Lambda - Spring Boot 3 + Java 21

Aplicação Spring Boot que consome mensagens de um tópico Kafka e exibe no console.

## 📋 Pré-requisitos

- Java 21
- Maven 3.8+
- Docker e Docker Compose
- Conta no DockerHub (para publicação)

## 🚀 Estrutura do Projeto

```
kafka-consumer-lambda/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/exemplo/kafka/
│       │       ├── KafkaConsumerApplication.java
│       │       └── consumer/
│       │           └── KafkaMessageConsumer.java
│       └── resources/
│           └── application.yml
├── .github/
│   └── workflows/
│       └── docker-publish.yml
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

## 🛠️ Configuração

### 1. Clonar o Repositório

```bash
git clone <seu-repositorio>
cd kafka-consumer-lambda
```

### 2. Configurar Variáveis de Ambiente

Você pode configurar as seguintes variáveis:

- `KAFKA_BOOTSTRAP_SERVERS`: Endereço do servidor Kafka (padrão: localhost:9092)
- `KAFKA_TOPIC_NAME`: Nome do tópico a ser consumido (padrão: meu-topico)
- `KAFKA_CONSUMER_GROUP`: ID do grupo de consumidores (padrão: meu-grupo-consumidor)

## 🔧 Executar Localmente

### Com Docker Compose (Recomendado)

```bash
# Inicia Kafka, Zookeeper e a aplicação
docker-compose up -d

# Aguardar o Kafka inicializar (cerca de 10-15 segundos)
sleep 15

# Ver logs da aplicação
docker-compose logs -f kafka-consumer

# Parar os serviços
docker-compose down
```

### Usando Makefile (Mais Fácil)

```bash
# Ver todos os comandos disponíveis
make help

# Iniciar tudo
make up

# Ver logs
make logs

# Enviar mensagens de teste
make test-send

# Parar tudo
make down
```
## 📨 Testar o Consumer

### Opção 1: Usando o Makefile (Recomendado)

```bash
# Enviar mensagens
make test-send
```

### Opção 2: Usando script bash

```bash
chmod +x test-kafka.sh
./test-kafka.sh
```

### Opção 3: Manualmente

```bash
# Acessar o container do Kafka
docker exec -it kafka bash

# Enviar mensagens para o tópico
kafka-console-producer --bootstrap-server localhost:9092 --topic meu-topico
```

Digite suas mensagens e pressione Enter. Você verá no console do consumer:
```
A mensagem chegou: Sua mensagem aqui
A mensagem chegou: Outra mensagem
A mensagem chegou: Teste 123
```

### Verificar se está funcionando

```bash
# Ver logs em tempo real
docker-compose logs -f kafka-consumer

# Ou com make
make logs
```

## 🚢 Publicar no DockerHub via GitHub Actions

### 1. Configurar Secrets no GitHub

Vá em: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Adicione os seguintes secrets:

- `DOCKERHUB_USERNAME`: Seu usuário do DockerHub
- `DOCKERHUB_TOKEN`: Token de acesso do DockerHub
  - Criar em: https://hub.docker.com/settings/security
  - New Access Token → Nome: GitHub Actions → Create

### 2. Atualizar o Nome da Imagem

No arquivo `.github/workflows/docker-publish.yml`, altere:

```yaml
env:
  DOCKER_IMAGE_NAME: seu-usuario/kafka-consumer-lambda
```

Para seu usuário real do DockerHub.

### 3. Push para Ativar o Workflow

```bash
git add .
git commit -m "Configuração inicial"
git push origin main
```

A GitHub Action será acionada automaticamente e publicará a imagem no DockerHub.

### 4. Verificar Tags Criadas

A action cria várias tags automaticamente:
- `latest` (branch principal)
- `main` ou `master` (nome da branch)
- `v1.0.0` (se criar uma tag)
- `sha-abc123` (hash do commit)

## 📦 Usar a Imagem Publicada

```bash
docker pull seu-usuario/kafka-consumer-lambda:latest

docker run -e KAFKA_BOOTSTRAP_SERVERS=seu-kafka:9092 \
  -e KAFKA_TOPIC_NAME=meu-topico \
  seu-usuario/kafka-consumer-lambda:latest
```

## 🔍 Verificar Logs

```bash
# Docker Compose
docker-compose logs -f kafka-consumer

# Container individual
docker logs -f <container-id>

# Ver logs de todos os serviços
docker-compose logs -f
```

## 🎯 Recursos Adicionais

- Multi-stage build para otimizar o tamanho da imagem
- Cache de dependências Maven
- Suporte a variáveis de ambiente
- Health checks e restart automático
- GitHub Actions com build cache
