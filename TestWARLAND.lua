-- [[ 🚀 WARLAND VN - V97.6: DYNAMIC ANTI-AFK (KHÔNG BẬT KHÔNG CHẠY) ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_V97") then TargetParent.WarLand_V97:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_V97"

-- [ BIẾN HỆ THỐNG ]
_G.FlySpeed = 100
_G.Flying = false
_G.Noclip = false
_G.InfJump = false
_G.Fullbright = false
_G.ClickTP = false
_G.FullESP = false 
_G.AntiAFK = false
local SelectedPlayer = nil
local AFKConnection = nil -- Dùng để quản lý kết nối AFK

-- [ HÀM XỬ LÝ ANTI-AFK (ĐỘNG) ]
local function ToggleAFK(state)
    _G.AntiAFK = state
    if state then
        -- Khi bật: Kết nối sự kiện Idled
        local vu = game:GetService("VirtualUser")
        AFKConnection = player.Idled:Connect(function()
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new(0, 0))
            end)
        end)
    else
        -- Khi tắt: Ngắt kết nối hoàn toàn
        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end

-- [ CÁC HÀM XỬ LÝ TOOL CLICK TP ]
local function GiveClickTPTool()
    if player.Backpack:FindFirstChild("Click TP") or (player.Character and player.Character:FindFirstChild("Click TP")) then return end
    local tool = Instance.new("Tool")
    tool.Name = "Click TP"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        if mouse.Target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end)
end

local function RemoveClickTPTool()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then local t = backpack:FindFirstChild("Click TP") if t then t:Destroy() end end
    if player.Character then local t = player.Character:FindFirstChild("Click TP") if t then t:Destroy() end end
end

-- [ HÀM UI ]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- [ KHUNG MENU VÀ TẠO GIAO DIỆN ]
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0.78, 0, 0.85, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.Visible = false; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255); MakeDraggable(Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0.28, 0, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", Sidebar)
local TabList = Instance.new("ScrollingFrame", Sidebar); TabList.Size = UDim2.new(1, 0, 1, 0); TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 2
local TabListLayout = Instance.new("UIListLayout", TabList); TabListLayout.Padding = UDim.new(0, 6)
local Pages = Instance.new("Frame", Main); Pages.Position = UDim2.new(0.3, 0, 0.02, 0); Pages.Size = UDim2.new(0.68, 0, 0.96, 0); Pages.BackgroundTransparency = 1

local function CreateTab(name, isFirst)
    local b = Instance.new("TextButton", TabList); b.Size = UDim2.new(1, -4, 0, 50); b.Text = name; b.Font = Enum.Font.GothamBold; b.TextSize = 15; b.BackgroundColor3 = isFirst and Color3.fromRGB(0,255,255) or Color3.fromRGB(20,20,25); b.TextColor3 = isFirst and Color3.new(0,0,0) or Color3.new(1,1,1); b.BorderSizePixel = 0; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = isFirst; p.BackgroundTransparency = 1; p.ScrollBarThickness = 6
    local pLayout = Instance.new("UIListLayout", p); pLayout.Padding = UDim.new(0.02, 0)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(TabList:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(20,20,25); v.TextColor3 = Color3.new(1,1,1) end end
        p.Visible = true; b.BackgroundColor3 = Color3.fromRGB(0, 255, 255); b.TextColor3 = Color3.new(0,0,0)
    end)
    return p
end

local PageHome = CreateTab("🏠 HOME", true)
local PageMovement = CreateTab("🏃 MOVEMENT", false)
local PagePlayer = CreateTab("👤 PLAYER", false)
local PageESP = CreateTab("👁 ESP", false)

local function AddToggle(parent, text, defaultState, cb)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.96, 0, 0, 50); btn.Text = text..": "..(defaultState and "ON" or "OFF"); btn.Font = Enum.Font.GothamBold; btn.TextSize = 16; btn.BackgroundColor3 = defaultState and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,40); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..": "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,40)
        cb(state)
    end)
end

-- [ CÀI ĐẶT MENU ]
AddToggle(PageHome, "SÁNG TOÀN BẢN ĐỒ", false, function(v) _G.Fullbright = v end)
AddToggle(PageHome, "CHỐNG AFK (TREO MÁY)", false, function(v) ToggleAFK(v) end) -- Gọi hàm mới
AddToggle(PageMovement, "FLY", false, function(v) _G.Flying = v end)
AddToggle(PageMovement, "NOCLIP", false, function(v) _G.Noclip = v end)
AddToggle(PagePlayer, "CLICK / TAP TO TP", false, function(v) _G.ClickTP = v; if v then GiveClickTPTool() else RemoveClickTPTool() end end)
AddToggle(PageESP, "FULL ESP", false, function(v) _G.FullESP = v end)

-- [ CÁC LUỒNG XỬ LÝ CHÍNH ]
task.spawn(function()
    local bv, bg
    while task.wait() do
        if _G.Flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if not bv then bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e9,1e9,1e9); bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e9,1e9,1e9) end
            bv.Velocity = Camera.CFrame.LookVector * _G.FlySpeed; bg.CFrame = Camera.CFrame
        else if bv then bv:Destroy(); bv = nil; bg:Destroy(); bg = nil end end
    end
end)

RunService.Stepped:Connect(function() if _G.Noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
RunService.RenderStepped:Connect(function() if _G.Fullbright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) end end)

-- Nút đóng mở
local Toggle = Instance.new("TextButton", ScreenGui); Toggle.Size = UDim2.new(0, 75, 0, 75); Toggle.Position = UDim2.new(0.02, 0, 0.42, 0); Toggle.Text = "WL"; Toggle.Font = Enum.Font.GothamBold; Toggle.TextSize = 22; Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Toggle.TextColor3 = Color3.fromRGB(0, 255, 255); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0); MakeDraggable(Toggle)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
