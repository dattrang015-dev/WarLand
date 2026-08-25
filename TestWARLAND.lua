-- [[ 🚀 WARLAND VN - GOD SPEED FLY (MAX 1000) ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TargetParent = (RunService:IsStudio() and player:WaitForChild("PlayerGui") or game:GetService("CoreGui"))

-- [ DỌN DẸP ]
if TargetParent:FindFirstChild("WarLand_GodFly") then TargetParent.WarLand_GodFly:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WarLand_GodFly"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- [ BIẾN ĐIỀU KHIỂN ]
_G.FlySpeed = 100
_G.Flying = false

-- [ HÀM KÉO THẢ ]
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ GIAO DIỆN CHÍNH ]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0, 15, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Thickness = 2.5; Stroke.Color = Color3.fromRGB(0, 255, 255)
MakeDraggable(MainFrame)

-- NÚT FLY
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, -20, 0, 40)
FlyBtn.Position = UDim2.new(0, 10, 0, 10)
FlyBtn.Text = "FLY: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = "GothamBold"
FlyBtn.TextSize = 16
FlyBtn.Parent = MainFrame
Instance.new("UICorner", FlyBtn)

-- THANH CHỈNH TỐC ĐỘ
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 55)
SpeedLabel.Text = "SPEED: " .. _G.FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = "GothamBold"
SpeedLabel.TextSize = 13
SpeedLabel.Parent = MainFrame

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(0.85, 0, 0, 8)
SliderBtn.Position = UDim2.new(0.075, 0, 0, 80)
SliderBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderBtn.Text = ""
SliderBtn.Parent = MainFrame
Instance.new("UICorner", SliderBtn)

local SliderCircle = Instance.new("Frame")
SliderCircle.Size = UDim2.new(0, 16, 0, 16)
SliderCircle.Position = UDim2.new(0.1, -8, 0.5, -8) -- Mặc định ở 100/1000
SliderCircle.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SliderCircle.Parent = SliderBtn
Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(1, 0)

-- [ LOGIC SLIDER ]
local isSliding = false
SliderBtn.MouseButton1Down:Connect(function() isSliding = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = false end end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
        SliderCircle.Position = UDim2.new(pos, -8, 0.5, -8)
        _G.FlySpeed = math.floor(pos * 1000) -- Tăng lên tối đa 1000
        SpeedLabel.Text = "SPEED: " .. _G.FlySpeed
    end
end)

-- [ LOGIC FLY ]
FlyBtn.MouseButton1Click:Connect(function()
    _G.Flying = not _G.Flying
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if _G.Flying then
        FlyBtn.Text = "FLY: ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "WarFlyVel"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Velocity = Vector3.new(0, 0, 0)
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.Name = "WarFlyGyro"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9); bg.P = 1e5
        
        task.spawn(function()
            while _G.Flying and char:FindFirstChild("HumanoidRootPart") do
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlySpeed
                else 
                    bv.Velocity = Vector3.new(0, 0, 0) 
                end
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            if char.HumanoidRootPart:FindFirstChild("WarFlyVel") then char.HumanoidRootPart.WarFlyVel:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("WarFlyGyro") then char.HumanoidRootPart.WarFlyGyro:Destroy() end
        end)
    else
        FlyBtn.Text = "FLY: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    end
end)
