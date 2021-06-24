SHELL=/bin/bash
PYTHONPATH=`pwd`/src

all:
	@echo IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18gCjwgVGhlcmUgaXMgbm8gZGVmYXVsdCBNYWtlZmlsZSB0YXJnZXQgPgogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAKICAgICAgICBcICAgXl9fXgogICAgICAgICBcICAob28pXF9fX19fX18KICAgICAgICAgICAgKF9fKVwgICAgICAgKVwvXAogICAgICAgICAgICAgICAgfHwtLS0tdyB8CiAgICAgICAgICAgICAgICB8fCAgICAgfHwK | base64 -d
	@echo "* make install            - install required requirements"
	@echo "  - make install-core     - install core requirements"
	@echo "  - make install-dev      - install development requirements"
	@echo "* make test               - run the test suite."
	@echo "  - make unittest         - test a unit of source code. inspired by JUnit."
	@echo "  - make docttest         - run examples embedded in the documentation and verifying that they produce the expected results."
	@echo "* make docs               - run pdoc3 to create project documentation."
	@echo "* make mypy               - run optional static type checker on project"
	@echo "* make pylint             - run static code analysis on project"
	@echo "* make flake8             - run the flake8 code checker."
	@echo "* make isort              - sort imports alphabetically, and automatically separated into sections and by type."
	@echo "* make docker             - build an image from Dockerfile & runs a container"
	@echo "  - make docker-build     - build an image from Dockerfile"
	@echo "  - make docker-run       - run a container from newly built image"
	@echo "* make clean              - delete any __pycache__ or .mypy_cache + docs dir + docker image"
	@echo "  - make image-clean      - untag & remove relevent docker image"
	@echo "  - make container-clean  - remove relevent docker container"
	@echo "* make goat               - ???"

install: install-core install-dev

install-core:
	@echo "[*] Installing core dependencies..."
	@pip install -r requirements.txt

install-dev:
	@echo "[*] Installing dev dependencies..."
	@pip install -r requirements-dev.txt

clean: container-clean image-clean docs-clean
	@echo "[*] Cleaning any __pycache__ dir..."
	@find . -name '__pycache__' -type d -prune -exec rm -rf {} \;
	@echo "[*] Cleaning any .mypy_cache dir..."
	@find . -name '.mypy_cache' -type d -prune -exec rm -rf {} \;

isort:
	@PYTHONPATH=${PYTHONPATH} \
	isort src

flake8:
	flake8

lint: mypy pylint

pylint:
	@PYTHONPATH=${PYTHONPATH} \
	pylint src

mypy:
	@cd src; \
	mypy -p block -p wallet -p coin -p transaction

test: unittest doctest

docs:
	@echo "[*] Generating documentation using pdoc3..."
	@cd src; \
	pdoc3 --html . -o ../docs --force; \
	mkdir -p ../docs/src/assets; \
	cp ../assets/* ../docs/src/assets;

doctest:
	@PYTHONPATH=${PYTHONPATH} \
	python -m doctest sbittest.py

unittest:
	@PYTHONPATH=${PYTHONPATH} \
	python -m unittest sbittest

docker: image-build container-run

image-build:
	@echo "[*] Building a docker image from Dockerfile..."
	@docker build -t sbitcoin:1.0 .

container-run:
	@echo "[*] Spawning a docker container from sbitcoin image"
	@docker run -it --rm --name sbitcoin sbitcoin:1.0 bash

image-clean:
	@echo "[*] Untag & Remove sbitcoin docker image"
	@docker rmi sbitcoin:1.0 | true

container-clean:
	@echo "[*] No need, docker autoremoves container on exit with --rm"

goat:
	@echo IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXyAKPCBaaWVnZW4gc2luZCBrZWluZSBha3plcHRhYmxlIFfDpGhydW5nID4KIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAKICAgICAgICBcCiAgICAgICAgIFwKICAgICAgICAgIClfXygKICAgICAgICAgJ3xvb3wnX19fX19fX18vCiAgICAgICAgICB8X198ICAgICAgICAgfAogICAgICAgICAgICAgfHwiIiIiIiIifHwKICAgICAgICAgICAgIHx8ICAgICAgIHx8Cgo= | base64 -d
