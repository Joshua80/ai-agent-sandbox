# ai-agent-sandbox/Makefile

# Configuration
PROJECTS_DIR := projects
OUTPUTS_DIR := outputs
SCRIPTS_DIR := scripts
SHELL := /bin/bash

.PHONY: help init eshop-start medplum-start test-eshop test-medplum clean status

help:
	@echo "AI Agent Sandbox - Control Plane"
	@echo "--------------------------------"
	@echo "Usage:"
	@echo "  make init            - Prepare directories and permissions"
	@echo "  make eshop-start     - Spin up eShopOnWeb (SQL Server)"
	@echo "  make medplum-start   - Spin up Medplum (Postgres + Redis)"
	@echo "  make clean           - Wipe all containers, volumes, and outputs"
	@echo "  make status          - Check health of sandbox services"

init:
	@mkdir -p $(OUTPUTS_DIR)
	@chmod +x $(SCRIPTS_DIR)/*.sh
	@echo "✅ Environment initialized."

# --- PROJECT 1: eShopOnWeb ---
eshop-start: init
	@echo "🚀 Launching eShopOnWeb sandbox..."
	bash $(SCRIPTS_DIR)/run-sandbox.sh eshop

test-eshop:
	@echo "🧪 Running eShopOnWeb tests..."
	cd $(PROJECTS_DIR)/eshoponweb && dotnet test --logger "json;LogFileName=../../$(OUTPUTS_DIR)/eshop_results.json"

# --- PROJECT 2: Medplum ---
medplum-start: init
	@echo "🚀 Launching Medplum sandbox..."
	bash $(SCRIPTS_DIR)/run-sandbox.sh medplum

test-medplum:
	@echo "🧪 Running Medplum tests..."
	cd $(PROJECTS_DIR)/medplum && npm test -- --json --outputFile=../../$(OUTPUTS_DIR)/medplum_results.json

# --- CLEANUP & MANAGEMENT ---
status:
	@docker compose ps

clean:
	@echo "🧹 Cleaning all sandbox environments..."
	docker compose down -v
	rm -rf $(OUTPUTS_DIR)/*.json
	@echo "✅ Sandbox reset to clean state."