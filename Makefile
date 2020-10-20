##
# Scout
#
# @file
# @version 0.1


.PHONY: build run init prune

build:
	docker-compose build
init:
	docker-compose up --detach
	docker-compose exec web yes | scout --host db setup database
	docker-compose exec web scout --host db load panel scout/demo/panel_1.txt
	docker-compose exec web scout --host db case scout/demo/643594.config.yaml
	echo "Setup scout demo database"
	docker-compose down
run:
	docker-compose up
bash:
	docker-compose run web /bin/bash
prune:
	docker-compose down --remove-orphans
	rm -rf volumes/mongodb/data/*
	docker images prune

# end
