-- [[ 🚀 WARLAND VN - V101.0: ALL-IN-ONE EDITION ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_V101") then TargetParent.WarLand_V101:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent); ScreenGui.Name = "WarLand_V101"

-- [ BIẾN HỆ THỐNG ]
_G.Fly = false; _G.Noclip = false; _G.FullESP = false; _G.Fullbright = false; _G.TPFly = false
local SelectedPlayer = nil

-- [ CƠ CHẾ CHẠY NGẦM ]
RunService.Stepped:Connect(function()
    -- Noclip toàn cục
    if _G.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    -- TP Fly tới Player (Có Auto-Stop)
    if _G.TPFly and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local targetPos = SelectedPlayer.Character.HumanoidRootPart.Position
        _G.Noclip = true 
        if (hrp.Position - targetPos).Magnitude > 5 then
            hrp.CFrame = CFrame.new(hrp.Position, targetPos) * CFrame.new(0, 0, -3)
        else
            _G.TPFly = false; _G.Noclip = false
        end
    end
end)

-- [ GIAO DIỆN UI ]
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0.5, 0, 0.7, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Visible = false; Instance.new("UICorner", Main)
local TabList = Instance.new("UIListLayout", Instance.new("Frame", Main)); TabList.Parent.Size = UDim2.new(0.3, 0, 1, 0); TabList.Parent.BackgroundTransparency = 1
local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(0.7, 0, 1, 0); Pages.Position = UDim2.new(0.3, 0, 0, 0); Pages.BackgroundTransparency = 1

local function CreateTab(name, isFirst)
    local b = Instance.new("TextButton", TabList.Parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1)
    local p = Instance.new("UIListLayout", Instance.new("ScrollingFrame", Pages)); p.Parent.Size = UDim2.new(1, 0, 1, 0); p.Parent.Visible = isFirst; p.Parent.BackgroundTransparency = 1
    b.MouseButton1Click:Connect(function() for _,v in pairs(Pages:GetChildren()) do v.Visible = false end; p.Parent.Visible = true end)
    return p
end

local Tab1 = CreateTab("MAIN", true); local Tab2 = CreateTab("MOVEMENT", false); local Tab3 = CreateTab("PLAYER", false)

local function AddBtn(parent, text, cb)
    local b = Instance.new("TextButton", parent.Parent); b.Size = UDim2.new(0.9, 0, 0, 40); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.MouseButton1Click:Connect(cb)
end

-- [ TÍNH NĂNG ]
AddBtn(Tab1, "SÁNG TOÀN BẢN ĐỒ", function() _G.Fullbright = not _G.Fullbright; Lighting.Brightness = _G.Fullbright and 2 or 1 end)
AddBtn(Tab1, "CHỐNG AFK", function() local vu = game:GetService("VirtualUser"); player.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.new(0,0)) end) end)
AddBtn(Tab1, "ESP (HIGHLIGHT)", function() 
    _G.FullESP = not _G.FullESP
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then 
            local hl = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            hl.Enabled = _G.FullESP
        end
    end
end)

-- TP MODES
AddBtn(Tab2, "TP TỨC THÌ", function() if SelectedPlayer and SelectedPlayer.Character then player.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame end end)
AddBtn(Tab2, "CLICK TP (TOOL)", function() 
    local t = Instance.new("Tool", player.Backpack); t.Name = "Click TP"; t.RequiresHandle = false
    t.Activated:Connect(function() player.Character.HumanoidRootPart.CFrame = player:GetMouse().Hit + Vector3.new(0,5,0) end)
end)
AddBtn(Tab2, "TP FLY TỚI PLAYER", function() if SelectedPlayer then _G.TPFly = true end end)
AddBtn(Tab2, "NOCLIP (TẮT/MỞ)", function() _G.Noclip = not _G.Noclip end)

-- PLAYER LIST
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= player then
        local b = Instance.new("TextButton", Tab3.Parent); b.Size = UDim2.new(0.9, 0, 0, 30); b.Text = p.Name; b.MouseButton1Click:Connect(function() SelectedPlayer = p end)
    end
end

-- Toggle UI
local ToggleBtn = Instance.new("TextButton", ScreenGui); ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Text = "WL"; ToggleBtn.Position = UDim2.new(0, 0, 0.5, 0); ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
