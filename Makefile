VENV 	?= venv
PYTHON 	= $(VENV)/bin/python3
PIP		= $(VENV)/bin/pip

# Variables used to configure
IMAGE_REGISTRY_DOCKERHUb	?= jacano1986
IMAGE_REGISTRY_GHCR             ?= ghcr.io
IMAGE_REPO		= jacano1986
IMAGE_NAME		?= keepcoding-simple-fast-api
VERSION			?= develop

# Variables used to configure docker images registries to build and push
IMAGE			= $(IMAGE_REGISTRY)/$(IMAGE_REPO)/$(IMAGE_NAME):$(VERSION)
IMAGE_LATEST	= $(IMAGE_REGISTRY)/$(IMAGE_REPO)/$(IMAGE_NAME):latest

.PHONY: run
run: $(VENV)/bin/activate
	$(PYTHON) src/app.py

.PHONY: unit-test
unit-test: $(VENV)/bin/activate
	pytest

.PHONY: unit-test-coverage
unit-test-coverage: $(VENV)/bin/activate
	pytest --cov

.PHONY: $(VENV)/bin/activate
$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install -r requirements.txt

.PHONY: docker-build
docker-build: ## Build main image
	docker build -t $(IMAGE) -t $(IMAGE_LATEST) .

.PHONY: publish
publish: docker-build ## Publish main image
	docker push $(IMAGE)
	docker push $(IMAGE_LATEST)
