# devops-for-developers-project-74

Учебный репозиторий по DevOps: в `app/` лежит блог на Fastify из практики Hexlet, всё остальное — Docker, Compose, CI и обёртки вокруг приложения.

Статус проверок:

[![Hexlet](https://github.com/MrFiftyFifty/devops-for-developers-project-74/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/MrFiftyFifty/devops-for-developers-project-74/actions)
[![CI push](https://github.com/MrFiftyFifty/devops-for-developers-project-74/actions/workflows/push.yml/badge.svg?branch=main)](https://github.com/MrFiftyFifty/devops-for-developers-project-74/actions/workflows/push.yml?query=branch%3Amain)

## Что нужно на машине

Понадобятся Docker (удобнее всего Docker Desktop на Windows с WSL2), Compose — лучше v2 (`docker compose`), и обычный `make`. Для локального сценария с Caddy и приложением должны быть свободны порты 80, 443 и 8080; если что-то уже занято, смотрите `docker-compose.override.yml` или остановите лишние контейнеры.

## Образ на Docker Hub

Собранный прод-образ пушится в **`devdanilboe/devops-for-developers-project-74:latest`** — [страница на Hub](https://hub.docker.com/r/devdanilboe/devops-for-developers-project-74). После `docker login` тот же тег можно стянуть и дернуть, например:

```bash
docker run --rm -p 8080:8080 -e NODE_ENV=development devdanilboe/devops-for-developers-project-74:latest make dev
```

## Как поднять у себя

1. Скопируйте переменные окружения: `make env` или вручную `cp .env.example .env`. Список переменных — в `.env.example`; сам `.env` в репозиторий не кладём.

2. Первый раз поставьте зависимости и миграции: `make setup`.

3. Разработка: `make dev` — поднимется compose с override (приложение, Postgres, при необходимости Caddy).

Настройки приложения и БД идут через env, без захардкоженных секретов в коде — идея в духе [twelve-factor config](https://12factor.net/config).

## Makefile — что за что отвечает

`make env` — создать `.env` из примера, если его ещё нет.

`make setup` — один раз прогнать установку зависимостей и миграции внутри контейнера приложения.

`make dev` — поднять стек для разработки (`docker compose up` с override).

`make test` — прогнать тесты так же, как в CI: только `docker-compose.yml`, прод-образ и Postgres, без override.

`make down` — остановить сервисы.

`make refresh` — если после обновления образа старый `docker-compose` v1 начинает сыпать ошибками про ContainerConfig: `down`, снести контейнеры проекта и снова `up`.

Внутри `app/` свой Makefile — это команды уже относительно приложения; с корня мы всё ведём через Compose.

## Тесты и CI

Тесты и локально, и в GitHub Actions гоняются внутри Docker. В CI за push и публикацию образа отвечает workflow `push`; для Docker Hub в секретах репозитория должны быть `DOCKER_USERNAME` и `DOCKER_PASSWORD` (или токен).

## Docker в двух словах

Базовый `docker-compose.yml` собирает приложение из `Dockerfile.production`, в том же файле поднимается Postgres, наружу порты приложения не торчат — только внутренняя сеть. Файл `docker-compose.override.yml` для локалки: сборка из короткого `Dockerfile`, монтирование `./app`, порты и Caddy поверх.
