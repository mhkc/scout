##
# Scout
#
# @file
# @version 0.1


.PHONY: build run init prune help

build:    ## Build new images
	docker-compose build
init:    ## Initialize scout database
	docker-compose up --detach
	docker-compose exec web yes | scout --host db setup database
	docker-compose exec web scout --host db load panel scout/demo/panel_1.txt
	docker-compose exec web scout --host db case scout/demo/643594.config.yaml
	echo "Setup scout demo database"
	docker-compose down
up:    ## Run Scout software
	docker-compose up
down:    ## Take down Scout software
bash:    ## Remove dangling images, volumes and used data
	docker-compose run web /bin/bash
prune:    ## Remove dangling images, volumes and used data
	docker-compose down --remove-orphans
	rm -rf volumes/mongodb/data/*
	docker images prune
help:    ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# end
