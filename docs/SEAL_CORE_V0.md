# SEAL-Core v0

SEAL-Core v0 defines a minimal authority gate for a fixed operation set:

- `OpMeasure`
- `OpOpen`
- `OpSeal`
- `OpTransition`

Each operation has one required capability. Evidence and transition receipt state are explicit gate inputs.

The model has no default allow path and no future or unknown operations. Extending the operation set requires changing the F* datatypes and proofs.

C extraction is deferred until a compatible KaRaMeL toolchain is pinned. F* verification is the required v0 validation path.

This pass does not include a parser, kernel integration, network service, daemon, GUI, package manager, plugin system, or bootable operating system.
