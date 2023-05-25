.PHONY: fix
fix:
	pdm run black .
	pdm run isort .

.PHONY: format
format:
	@echo "Running black" && pdm run black -l 79 --check app tests || exit 1

.PHONY: lint
lint:
	@echo "Running ruff" && pdm run ruff app tests || exit 1

.PHONY: setup
setup:
	pdm sync
	pdm run pre-commit install

.PHONY: sort
sort:
	@echo "Running Isort" && pdm run isort . --check-only --diff || exit 1

.PHONY: check
check:
	@echo "Running MyPy" && pdm run mypy app || exit 1

.PHONY: test
test:
	pdm run py.test tests

.PHONY: repl
repl:
	pdm run bpython

.PHONY: run
run:
	pdm run uvicorn app.main:app