-- [[ 🚀 WARLAND VN - V100.0: 3 MODES TP (INSTANT/CLICK/FLY-TO-PLAYER) ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_V100") then TargetParent.WarLand_V100:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent); ScreenGui.Name = "WarLand_V100"

-- [ BIẾN HỆ THỐNG ]
_G.TPFly = false
_G.Noclip = false
_G.ClickTP = false
local SelectedPlayer = nil

-- [ CƠ CHẾ NOCLIP ]
RunService.Stepped:Connect(function()
    if _G.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [ CƠ CHẾ TP BAY ĐẾN PLAYER (CÓ AUTO-STOP) ]
RunService.RenderStepped:Connect(function()
    if _G.TPFly and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local targetPos = SelectedPlayer.Character.HumanoidRootPart.Position
        _G.Noclip = true -- Tự bật noclip khi bay
        
        local dist = (hrp.Position - targetPos).Magnitude
        if dist > 5 then
            hrp.CFrame = CFrame.new(hrp.Position, targetPos) * CFrame.new(0, 0, -2) -- Tốc độ bay
        else
            _G.TPFly = false -- TỰ TẮT BAY
            _G.Noclip = false -- TỰ TẮT NOCLIP
            print("Đã tới nơi, tự động tắt!")
        end
    end
end)

-- [ GIAO DIỆN UI ]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = obj.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragging then local delta = input.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0.5, 0, 0.6, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Visible = false; Instance.new("UICorner", Main); MakeDraggable(Main)

local TabList = Instance.new("UIListLayout", Instance.new("Frame", Main)); TabList.Parent.Size = UDim2.new(0.3, 0, 1, 0); TabList.Parent.BackgroundTransparency = 1
local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(0.7, 0, 1, 0); Pages.Position = UDim2.new(0.3, 0, 0, 0); Pages.BackgroundTransparency = 1

local function CreatePage(name, isFirst)
    local b = Instance.new("TextButton", TabList.Parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1)
    local p = Instance.new("UIListLayout", Instance.new("ScrollingFrame", Pages)); p.Parent.Size = UDim2.new(1, 0, 1, 0); p.Parent.Visible = isFirst; p.Parent.BackgroundTransparency = 1
    b.MouseButton1Click:Connect(function() for _,v in pairs(Pages:GetChildren()) do v.Visible = false end; p.Parent.Visible = true end)
    return p
end

local Page1 = CreatePage("TP MODES", true)
local Page2 = CreatePage("PLAYER", false)

-- [ CÁC NÚT BẤM ]
local function AddBtn(parent, text, cb)
    local b = Instance.new("TextButton", parent.Parent); b.Size = UDim2.new(0.9, 0, 0, 40); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.MouseButton1Click:Connect(cb)
end

-- 1. TP BÌNH THƯỜNG
AddBtn(Page1, "TP TỨC THÌ (INSTANT)", function()
    if SelectedPlayer and SelectedPlayer.Character then
        player.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- 2. CLICK TP
AddBtn(Page1, "CLICK TP (TOOL ON/OFF)", function()
    _G.ClickTP = not _G.ClickTP
    if _G.ClickTP then
        local t = Instance.new("Tool", player.Backpack); t.Name = "Click TP"
        t.Activated:Connect(function() local m = player:GetMouse(); if m.Hit then player.Character.HumanoidRootPart.CFrame = m.Hit + Vector3.new(0,5,0) end end)
    else
        for _, v in pairs(player.Backpack:GetChildren()) do if v.Name == "Click TP" then v:Destroy() end end
    end
end)

-- 3. TP FLY ĐẾN PLAYER
AddBtn(Page1, "TP FLY TỚI PLAYER (AUTO-STOP)", function()
    if SelectedPlayer then _G.TPFly = true end
end)

-- [ CHỌN PLAYER ]
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= player then
        local b = Instance.new("TextButton", Page2.Parent); b.Size = UDim2.new(0.9, 0, 0, 30); b.Text = p.Name; b.MouseButton1Click:Connect(function() SelectedPlayer = p end)
    end
end

-- [ NÚT TẮT MỞ UI ]
local ToggleBtn = Instance.new("TextButton", ScreenGui); ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Text = "WL"; ToggleBtn.Position = UDim2.new(0, 0, 0.5, 0); ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
