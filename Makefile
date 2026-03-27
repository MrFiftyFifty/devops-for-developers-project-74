.PHONY: setup dev test

setup:
	docker-compose run --rm app make setup

dev:
	docker-compose up

test:
	docker-compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app
