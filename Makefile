.PHONY: ruff-check
ruff-check:
	uv run ruff check --output-format=github src tests

.PHONY: ruff-format-check
ruff-format-check:
	uv run ruff format src tests --check --diff

.PHONY: ruff-format
ruff-format:
	uv run ruff format src tests
	uv run ruff check --fix

.PHONY: mdformat
mdformat:
	uv run mdformat *.md

.PHONY: mdformat-check
mdformat-check:
	uv run mdformat --check *.md

.PHONY: mypy
mypy:
	uv run mypy src tests

.PHONY: test
test:
	uv run pytest tests --cov=src tests --cov-report term-missing --durations 5

.PHONY: format
format:
	$(MAKE) mdformat
	$(MAKE) ruff-format

.PHONY: lint
lint:
	$(MAKE) mdformat-check
	$(MAKE) ruff-format-check
	$(MAKE) mypy
	$(MAKE) ruff-check


.PHONY: test-all
test-all:
	$(MAKE) lint
	$(MAKE) test