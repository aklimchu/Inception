#Colors
DEF_COLOR = \033[0;39m
RED = \033[0;91m
GREEN = \033[0;92m
YELLOW = \033[0;93m

# Variables
DOCKER_COMPOSE_COMM=docker compose
DOCKER_COMPOSE_FILE=./srcs/docker-compose.yml

# Rules
all:		build

build:
			@echo "$(YELLOW)Building Inception... $(DEF_COLOR)"
			mkdir -p /home/aklimchu/data/mariadb_data
			mkdir -p /home/aklimchu/data/wordpress_data
			@$(DOCKER_COMPOSE_COMM)  -f $(DOCKER_COMPOSE_FILE) up --build -d
			@echo "$(GREEN)SUCCESS, INCEPTION IS READY $(DEF_COLOR)"

down:
			@$(DOCKER_COMPOSE_COMM) -f $(DOCKER_COMPOSE_FILE) down

clean:		
			@echo "$(RED)Deleting Inception... $(DEF_COLOR)"
			@$(DOCKER_COMPOSE_COMM) -f $(DOCKER_COMPOSE_FILE) down -v --remove-orphans --rmi all
			@echo "$(GREEN)CLEAR $(DEF_COLOR)"

re: 		clean all

.PHONY: 	all build down clean re