# Jhoan's Glove80 ZMK Configuration

![ZMK](https://img.shields.io/badge/firmware-ZMK-blue)
![Keyboard](https://img.shields.io/badge/keyboard-Glove80-orange)
![OS](https://img.shields.io/badge/host-Windows-blue)

![MoErgo Logo](moergo_logo.png)

This repository contains my personal **ZMK firmware configuration** for the **MoErgo Glove80 wireless split contoured keyboard**.

It includes custom layers, key bindings, experimental firmware features, and a modular structure for extending the keyboard behavior.

While this repository is primarily maintained for my own setup, anyone is welcome to explore, learn from it, or use it as a starting point for their own **Glove80 ZMK configuration**.

The firmware is built automatically using **GitHub Actions**, allowing changes to the layout to produce new firmware builds automatically.

---

# Purpose of this Repository

This repository serves as:

- My personal firmware configuration for the Glove80
- A place to experiment with layouts, layers, and behaviors
- A reference for others interested in custom **ZMK setups for Glove80**

It is based on the official ZMK configuration template provided by **MoErgo**.

---

# Customizing Your Own Layout

If you want to adapt this configuration for your own keyboard:

1. Fork this repository or use it as a template.
2. Modify the keymap file located in:

```
config/glove80.keymap
```

3. Commit and push your changes.
4. GitHub Actions will automatically build a new firmware version.

---

# Firmware Build Process

This repository uses **GitHub Actions** to build the firmware automatically whenever changes are pushed.

To download the compiled firmware:

1. Open this repository on GitHub.
2. Click **Actions** in the navigation bar.
3. Select the latest **Build** workflow run.
4. Scroll to the bottom of the page and download the artifact:

```
glove80.uf2
```

---

# Flashing the Firmware

To flash the firmware onto your Glove80:

1. Connect the keyboard to your computer via USB.
2. Enter **bootloader mode**.
3. The keyboard will appear as a USB drive.
4. Copy the file:

```
glove80.uf2
```

into the drive.

The keyboard will reboot automatically with the new firmware.

---

# Alternative Layout Editing

For users who prefer a graphical interface, the official **Glove80 Layout Editor** is available.

Most users will find it easier to start there before moving to full ZMK customization.

---

# Repository Structure
```
repo
│
├─ config
│   ├─ features
│   │   ├─ compose_hyper.dtsi       ← Orchestrator: hold-tap + hyper + includes
│   │   ├─ spanish.dtsi             ← á/Á é/É í/Í ó/Ó ú/Ú ñ/Ñ
│   │   ├─ german.dtsi              ← ä/Ä ö/Ö ü/Ü ß
│   │   └─ layer_rgb.c
│   │
│   ├─ glove80.conf
│   ├─ glove80.keymap
│   ├─ default.nix
│   ├─ info.json
│   └─ keymap.json
│
├─ layouts
│   └─ personal_editor_ver5_1.keymap
│
├─ docs
│   └─ legacy
│       └─ rgb_layers.dtsi
│
└─ README.md
```

---

# Layer Map

| Index | Layer | Purpose |
|-------|-------|---------|
| 0 | Base | QWERTY main layout |
| 1 | Gaming | Gaming-optimized layout |
| 2 | Lower | Media, navigation, numpad |
| 3 | Magic | Bluetooth, RGB, bootloader |
| 4 | Accent | Spanish accents (sticky / one-shot) |
| 5 | Umlaut | German umlauts (sticky / one-shot) |

---

# Personal Layout

The layout exported from the **Glove80 Layout Editor** is stored here:

```
layouts/personal_editor_ver5_1.keymap
```

To compile firmware with this layout:

```
cp layouts/personal_editor_ver5_1.keymap config/glove80.keymap
```

Then commit and push to trigger the **GitHub Actions build**.

---

# International Character System

This configuration provides **accent and umlaut input** using a dedicated key, without changing the OS keyboard layout (English US). Characters are sent via **Windows Alt Codes** through ZMK macros.

### Architecture

Each language file defines its own macros and shift-aware mod-morphs as explicit devicetree nodes. The orchestrator includes them and wires the hold-tap behavior:

```
config/features/
├─ compose_hyper.dtsi   ← Orchestrator: includes languages + hyper + hold-tap
├─ spanish.dtsi         ← 6 character pairs (macro + mod-morph each)
└─ german.dtsi          ← 3 character pairs + eszett
```

Adding a new language only requires:

1. Create a new `.dtsi` file with macro + mod-morph nodes.
2. Add a `#include` in `compose_hyper.dtsi`.
3. Map the new behaviors in a keymap layer.

### Accent Layer (Layer 4)

Activated by **tapping** the Compose/Hyper key. It's a sticky layer (one-shot): press a character key, get the accented version, auto-return to Base.

```
[tap Compose] → A → á       (+ Shift → Á)
[tap Compose] → E → é       (+ Shift → É)
[tap Compose] → I → í       (+ Shift → Í)
[tap Compose] → O → ó       (+ Shift → Ó)
[tap Compose] → U → ú       (+ Shift → Ú)
[tap Compose] → N → ñ       (+ Shift → Ñ)
[tap Compose] → S → ß
```

### Umlaut Layer (Layer 5)

Activated by **tapping Compose twice** (from within the Accent layer, tap the same key position again):

```
[tap Compose] → [tap Compose] → A → ä       (+ Shift → Ä)
[tap Compose] → [tap Compose] → O → ö       (+ Shift → Ö)
[tap Compose] → [tap Compose] → U → ü       (+ Shift → Ü)
[tap Compose] → [tap Compose] → S → ß
```

### Requirements

- Host OS keyboard layout set to **English US**
- **NumLock** must be ON (the macros send numpad keycodes)
- No additional software required on Windows

---

# Compose + Hyper Key

This configuration uses a **dual-purpose key** implemented with ZMK hold-tap behavior.

| Action | Result |
|--------|--------|
| Tap | Sticky Accent layer (one-shot) |
| Hold | Hyper modifier |

### Behavior Diagram

```
    Compose/Hyper key
           │
     ┌─────┴─────┐
     │           │
   Tap         Hold (200ms+)
     │           │
  &sl Accent   Hyper macro
     │           │
 one-shot      Ctrl + Alt + Shift + GUI
  layer 4       (held until key release)
```

The implementation uses **ZMK hold-tap** with a `hyper_macro` that uses `macro_pause_for_release` to keep all four modifiers held for the duration of the keypress.

Defined in:

```
config/features/compose_hyper.dtsi
```

And wired in the keymap as:

```
&compose_hyper 0 LAYER_Accent
```

---

# Hyper Key

Holding the Compose/Hyper key activates **Hyper**, which sends:

```
Ctrl + Alt + Shift + GUI
```

This modifier is commonly used for:

- window manager shortcuts
- automation
- keyboard driven workflows

Example usage:

```
Hyper + H → open terminal
Hyper + J → move workspace
Hyper + K → launch browser
```

---

# RGB Per Layer (ZMK Implementation)

I am currently implementing **RGB per layer behavior** for the Glove80 using ZMK.

The goal is to have the keyboard change its RGB color automatically depending on the active layer.

Example layer color mapping:

| Layer | Color |
|-------|-------|
| Base | Light Blue |
| Gaming | Electric Blue |
| Lower | Red |
| Magic | RGB Off |

Implementation concept:

```
layer change
      │
      ▼
layer listener
      │
      ▼
update RGB color
```

The implementation lives in:

```
config/features/layer_rgb.c
```

This approach follows the same pattern used in **ZMK internals**, using a **layer listener** instead of keymap hacks.

This repository documents the implementation to help other Glove80 users searching for:

- glove80 rgb per layer
- zmk rgb layer indicator
- glove80 layer color indicator
- zmk underglow per layer

---

# Feature Modularization

Features are stored in the `features` folder to keep the main keymap clean.

```
config/features/
├── compose_hyper.dtsi      ← Orchestrator (includes + hyper + hold-tap)
├── spanish.dtsi            ← Spanish accents (macros + mod-morphs)
├── german.dtsi             ← German umlauts + eszett (macros + mod-morphs)
└── layer_rgb.c             ← RGB per layer (experimental)
```

Benefits:

- Each file has a single responsibility
- Adding a language = one file + one `#include`
- The keymap stays clean — all complexity lives in feature files

---

# Resources

### MoErgo

- https://moergo.com/glove80-support
- https://moergo.com/discord

### ZMK Firmware

- https://zmk.dev/docs
- https://discord.gg/8cfMkQksSB

### Official Glove80 ZMK Distribution

- https://github.com/moergo-sc/zmk

---

# Search Keywords

```
glove80 zmk glove80-config zmk-config zmk-keymap rgb-per-layer glove80-rgb zmk-rgb glove80-layout ergonomic-keyboard split-keyboard zmk-compose-key zmk-hyper-key zmk-accent-layer zmk-windows-alt-code zmk-umlaut zmk-international-characters zmk-dead-key glove80-spanish glove80-german
```

---

# License / Usage

This configuration is shared publicly for learning and experimentation.

Feel free to fork or adapt it for your own keyboard setup.

---

# Credits

- ZMK Firmware
- MoErgo Glove80
