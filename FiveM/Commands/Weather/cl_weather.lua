RegisterCommand("setweather", function(_, args)
    local weatherType = args[1] or "clear"

    local correctWeatherTypes = {
        "clear",
        "extra sunny",
        "clouds",
        "overcast",
        "rain",
        "thunder",
        "smog",
        "foggy",
        "light rain",
        "clearing",
        "neutral",
        "hazy",
        "dark",
        "foggy",
        "light rain",
        "xmas",
        "snowlight",
        "blizzard"
    }

    if not table.contains(correctWeatherTypes, weatherType) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"Invalid weather type. "}
        })
        return
    else
        SetWeatherTypeNowPersist(weatherType)

        TriggerEvent('chat:addMessage', {
            color = {52, 128, 235},
            args = {"The weather is now " .. weatherType}
        })
    end
end, false)

function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end
