# Finviz Scanner Frontend Makefile
# Provides easy commands for building and running different environments

.PHONY: help build-dev build-prod build-test run-dev run-prod run-test stop clean

help: ## Show this help message
	@echo "Finviz Scanner Frontend Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Build commands
build-dev: ## Build development image
	docker-compose -f docker-compose.dev.yml build

build-prod: ## Build production image
	docker-compose -f docker-compose.yml build

build-test: ## Build test image
	docker-compose -f docker-compose.test.yml build

build-all: ## Build all images (dev, prod, test)
	$(MAKE) build-dev
	$(MAKE) build-prod
	$(MAKE) build-test

# Run commands
run-dev: ## Run development environment
	docker-compose -f docker-compose.dev.yml up -d
	@echo "Development frontend running at http://localhost:8080"

run-prod: ## Run production environment
	docker-compose -f docker-compose.yml up -d
	@echo "Production frontend running at http://localhost:80"

run-test: ## Run test environment
	docker-compose -f docker-compose.test.yml up -d
	@echo "Test frontend running at http://localhost:9080"

# Stop commands
stop-dev: ## Stop development environment
	docker-compose -f docker-compose.dev.yml down

stop-prod: ## Stop production environment
	docker-compose -f docker-compose.yml down

stop-test: ## Stop test environment
	docker-compose -f docker-compose.test.yml down

stop-all: ## Stop all environments
	$(MAKE) stop-dev
	$(MAKE) stop-prod
	$(MAKE) stop-test

# Utility commands
logs-dev: ## Show development logs
	docker-compose -f docker-compose.dev.yml logs -f

logs-prod: ## Show production logs
	docker-compose -f docker-compose.yml logs -f

logs-test: ## Show test logs
	docker-compose -f docker-compose.test.yml logs -f

test: ## Run health check tests
	@echo "Testing development environment..."
	@curl -f http://localhost:8080/health 2>/dev/null && echo "✓ Dev health check passed" || echo "✗ Dev health check failed"
	@echo "Testing production environment..."
	@curl -f http://localhost:80/health 2>/dev/null && echo "✓ Prod health check passed" || echo "✗ Prod health check failed"
	@echo "Testing test environment..."
	@curl -f http://localhost:9080/health 2>/dev/null && echo "✓ Test health check passed" || echo "✗ Test health check failed"

clean: ## Clean up Docker images and containers
	docker-compose -f docker-compose.yml down --rmi all --volumes --remove-orphans
	docker-compose -f docker-compose.dev.yml down --rmi all --volumes --remove-orphans
	docker-compose -f docker-compose.test.yml down --rmi all --volumes --remove-orphans
	docker system prune -f

# Quick development workflow
dev: ## Quick development setup (build + run)
	$(MAKE) build-dev
	$(MAKE) run-dev

# Production deployment
deploy: ## Production deployment (build + run)
	$(MAKE) build-prod
	$(MAKE) run-prod

# Development with live reload
dev-watch: ## Development with file watching (requires inotify-tools)
	@echo "Starting development environment with file watching..."
	$(MAKE) run-dev
	@echo "Watching for changes to frontend.html..."
	@while inotifywait -e close_write frontend.html 2>/dev/null; do \
		echo "File changed, restarting container..."; \
		docker-compose -f docker-compose.dev.yml restart frontend; \
	done || echo "File watching not available (install inotify-tools for auto-reload)"
