# Jhoan's Glove80 ZMK Configuration

![ZMK](https://img.shields.io/badge/firmware-ZMK-blue)
![Keyboard](https://img.shields.io/badge/keyboard-Glove80-orange)
![ZMK](https://img.shields.io/badge/firmware-ZMK-blue)

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
│   ├─ behaviors
│   ├─ combos
│   ├─ features
│   │   ├─ compose.dtsi
│   │   ├─ hyper.dtsi
│   │   ├─ compose_hyper.dtsi
│   │   └─ layer_rgb.c
│   │
│   ├─ glove80.conf
│   ├─ glove80.keymap
│   ├─ default.nix
│   ├─ info.json
│   └─ keymap.json
│
├─ layouts
│   └─ jhoan_editor_v5_1.keymap
│
├─ docs
│   └─ legacy
│       └─ rgb_layers.dtsi
│
├─ build.yaml
└─ README.md
```

---

# Personal Layout

The layout exported from the **Glove80 Layout Editor** is stored here:

```
layouts/jhoan_editor_v5_1.keymap
```

To compile firmware with this layout:

```
cp layouts/jhoan_editor_v5_1.keymap config/glove80.keymap
```

Then commit and push to trigger the **GitHub Actions build**.

---

# RGB Per Layer (ZMK Implementation)

I am currently implementing **RGB per layer behavior** for the Glove80 using ZMK.

The goal is to have the keyboard change its RGB color automatically depending on the active layer.

Example layer color mapping:

| Layer | Color |
|------|------|
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

# Compose + Hyper Key

This configuration replaces **Right Alt (RALT)** with a dual‑purpose key.

| Action | Result |
|------|------|
| Tap | Compose key |
| Hold | Hyper key |

### Behavior Diagram

```
        RALT key
           │
     ┌─────┴─────┐
     │           │
   Tap         Hold
     │           │
 Compose       Hyper
               │
    Ctrl + Alt + Shift + GUI
```

The implementation uses **ZMK hold‑tap behavior**.

```
Tap  → Compose
Hold → Hyper
```

Defined in:

```
config/features/compose_hyper.dtsi
```

And wired in the keymap by replacing:

```
&sk RALT
```

with:

```
&compose_hyper
```

---

# Compose Key Usage

Compose allows typing international characters **without depending on OS keyboard layout**.

Examples:

```
Compose + a → á
Compose + e → é
Compose + i → í
Compose + o → ó
Compose + u → ú

Compose + n → ñ

Compose + u → ü
Compose + s → ß
```

This works consistently across:

- Windows
- Linux
- macOS

---

# Hyper Key

Holding the same key activates **Hyper**, which sends:

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

# Feature Modularization

Features are stored in the `features` folder to keep the main keymap clean.

```
config/features/
```

Example features implemented here:

```
compose.dtsi
hyper.dtsi
compose_hyper.dtsi
layer_rgb.c
```

Benefits:

- easier maintenance
- cleaner keymap
- reusable features

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
glove80 zmk glove80-config zmk-config zmk-keymap rgb-per-layer glove80-rgb zmk-rgb glove80-layout ergonomic-keyboard split-keyboard zmk-compose-key zmk-hyper-key
```

---

# License / Usage

This configuration is shared publicly for learning and experimentation.

Feel free to fork or adapt it for your own keyboard setup.

---

# Credits

- ZMK Firmware
- MoErgo Glove80

