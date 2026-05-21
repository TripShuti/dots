hl.window_rule({
    name  = "telegram-on-ws1",
    match = { class = "^(org\\.telegram\\.desktop)$" },
    workspace = "1"
})
hl.window_rule({
    name  = "feishin-on-ws1",
    match = { class = "^(feishin)$" },
    workspace = "1"
})
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize"
})
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true
})
hl.window_rule({
    name  = "pavucontrol-float",
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true, 
    size = "750 400"
})
hl.window_rule({
    name  = "blueman-float",
    match = { class = "blueman-manager" },
    float = true,
    size = "450 500"

})
hl.window_rule({
    name  = "thunar-progress",
    match = { class = "thunar", title = "^(Прогрес файлової операції|Копіювання файлів).*" },
    float = true,
    size = "460 500",
    move = "10 50"
})

hl.window_rule({
    name  = "thunar-dialogs",
    match = { class = "thunar", title = "^(Підтвердіть заміну файлів|Перейменувати).*" },
    float = true,
    center = true,
    size = "460 500"
})
hl.window_rule({
    name  = "prismlauncher-float",
    match = { class = "org.prismlauncher.PrismLauncher" },
    center = true, float = true, size = "701 487"
})
hl.window_rule({
    name  = "engrampa-float",
    match = { class = "engrampa" },
    center = true, float = true
})
hl.window_rule({
    name  = "galculator-float",
    match = { class = "galculator" },
    center = true, float = true,
    size = "400 540"
})