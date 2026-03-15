# Jhoan's Glove80 ZMK Configuration

![MoErgo Logo](moergo_logo.png)

This repository contains my personal ZMK configuration for the MoErgo Glove80 wireless split contoured keyboard.

It includes my custom layers, key bindings, and firmware configuration used to build and flash firmware for my keyboard.

While this repository is primarily maintained for my own setup, anyone is welcome to explore, learn from it, or use it as a starting point for their own Glove80 configuration.

The firmware is built automatically using GitHub Actions, making it easy to modify the layout and generate updated firmware for the keyboard.

---

# Purpose of this Repository

This repository serves as:

- My personal firmware configuration for the Glove80
- A place to experiment with layouts, layers, and behaviors
- A reference for others interested in custom ZMK setups for Glove80

It is based on the official ZMK configuration template provided by MoErgo.

---

# Customizing Your Own Layout

If you want to adapt this configuration for your own keyboard:

1. Fork this repository or use it as a template.
2. Modify the keymap files located in:

```
config/glove80.keymap
```

3. Commit and push your changes.
4. GitHub Actions will automatically build a new firmware version.

---

# Firmware Build Process

This repository uses GitHub Actions to build the firmware automatically whenever changes are pushed.

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

For users who prefer a graphical interface, the official Glove80 Layout Editor is available.

Most users will find it easier to start there before moving to full ZMK customization.

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

# License / Usage

This configuration is shared publicly for learning and experimentation.

Feel free to fork or adapt it for your own keyboard setup.



---

# RGB Per Layer Implementation (Work in Progress)

I am currently implementing **RGB per layer behavior** for the Glove80 using ZMK. The goal is to have the keyboard change its RGB color automatically depending on which layer is active.

This repository will progressively include examples and configuration snippets showing how to implement **layer-aware RGB behavior** in ZMK for the Glove80.

Typical use case:

```
Base layer   → Blue
Lower layer  → Red
GOG layer → Dark blue
Magic layer  → RGB off
```

The intention of documenting this here is to help other Glove80 users who want to implement **"RGB per layer"**, **"layer RGB indicator"**, or **"RGB layer feedback"** in their own ZMK configurations.

Search terms that may help people find this repository:

- glove80 rgb per layer
- zmk rgb layer indicator
- glove80 zmk rgb configuration
- glove80 layer color indicator
- zmk underglow per layer

As the configuration evolves, I will add practical examples in the keymap and configuration files so others can reuse or adapt the implementation.

If you are experimenting with **ZMK RGB behaviors or layer indicators**, feel free to fork this repository and adapt the configuration for your keyboard
