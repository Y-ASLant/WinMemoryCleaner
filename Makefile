.PHONY: clean build install test

PROJECT_DIR := src
PROJECT_FILE := $(PROJECT_DIR)/WinMemoryCleaner.csproj
CONFIGURATION := Release
OUTPUT_DIR := $(PROJECT_DIR)/bin/$(CONFIGURATION)/net48
PREFIX ?= $(CURDIR)/dist
INSTALL_DIR := $(DESTDIR)$(PREFIX)/WinMemoryCleaner

clean:
	@dotnet clean $(PROJECT_FILE) --configuration $(CONFIGURATION) --verbosity quiet >/dev/null 2>&1 || true
	@rm -rf $(PROJECT_DIR)/bin $(PROJECT_DIR)/obj $(PROJECT_DIR)/*.xml dist 2>/dev/null || true
	@echo "Cleaned build artifacts"

build:
	@dotnet build $(PROJECT_FILE) --configuration $(CONFIGURATION)

test: build
	@dotnet test $(PROJECT_FILE) --configuration $(CONFIGURATION) --no-build
install: build
	@mkdir -p $(INSTALL_DIR)
	@cp $(OUTPUT_DIR)/*.exe $(OUTPUT_DIR)/*.config $(INSTALL_DIR)/
	@cp $(OUTPUT_DIR)/System.*.dll $(OUTPUT_DIR)/Microsoft.Bcl.AsyncInterfaces.dll $(INSTALL_DIR)/ 2>/dev/null || true
	@cp $(OUTPUT_DIR)/WinMemoryCleaner.pdb $(INSTALL_DIR)/ 2>/dev/null || true
	@echo "Installed WinMemoryCleaner to $(INSTALL_DIR)"
