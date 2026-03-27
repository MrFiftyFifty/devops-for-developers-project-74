setup: install db-migrate

install:
	npm install

db-migrate:
	@db_reachable=true; \
	if [ "$${DATABASE_HOST}" = "db" ]; then \
	  db_reachable=false; \
	  if command -v getent >/dev/null 2>&1 && getent hosts db >/dev/null 2>&1; then \
	    db_reachable=true; \
	  elif command -v bash >/dev/null 2>&1 && bash -c 'cat < /dev/null > /dev/tcp/db/5432' 2>/dev/null; then \
	    db_reachable=true; \
	  fi; \
	fi; \
	if [ "$${DATABASE_HOST}" = "db" ] && [ "$$db_reachable" = "false" ]; then \
	  env -u DATABASE_HOST -u DATABASE_NAME -u DATABASE_USERNAME -u DATABASE_PASSWORD -u DATABASE_PORT npm run migrate; \
	else \
	  npm run migrate; \
	fi

build:
	npm run build

prepare-env:
	cp -n .env.example .env

start:
	NODE_ENV=production npm run start

dev:
	npx concurrently "make start-frontend" "make start-backend"

start-backend:
	npm start -- --watch --verbose-watch --ignore-watch='node_modules .git .sqlite'

start-frontend:
	npx webpack --watch --progress

lint:
	npx eslint .

lint-fix:
	npx eslint --fix .

test:
	NODE_ENV=test npm test -s
