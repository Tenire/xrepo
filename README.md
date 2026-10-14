# xrepo (Custom Xmake Package Repository)

A curated, lightweight, and custom package repository for [Xmake](https://xmake.io).

## Introduction

This repository serves as a personal/custom package registry for projects needing packages not yet available or inconvenient to publish to the official `xmake-repo`.

- **Lean & Curated**: Only contains explicitly needed packages.
- **Selective Sourcing**: Selected packages can be imported or customized on demand from official `xmake-repo`.
- **Local & Private Friendly**: Seamlessly integrated into local or private builds without upstream PR overhead.

## Usage

### 1. Add Repository

To add this repository locally:

```bash
# Recommended: Add from GitHub (defaults to stable master)
xrepo add-repo tenire-xrepo https://github.com/Tenire/xrepo.git

# Or add local development folder:
# xrepo add-repo tenire-xrepo /path/to/xrepo dev

# Verify registered repositories
xrepo list-repo
```

### 2. Install Packages

```bash
xrepo install <package-name>
```

Or in your project `xmake.lua`:

```lua
-- Add custom repository directly via GitHub URL:
add_repositories("tenire-xrepo https://github.com/Tenire/xrepo.git")
-- Or local directory:
-- add_repositories("tenire-xrepo /path/to/xrepo")
add_requires("<package-name>")

target("demo")
    set_kind("binary")
    add_files("src/*.cpp")
    add_packages("<package-name>")
```

## Local Testing

Test a package locally using the embedded test runner:

```bash
xmake l scripts/test.lua <package-name>
# Or test specifically:
xmake l scripts/test_packages.lua -vD <package-name>
```
