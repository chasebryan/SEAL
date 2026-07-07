# Architecture

SEAL-Core v0 is a small authority gate over explicit state.

```text
policy
↓
capability set
↓
evidence state
↓
transition receipt state
↓
gate decision
```

The F* model is intentionally direct. `Seal.Policy` defines the operation requirements, and `Seal.Gate` applies those requirements in fail-closed order:

1. missing capability denies first
2. missing evidence denies before receipt checks
3. missing receipt denies before allow
4. allow is returned only after all required conditions are present

There is no parser, no network path, no daemon, no plugin system, no package manager, and no seL4 integration in v0.
