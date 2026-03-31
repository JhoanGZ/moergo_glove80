# Jhoan's Glove80 ZMK Configuration

![ZMK](https://img.shields.io/badge/firmware-ZMK-blue)
![Keyboard](https://img.shields.io/badge/keyboard-Glove80-orange)
![OS](https://img.shields.io/badge/host-Windows-blue)
![RGB](https://img.shields.io/badge/RGB-per--layer-green)

![MoErgo Logo](moergo_logo.png)

This repository contains my personal **ZMK firmware configuration** for the **MoErgo Glove80 wireless split contoured keyboard**.

It includes custom layers, key bindings, RGB per-layer underglow, international character input, and a modular structure for extending keyboard behavior.

While this repository is primarily maintained for my own setup, anyone is welcome to explore, learn from it, or use it as a starting point for their own **Glove80 ZMK configuration**.

The firmware is built automatically using **GitHub Actions** with the **darknao/zmk** fork for RGB per-layer support.

---

## Changelog

### v2.0 — RGB Per-Layer + Accent Refactor

- **RGB per-layer underglow** fully working using `darknao/zmk` fork (`rgb-layer-25.08`)
  - Base = Teal, Gaming = Blue, Lower = Red, Magic = Off, Accent = Green, Umlaut = Yellow
  - Requires `CONFIG_EXPERIMENTAL_RGB_LAYER=y` in `.conf`
  - `underglow-layer` block must be **inlined in the keymap** (external `.dtsi` includes do not work)
  - Layer IDs must be **numeric** (C preprocessor macros do not resolve in devicetree context)
  - Activation: cycle RGB effect with Magic+G until swirl "freezes"; brightness adjusted by switching effect, changing brightness, then returning
  - Factory reset on both halves required before flashing
- **Accent key simplified** to `&sl LAYER_Accent` — Hyper decoupled to avoid hold-tap interference
- **Hyper macro** preserved in `compose_hyper.dtsi` as `&hyper_macro` for future use (custom shortcuts via AutoHotkey or similar)
- **Accent macro speed** reduced from `wait-ms=50 / tap-ms=50` to `wait-ms=10 / tap-ms=10` (~5x faster)
- **Build workflow** switched from `actions/checkout` to `git clone --branch` for darknao fork (branch names with slashes fail with `actions/checkout@v4`)

### v1.0 — Initial Custom Configuration

- 6-layer keymap: Base, Gaming, Lower, Magic, Accent (Spanish), Umlaut (German)
- Spanish/German accent input via sticky layer + Windows Alt Codes (numpad keycodes)
- Hyper modifier (Ctrl+Alt+Shift+GUI) as hold-tap on accent key
- RGB underglow enabled (standard effects only)
- GitHub Actions build with Nix

---

## Layer Map

| Index | Layer | Color | Purpose |
|-------|-------|-------|---------|
| 0 | Base | Teal | QWERTY main layout |
| 1 | Gaming | Blue | Gaming-optimized layout |
| 2 | Lower | Red | Media, navigation, numpad |
| 3 | Magic | Off | Bluetooth, RGB, bootloader |
| 4 | Accent | Green | Spanish accents (sticky / one-shot) |
| 5 | Umlaut | Yellow | German umlauts (sticky / one-shot) |

---

## Repository Structure

```
repo
│
├─ .github/workflows
│   └─ build.yml                    ← GitHub Actions (darknao/zmk fork)
│
├─ config
│   ├─ features
│   │   ├─ compose_hyper.dtsi       ← Accent includes + Hyper macro (modular)
│   │   ├─ spanish.dtsi             ← á/Á é/É í/Í ó/Ó ú/Ú ñ/Ñ
│   │   └─ german.dtsi              ← ä/Ä ö/Ö ü/Ü ß
│   │
│   ├─ glove80.conf                 ← Firmware configuration (RGB, queue size, etc.)
│   ├─ glove80.keymap               ← Main keymap + inline underglow-layer
│   ├─ default.nix
│   └─ info.json
│
├─ docs
│   └─ legacy
│       └─ rgb_layers.dtsi          ← Archived: external .dtsi approach (did not work)
│
└─ README.md
```

---

## Firmware Configuration

```properties
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_ZMK_BEHAVIORS_QUEUE_SIZE=256
CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE=y
CONFIG_ZMK_RGB_UNDERGLOW_EXT_POWER=y
CONFIG_ZMK_IDLE_TIMEOUT=30000
CONFIG_EXPERIMENTAL_RGB_LAYER=y
```

| Config | Purpose |
|--------|---------|
| `CONFIG_ZMK_RGB_UNDERGLOW` | Enable RGB underglow system |
| `CONFIG_ZMK_BEHAVIORS_QUEUE_SIZE` | Larger queue for macro event processing |
| `CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE` | Turn off LEDs when idle (battery saving) |
| `CONFIG_ZMK_RGB_UNDERGLOW_EXT_POWER` | Control LED hardware power via regulator |
| `CONFIG_ZMK_IDLE_TIMEOUT` | Idle timeout in ms (30 seconds) |
| `CONFIG_EXPERIMENTAL_RGB_LAYER` | **Required** — enables the underglow-layer feature |

---

## RGB Per-Layer Underglow

This configuration uses the **darknao/zmk** fork (`rgb-layer-25.08` branch) which adds per-layer / per-key RGB underglow support.

### How It Works

The `underglow-layer` block in the keymap defines 80 color bindings per layer (one per key position). When the layer effect is active, the keyboard automatically changes color based on the active layer.

### Activation

1. **Magic + T** — toggle RGB on
2. **Magic + G** — cycle effects until the swirl "freezes" (that is the layer effect)
3. Switch layers to see color changes

### Brightness

The layer effect uses the global brightness setting. To adjust:

1. Switch to a different effect (Magic + G)
2. Adjust brightness (Magic + I to increase, Magic + K to decrease)
3. Switch back to the layer effect (Magic + G)

### Key Learnings

- `underglow-layer` must be **inlined in the keymap** — external `.dtsi` includes silently fail
- `LAYER_*` macros do not resolve in devicetree context — use numeric IDs (`<0>`, `<1>`, etc.)
- `CONFIG_EXPERIMENTAL_RGB_LAYER=y` is **required** — without it, the underglow-layer block is ignored
- `actions/checkout@v4` cannot resolve branch names with slashes — use `git clone --branch` instead
- Factory reset on **both halves** is required when switching between firmware versions

---

## International Character System

Accent and umlaut input using dedicated layers, without changing the OS keyboard layout (English US). Characters are sent via **Windows Alt Codes** through ZMK macros.

### Architecture

```
config/features/
├─ compose_hyper.dtsi   ← Orchestrator: includes languages + Hyper macro
├─ spanish.dtsi         ← 6 character pairs (macro + mod-morph each)
└─ german.dtsi          ← 3 character pairs + eszett
```

Adding a new language only requires creating a new `.dtsi` file, adding `#include` in `compose_hyper.dtsi`, and mapping behaviors in a keymap layer.

### Accent Layer (Layer 4) — Spanish

Activated by tapping the accent key (`&sl LAYER_Accent`). Sticky layer (one-shot): press a character key, get the accented version, auto-return to Base.

```
[tap Accent] → A → á       (+ Shift → Á)
[tap Accent] → E → é       (+ Shift → É)
[tap Accent] → I → í       (+ Shift → Í)
[tap Accent] → O → ó       (+ Shift → Ó)
[tap Accent] → U → ú       (+ Shift → Ú)
[tap Accent] → N → ñ       (+ Shift → Ñ)
[tap Accent] → S → ß
```

### Umlaut Layer (Layer 5) — German

From within the Accent layer, tap the Umlaut key to switch:

```
[tap Accent] → [tap Umlaut key] → A → ä       (+ Shift → Ä)
[tap Accent] → [tap Umlaut key] → O → ö       (+ Shift → Ö)
[tap Accent] → [tap Umlaut key] → U → ü       (+ Shift → Ü)
[tap Accent] → [tap Umlaut key] → S → ß
```

### Macro Timing

Alt code macros use `wait-ms=10` and `tap-ms=10` for fast output (~80ms per character).

### Requirements

- Host OS keyboard layout: **English US**
- **NumLock** must be ON (macros send numpad keycodes)
- No additional software required on Windows

### Known Limitation

Alt code macros do not work correctly inside terminal emulators (Windows Terminal, WSL, nvim) because terminals interpret Alt as Escape. For occasional accent input in terminals, use vim digraphs: `Ctrl+K ' a` → á.

---

## Hyper Key

The `&hyper_macro` behavior is available for future use. It sends **Ctrl + Alt + Shift + GUI** simultaneously, commonly used for window manager shortcuts and automation tools like AutoHotkey.

Currently not bound to any key. To use, assign `&hyper_macro` to any key position in the keymap.

Defined in `config/features/compose_hyper.dtsi`.

---

## Build Process

This repository uses **GitHub Actions** with the **darknao/zmk** fork to build firmware automatically.

### Build Workflow

The workflow clones `darknao/zmk` (branch `rgb-layer-25.08`) instead of the official MoErgo fork, then builds using Nix:

```yaml
- name: Clone darknao ZMK fork
  run: git clone --depth 1 --branch rgb-layer-25.08 https://github.com/darknao/zmk.git src
```

### Download Firmware

1. Open this repository on GitHub
2. Click **Actions** → select the latest **Build** workflow run
3. Download the `glove80.uf2` artifact

### Flash Firmware

1. **Factory reset both halves** (required when switching firmware versions)
2. Enter bootloader mode on each half
3. Copy `glove80.uf2` to the mounted USB drive
4. The keyboard reboots automatically

---

## Resources

- [MoErgo Glove80 Support](https://moergo.com/glove80-support)
- [MoErgo Discord](https://moergo.com/discord)
- [ZMK Firmware Documentation](https://zmk.dev/docs)
- [ZMK Discord](https://discord.gg/8cfMkQksSB)
- [darknao/zmk fork (RGB per-layer)](https://github.com/darknao/zmk/tree/rgb-layer-25.08)
- [darknao/glove80-zmk-config (reference)](https://github.com/darknao/glove80-zmk-config)
- [Official Glove80 ZMK Distribution](https://github.com/moergo-sc/zmk)

---

## Search Keywords

```
glove80 zmk glove80-config zmk-config zmk-keymap rgb-per-layer glove80-rgb zmk-rgb
glove80-layout ergonomic-keyboard split-keyboard zmk-accent-layer zmk-windows-alt-code
zmk-umlaut zmk-international-characters glove80-spanish glove80-german zmk-hyper-key
zmk-underglow-per-layer darknao-zmk glove80-rgb-layer-indicator
```

---

## License

This configuration is shared publicly for learning and experimentation. Feel free to fork or adapt it for your own keyboard setup.

---

## Credits

- [ZMK Firmware](https://zmk.dev)
- [MoErgo Glove80](https://moergo.com)
- [darknao](https://github.com/darknao) — RGB per-layer ZMK fork
