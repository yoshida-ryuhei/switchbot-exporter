IMAGE_NAME := nasa9084/switchbot-exporter:latest
CONTAINER_NAME := switchbot-exporter
PORT := 8080

.PHONY: build up down restart logs

build:
	docker build -t $(IMAGE_NAME) .

up:
	docker run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT):8080 \
		-e SWITCHBOT_OPENTOKEN=$(shell cat .env | yq .token) \
		-e SWITCHBOT_SECRETKEY=$(shell cat .env | yq .client_secret) \
		$(IMAGE_NAME)
	@echo "Exporter is running at http://localhost:$(PORT)/metrics"

down:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)

restart: down up

logs:
	docker logs -f $(CONTAINER_NAME)
