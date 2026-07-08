# SEAL-Core v0 Review Packet

## Project Identity

SEAL is Substrate Evidence Authority Layer Zero.

SEAL-Core v0 is a terminal-native normative authority core. It models a small authority gate for sealed evidence, capability-bound authority, and fail-closed decision order.

## Current Verified Scope

The current F* verification scope covers:

- operation-to-capability mapping
- fail-closed gate order
- evidence requirements
- receipt requirements
- explicit proof matrix
- GitHub Actions verification of the F* modules

The verified modules are the source-level F* authority model only. The CI checkpoint runs the verifier over the SEAL-Core v0 modules and fails if F* verification fails.

## Current Non-Scope

SEAL-Core v0 currently has:

- no parser
- no runtime command execution
- no encryption
- no networking
- no kernel isolation
- no seL4 integration
- no production authorization
- no whole-system formal verification

It is not an operating system, not a kernel boundary, not seL4, not seL4-equivalent, not externally certified, and not government approved.

## Verified Rule Summary

The verified authority model establishes the following decision order:

- missing capability denies first
- missing evidence denies before receipt checks
- missing receipt denies before allow
- allow only occurs after required conditions are present

The proof matrix states explicit cases for `OpMeasure`, `OpOpen`, `OpSeal`, and `OpTransition` without adding operations or capabilities.

## Reviewer Commands

```sh
make toolchain
make verify
make test
git diff --check
```

`make verify` is the primary local verification command. `make test` runs the toolchain check and F* verification.

## Public Claim Boundary

SEAL-Core v0 verifies a small F* authority-gate model only.

It does not verify an OS, runtime, kernel boundary, cryptographic system, or seL4 substrate.

C extraction remains deferred until a compatible KaRaMeL toolchain is pinned. KaRaMeL is not mandatory for SEAL-Core v0 verification.
