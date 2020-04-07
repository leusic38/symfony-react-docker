dc := docker-compose
de := $(dc) exec
sy := $(de) bin/console
dr := $(dc) run --rm

vendor/autoload.php: apps/api-symfo/composer.lock
	$(dr) --no-deps php composer install
	touch vendor/autoload.php

node_modules/time: yarn.lock
	$(dr) --no-deps node yarn
	touch node_modules/time

public/assets: node_modules/time
	$(dr) --no-deps node yarn run build

.PHONY: api
api:
	docker-compose exec php fish
.PHONY: admin
admin:
	docker-compose exec admin
.PHONY: client
client:
	docker-compose exec client

