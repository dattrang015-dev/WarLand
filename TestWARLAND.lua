-- [[ 🚀 WARLAND VN - V95: FULL OPTIONS (GIAO DIỆN TO TỐI ƯU CHO ĐIỆN THOẠI) ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_V95") then TargetParent.WarLand_V95:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_V95"

-- [ BIẾN HỆ THỐNG ]
_G.FlySpeed = 100
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.Flying = false
_G.Noclip = false
_G.InfJump = false
_G.Fullbright = false
_G.ClickTP = false
_G.FullESP = false 
_G.AntiAFK = false
_G.LowGravity = false
local SelectedPlayer = nil

-- [ HÀM KÉO THẢ MENU ]
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

-- [ KHUNG MENU CHÍNH - LÀM TO HƠN CHO ĐIỆN THOẠI ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0.78, 0, 0.85, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.Visible = false; Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)
MakeDraggable(Main)

-- [ CẤU TRÚC TAB ]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0.28, 0, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", Sidebar)
local TabList = Instance.new("Frame", Sidebar); TabList.Size = UDim2.new(1, 0, 1, 0); TabList.BackgroundTransparency = 1; local TabListLayout = Instance.new("UIListLayout", TabList); TabListLayout.Padding = UDim.new(0.01, 0)
local Pages = Instance.new("Frame", Main); Pages.Position = UDim2.new(0.3, 0, 0.02, 0); Pages.Size = UDim2.new(0.68, 0, 0.96, 0); Pages.BackgroundTransparency = 1

local function CreateTab(name, isFirst)
    local b = Instance.new("TextButton", TabList); b.Size = UDim2.new(1, 0, 0, 55); b.Text = name; b.Font = Enum.Font.GothamBold; b.TextSize = 18; b.BackgroundColor3 = isFirst and Color3.fromRGB(0,255,255) or Color3.fromRGB(20,20,25); b.TextColor3 = isFirst and Color3.new(0,0,0) or Color3.new(1,1,1); b.BorderSizePixel = 0
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = isFirst; p.BackgroundTransparency = 1; p.ScrollBarThickness = 6
    local pLayout = Instance.new("UIListLayout", p); pLayout.Padding = UDim.new(0.02, 0)
    pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 20)
    end)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(TabList:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(20,20,25); v.TextColor3 = Color3.new(1,1,1) end end
        p.Visible = true; b.BackgroundColor3 = Color3.fromRGB(0, 255, 255); b.TextColor3 = Color3.new(0,0,0)
    end)
    return p
end

local PageHome = CreateTab("🏠 HOME", true)
local PagePlayer = CreateTab("👤 PLAYER", false)
local PageESP = CreateTab("👁 ESP", false)

-- [ HÀM THANH KÉO (SLIDER) TO RỘNG ]
local function AddSlider(parent, text, min, max, default, cb)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.96, 0, 0, 80); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", frame)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, 0, 0, 32); lbl.Text = text..": "..default; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 16; lbl.BackgroundTransparency = 1
    local sBg = Instance.new("Frame", frame); sBg.Size = UDim2.new(0.85, 0, 0, 8); sBg.Position = UDim2.new(0.07,0,0,52); sBg.BackgroundColor3 = Color3.fromRGB(45,45,50); Instance.new("UICorner", sBg)
    local sFill = Instance.new("Frame", sBg); sFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); sFill.BackgroundColor3 = Color3.fromRGB(0,255,255); Instance.new("UICorner", sFill)
    local btn = Instance.new("TextButton", sBg); btn.Size = UDim2.new(0, 26, 0, 26); btn.AnchorPoint = Vector2.new(0.5,0.5); btn.Position = UDim2.new(sFill.Size.X.Scale, 0, 0.5, 0); btn.Text = ""; Instance.new("UICorner", btn)
    local dragging = false
    local function upd(input)
        local p = math.clamp((input.Position.X - sBg.AbsolutePosition.X)/sBg.AbsoluteSize.X, 0, 1)
        sFill.Size = UDim2.new(p, 0, 1, 0); btn.Position = UDim2.new(p, 0, 0.5, 0)
        local val = math.floor(min + (max-min)*p); lbl.Text = text..": "..val; cb(val)
    end
    btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then upd(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local function AddToggle(parent, text, defaultState, cb)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.96, 0, 0, 50); btn.Text = text..": "..(defaultState and "ON" or "OFF"); btn.Font = Enum.Font.GothamBold; btn.TextSize = 16; btn.BackgroundColor3 = defaultState and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,40); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..": "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,40)
        cb(state)
    end)
    return btn
end

-- [[ 🏠 TAB HOME ]]
AddToggle(PageHome, "FLY", false, function(v) _G.Flying = v end)
AddSlider(PageHome, "TỐC ĐỘ BAY", 10, 500, 100, function(v) _G.FlySpeed = v end)
AddToggle(PageHome, "NOCLIP (XUYÊN TƯỜNG)", false, function(v) _G.Noclip = v end)
AddToggle(PageHome, "NHẢY VÔ TẬN", false, function(v) _G.InfJump = v end)
AddToggle(PageHome, "SÁNG TOÀN BẢN ĐỒ", false, function(v) _G.Fullbright = v end)
AddSlider(PageHome, "TỐC ĐỘ CHẠY", 16, 350, 16, function(v) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = v end end)
AddSlider(PageHome, "NHẢY CAO", 50, 500, 50, function(v) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.UseJumpPower = true; player.Character.Humanoid.JumpPower = v end end)
AddSlider(PageHome, "GÓC NHÌN (FOV)", 70, 120, 70, function(v) Camera.FieldOfView = v end)
AddToggle(PageHome, "CHỐNG AFK (TREO MÁY)", false, function(v) _G.AntiAFK = v end)

local DashBtn = Instance.new("TextButton", PageHome)
DashBtn.Size = UDim2.new(0.96, 0, 0, 50)
DashBtn.Text = "⚡ LƯỚT NHANH (DASH)"
DashBtn.Font = Enum.Font.GothamBold
DashBtn.TextSize = 16
DashBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
DashBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", DashBtn)
DashBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 15)
    end
end)

AddToggle(PageHome, "TRỌNG LỰC THẤP", false, function(v) _G.LowGravity = v end)


-- [[ 👤 TAB PLAYER ]]
local DropContainer = Instance.new("Frame", PagePlayer); DropContainer.Size = UDim2.new(0.96, 0, 0, 50); DropContainer.BackgroundColor3 = Color3.fromRGB(30,30,35); Instance.new("UICorner", DropContainer)
local DropBtn = Instance.new("TextButton", DropContainer); DropBtn.Size = UDim2.new(1, 0, 1, 0); DropBtn.Text = "CHỌN PLAYER ▼"; DropBtn.Font = Enum.Font.GothamBold; DropBtn.TextSize = 16; DropBtn.TextColor3 = Color3.new(1,1,1); DropBtn.BackgroundTransparency = 1
local DropListFrame = Instance.new("ScrollingFrame", PagePlayer); DropListFrame.Size = UDim2.new(0.96, 0, 0, 160); DropListFrame.Visible = false; DropListFrame.BackgroundColor3 = Color3.fromRGB(20,20,25); DropListFrame.ScrollBarThickness = 6; DropListFrame.ZIndex = 5
local ListLayout = Instance.new("UIListLayout", DropListFrame)

DropBtn.MouseButton1Click:Connect(function()
    DropListFrame.Visible = not DropListFrame.Visible
    if DropListFrame.Visible then
        for _, v in pairs(DropListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local b = Instance.new("TextButton", DropListFrame); b.Size = UDim2.new(1, -10, 0, 40); b.Text = p.DisplayName; b.Font = Enum.Font.Gotham; b.TextSize = 15; b.BackgroundColor3 = Color3.fromRGB(40,40,45); b.TextColor3 = Color3.new(1,1,1); b.ZIndex = 6; Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(function() SelectedPlayer = p; DropBtn.Text = "ĐÃ CHỌN: " .. p.DisplayName; DropListFrame.Visible = false end)
            end
        end
        DropListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
    end
end)

local function Act(p, t, c, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 50); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 16; Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
end

local function SuperTeleport(targetCFrame)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    pcall(function() player:RequestStreamAroundAsync(targetCFrame.Position) end)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.CFrame = targetCFrame + Vector3.new(0, 50, 0)
    task.wait(0.5)
end

Act(PagePlayer, "TELE ĐẾN HỌ (SIÊU XA)", Color3.fromRGB(0, 120, 200), function() 
    if not SelectedPlayer then
        DropBtn.Text = "LỖI: CHƯA CHỌN PLAYER!"
        task.wait(1.5)
        DropBtn.Text = "CHỌN PLAYER ▼"
        return
    end
    if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        SuperTeleport(SelectedPlayer.Character.HumanoidRootPart.CFrame)
    else
        DropBtn.Text = "LỖI: HỌ ĐANG CHẾT/ĐANG TẢI!"
        task.wait(1.5)
        DropBtn.Text = "ĐÃ CHỌN: " .. SelectedPlayer.DisplayName
    end
end)

AddToggle(PagePlayer, "CLICK / TAP TO TP", false, function(v) _G.ClickTP = v end)


-- [[ 👁 TAB ESP ]]
AddToggle(PageESP, "FULL ESP", false, function(v) _G.FullESP = v end)


-- [[ ⚙️ CÁC LUỒNG XỬ LÝ (LOOPS & EVENTS) ]]

-- 1. Fly Logic
task.spawn(function()
    local bv, bg
    while task.wait() do
        if _G.Flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if not bv then 
                bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
            end
            bv.Velocity = Camera.CFrame.LookVector * (player.Character.Humanoid.MoveDirection.Magnitude > 0 and _G.FlySpeed or 0)
            bg.CFrame = Camera.CFrame
        else 
            if bv then bv:Destroy(); bv = nil; bg:Destroy(); bg = nil end 
        end
    end
end)

-- 2. Noclip Logic
RunService.Stepped:Connect(function()
    if _G.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 3. Infinite Jump Logic
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- 4. Fullbright Logic
RunService.RenderStepped:Connect(function()
    if _G.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
end)

-- 5. Anti-AFK Logic
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if _G.AntiAFK then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- 6. Low Gravity Logic
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local char = player.Character
        if _G.LowGravity then
            if not char:FindFirstChild("CustomGravity") then
                local grav = Instance.new("BodyForce", char.HumanoidRootPart)
                grav.Name = "CustomGravity"
                grav.Force = Vector3.new(0, char.HumanoidRootPart:GetMass() * 350, 0)
            end
        else
            if char:FindFirstChild("CustomGravity") then
                char.CustomGravity:Destroy()
            end
        end
    end
end)

-- 7. Click/Tap to TP Logic
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and _G.ClickTP then
        local targetPos = nil
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                local mouse = player:GetMouse()
                if mouse.Target then targetPos = mouse.Hit.Position end
            end
        elseif input.UserInputType == Enum.UserInputType.Touch then
            local unitRay = Camera:ScreenPointToRay(input.Position.X, input.Position.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 10000, raycastParams)
            if raycastResult then targetPos = raycastResult.Position end
        end
        if targetPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        end
    end
end)

-- 8. ESP Logic
local function ApplyESP(p)
    local hl = Instance.new("Highlight")
    local bill = Instance.new("BillboardGui", ScreenGui); bill.AlwaysOnTop = true; bill.Size = UDim2.new(0, 200, 0, 50); bill.ExtentsOffset = Vector3.new(0, 3, 0)
    local lbl = Instance.new("TextLabel", bill); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 20; lbl.TextStrokeTransparency = 0
    RunService.RenderStepped:Connect(function()
        if _G.FullESP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= player then
            hl.Parent = p.Character; bill.Parent = p.Character:FindFirstChild("Head")
            lbl.Text = p.DisplayName .. "\n[" .. math.floor((player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude) .."m]"
        else 
            hl.Parent = nil; bill.Parent = nil 
        end
    end)
end
for _, p in pairs(game.Players:GetPlayers()) do ApplyESP(p) end
game.Players.PlayerAdded:Connect(ApplyESP)

-- [ NÚT MỞ/ĐÓNG MENU (WL) PHÓNG TO CHO ĐT ]
local Toggle = Instance.new("TextButton", ScreenGui); Toggle.Size = UDim2.new(0, 75, 0, 75); Toggle.Position = UDim2.new(0.02, 0, 0.42, 0); Toggle.Text = "WL"; Toggle.Font = Enum.Font.GothamBold; Toggle.TextSize = 22; Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Toggle.TextColor3 = Color3.fromRGB(0, 255, 255); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0); MakeDraggable(Toggle)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
