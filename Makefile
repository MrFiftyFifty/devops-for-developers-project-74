COMPOSE ?= docker-compose

.PHONY: setup dev test ci

ci:
	$(COMPOSE) -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

test: ci

setup:
	$(COMPOSE) run --rm app make setup

dev:
	$(COMPOSE) up
