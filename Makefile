CORE_MODULES := src/Seal.Types.fst src/Seal.Policy.fst src/Seal.Gate.fst src/Seal.Proofs.fst

.PHONY: toolchain verify extract test clean

toolchain:
	./scripts/check-toolchain.sh

verify:
	./scripts/verify-core.sh

extract:
	@mkdir -p generated/c
	@set -e; \
	if command -v opam >/dev/null 2>&1 && opam switch list --short 2>/dev/null | grep -qx seal-core; then \
		eval "$$(opam env --switch=seal-core --set-switch)"; \
	fi; \
	if ! command -v krml >/dev/null 2>&1; then \
		echo "SEAL_EXTRACTION_NOT_READY"; \
		exit 0; \
	fi; \
	if ! ./scripts/verify-core.sh >/dev/null 2>&1; then \
		echo "SEAL_EXTRACTION_NOT_READY"; \
		exit 0; \
	fi; \
	if krml -skip-compilation -tmpdir generated/c -bundle 'Seal.*=SEAL' $(CORE_MODULES) -o generated/c/seal_core.c >/dev/null 2>&1; then \
		echo "SEAL_EXTRACTION_SUCCEEDED"; \
	else \
		echo "SEAL_EXTRACTION_NOT_READY"; \
		exit 0; \
	fi

test: toolchain verify

clean:
	rm -rf build generated/c
