SHELL := /bin/bash

CONTAINER = cloud_cost_sql_db
DB = cloudcost
USER = cloud

.PHONY: up down reset logs psql apply-views

up:
	docker compose up -d

down:
	docker compose down

reset:
	docker compose down -v
	docker compose up -d

logs:
	docker compose logs -f --tail=200

psql:
	PGPASSWORD=cloudpw psql -h localhost -U $(USER) -d $(DB)

apply-views:
	./scripts/apply_views.sh $(CONTAINER) $(DB) $(USER)
