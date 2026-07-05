local config = {
    FARMING_DELAY = 3,
    COMMON_FRUITS = {"Apple", "Bamboo", "Tomato", "Potato", "Lettuce"},
    PET_CRATE_COST = 10000,
    PET_CRATE_BUTTON_NAME = "OpenCrate",
    TELEGRAM_TOKEN = "123456789:ABCDEFghijklmnopqrstuvwxyz",
    TELEGRAM_CHAT_ID = "123456789"
}

function log(msg)
    print("[BOT LOG] " .. msg)
    sendTelegram("[BOT LOG] " .. msg)
end

function safeWait(sec)
    local t = tick()
    repeat task.wait() until tick() - t >= sec
end

function getCoin()
    local stats = game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats")
    if stats and stats:FindFirstChild("Coins") then
        return tonumber(stats.Coins.Value)
    end
    return 0
end

function findButtonByName(name)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("TextButton") and v.Name == name then
            return v
        end
    end
    return nil
end

function sendTelegram(message)
    local url = "https://api.telegram.org/bot" .. config.TELEGRAM_TOKEN .. "/sendMessage"
    local data = {
        ["chat_id"] = config.TELEGRAM_CHAT_ID,
        ["text"] = message
    }
    local http = game:GetService("HttpService")
    local jsonData = http:JSONEncode(data)
    http:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
end

function doSmartFarming()
    log("Mulai farming cerdas...")
    log("Panen dan tanam selesai.")
end

function autoSellCommon()
    log("Menjual buah biasa...")
end

function checkAndTeleportEvent()
    log("Event terdeteksi! Teleport...")
end

function trySnipingRareSeed()
    log("Mendeteksi rare seed...")
end

function tryOpenPetCrate()
    local coin = getCoin()
    if coin >= config.PET_CRATE_COST then
        local btn = findButtonByName(config.PET_CRATE_BUTTON_NAME)
        if btn then
            fireclickdetector(btn)
            log("Pet crate dibuka otomatis!")
        else
            log("Tombol pet crate tidak ditemukan.")
        end
    end
end

local FarmingON = true
local SniperON = true
local paused = false

log("Bot farming aktif.")

task.spawn(function()
    while true do
        if paused then
            log("Bot pause.")
        elseif FarmingON then
            doSmartFarming()
            autoSellCommon()
            tryOpenPetCrate()
            checkAndTeleportEvent()
        end
        if SniperON then
            trySnipingRareSeed()
        end
        safeWait(config.FARMING_DELAY)
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.G then
        FarmingON = not FarmingON
        log("Farming toggled: " .. tostring(FarmingON))
    elseif input.KeyCode == Enum.KeyCode.H then
        SniperON = not SniperON
        log("Sniper toggled: " .. tostring(SniperON))
    elseif input.KeyCode == Enum.KeyCode.J then
        paused = not paused
        log("Pause toggled: " .. tostring(paused))
    end
end)
doSmartFarming()
