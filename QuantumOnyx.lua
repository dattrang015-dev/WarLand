--[[
                            QUANTUM ONYX HUB PROJECT
            This was made by Quantum Onyx Team ( discord.gg/quantumonyx )
            Key system removed as requested[span_1](start_span)[span_1](end_span)
            Service by Luarmor.net
            Compiled by: Flazhy
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
local SCRIPT_ID = "0ae9fe4cf963e3a13d25eed0e2ce5940"
local Players = game:GetService("Players")
local gameId = game.GameId

local StarterGui = game:GetService("StarterGui")
local function Notify(title, desc, accent, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Quantum Onyx",
            Text = desc or "",
            Duration = duration or 5,
        })
    end)
end

local function apply_script_key(key)
    getgenv().script_key = key
    getgenv().key = key
    if type(_G) == "table" then
        _G.script_key = key
    end
    if type(shared) == "table" then
        shared.script_key = key
    end
    pcall(function()
        if type(getrenv) == "function" then
            local env = getrenv()
            if type(env) == "table" then
                env.script_key = key
            end
        end
    end)
end

local function LoadScript(tier, key)
    local tbl = Scripts[tier]
    if not tbl then return end
    local url = tbl[gameId]
    if not url then
        warn("[Quantum Onyx] No " .. tier .. " script for GameId: " .. tostring(gameId))
        return
    end
    if tier == "Premium" and key then
        apply_script_key(key)
    end
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if not ok then warn("[Quantum Onyx] Error: " .. tostring(err)) end
end

local function LoadHub()
    if Scripts.Premium[gameId] then
        Notify("Quantum Onyx", "Loading Premium Script...", Color3.fromRGB(80, 230, 130), 3)
        LoadScript("Premium", "Bypassed")
    elseif Scripts.Free[gameId] then
        Notify("Quantum Onyx", "Loading Free Script...", Color3.fromRGB(80, 230, 130), 3)
        LoadScript("Free", nil)
    else
        warn("[Quantum Onyx] No script found for this GameId: " .. tostring(gameId))
        Notify("Quantum Onyx", "No script found for this game.", Color3.fromRGB(255, 90, 110), 5)
    end
end

LoadHub()
