--[[
                            QUANTUM ONYX HUB PROJECT
            This was made by Quantum Onyx Team ( discord.gg/quantumonyx )
            Key system completely removed
            Copyright © 2022-2026 Quantum Onyx Team - All Rights Reserved.
]]--
local Directory = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/Games"
local Api = "https://api.luarmor.net/files/v4/loaders"
local Scripts = {
    Free = {
        [994732206] = Directory .. "/BloxFruits.lua",
        [9186719164] = Directory .. "/SailorPiece.lua",
        [8191429227] = Directory .. "/CutTrees.lua",
    },
    Premium = {
        [994732206] = Api .. "/0ae9fe4cf963e3a13d25eed0e2ce5940.lua",
        [10004244222] = Api .. "/63980a492928552d074ceee243a918d6.lua",
        [9792947201] = Api .. "/50e8e00251d97215e14313c0bb012058.lua",
        [10200395747] = Api .. "/65265b2869c03f57430ee45357d8c3f9.lua"
    }
}

local gameId = game.GameId
local StarterGui = game:GetService("StarterGui")

local function Notify(title, desc, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Quantum Onyx",
            Text = desc or "",
            Duration = duration or 5,
        })
    end)
end

local function LoadScript(tier)
    local tbl = Scripts[tier]
    if not tbl then return end
    local url = tbl[gameId]
    if not url then
        warn("[Quantum Onyx] No script for GameId: " .. tostring(gameId))
        return
    end
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if not ok then warn("[Quantum Onyx] Error: " .. tostring(err)) end
end

local function LoadHub()
    if Scripts.Premium[gameId] then
        Notify("Quantum Onyx", "Loading Script...", 3)
        LoadScript("Premium")
    elseif Scripts.Free[gameId] then
        Notify("Quantum Onyx", "Loading Script...", 3)
        LoadScript("Free")
    else
        warn("[Quantum Onyx] No script found for this GameId: " .. tostring(gameId))
        Notify("Quantum Onyx", "No script found for this game.", 5)
    end
end

LoadHub()
