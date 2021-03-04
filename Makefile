SHELL := /bin/bash

PYTHON_VERSIONS := 3.7 3.8 3.9

# $1 = package name
define print_pkg_version_stmt
import pkg_resources; \
print(pkg_resources.get_distribution("$1").version)
endef

# $1 = docker image
# $2 = package name
define pkg_version
	$(shell docker run -it --rm --entrypoint python $1 \
		-c '$(call print_pkg_version_stmt,$2)')
endef


.PHONY: all
all: $(foreach pyver,$(PYTHON_VERSIONS),build-$(pyver))

.PHONY: build-%
build-%:
	$(eval PYTHON_VERSION := $*)
	@echo $$'\e[01;32m=== Building for Python $(PYTHON_VERSION) ===\e[0m'
	$(eval VERSION := python$(PYTHON_VERSION))
	docker build --no-cache \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		-t otkds/piptools:$(VERSION) .
	$(eval PIPTOOLS_VERSION := \
		$(call pkg_version,otkds/piptools:$(VERSION),pip-tools))
	$(eval FULL_VERSION := $(VERSION)-$(PIPTOOLS_VERSION))
	docker tag otkds/piptools:$(VERSION) otkds/piptools:$(FULL_VERSION)
	@echo
	@echo $$'\e[01;32m--- To push images run: ---\e[0m'
	@echo "docker push otkds/piptools:$(VERSION)"
	@echo "docker push otkds/piptools:$(FULL_VERSION)"
	@echo $$'\e[01;32m---------------------------\e[0m'
	@echo
