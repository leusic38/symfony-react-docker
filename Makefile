dc := docker-compose
de := $(dc) exec
sy := $(de) php bin/console
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
	docker-compose run -it admin
.PHONY: client
client:
	docker-compose run client

.PHONY: route
route:
	docker-compose exec php bin/console debug:router

.PHONY: sy
sy:
	$(sy)

.PHONY: start
start:
	$(dc) up -d

.PHONY: stop
stop:
	$(dc) stop

.PHONY: cc
cc:
	$(sy) cache:clear

.PHONY: dfl
dfl:
	$(sy) doctrine:fixture:load

.PHONY: cu
cu:
	$(de) php composer update
