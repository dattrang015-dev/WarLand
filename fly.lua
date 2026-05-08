-- [[ 🚀 WARLAND VN - CAMERA FLY ONLY EDITION ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TargetParent = (RunService:IsStudio() and player:WaitForChild("PlayerGui") or game:GetService("CoreGui"))

-- [ DỌN DẸP ]
if TargetParent:FindFirstChild("WarLand_Fly_Only") then TargetParent.WarLand_Fly_Only:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WarLand_Fly_Only"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- [ BIẾN ĐIỀU KHIỂN ]
_G.FlySpeed = 85
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

-- [ NÚT BẤM BAY ]
local FlyBtn = Instance.new("TextButton")
FlyBtn.Parent = ScreenGui
FlyBtn.Size = UDim2.new(0, 60, 0, 60)
FlyBtn.Position = UDim2.new(0, 15, 0.5, -30)
FlyBtn.Text = "FLY"
FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Màu đỏ khi đang tắt
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = "GothamBold"
FlyBtn.TextSize = 20
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(1, 0)
local BStroke = Instance.new("UIStroke", FlyBtn); BStroke.Thickness = 2.5; BStroke.Color = Color3.fromRGB(255, 255, 255)

MakeDraggable(FlyBtn)

-- [ LOGIC BAY ]
FlyBtn.MouseButton1Click:Connect(function()
    _G.Flying = not _G.Flying
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if _G.Flying then
        FlyBtn.Text = "ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50) -- Màu xanh khi đang bật
        
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "F_Fly"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0)
        
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.Name = "F_Gyro"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 9e4
        
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
            if char.HumanoidRootPart:FindFirstChild("F_Fly") then char.HumanoidRootPart.F_Fly:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("F_Gyro") then char.HumanoidRootPart.F_Gyro:Destroy() end
        end)
    else
        FlyBtn.Text = "FLY"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
