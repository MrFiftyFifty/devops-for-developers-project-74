COMPOSE ?= $(shell docker compose version >/dev/null 2>&1 && echo "docker compose" || echo "docker-compose")

.PHONY: setup dev test ci env down refresh

env:
	cp -n .env.example .env

down:
	$(COMPOSE) down --remove-orphans

refresh: down
	-docker ps -a --filter "name=devops-for-developers-project-74" -q | xargs -r docker rm -f
	$(COMPOSE) up

ci:
	$(COMPOSE) -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

test: ci

setup:
	$(COMPOSE) run --rm app make setup

dev:
	$(COMPOSE) up
