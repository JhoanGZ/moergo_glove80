#include <zephyr/kernel.h>
#include <zmk/keyboard.h>
#include <zmk/event_manager.h>
#include <zmk/events/layer_state_changed.h>
#include <zmk/led.h>  

/*
    Glove80 RGB Layer Indicator

    I've created this module to ease layer manipulation when layers are used.
    This module changes the keyboard RGB underglow color depending 
    currently active layer.

    Default ZMK configuration does not provide a simple visual indicator
    of the active layer. This implementation listens to layer change and updates the color 
    accordingly.

    Advantages of this approach:
    - Does not modifiy the keymap
    - Works automatically with any layer change
    - Uses the ZMK event system (layer_state_changed)
    - Clean and maintainable solution

    I hope this implementation may help other Glove80 / ZMK users implement per layer
    RGB indicators without adding macros to the keymap.

    Repo:
    https://github.com/JhoanGZ/moergo_glove80

*/

static int layer_rgb_listener(const zmk_event_t *eh) {

    const struct zmk_layer_state_changed *ev =
        as_zmk_layer_state_changed(eh);

    if (!ev) {
        return ZMK_EV_EVENT_BUBBLE;
    }

    uint8_t layer = ev->layer;

    switch (layer) {

        case 0: // BASE
            zmk_led_set_hsv(180, 100, 100); // light blue
            break;

        case 1: // LOWER
            zmk_led_set_hsv(0, 100, 100); // red
            break;

        case 2: //  GOG
            zmk_led_set_hsv(220, 100, 100); // electric blue
            break;

        case 3: // MAGIC
            zmk_led_off(); 
            break;
    }

    return ZMK_EV_EVENT_BUBBLE;
}

ZMK_LISTENER(layer_rgb, layer_rgb_listener);
ZMK_SUBSCRIPTION(layer_rgb, zmk_layer_state_changed);