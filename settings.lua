data:extend({
    {
        type = "int-setting",
        name = "spotlight-size",
        setting_type = "runtime-per-user",
        default_value = 8,
        minimum_value = 1,
        order = "bt-a"
    },
    {
        type = "double-setting",
        name = "spotlight-intensity",
        setting_type = "runtime-per-user",
        default_value = 0.9,
        minimum_value = 0,
        maximum_value = 1,
        order = "bt-b"
    },
    {
        type = "bool-setting",
        name = "spotlight-player",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "bt-c"
    },
})
