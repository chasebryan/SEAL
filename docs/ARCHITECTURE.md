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

Decision-order matrix:

| Operation | Required capability | Evidence required | Receipt required | Allow condition |
| --- | --- | --- | --- | --- |
| `OpMeasure` | `CapMeasure` | no | no | capability present |
| `OpOpen` | `CapOpen` | yes | no | capability present and evidence valid |
| `OpSeal` | `CapSeal` | yes | no | capability present and evidence valid |
| `OpTransition` | `CapTransition` | yes | yes | capability present, evidence valid, and receipt valid |

There is no parser, no network path, no daemon, no plugin system, no package manager, and no seL4 integration in v0.
