-- [[ 🚀 WARLAND VN - V23: RAINBOW TITLE & FULL DRAGGABLE ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_Pro_V23") then TargetParent.WarLand_Pro_V23:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_Pro_V23"
ScreenGui.ResetOnSpawn = false

-- [ BIẾN CÀI ĐẶT ]
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.FlySpeed = 150
_G.Flying = false
_G.EspEnabled = false
local SelectedPlayer = nil

-- [ HÀM KÉO THẢ TỰ DO ]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ GIAO DIỆN CHÍNH ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 380)
Main.Position = UDim2.new(0.5, -250, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 3; Stroke.Color = Color3.fromRGB(0, 255, 255)
MakeDraggable(Main)

-- [ NÚT ĐÓNG/MỞ ]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 70, 0, 70); ToggleBtn.Position = UDim2.new(0, 30, 0.5, -35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ToggleBtn.Text = "CLOSE"; ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Font = "GothamBold"; ToggleBtn.TextSize = 16; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local TStroke = Instance.new("UIStroke", ToggleBtn); TStroke.Color = Color3.fromRGB(0, 255, 255); TStroke.Thickness = 2
MakeDraggable(ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    ToggleBtn.Text = Main.Visible and "CLOSE" or "OPEN"
end)

-- [ TIÊU ĐỀ RAINBOW ]
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 50); Header.Text = "WARLAND VN"; Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Header.Font = "GothamBold"; Header.TextSize = 26 -- Chữ rất bự
Instance.new("UICorner", Header)

task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        Header.TextColor3 = Color3.fromHSV(hue, 1, 1)
        Stroke.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- [ THANH TAB ]
local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(1, 0, 0, 45); TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

local ContentContainer = Instance.new("Frame", Main)
ContentContainer.Size = UDim2.new(1, 0, 1, -110); ContentContainer.Position = UDim2.new(0, 0, 0, 110)
ContentContainer.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name, pos_x)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.333, 0, 1, 0); TabBtn.Position = UDim2.new(pos_x, 0, 0, 0)
    TabBtn.Text = name:upper(); TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.Font = "GothamBold"; TabBtn.TextSize = 18; TabBtn.BorderSizePixel = 0
    
    local Page = Instance.new("Frame", ContentContainer)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
    Tabs[name] = {Btn = TabBtn, Page = Page}
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false; t.Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); t.Btn.TextColor3 = Color3.fromRGB(255,255,255) end
        Page.Visible = true; TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); TabBtn.TextColor3 = Color3.fromRGB(0,0,0)
    end)
    return Page
end

local HomePage = CreateTab("home", 0)
local TpPage = CreateTab("tp", 0.333)
local EspPage = CreateTab("esp", 0.666)
Tabs["home"].Page.Visible = true; Tabs["home"].Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Tabs["home"].Btn.TextColor3 = Color3.fromRGB(0,0,0)

-- [[ 🏠 TAB HOME ]]
local function CreateSlider(parent, name, pos, min, max, default, callback)
    local Lbl = Instance.new("TextLabel", parent); Lbl.Size = UDim2.new(0.9, 0, 0, 30); Lbl.Position = pos; Lbl.Text = name..": "..default; Lbl.TextColor3 = Color3.fromRGB(255,255,255); Lbl.BackgroundTransparency = 1; Lbl.Font = "GothamBold"; Lbl.TextSize = 16
    local Sld = Instance.new("TextButton", parent); Sld.Size = UDim2.new(0.8, 0, 0, 10); Sld.Position = pos + UDim2.new(0.05, 0, 0, 35); Sld.BackgroundColor3 = Color3.fromRGB(50,50,55); Sld.Text = ""; Instance.new("UICorner", Sld)
    local Dot = Instance.new("Frame", Sld); Dot.Size = UDim2.new(0, 20, 0, 20); Dot.Position = UDim2.new((default-min)/(max-min), -10, 0.5, -10); Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Dot)
    Sld.MouseButton1Down:Connect(function()
        local con; con = RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local p = math.clamp((UserInputService:GetMouseLocation().X - Sld.AbsolutePosition.X) / Sld.AbsoluteSize.X, 0, 1)
                Dot.Position = UDim2.new(p, -10, 0.5, -10); local v = math.floor(min + (p * (max-min))); Lbl.Text = name..": "..v; callback(v)
            else con:Disconnect() end
        end)
    end)
end

CreateSlider(HomePage, "TỐC ĐỘ CHẠY", UDim2.new(0.05,0,0,10), 16, 500, _G.WalkSpeed, function(v) _G.WalkSpeed = v end)
CreateSlider(HomePage, "NHẢY CAO", UDim2.new(0.05,0,0,75), 50, 700, _G.JumpPower, function(v) _G.JumpPower = v end)
CreateSlider(HomePage, "TỐC ĐỘ BAY", UDim2.new(0.05,0,0,140), 50, 1000, _G.FlySpeed, function(v) _G.FlySpeed = v end)

local FlyTgl = Instance.new("TextButton", HomePage); FlyTgl.Size = UDim2.new(0.4, 0, 0, 50); FlyTgl.Position = UDim2.new(0.3, 0, 0, 210); FlyTgl.Text = "FLY: OFF"; FlyTgl.BackgroundColor3 = Color3.fromRGB(50,50,60); FlyTgl.TextColor3 = Color3.fromRGB(255,255,255); FlyTgl.Font = "GothamBold"; FlyTgl.TextSize = 18; Instance.new("UICorner", FlyTgl)
FlyTgl.MouseButton1Click:Connect(function() _G.Flying = not _G.Flying; FlyTgl.Text = _G.Flying and "FLY: ON" or "FLY: OFF"; FlyTgl.BackgroundColor3 = _G.Flying and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50,50,60) end)

-- [[ 📍 TAB TP ]]
local PList = Instance.new("ScrollingFrame", TpPage); PList.Size = UDim2.new(0.45, 0, 0.9, 0); PList.Position = UDim2.new(0.03, 0, 0.05, 0); PList.BackgroundColor3 = Color3.fromRGB(5,5,10); PList.ScrollBarThickness = 5; Instance.new("UIListLayout", PList).Padding = UDim.new(0, 5)
local TgtLbl = Instance.new("TextLabel", TpPage); TgtLbl.Size = UDim2.new(0.48, 0, 0, 45); TgtLbl.Position = UDim2.new(0.5, 0, 0.05, 0); TgtLbl.Text = "Mục tiêu: None"; TgtLbl.TextColor3 = Color3.fromRGB(255,255,0); TgtLbl.TextSize = 18; TgtLbl.Font = "GothamBold"; TgtLbl.BackgroundTransparency = 1

local function UpdPList()
    for _,v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _,plr in pairs(game.Players:GetPlayers()) do if plr ~= player then
        local b = Instance.new("TextButton", PList); b.Size = UDim2.new(1, -10, 0, 40); b.Text = plr.DisplayName; b.BackgroundColor3 = Color3.fromRGB(40,40,50); b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = "GothamBold"; b.TextSize = 15; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() SelectedPlayer = plr; TgtLbl.Text = "Mục tiêu: "..plr.DisplayName end)
    end end
end
UpdPList(); game.Players.PlayerAdded:Connect(UpdPList); game.Players.PlayerRemoving:Connect(UpdPList)

local TPTo = Instance.new("TextButton", TpPage); TPTo.Size = UDim2.new(0.45, 0, 0, 50); TPTo.Position = UDim2.new(0.52, 0, 0.35, 0); TPTo.Text = "TP ĐẾN HỌ"; TPTo.BackgroundColor3 = Color3.fromRGB(0, 120, 255); TPTo.TextColor3 = Color3.fromRGB(255,255,255); TPTo.Font = "GothamBold"; TPTo.TextSize = 16; Instance.new("UICorner", TPTo)
local Bring = Instance.new("TextButton", TpPage); Bring.Size = UDim2.new(0.45, 0, 0, 50); Bring.Position = UDim2.new(0.52, 0, 0.6, 0); Bring.Text = "KÉO HỌ ĐẾN"; Bring.BackgroundColor3 = Color3.fromRGB(255, 80, 0); Bring.TextColor3 = Color3.fromRGB(255,255,255); Bring.Font = "GothamBold"; Bring.TextSize = 16; Instance.new("UICorner", Bring)

TPTo.MouseButton1Click:Connect(function() if SelectedPlayer and SelectedPlayer.Character then player.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end)
Bring.MouseButton1Click:Connect(function() if SelectedPlayer and SelectedPlayer.Character then SelectedPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) end end)

-- [[ 👁 TAB ESP ]]
local EspTgl = Instance.new("TextButton", EspPage); EspTgl.Size = UDim2.new(0.6, 0, 0, 70); EspTgl.Position = UDim2.new(0.2, 0, 0.3, 0); EspTgl.Text = "BẬT/TẮT ESP"; EspTgl.BackgroundColor3 = Color3.fromRGB(50,50,60); EspTgl.TextColor3 = Color3.fromRGB(255,255,255); EspTgl.Font = "GothamBold"; EspTgl.TextSize = 22; Instance.new("UICorner", EspTgl)
EspTgl.MouseButton1Click:Connect(function() _G.EspEnabled = not _G.EspEnabled; EspTgl.BackgroundColor3 = _G.EspEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50,50,60) end)

-- [ LOGIC HỆ THỐNG ]
RunService.Stepped:Connect(function()
    pcall(function()
        local hum = player.Character.Humanoid
        if _G.WalkSpeed > 16 and not _G.Flying and hum.MoveDirection.Magnitude > 0 then
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (_G.WalkSpeed / 45))
        end
        hum.JumpPower = _G.JumpPower; hum.UseJumpPower = true
    end)
end)

task.spawn(function()
    while task.wait() do
        if _G.Flying then
            local root = player.Character.HumanoidRootPart
            local bv = root:FindFirstChild("WarVel") or Instance.new("BodyVelocity", root); bv.Name = "WarVel"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            local bg = root:FindFirstChild("WarGyro") or Instance.new("BodyGyro", root); bg.Name = "WarGyro"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            local cam = workspace.CurrentCamera
            if player.Character.Humanoid.MoveDirection.Magnitude > 0 then 
                bv.Velocity = cam.CFrame:VectorToWorldSpace(Vector3.new(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0), 0, UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0))).Unit * _G.FlySpeed
            else bv.Velocity = Vector3.new(0, 0.1, 0) end
            bg.CFrame = cam.CFrame
        else
            if player.Character.HumanoidRootPart:FindFirstChild("WarVel") then player.Character.HumanoidRootPart.WarVel:Destroy() end
            if player.Character.HumanoidRootPart:FindFirstChild("WarGyro") then player.Character.HumanoidRootPart.WarGyro:Destroy() end
        end
    end
end)

local function AddEsp(p)
    local b = Instance.new("BillboardGui", ScreenGui); b.AlwaysOnTop = true; b.Size = UDim2.new(0, 200, 0, 50)
    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 16; l.Font = "GothamBold"
    RunService.RenderStepped:Connect(function()
        if _G.EspEnabled and p.Character and p.Character:FindFirstChild("Head") then
            b.Adornee = p.Character.Head; b.Enabled = true
            l.Text = p.DisplayName .. " [" .. math.floor((player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
        else b.Enabled = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= player then AddEsp(v) end end
game.Players.PlayerAdded:Connect(AddEsp)
