# Pull Request

## Summary

- What changed?
- Why was the change needed?

## Change Type

- [ ] New contract package
- [ ] Contract update
- [ ] Implementation from contract
- [ ] Workflow or tooling change
- [ ] Documentation change
- [ ] Build or test flow change

## Contract Scope

- Related contract package:
- Updated files under `contract/`:
- Updated files under `include/`:
- Does this PR change public behavior?

If yes:
Describe the behavior change in caller-visible terms.

## Review Gates

- [ ] Ownership, lifetime, invalidation rules, and exception policy are explicit.
- [ ] `contract/` and `include/` remain consistent.
- [ ] Acceptance criteria remain black-box and observable.
- [ ] Contract changes were reviewed before relying on implementation details.

## Validation

- [ ] `scripts/Validate-ContractPackage.ps1` was run when a contract package changed.
- [ ] `scripts/Invoke-CMakePreset.ps1 -Preset x64-debug -Build -Test` was run when buildable code changed.

Validation notes:

```text
Paste the important result lines here.
```

## AI and Human Review Split

- What was produced or updated by AI?
- What decisions were explicitly reviewed and approved by a human?

## Release Notes

- User-facing impact:
- Breaking change:
- Follow-up issues:
