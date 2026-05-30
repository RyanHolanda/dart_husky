<div align="center">

<img src="https://raw.githubusercontent.com/moulibheemaneti/dart_githooks/main/.github/assets/logo.png" alt="dart_githooks" width="80" />

# dart_githooks

**Git hook manager for Dart & Flutter — no binaries, no fuss.**

[![pub version](https://img.shields.io/pub/v/dart_githooks.svg?style=flat-square&color=0175C2&labelColor=1a1a2e)](https://pub.dev/packages/dart_githooks)
[![pub points](https://img.shields.io/pub/points/dart_githooks?style=flat-square&color=0175C2&labelColor=1a1a2e)](https://pub.dev/packages/dart_githooks/score)
[![license](https://img.shields.io/badge/license-MIT-0175C2?style=flat-square&labelColor=1a1a2e)](LICENSE)
[![dart](https://img.shields.io/badge/dart-%3E%3D3.12.0-0175C2?style=flat-square&labelColor=1a1a2e)](https://dart.dev)

Pure Dart. Zero external dependencies. Works with Flutter, FVM, or bare Dart SDK.  
Inspired by [husky](https://github.com/typicode/husky) and [lefthook](https://github.com/evilmartians/lefthook).

</div>

---

## Why dart_githooks?

Most git hook tools require installing a separate binary (Go, Node.js, etc.). `dart_githooks` is **pure Dart** — if your team has Dart, they have everything they need.

```
✦ Pure Dart — no Go, no Node, no extra installs
✦ YAML config — familiar, readable, version-controlled
✦ Built-in conventional commits validation
✦ Sequential or parallel command execution
✦ Works with dart, flutter, and fvm
```

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  dart_githooks: ^1.0.0
```

Install dependencies and set up hooks:

```sh
dart pub get
dart run dart_githooks install
```

That's it. Your hooks are live.

---

## Configuration

Create `dart_githooks.yaml` in your project root:

```yaml
pre-commit:
  commands:
    format:
      run: dart format --set-exit-if-changed .
    analyze:
      run: dart analyze

commit-msg:
  commands:
    conventional:
      preset: conventional
```

---

## Supported Hooks

| Hook | Triggered when... |
|---|---|
| `pre-commit` | Before a commit is created |
| `commit-msg` | After you write a commit message |
| `pre-push` | Before pushing to remote |
| `post-checkout` | After switching branches |
| `pre-merge-commit` | Before a merge commit |

---

## Commands

```sh
# Install hooks defined in dart_githooks.yaml
dart run dart_githooks install

# Remove all installed hooks
dart run dart_githooks uninstall

# Manually trigger a hook
dart run dart_githooks run pre-commit

# List configured hooks and install status
dart run dart_githooks list
```

---

## Conventional Commits

Enable built-in conventional commits validation with one line:

```yaml
commit-msg:
  commands:
    conventional:
      preset: conventional
```

Valid format:

```
<type>(<optional scope>): <subject>
```

| Type | When to use |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `chore` | Maintenance, deps, tooling |
| `docs` | Documentation only |
| `style` | Formatting, whitespace |
| `refactor` | Code change, no feature or fix |
| `test` | Adding or fixing tests |
| `build` | Build system changes |
| `ci` | CI configuration |
| `perf` | Performance improvement |
| `revert` | Revert a previous commit |

**Examples:**

```sh
git commit -m "feat(auth): add login screen"         ✅
git commit -m "fix: resolve null pointer exception"  ✅
git commit -m "feat!: breaking api change"           ✅
git commit -m "updated stuff"                        ❌
```

---

## Parallel Execution

Speed up slow hooks by running commands simultaneously:

```yaml
pre-commit:
  parallel: true
  commands:
    format:
      run: dart format --set-exit-if-changed .
    analyze:
      run: dart analyze
    test:
      run: dart test
```

---

## How It Works

```
you run: git commit
         └── git checks .git/hooks/pre-commit
                  └── dart run dart_githooks run pre-commit
                           └── reads dart_githooks.yaml
                                    └── runs each command
                                             ├── all pass → commit created ✅
                                             └── any fail → commit blocked ❌
```

`dart_githooks install` writes a small shell script into `.git/hooks/` for each configured hook. The script detects whether to use `dart` or `fvm dart` automatically.

<!-- 
---

## Requirements

- Dart SDK `>=3.12.0`
- macOS *(Linux & Windows coming in v1.1.0)*
- A git repository

---

## Roadmap

| Version | What's coming |
|---|---|
| `v1.1.0` | Linux & Windows support, verbose config, custom commit types |
| `v1.2.0` | Glob filtering — run commands only on staged matching files |
| `v2.0.0` | Plugin system, shareable hook configs |

--- 
-->

## Contributing

Contributions are welcome! Please make sure your commits follow the conventional commits format — `dart_githooks` will enforce it. 😄

---

<div align="center">

Made with 🎯 by [@moulibheemaneti](https://github.com/moulibheemaneti)  
MIT License

</div>
