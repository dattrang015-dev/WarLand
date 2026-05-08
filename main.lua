-- [[ 🚀 WARLAND VN - V48: FULL SLIDERS + PLAYER MENU (NO KILL) ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_V48") then TargetParent.WarLand_V48:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_V48"
ScreenGui.ResetOnSpawn = false

-- [ BIẾN HỆ THỐNG ]
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.FlySpeed = 150
_G.Flying = false
_G.EspEnabled = false
local SelectedPlayer = nil

-- [ HÀM KÉO THẢ ]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end

-- [ GIAO DIỆN CHÍNH ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 460); Main.Position = UDim2.new(0.5, -230, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.BorderSizePixel = 0; Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2.5; Stroke.Color = Color3.fromRGB(0, 255, 255)
MakeDraggable(Main)

-- [ NÚT MỞ ]
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 55, 0, 55); Toggle.Position = UDim2.new(0, 10, 0.5, -27)
Toggle.Text = "WL"; Toggle.Font = "GothamBold"; Toggle.TextSize = 20; Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Toggle.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
MakeDraggable(Toggle)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [ TABS ]
local TabBar = Instance.new("Frame", Main); TabBar.Size = UDim2.new(1, 0, 0, 45); TabBar.BackgroundTransparency = 1
local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, 0, 1, -55); Pages.Position = UDim2.new(0, 0, 0, 55); Pages.BackgroundTransparency = 1

local function CreateTab(name, x)
    local btn = Instance.new("TextButton", TabBar); btn.Size = UDim2.new(0.333, 0, 1, 0); btn.Position = UDim2.new(x, 0, 0, 0); btn.Text = name; btn.Font = "GothamBold"; btn.TextSize = 18; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); btn.TextColor3 = Color3.fromRGB(255,255,255)
    local pg = Instance.new("ScrollingFrame", Pages); pg.Size = UDim2.new(1, 0, 1, 0); pg.Visible = false; pg.BackgroundTransparency = 1; pg.ScrollBarThickness = 0
    Instance.new("UIListLayout", pg).Padding = UDim.new(0, 12); Instance.new("UIPadding", pg).PaddingLeft = UDim.new(0, 15)
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30,30,35); v.TextColor3 = Color3.fromRGB(255,255,255) end end
        pg.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255); btn.TextColor3 = Color3.fromRGB(0,0,0)
    end)
    return pg, btn
end

local PageHome, _ = CreateTab("HOME", 0)
local PagePlayer, _ = CreateTab("PLAYER", 0.333)
local PageESP, _ = CreateTab("ESP", 0.666)
PageHome.Visible = true

-- [[ 🏠 TAB HOME (HÀM SLIDER CHUẨN) ]]
local function CreateSlider(parent, name, min, max, default, callback)
    local F = Instance.new("Frame", parent); F.Size = UDim2.new(0.95, 0, 0, 75); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 30); L.Text = name..": "..default; L.TextColor3 = Color3.fromRGB(255,255,255); L.Font = "GothamBold"; L.TextSize = 22; L.BackgroundTransparency = 1
    local S = Instance.new("TextButton", F); S.Size = UDim2.new(0.9, 0, 0, 12); S.Position = UDim2.new(0.05, 0, 0, 42); S.Text = ""; S.BackgroundColor3 = Color3.fromRGB(50,50,50); Instance.new("UICorner", S)
    local D = Instance.new("Frame", S); D.Size = UDim2.new(0, 26, 0, 26); D.Position = UDim2.new((default-min)/(max-min), -13, 0.5, -13); D.BackgroundColor3 = Color3.fromRGB(0, 255, 255); Instance.new("UICorner", D)
    S.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then local move; move = RunService.RenderStepped:Connect(function() local p = math.clamp((UserInputService:GetMouseLocation().X - S.AbsolutePosition.X) / S.AbsoluteSize.X, 0, 1); D.Position = UDim2.new(p, -13, 0.5, -13); local v = math.floor(min + (p * (max-min))); L.Text = name..": "..v; callback(v) end); input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end end) end end)
end

CreateSlider(PageHome, "Tốc Độ Đi", 16, 500, _G.WalkSpeed, function(v) _G.WalkSpeed = v end)
CreateSlider(PageHome, "Nhảy Cao", 50, 600, _G.JumpPower, function(v) _G.JumpPower = v end)
CreateSlider(PageHome, "Tốc Độ Fly", 50, 1000, _G.FlySpeed, function(v) _G.FlySpeed = v end) -- THANH CHỈNH FLY SPEED ĐÂY RỒI!

local FlyTgl = Instance.new("TextButton", PageHome); FlyTgl.Size = UDim2.new(0.95, 0, 0, 65); FlyTgl.Text = "FLY (CAM): OFF"; FlyTgl.Font = "GothamBold"; FlyTgl.TextSize = 22; FlyTgl.BackgroundColor3 = Color3.fromRGB(40,40,45); FlyTgl.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", FlyTgl)
FlyTgl.MouseButton1Click:Connect(function() _G.Flying = not _G.Flying; FlyTgl.Text = _G.Flying and "FLY: ON" or "FLY: OFF"; FlyTgl.BackgroundColor3 = _G.Flying and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40,40,45) end)

-- [[ 📍 TAB PLAYER ]]
local SelectedMenu = Instance.new("Frame", PagePlayer); SelectedMenu.Size = UDim2.new(0.95, 0, 0, 55); SelectedMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255); SelectedMenu.BackgroundTransparency = 0.9; Instance.new("UICorner", SelectedMenu)
local NameDisplay = Instance.new("TextLabel", SelectedMenu); NameDisplay.Size = UDim2.new(1, 0, 1, 0); NameDisplay.Text = "🎯 CHỌN PLAYER"; NameDisplay.TextColor3 = Color3.fromRGB(0, 255, 255); NameDisplay.Font = "GothamBold"; NameDisplay.TextSize = 22; NameDisplay.BackgroundTransparency = 1

local PListFrame = Instance.new("ScrollingFrame", PagePlayer); PListFrame.Size = UDim2.new(0.95, 0, 0, 120); PListFrame.BackgroundTransparency = 0.95; PListFrame.ScrollBarThickness = 2; PListFrame.CanvasSize = UDim2.new(0,0,5,0)
Instance.new("UIListLayout", PListFrame).Padding = UDim.new(0, 5)

local function UpdP()
    for _,v in pairs(PListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _,p in pairs(game.Players:GetPlayers()) do if p ~= player then
        local b = Instance.new("TextButton", PListFrame); b.Size = UDim2.new(1, 0, 0, 35); b.Text = p.DisplayName; b.Font = "GothamBold"; b.TextSize = 17; b.BackgroundColor3 = Color3.fromRGB(40,40,50); b.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() SelectedPlayer = p; NameDisplay.Text = "🎯 " .. p.DisplayName end)
    end end
end
UpdP(); game.Players.PlayerAdded:Connect(UpdP); game.Players.PlayerRemoving:Connect(UpdP)

local function CreateActionBtn(txt, color, func)
    local b = Instance.new("TextButton", PagePlayer); b.Size = UDim2.new(0.95, 0, 0, 60); b.Text = txt; b.BackgroundColor3 = color; b.Font = "GothamBold"; b.TextSize = 23; b.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end
CreateActionBtn("TELEPORT ĐẾN HỌ", Color3.fromRGB(0, 100, 255), function() if SelectedPlayer and SelectedPlayer.Character then player.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end end)
CreateActionBtn("BRING (MANG TỚI)", Color3.fromRGB(0, 150, 100), function() if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then SelectedPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) end end)

-- [[ 👁 TAB ESP ]]
local EspTglBtn = Instance.new("TextButton", PageESP); EspTglBtn.Size = UDim2.new(0.95, 0, 0, 65); EspTglBtn.Text = "BẬT ESP"; EspTglBtn.BackgroundColor3 = Color3.fromRGB(40,40,45); EspTglBtn.Font = "GothamBold"; EspTglBtn.TextSize = 22; Instance.new("UICorner", EspTglBtn)
EspTglBtn.MouseButton1Click:Connect(function() _G.EspEnabled = not _G.EspEnabled; EspTglBtn.Text = _G.EspEnabled and "ESP: ĐANG BẬT" or "ESP: ĐANG TẮT"; EspTglBtn.BackgroundColor3 = _G.EspEnabled and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40,40,45) end)

-- [[ 🚀 LOGIC HỆ THỐNG ]]
task.spawn(function()
    local bv, bg
    while task.wait() do
        if _G.Flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart; local hum = player.Character.Humanoid; local cam = workspace.CurrentCamera
            if not bv then bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9) end
            local camLook = cam.CFrame.LookVector; local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then bv.Velocity = Vector3.new(moveDir.X * _G.FlySpeed, camLook.Y * _G.FlySpeed, moveDir.Z * _G.FlySpeed) else bv.Velocity = Vector3.new(0, 0, 0) end
            bg.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(camLook.X, 0, camLook.Z))
        else if bv then bv:Destroy(); bv = nil; bg:Destroy(); bg = nil end end
    end
end)

local function AddEsp(p)
    local b = Instance.new("BillboardGui", ScreenGui); b.AlwaysOnTop = true; b.Size = UDim2.new(0, 200, 0, 50); b.ExtentsOffset = Vector3.new(0, 3, 0)
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 18; l.Font = "GothamBold"
    RunService.RenderStepped:Connect(function()
        if _G.EspEnabled and p.Character and p.Character:FindFirstChild("Head") then
            b.Adornee = p.Character.Head; b.Enabled = true
            l.Text = p.DisplayName .. " [" .. math.floor((player.Character.HumanoidRootPart.Position - p.Character.Head.Position).Magnitude) .. "m]"
        else b.Enabled = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= player then AddEsp(v) end end
game.Players.PlayerAdded:Connect(AddEsp)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if _G.WalkSpeed > 16 and not _G.Flying and hum.MoveDirection.Magnitude > 0 then
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (_G.WalkSpeed / 45))
        end
        hum.JumpPower = _G.JumpPower; hum.UseJumpPower = true
    end
end)
