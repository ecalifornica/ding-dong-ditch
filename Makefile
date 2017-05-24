SHELL := /bin/bash

.PHONY: setup
setup:
	stat venv/bin/activate &> /dev/null || \
	virtualenv venv -p python3.6
	source venv/bin/activate; \
	pip install -r requirements.txt

.PHONY: setup_test
setup_test:
	source venv/bin/activate; \
	pip install -r requirements.txt; \
	pip install -r requirements_test.txt

.PHONY: setup_ci
setup_ci:
	pip install -r requirements.txt
	pip install -r requirements_test.txt

.PHONY: install
install:
	sudo cp dingdongditch.service /lib/systemd/system/dingdongditch.service
	sudo chmod 644 /lib/systemd/system/dingdongditch.service
	sudo systemctl daemon-reload
	sudo systemctl enable dingdongditch.service
	sudo systemctl start dingdongditch
	sudo systemctl status dingdongditch

.PHONY: uninstall
uninstall:
	sudo systemctl stop dingdongditch
	sudo systemctl disable dingdongditch.service
	sudo rm /lib/systemd/system/dingdongditch.service
	sudo systemctl daemon-reload

.PHONY: run
run:
	source venv/bin/activate; \
	source env.sh; \
	python run.py

.PHONY: test
test:
	source venv/bin/activate; \
	PYTHONPATH=.:./tests/mocks py.test tests

.PHONY: test_ci
test_ci:
	PYTHONPATH=.:./tests/mocks py.test tests
