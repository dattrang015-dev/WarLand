--[[ 
    👑 WARLAND VN HUB V2 | DEFINITIVE EDITION (NO LOADSTRING)
    CHỨC NĂNG ĐƯỢC VIẾT TRỰC TIẾP VÀO SCRIPT - KHÔNG LO LỖI LINK
]]

local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TargetParent = (RunService:IsStudio() and player:WaitForChild("PlayerGui") or game:GetService("CoreGui"))

-- [ DỌN DẸP ]
if TargetParent:FindFirstChild("WarLand_Definitive_Full") then TargetParent.WarLand_Definitive_Full:Destroy() end

local ScreenGui = Instance.new("ScreenGui", TargetParent)
ScreenGui.Name = "WarLand_Definitive_Full"
ScreenGui.ResetOnSpawn = false

-- [ BIẾN ĐIỀU KHIỂN ]
_G.AutoFarm = false
_G.FastAttack = false

-- Anti-AFK (Để treo máy đi học)
if _G.AntiAFKSignal then _G.AntiAFKSignal:Disconnect() end
_G.AntiAFKSignal = player.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

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

-- [ KHUNG MENU CHÍNH ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 650, 0, 450); MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Thickness = 3.5; Stroke.Color = Color3.fromRGB(255, 255, 255)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 60); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "WARLAND VN HUB V2 - NO LOADSTRING"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = "GothamBold"; Title.TextSize = 26
MakeDraggable(MainFrame)

-- THANH TAB
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 55); TabBar.Position = UDim2.new(0, 10, 0, 65); TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabBar); TabList.FillDirection = "Horizontal"; TabList.HorizontalAlignment = "Center"; TabList.VerticalAlignment = "Center"; TabList.Padding = UDim.new(0, 4)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -145); Container.Position = UDim2.new(0, 10, 0, 135); Container.BackgroundTransparency = 1
local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.AutomaticCanvasSize = "Y"; Page.ScrollBarThickness = 4
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12)
    Pages[name] = Page
    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(0, 80, 0, 40); TabBtn.Text = name:upper(); TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55); TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.Font = "GothamBold"; TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        for _, b in pairs(TabBar:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end end
        TabBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    end)
    return Page
end

local function AddToggle(parent, name, sub, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -15, 0, 75); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = "  " .. name .. "\n  [ " .. sub .. " ]"; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextXAlignment = "Left"; btn.Font = "GothamBold"; btn.TextSize = 22
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(callback)
end

-- [ KHỞI TẠO TAB ]
local Home = CreatePage("Home")
local Farm = CreatePage("Farm")

-- ⚔️ LOGIC AUTO CLICK (Đã bỏ loadstring)
local function AutoClick()
    task.spawn(function()
        while _G.AutoFarm do
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton1(Vector2.new(851, 158))
            task.wait(0.1)
        end
    end)
end

-- ⚔️ CHỨC NĂNG TAB FARM
AddToggle(Farm, "🔥 BẬT AUTO CLICK", "Tự đấm liên tục", function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then AutoClick() end
end)

AddToggle(Home, "⚡ FIX LAG", "Mượt máy để treo", function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = "SmoothPlastic" end
    end
end)

-- [ 💠 NÚT MỞ W ]
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30)
OpenBtn.Text = "W"; OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = "GothamBold"; OpenBtn.TextSize = 32; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(OpenBtn); Pages["Home"].Visible = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
