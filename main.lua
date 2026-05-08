-- [[ 🚀 WARLAND VN - V9: ULTIMATE ESP (BOX, NAME, DISTANCE) ]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

-- [ DỌN DẸP ]
if TargetParent:FindFirstChild("WarLand_Final_V9") then TargetParent.WarLand_Final_V9:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_Final_V9"
ScreenGui.ResetOnSpawn = false

-- [ BIẾN ĐIỀU KHIỂN ]
_G.FlySpeed = 150
_G.WalkSpeed = 100 
_G.JumpPower = 300 
_G.Flying = false
_G.EspEnabled = false

-- [ GIAO DIỆN CHÍNH ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 310); Main.Position = UDim2.new(0.5, -120, 0.5, -155)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.BorderSizePixel = 0
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2.5; Stroke.Color = Color3.fromRGB(0, 255, 255)

-- [ NÚT TOGGLE ]
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ToggleBtn.Text = "WL"; ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Font = "GothamBold"; ToggleBtn.TextSize = 18; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 255, 255)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [ HÀM KÉO THẢ ]
local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end
EnableDragging(Main); EnableDragging(ToggleBtn)

-- [ HÀM TẠO SLIDER ]
local function CreateSlider(name, pos, color, min, max, default, callback)
    local Label = Instance.new("TextLabel", Main)
    Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = pos; Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1; Label.Font = "GothamBold"; Label.TextSize = 11
    local Slider = Instance.new("TextButton", Main)
    Slider.Size = UDim2.new(0.8, 0, 0, 6); Slider.Position = pos + UDim2.new(0.1, 0, 0, 22); Slider.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Slider.Text = ""; Instance.new("UICorner", Slider)
    local Dot = Instance.new("Frame", Slider)
    Dot.Size = UDim2.new(0, 16, 0, 16); Dot.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8); Dot.BackgroundColor3 = color; Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    Slider.MouseButton1Down:Connect(function()
        local con; con = RunService.RenderStepped:Connect(function()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local pos_X = math.clamp((UserInputService:GetMouseLocation().X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                Dot.Position = UDim2.new(pos_X, -8, 0.5, -8); local val = math.floor(min + (pos_X * (max - min)))
                Label.Text = name .. ": " .. val; callback(val)
            else con:Disconnect() end
        end)
    end)
end

-- [ NÚT BẬT/TẮT FLY ]
local FlyBtn = Instance.new("TextButton", Main)
FlyBtn.Size = UDim2.new(1, -20, 0, 40); FlyBtn.Position = UDim2.new(0, 10, 0, 10); FlyBtn.Text = "FLY MODE: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FlyBtn.Font = "GothamBold"; Instance.new("UICorner", FlyBtn)

CreateSlider("FLY SPEED", UDim2.new(0, 0, 0, 60), Color3.fromRGB(255, 0, 100), 0, 1000, _G.FlySpeed, function(v) _G.FlySpeed = v end)
CreateSlider("WALK SPEED", UDim2.new(0, 0, 0, 110), Color3.fromRGB(255, 200, 0), 0, 500, _G.WalkSpeed, function(v) _G.WalkSpeed = v end)
CreateSlider("JUMP POWER", UDim2.new(0, 0, 0, 160), Color3.fromRGB(0, 255, 150), 50, 700, _G.JumpPower, function(v) _G.JumpPower = v end)

-- [ NÚT BẬT/TẮT ESP ]
local EspBtn = Instance.new("TextButton", Main)
EspBtn.Size = UDim2.new(1, -20, 0, 40); EspBtn.Position = UDim2.new(0, 10, 0, 210); EspBtn.Text = "PLAYER ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255); EspBtn.Font = "GothamBold"; Instance.new("UICorner", EspBtn)

-- [[ 👁️ HỆ THỐNG ESP TRACERS & NAME ]]
local function AddEsp(plr)
    local Billboard = Instance.new("BillboardGui")
    local Label = Instance.new("TextLabel")
    
    Billboard.Name = "WarEsp"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.Adornee = plr.Character:WaitForChild("Head")
    Billboard.AlwaysOnTop = true
    Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    Billboard.Parent = ScreenGui
    
    Label.Parent = Billboard
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextStrokeTransparency = 0
    Label.Font = "GothamBold"
    Label.TextSize = 14

    RunService.RenderStepped:Connect(function()
        if _G.EspEnabled and plr.Character and plr.Character:FindFirstChild("Head") then
            Billboard.Enabled = true
            local dist = math.floor((player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
            Label.Text = plr.Name .. " [" .. dist .. "m]"
        else
            Billboard.Enabled = false
        end
    end)
end

-- Tự động thêm ESP cho người chơi mới
game.Players.PlayerAdded:Connect(AddEsp)
for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= player then task.spawn(function() AddEsp(v) end) end
end

EspBtn.MouseButton1Click:Connect(function()
    _G.EspEnabled = not _G.EspEnabled
    EspBtn.Text = _G.EspEnabled and "PLAYER ESP: ON" or "PLAYER ESP: OFF"
    EspBtn.BackgroundColor3 = _G.EspEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)

-- [ VÒNG LẶP CHÍNH ]
RunService.Stepped:Connect(function()
    pcall(function()
        local char = player.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
        if hum and root then
            if _G.WalkSpeed > 0 and not _G.Flying and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (_G.WalkSpeed / 45))
            end
            hum.JumpPower = _G.JumpPower; hum.UseJumpPower = true
        end
    end)
end)

-- [ LOGIC FLY ]
FlyBtn.MouseButton1Click:Connect(function()
    _G.Flying = not _G.Flying
    FlyBtn.Text = _G.Flying and "FLY MODE: ON" or "FLY MODE: OFF"
    FlyBtn.BackgroundColor3 = _G.Flying and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if _G.Flying and root then
        local bv = Instance.new("BodyVelocity", root); bv.Name = "WarVel"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        local bg = Instance.new("BodyGyro", root); bg.Name = "WarGyro"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        task.spawn(function()
            while _G.Flying and root.Parent do
                local cam = workspace.CurrentCamera
                if player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    bv.Velocity = cam.CFrame:VectorToWorldSpace(Vector3.new(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0), 0, UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0))).Unit * _G.FlySpeed
                else bv.Velocity = Vector3.new(0, 0, 0) end
                bg.CFrame = cam.CFrame; task.wait()
            end
            if root:FindFirstChild("WarVel") then root.WarVel:Destroy() end
            if root:FindFirstChild("WarGyro") then root.WarGyro:Destroy() end
        end)
    end
end)
