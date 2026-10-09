#!/usr/bin/env nu

let config = ($env.HOME | path join "nixos-config" "home" "linux" "gui" "niri" "conf" "libinput.kdl")

let content = (open --raw $config)

if ($content | str contains "off // NIRI-TOUCHPAD-OFF") {
    # 当前关闭 → 开启
    $content
        | str replace "        off // NIRI-TOUCHPAD-OFF" "        // NIRI-TOUCHPAD-OFF"
        | save -f $config

    ^notify-send "Touchpad" "Enabled"
} else {
    # 当前开启 → 关闭
    $content
        | str replace "        // NIRI-TOUCHPAD-OFF" "        off // NIRI-TOUCHPAD-OFF"
        | save -f $config

    ^notify-send "Touchpad" "Disabled"
}
