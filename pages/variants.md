---
date: '2026-04-09'
description: 'Container image variants for devtainer, including distro, purpose, and build commands'
published: true
title: 'Devtainer Image Variants'
---

devtainer ships several container image variants. They share the same repo and
core dotfiles, but they target different distros and use cases.

## Variant Matrix

| Variant | Base distro | Tag | Best for |
| --- | --- | --- | --- |
| `latest` | Ubuntu 24.04 | `ghcr.io/waylonwalker/devtainer:latest` | Default daily-driver image |
| `slim` | Ubuntu 24.04 | `ghcr.io/waylonwalker/devtainer:slim` | Lighter Ubuntu image |
| `alpine` | Alpine Edge | `ghcr.io/waylonwalker/devtainer:alpine` | Small image and compatibility testing |
| `alpine-slim` | Alpine Edge | `ghcr.io/waylonwalker/devtainer:alpine-slim` | Smaller Alpine shell image |
| `arch` | Arch Linux | `ghcr.io/waylonwalker/devtainer:arch` | Richest rolling-release image |
| `arch-slim` | Arch Linux | `ghcr.io/waylonwalker/devtainer:arch-slim` | Leaner Arch image |

## latest

`latest` is the main Ubuntu 24.04 image. It is the default variant for most
examples and the safest choice when you want the fewest surprises.

- Includes the full Ubuntu-based devtainer environment
- Best default choice for distrobox and general development
- Publishes moving, date, and version tags

Build it locally with:

```bash
just build-latest
```

## slim

`slim` uses the same Ubuntu 24.04 base as `latest`, but with a smaller system
package set. It keeps the same general devtainer workflow while dropping some
of the heavier OS-level packages.

- Same distro family as `latest`
- Smaller package footprint
- Good when you want Ubuntu behavior with less system baggage

Build it locally with:

```bash
just build-slim
```

## alpine

`alpine` uses Alpine Edge. It is the smallest variant in the set, but it also
has the most compatibility tradeoffs because it uses musl instead of glibc.

- Smallest image family member
- Useful for smoke tests and lightweight environments
- Expect more package-specific exceptions than Ubuntu or Arch

Build it locally with:

```bash
just build-alpine
```

## alpine-slim

`alpine-slim` keeps the Alpine base but trims the installed toolset down to a
smaller core shell and editor environment.

- Smaller than `alpine`
- Keeps the same distro family and bootstrap pattern
- Keeps `zsh`, `tmux`, and `nvim` ready to go
- Good when you want Alpine with fewer bundled tools

Build it locally with:

```bash
just build-alpine-slim
```

## arch

`arch` uses Arch Linux and is the most feature-rich variant in practice. It is
the rolling-release option and a good fit if you want the broadest toolset.

- Rolling-release base
- Richest daily-driver image
- Publishes `arch`, `arch-<date>`, and `arch-<version>` tags

Build it locally with:

```bash
just build-arch
```

## arch-slim

`arch-slim` keeps the Arch base and rolling-release behavior, but trims the
package and tool list to a smaller core environment.

- Same Arch base as `arch`
- Smaller package and tool surface
- Keeps `zsh`, `tmux`, and `nvim` ready to go
- Good when you want Arch behavior without the full image footprint

Build it locally with:

```bash
just build-arch-slim
```

## All Variants

Build every main variant with:

```bash
just build
```

## Dotfile Smoke Tests

The images share one dotfile contract: shell and editor config must work both in
the image's default home and in a remapped home directory.

That matters for:

- `podman run` and `docker run` with mounted homes or named volumes
- distrobox homes created outside the image
- kubernetes-style workloads that mount a writable home at runtime

Run the smoke suite with:

```bash
just test-dotfiles
```

The smoke tests check three things for each image:

- dotfiles are baked into `/opt/devtainer-home`
- the default `/home/devtainer` sees readable dotfiles and app config
- `devtainer-bootstrap-home` can restow that config into a fresh runtime home

Deploy every main variant with:

```bash
just deploy
```

## Distrobox

The repo also defines distrobox entries for the main variants:

- `devtainer`
- `devtainer-arch`
- `devtainer-slim`
- `devtainer-alpine`
- `devtainer-arch-slim`
- `devtainer-alpine-slim`

Assemble them with:

```bash
just distrobox-assemble
```
