-- ====================================================================================
-- ||  🚀 WARLAND VN - V100.0: ULTIMATE SOVEREIGN EXCLUSIVE EDITION                  ||
-- ||  ============================================================================  ||
-- ||  STATUS: [STABLE / SOVEREIGN] | FEATURES: FULL PACK + 100% EXCLUSIVE TECH      ||
-- ====================================================================================

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local TargetParent = (game:GetService("CoreGui") or player:WaitForChild("PlayerGui"))

if TargetParent:FindFirstChild("WarLand_V100_Sovereign") then 
    TargetParent.WarLand_V100_Sovereign:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_V100_Sovereign"

-- [ BIẾN HỆ THỐNG VÀ CẤU HÌNH ĐỘC QUYỀN ]
_G.FlySpeed = 100
_G.Flying = false
_G.Noclip = false
_G.InfJump = false
_G.Fullbright = false
_G.ClickTP = false
_G.FullESP = false 
_G.AntiAFK = false
_G.DashButton = false
_G.TPFlyToPlayer = false
_G.InfZoom = false

-- Tính năng độc quyền trước đó
_G.AntiVoid = false
_G.HitboxExpander = false
_G.HitboxSize = 15
_G.CameraAimbot = false
_G.RainbowUI = false
_G.SavedPosition = nil

-- ✨ TÍNH NĂNG ĐỘC QUYỀN MỚI 100% CHỈ WARLAND MỚI CÓ
_G.WarLandEMP = false
_G.GhostCloak = false

local SelectedPlayer = nil
local AFKConnection = nil
local DashBtnInstance = nil
local RainbowConnection = nil

-- [ HÀM XỬ LÝ ANTI-AFK ]
local function ToggleAFK(state)
    _G.AntiAFK = state
    if state then
        local vu = game:GetService("VirtualUser")
        AFKConnection = player.Idled:Connect(function()
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new(0, 0))
            end)
        end)
    else
        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end

-- [ TÍNH NĂNG ĐỘC QUYỀN: ANTI-VOID (CHỐNG RƠI VỰC) ]
local function ToggleAntiVoid(state)
    _G.AntiVoid = state
    task.spawn(function()
        while _G.AntiVoid do
            task.wait(0.5)
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                if hrp.Position.Y < -50 then
                    if _G.SavedPosition then
                        hrp.CFrame = _G.SavedPosition
                    else
                        hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                    end
                elseif hrp.Position.Y > -10 and hrp.Position.Y < 500 then
                    _G.SavedPosition = hrp.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end)
end

-- [ TÍNH NĂNG ĐỘC QUYỀN CHỈ WARLAND CÓ: EMP SHOCKWAVE PULSE ]
local function RunWarLandEMPModule()
    task.spawn(function()
        while task.wait(0.3) do
            if _G.WarLandEMP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = player.Character.HumanoidRootPart
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local enemyHRP = p.Character.HumanoidRootPart
                        local dist = (myHRP.Position - enemyHRP.Position).Magnitude
                        if dist < 18 then
                            -- Hất văng kẻ địch ra xa ngay lập tức bằng lực vector hướng ra ngoài
                            local pushDirection = (enemyHRP.Position - myHRP.Position).Unit
                            enemyHRP.Velocity = pushDirection * 120 + Vector3.new(0, 50, 0)
                        end
                    end
                end
            end
        end
    end)
end
RunWarLandEMPModule()

-- [ TÍNH NĂNG ĐỘC QUYỀN CHỈ WARLAND CÓ: GHOST STEALTH CLOAK ]
local function ToggleGhostCloak(state)
    _G.GhostCloak = state
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                if state then
                    part.Transparency = 0.75
                else
                    part.Transparency = (part.Name == "HumanoidRootPart" and 1 or 0)
                end
            end
        end
    end
end

-- [ TÍNH NĂNG ĐỘC QUYỀN: CAMERA LOCK-ON (AIMBOT NHẸ) ]
local function RunCameraAimbot()
    RunService.RenderStepped:Connect(function()
        if _G.CameraAimbot and SelectedPlayer and SelectedPlayer.Character then
            local targetHead = SelectedPlayer.Character:FindFirstChild("Head")
            if targetHead then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            end
        end
    end)
end
RunCameraAimbot()

-- [ TÍNH NĂNG ĐỘC QUYỀN: HITBOX EXPANDER ]
local function RunHitboxModule()
    RunService.RenderStepped:Connect(function()
        if _G.HitboxExpander then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.CanCollide = false
                end
            end
        end
    end)
end
RunHitboxModule()

-- [ HÀM XỬ LÝ NÚT LƯỚT MƯỢT (SMOOTH DASH) ]
local function ToggleDashButton(state)
    _G.DashButton = state
    if state then
        if not DashBtnInstance then
            DashBtnInstance = Instance.new("TextButton", ScreenGui)
            DashBtnInstance.Size = UDim2.new(0, 70, 0, 70)
            DashBtnInstance.Position = UDim2.new(0.85, 0, 0.55, 0)
            DashBtnInstance.Text = "DASH"
            DashBtnInstance.Font = Enum.Font.GothamBold
            DashBtnInstance.TextSize = 16
            DashBtnInstance.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            DashBtnInstance.TextColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", DashBtnInstance).CornerRadius = UDim.new(1, 0)
            
            local dragging, dragInput, dragStart, startPos
            DashBtnInstance.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; dragStart = input.Position; startPos = DashBtnInstance.Position
                end
            end)
            DashBtnInstance.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    DashBtnInstance.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)

            local isDashing = false
            DashBtnInstance.MouseButton1Click:Connect(function()
                if isDashing then return end
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    isDashing = true
                    local hrp = player.Character.HumanoidRootPart
                    local startCFrame = hrp.CFrame
                    local targetCFrame = startCFrame + (startCFrame.LookVector * 55)
                    local duration = 0.12
                    local elapsed = 0
                    
                    local dashConn
                    dashConn = RunService.RenderStepped:Connect(function(dt)
                        elapsed = elapsed + dt
                        local alpha = math.clamp(elapsed / duration, 0, 1)
                        hrp.CFrame = startCFrame:Lerp(targetCFrame, alpha)
                        if alpha >= 1 then
                            dashConn:Disconnect()
                            isDashing = false
                        end
                    end)
                end
            end)
        end
    else
        if DashBtnInstance then
            DashBtnInstance:Destroy()
            DashBtnInstance = nil
        end
    end
end

-- [ HÀM XỬ LÝ TOOL CLICK TP ]
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

-- [ GIAO DIỆN UI CHÍNH ]
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

local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0.8, 0, 0.85, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16); Main.Visible = false; Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(0, 255, 255); MainStroke.Thickness = 2
MakeDraggable(Main)

-- Hiệu ứng Rainbow UI độc quyền
local function ToggleRainbowUI(state)
    _G.RainbowUI = state
    if state then
        RainbowConnection = RunService.RenderStepped:Connect(function()
            local hue = tick() % 5 / 5
            local rgbColor = Color3.fromHSV(hue, 1, 1)
            MainStroke.Color = rgbColor
        end)
    else
        if RainbowConnection then
            RainbowConnection:Disconnect()
            RainbowConnection = nil
        end
        MainStroke.Color = Color3.fromRGB(0, 255, 255)
    end
end

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0.28, 0, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UICorner", Sidebar)
local TabList = Instance.new("ScrollingFrame", Sidebar); TabList.Size = UDim2.new(1, 0, 1, 0); TabList.BackgroundTransparency = 1; TabList.ScrollBarThickness = 2
local TabListLayout = Instance.new("UIListLayout", TabList); TabListLayout.Padding = UDim.new(0, 6)
local Pages = Instance.new("Frame", Main); Pages.Position = UDim2.new(0.3, 0, 0.02, 0); Pages.Size = UDim2.new(0.68, 0, 0.96, 0); Pages.BackgroundTransparency = 1

local function CreateTab(name, isFirst)
    local b = Instance.new("TextButton", TabList); b.Size = UDim2.new(1, -4, 0, 48); b.Text = name; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.BackgroundColor3 = isFirst and Color3.fromRGB(0,255,255) or Color3.fromRGB(24,24,30); b.TextColor3 = isFirst and Color3.new(0,0,0) or Color3.new(1,1,1); b.BorderSizePixel = 0; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = isFirst; p.BackgroundTransparency = 1; p.ScrollBarThickness = 6
    local pLayout = Instance.new("UIListLayout", p); pLayout.Padding = UDim.new(0.02, 0)
    pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 20)
    end)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(TabList:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(24,24,30); v.TextColor3 = Color3.new(1,1,1) end end
        p.Visible = true; b.BackgroundColor3 = Color3.fromRGB(0, 255, 255); b.TextColor3 = Color3.new(0,0,0)
    end)
    return p
end

local PageHome = CreateTab("🏠 HOME", true)
local PageMovement = CreateTab("🏃 MOVEMENT", false)
local PageCombat = CreateTab("⚔️ COMBAT", false)
local PagePlayer = CreateTab("👤 PLAYER", false)
local PageESP = CreateTab("👁 ESP", false)
local PageWarLandExclusive = CreateTab("🔥 WARLAND EXCLUSIVE", false) -- TAB ĐỘC QUYỀN MỚI

local function AddToggle(parent, text, defaultState, cb)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.96, 0, 0, 48); btn.Text = text..": "..(defaultState and "ON" or "OFF"); btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.BackgroundColor3 = defaultState and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,42); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..": "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,35,42)
        cb(state)
    end)
end

local function AddSlider(parent, text, min, max, default, cb)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.96, 0, 0, 75); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32); Instance.new("UICorner", frame)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, 0, 0, 30); lbl.Text = text..": "..default; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14; lbl.BackgroundTransparency = 1
    local sBg = Instance.new("Frame", frame); sBg.Size = UDim2.new(0.85, 0, 0, 8); sBg.Position = UDim2.new(0.07,0,0,48); sBg.BackgroundColor3 = Color3.fromRGB(45,45,55); Instance.new("UICorner", sBg)
    local sFill = Instance.new("Frame", sBg); sFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); sFill.BackgroundColor3 = Color3.fromRGB(0,255,255); Instance.new("UICorner", sFill)
    local btn = Instance.new("TextButton", sBg); btn.Size = UDim2.new(0, 24, 0, 24); btn.AnchorPoint = Vector2.new(0.5,0.5); btn.Position = UDim2.new(sFill.Size.X.Scale, 0, 0.5, 0); btn.Text = ""; Instance.new("UICorner", btn)
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

local function Act(p, t, c, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.96, 0, 0, 48); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 14; Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
end

-- [ TAB 1: HOME ]
AddToggle(PageHome, "SÁNG TOÀN BẢN ĐỒ (FULLBRIGHT)", false, function(v) _G.Fullbright = v end)
AddToggle(PageHome, "CHỐNG AFK (TREO MÁY)", false, function(v) ToggleAFK(v) end)
AddToggle(PageHome, "🛡 ANTI-VOID (CHỐNG RƠI VỰC)", false, function(v) ToggleAntiVoid(v) end)
AddToggle(PageHome, "🌈 GIAO DIỆN MÀU RAINBOW RGB", false, function(v) ToggleRainbowUI(v) end)
AddSlider(PageHome, "GÓC NHÌN FOV", 70, 120, 70, function(v) Camera.FieldOfView = v end)
AddToggle(PageHome, "ZOOM VÔ HẠN", false, function(v) _G.InfZoom = v end)

-- [ TAB 2: MOVEMENT ]
AddToggle(PageMovement, "FLY MODE", false, function(v) _G.Flying = v end)
AddSlider(PageMovement, "TỐC ĐỘ BAY", 10, 500, 100, function(v) _G.FlySpeed = v end)
AddToggle(PageMovement, "NOCLIP", false, function(v) _G.Noclip = v end)
AddToggle(PageMovement, "NHẢY VÔ TẬN", false, function(v) _G.InfJump = v end)
AddSlider(PageMovement, "TỐC ĐỘ CHẠY", 16, 350, 16, function(v) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = v end end)
AddSlider(PageMovement, "NHẢY CAO", 50, 500, 50, function(v) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.UseJumpPower = true; player.Character.Humanoid.JumpPower = v end end)
AddToggle(PageMovement, "⚡ NÚT LƯỚT NHANH (SMOOTH DASH)", false, function(v) ToggleDashButton(v) end)

-- [ TAB 3: COMBAT ]
AddToggle(PageCombat, "🎯 CAMERA LOCK-ON AIMBOT", false, function(v) _G.CameraAimbot = v end)
AddToggle(PageCombat, "📦 HITBOX EXPANDER", false, function(v) _G.HitboxExpander = v end)
AddSlider(PageCombat, "KÍCH THƯỚC HITBOX", 5, 50, 15, function(v) _G.HitboxSize = v end)

-- [ TAB 4: PLAYER ]
local DropContainer = Instance.new("Frame", PagePlayer); DropContainer.Size = UDim2.new(0.96, 0, 0, 48); DropContainer.BackgroundColor3 = Color3.fromRGB(30,30,38); Instance.new("UICorner", DropContainer)
local DropBtn = Instance.new("TextButton", DropContainer); DropBtn.Size = UDim2.new(1, 0, 1, 0); DropBtn.Text = "CHỌN PLAYER ▼"; DropBtn.Font = Enum.Font.GothamBold; DropBtn.TextSize = 14; DropBtn.TextColor3 = Color3.new(1,1,1); DropBtn.BackgroundTransparency = 1
local DropListFrame = Instance.new("ScrollingFrame", PagePlayer); DropListFrame.Size = UDim2.new(0.96, 0, 0, 160); DropListFrame.Visible = false; DropListFrame.BackgroundColor3 = Color3.fromRGB(20,20,26); DropListFrame.ScrollBarThickness = 6; DropListFrame.ZIndex = 5
local ListLayout = Instance.new("UIListLayout", DropListFrame)

DropBtn.MouseButton1Click:Connect(function()
    DropListFrame.Visible = not DropListFrame.Visible
    if DropListFrame.Visible then
        for _, v in pairs(DropListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local b = Instance.new("TextButton", DropListFrame); b.Size = UDim2.new(1, -10, 0, 38); b.Text = p.DisplayName; b.Font = Enum.Font.Gotham; b.TextSize = 13; b.BackgroundColor3 = Color3.fromRGB(40,40,48); b.TextColor3 = Color3.new(1,1,1); b.ZIndex = 6; Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(function() SelectedPlayer = p; DropBtn.Text = "ĐÃ CHỌN: " .. p.DisplayName; DropListFrame.Visible = false end)
            end
        end
        DropListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
    end
end)

Act(PagePlayer, "TELE ĐẾN HỌ (SIÊU XA)", Color3.fromRGB(0, 120, 200), function() 
    if not SelectedPlayer then
        DropBtn.Text = "LỖI: CHƯA CHỌN PLAYER!"
        task.wait(1.5); DropBtn.Text = "CHỌN PLAYER ▼"
        return
    end
    if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        local hrp = player.Character.HumanoidRootPart
        pcall(function() player:RequestStreamAroundAsync(SelectedPlayer.Character.HumanoidRootPart.Position) end)
        hrp.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    else
        DropBtn.Text = "LỖI: HỌ ĐANG CHẾT/ĐANG TẢI!"
        task.wait(1.5); DropBtn.Text = "ĐÃ CHỌN: " .. SelectedPlayer.DisplayName
    end
end)

AddToggle(PagePlayer, "TP FLY TỚI PLAYER (AUTO-STOP)", false, function(v)
    if v and not SelectedPlayer then
        DropBtn.Text = "CHƯA CHỌN PLAYER!"
        task.wait(1.5); DropBtn.Text = "CHỌN PLAYER ▼"
        return
    end
    _G.TPFlyToPlayer = v
end)

Act(PagePlayer, "🧲 KÉO PLAYER ĐẾN CHỖ BẠN", Color3.fromRGB(150, 0, 150), function()
    if not SelectedPlayer then
        DropBtn.Text = "LỖI: CHƯA CHỌN PLAYER!"
        task.wait(1.5); DropBtn.Text = "CHỌN PLAYER ▼"
        return
    end
    if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        SelectedPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 3)
    end
end)

AddToggle(PagePlayer, "CLICK / TAP TO TP", false, function(v) 
    _G.ClickTP = v 
    if v then GiveClickTPTool() else RemoveClickTPTool() end
end)

-- [ TAB 5: ESP ]
AddToggle(PageESP, "FULL ESP (HIỂN THỊ KHOẢNG CÁCH)", false, function(v) _G.FullESP = v end)

-- [ TAB 6: 🔥 TÍNH NĂNG ĐỘC QUYỀN CHỈ WARLAND CÓ ]
AddToggle(PageWarLandExclusive, "💥 WARLAND EMP SHOCKWAVE (ĐẨY VĂNG KẺ ĐỊCH)", false, function(v) _G.WarLandEMP = v end)
AddToggle(PageWarLandExclusive, "👻 GHOST STEALTH CLOAK (TÀNG HÌNH BÓNG MA)", false, function(v) ToggleGhostCloak(v) end)

-- [ CÁC LUỒNG XỬ LÝ CHÍNH (LOOPS) ]
task.spawn(function()
    local bv, bg
    while task.wait() do
        if _G.Flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if not bv then bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e9,1e9,1e9); bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e9,1e9,1e9) end
            bv.Velocity = Camera.CFrame.LookVector * _G.FlySpeed; bg.CFrame = Camera.CFrame
        else 
            if bv then bv:Destroy(); bv = nil; bg:Destroy(); bg = nil end 
        end
    end
end)

RunService.Stepped:Connect(function()
    if (_G.Noclip or _G.TPFlyToPlayer) and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end
    end
    
    if _G.TPFlyToPlayer and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local targetPos = SelectedPlayer.Character.HumanoidRootPart.Position
        local dist = (hrp.Position - targetPos).Magnitude
        
        if dist > 6 then
            hrp.CFrame = CFrame.new(hrp.Position, targetPos) * CFrame.new(0, 0, -3.5)
        else
            _G.TPFlyToPlayer = false
        end
    end
end)

UserInputService.JumpRequest:Connect(function() 
    if _G.InfJump and player.Character then 
        local h = player.Character:FindFirstChildOfClass("Humanoid") 
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
    end 
end)

RunService.RenderStepped:Connect(function()
    if _G.Fullbright then 
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) 
    end
    if _G.InfZoom then
        player.CameraMaxZoomDistance = 999999
    else
        player.CameraMaxZoomDistance = 400 
    end
end)

local function ApplyESP(p)
    local hl = Instance.new("Highlight")
    local bill = Instance.new("BillboardGui", ScreenGui); bill.AlwaysOnTop = true; bill.Size = UDim2.new(0, 200, 0, 50); bill.ExtentsOffset = Vector3.new(0, 3, 0)
    local lbl = Instance.new("TextLabel", bill); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 18; lbl.TextStrokeTransparency = 0
    RunService.RenderStepped:Connect(function()
        if _G.FullESP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            hl.Parent = p.Character; bill.Parent = p.Character:FindFirstChild("Head")
            local distance = math.floor((player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
            lbl.Text = p.DisplayName .. "\n[" .. distance .. "m]"
        else 
            hl.Parent = nil; bill.Parent = nil 
        end
    end)
end
for _, p in pairs(game.Players:GetPlayers()) do ApplyESP(p) end
game.Players.PlayerAdded:Connect(ApplyESP)

-- [ NÚT BẬT/TẮT MENU CHÍNH "WL" ]
local Toggle = Instance.new("TextButton", ScreenGui); Toggle.Size = UDim2.new(0, 75, 0, 75); Toggle.Position = UDim2.new(0.02, 0, 0.42, 0); Toggle.Text = "WL"; Toggle.Font = Enum.Font.GothamBold; Toggle.TextSize = 22; Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Toggle.TextColor3 = Color3.fromRGB(0, 255, 255); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0); MakeDraggable(Toggle)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
