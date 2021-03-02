PYTHON_VERSIONS := 3.7 3.8 3.9

PRINT_PIPTOOLS_VERSION = \
	import pkg_resources; \
	print(pkg_resources.get_distribution("pip-tools").version)

PIPTOOLS_VERSION_COMMAND = docker run -it --rm \
	--entrypoint python \
	otkds/piptools:python$(PYTHON_VERSION) \
	-c '$(PRINT_PIPTOOLS_VERSION)'

PIPTOOLS_VERSION = $(shell $(PIPTOOLS_VERSION_COMMAND))

BUILD_COMMAND = docker build \
	--no-cache \
	--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
	-t otkds/piptools:python$(PYTHON_VERSION) \
	.

TAG_PIPTOOLS_COMMAND = docker tag \
	otkds/piptools:python$(PYTHON_VERSION) \
	otkds/piptools:python$(PYTHON_VERSION)-$(PIPTOOLS_VERSION)


.PHONY: all
all: $(foreach pyver,$(PYTHON_VERSIONS),build-$(pyver))

.PHONY: build-%
build-%:
	$(eval PYTHON_VERSION = $*)
	@echo "Building for Python $(PYTHON_VERSION)"
	$(BUILD_COMMAND)
	$(TAG_PIPTOOLS_COMMAND)
	@echo "To push images run:"
	@echo "docker push otkds/piptools:python$(PYTHON_VERSION)"
	@echo "docker push otkds/piptools:python$(PYTHON_VERSION)-$(PIPTOOLS_VERSION)"
