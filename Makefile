GOOGLE_CLOUD_PROJECT = $(shell bash -c 'source .env.dev && echo $$GOOGLE_CLOUD_PROJECT')

GCLOUD_CMD = gcloud --project=$(GOOGLE_CLOUD_PROJECT)

PROJ_NAME = structured-logging-gcp-example


.PHONY: init
init: .venv/pyenv.cfg


.venv/pyenv.cfg: requirements.txt
	python3 -m venv --upgrade-deps .venv
	.venv/bin/pip install -U pip setuptools wheel
	.venv/bin/pip install -U -r requirements.txt
	touch .venv/pyenv.cfg



##############################

.PHONY: local
local: run-local  # alias to run-local

##############################

.PHONY: run-local
run-local:
	env PYTHONUNBUFFERED=1 .venv/bin/flask --app main run --reload --port 8080


.PHONY: run-container-local
run-container-local:
	env DOCKER_BUILDKIT=1 docker image build --tag $(PROJ_NAME) .
	docker container run --rm -it --init -p 8080:8080 --env-file=.env.dev $(PROJ_NAME)


.PHONY: lint
lint:
	pipx run isort *.py
	pipx run black *.py

################################

.PHONY: curl-trace-local
curl-trace-local: RANDOM_TRACE_ID=$(shell openssl rand -hex 16)# generate 32 hex characters
curl-trace-local:
	curl localhost:8080/trace -H "X-Cloud-Trace-Context: $(RANDOM_TRACE_ID)/1;o=1"


################################

.PHONY: deploy-dev
deploy-dev:
	$(GCLOUD_CMD) run deploy --max-instances=1 --min-instances=0 --region=us-central1 --allow-unauthenticated --source=. $(PROJ_NAME)


.PHONY: destroy-dev
destroy-dev:
	$(GCLOUD_CMD) run services delete --region=us-central1 $(PROJ_NAME)
