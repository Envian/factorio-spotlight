if script.active_mods["gvv"] then require("__gvv__.gvv")() end

script.on_init(function()
    storage.playerToLightMap = {}
    for _, player in pairs(game.players) do 
        updatePlayer(player)
    end
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    for _, player in pairs(game.players) do 
        updatePlayer(player)
    end
end)

function updatePlayer(player)
    playerSettings = settings.get_player_settings(player)
    existingLight = storage.playerToLightMap[player.index]

    if existingLight ~= nil and (not existingLight.valid or existingLight.surface ~= player.surface) then 
        -- Delete any lights on the wrong surface to be remade.
        existingLight.destroy()
        existingLight = nil
    end
    
    if existingLight == nil or not existingLight.valid then
        -- The light doesn't exist and the player has a character
        storage.playerToLightMap[player.index] = rendering.draw_light({
            sprite = "utility/light_medium",
            target = player.position,
            surface = player.surface,
            scale = playerSettings["spotlight-size"].value,
            intensity = playerSettings["spotlight-intensity"].value,
            players = { player }
        })
    else
        -- The light exists
        existingLight.scale = playerSettings["spotlight-size"].value
        existingLight.intensity = playerSettings["spotlight-intensity"].value
    end

    if playerSettings["spotlight-player"].value then
        player.enable_flashlight()
    else
        player.disable_flashlight()
    end
end

script.on_event({
    defines.events.on_player_changed_surface,
    defines.events.on_player_joined_game,
    defines.events.on_player_respawned,
}, function(event)
    updatePlayer(game.players[event.player_index])
end)

script.on_event({
    defines.events.on_player_left_game,
}, function(event)
    if storage.playerToLightMap[event.player_index] ~= nil then
        storage.playerToLightMap[event.player_index].destroy()
        storage.playerToLightMap[event.player_index] = nil
    end
end)

-- I went with an ontick solution instead of attaching the light to the player
-- since this needs to support remote view - which does not have a character
-- that I can attach a light to. Just doing on tick each frame keeps the code simple.
script.on_event(defines.events.on_tick, function(event)
    for index, player in pairs(game.players) do
        light = storage.playerToLightMap[index]
        if light ~= nil and light.valid then
            light.target = player.position
        end
    end
end)