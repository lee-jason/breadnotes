.PHONY: help dev up down build logs shell-api shell-web shell-db psql migrate migrate-create clean test

help: ## Show this help message
	@echo "BreadNotes Development Commands"
	@echo "==============================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev: ## Start development environment
	@echo "Starting BreadNotes development environment..."
	docker-compose up --build -d
	@echo "Waiting for database to be ready..."
	@sleep 10
	@echo "Running database migrations..."
	docker-compose exec api uv run alembic upgrade head
	@echo "Development environment is ready!"
	@echo "Frontend: http://localhost:3000"
	@echo "API: http://localhost:8000"
	@echo "API Docs: http://localhost:8000/docs"

up: ## Start services without building
	docker-compose up -d

down: ## Stop all services
	docker-compose down

stop: ## Stop services without removing containers
	docker-compose stop

restart: ## Restart all services
	docker-compose restart

build: ## Build all Docker images
	docker-compose build --no-cache

rebuild: ## Rebuild and restart services
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

logs: ## Show logs for all services
	docker-compose logs -f

logs-api: ## Show API logs
	docker-compose logs -f api

logs-web: ## Show web logs
	docker-compose logs -f web

logs-db: ## Show database logs
	docker-compose logs -f db

shell-api: ## Access API container shell
	docker-compose exec api /bin/bash

shell-web: ## Access web container shell
	docker-compose exec web /bin/sh

shell-db: ## Access database shell
	docker-compose exec db psql -U $${POSTGRES_USER:-breadnotes} -d $${POSTGRES_DB:-breadnotes}

psql: ## Access PostgreSQL database directly
	docker-compose exec db psql -U $${POSTGRES_USER:-breadnotes} -d $${POSTGRES_DB:-breadnotes}

migrate: ## Run database migrations
	docker-compose exec api uv run alembic upgrade head

migrate-create: ## Create new migration
	docker-compose exec api uv run alembic revision --autogenerate -m "$(MSG)"

migrate-down: ## Downgrade database by one migration
	docker-compose exec api uv run alembic downgrade -1

migrate-reset: ## Reset database (WARNING: This will delete all data)
	@echo "WARNING: This will delete all data in the database!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo ""; \
		docker-compose down -v; \
		docker-compose up -d db; \
		sleep 10; \
		docker-compose exec api uv run alembic upgrade head; \
		echo "Database reset complete"; \
	else \
		echo ""; \
		echo "Database reset cancelled"; \
	fi

test: ## Run tests
	docker-compose exec api uv run pytest

clean: ## Clean up Docker resources
	docker-compose down -v --remove-orphans
	docker system prune -f
	docker volume prune -f

clean-all: ## Clean up everything
	docker-compose down -v --remove-orphans
	docker system prune -af
	docker volume prune -f

health: ## Check service health
	@echo "Checking service health..."
	@echo "API Health:"
	@curl -s http://localhost:8000/api/health || echo "API not responding"
	@echo "\nWeb Health:"
	@curl -s http://localhost:3000/health || echo "Web not responding"
	@echo "\nDatabase Health:"
	@docker-compose exec -T db pg_isready -U $${POSTGRES_USER:-breadnotes} -d $${POSTGRES_DB:-breadnotes}

env-setup: ## Create environment files from examples
	@if [ ! -f .env ]; then \
		echo "Creating .env file..."; \
		cp .env.example .env; \
		echo "Please edit .env file with your configuration"; \
	fi
	@if [ ! -f api/.env ]; then \
		echo "Creating api/.env file..."; \
		cp api/.env.example api/.env; \
		echo "Please edit api/.env file with your configuration"; \
	fi
	@if [ ! -f web/.env.local ]; then \
		echo "Creating web/.env.local file..."; \
		cp web/.env.example web/.env.local; \
		echo "Please edit web/.env.local file with your configuration"; \
	fi

setup: env-setup dev ## Complete setup for new development environment

status: ## Show service status
	docker-compose ps