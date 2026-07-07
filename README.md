# SEAL

Substrate Evidence Authority Layer Zero

SEAL is a minimal operator substrate for sealed evidence, capability-bound authority, and fail-closed system design on seL4-class foundations.

SEAL-Core v0 is a terminal-native normative authority core, not an OS.

Trusted core logic is written in F*/Low*.

C extraction is deferred until a compatible KaRaMeL toolchain is pinned. KaRaMeL is optional for SEAL-Core v0 verification.

## Commands

```sh
scripts/bootstrap-toolchain.sh
make toolchain
make verify
make test
```

## CI

```sh
make verify
make test
```

GitHub Actions verifies the F* authority model on push and pull request.

C extraction remains deferred until a compatible KaRaMeL toolchain is pinned.

## Current Prototype

SEAL-Core v0 models a small fail-closed authority gate in F*. The gate evaluates a subject operation against a capability set, evidence state, and transition receipt state.

The v0 model has no parser. Files in `examples/` are documentation fixtures only.

`make extract` is non-fatal in v0. It reports `SEAL_EXTRACTION_NOT_READY` when `krml` is unavailable or the model is not ready for extraction.

## Proof Matrix

`src/Seal.Matrix.fst` encodes explicit v0 decision cases for measure, open, seal, and transition operations. It proves capability checks dominate evidence and receipt checks, evidence checks dominate receipt checks where evidence is required, and disallowed state combinations cannot return `Allow`.

## SEAL-Core v0 Review Packet

The current review packet is in [docs/SEAL_CORE_V0_REVIEW_PACKET.md](docs/SEAL_CORE_V0_REVIEW_PACKET.md).

## Non-Claims

SEAL-Core v0 is:

- not seL4
- not seL4-equivalent
- not kernel isolation
- not production authorized
- not externally certified
- not government approved
- not whole-system formally verified

No production, certification, government approval, kernel isolation, or whole-system formal verification claim is made by this repository.
