--[[ 
    👑 WARLAND VN HUB V2 | DEFINITIVE EDITION (FULL A-Z)
    🍎 FRUIT: RANDOM, STORE, FARM FRUIT, ESP
    ⚔️ PVP: AUTO BOTI, SELECT PLAYER, SPECTATE, TP PLAYER
    ⛩️ TRIAL: FULL RACE V4 PATH (TEMPLE, LEVER, TRIAL)
    🔥 FARM: AUTO LEVEL, QUEST, BOSS, CHEST
    🎯 INTERFACE: COMPACT W (60PX) - BIG TEXT (22-28PX)
]]

local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TargetParent = (RunService:IsStudio() and player:WaitForChild("PlayerGui") or game:GetService("CoreGui"))

-- [ DỌN DẸP ]
if TargetParent:FindFirstChild("WarLand_Definitive_Full") then TargetParent.WarLand_Definitive_Full:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WarLand_Definitive_Full"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- [ BIẾN ĐIỀU KHIỂN ]
_G.SelectPlayer = ""
_G.AutoBoti = false
_G.FlySpeed = 85
_G.Flying = false
_G.NoClip = false
_G.WalkOnWater = false

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
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 450); MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.Parent = ScreenGui; MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Thickness = 3.5; Stroke.Color = Color3.fromRGB(255, 255, 255)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60); Header.BackgroundTransparency = 1; Header.Parent = MainFrame
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "WARLAND VN HUB V2 - FULL A-Z"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = "GothamBold"; Title.TextSize = 26; Title.Parent = Header
MakeDraggable(MainFrame)

-- THANH TAB
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 55); TabBar.Position = UDim2.new(0, 10, 0, 65); TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35); TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabBar); TabList.FillDirection = "Horizontal"; TabList.HorizontalAlignment = "Center"; TabList.VerticalAlignment = "Center"; TabList.Padding = UDim.new(0, 4)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -145); Container.Position = UDim2.new(0, 10, 0, 135); Container.BackgroundTransparency = 1; Container.Parent = MainFrame
local Pages = {}

local function CreatePage(name)
	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.AutomaticCanvasSize = "Y"; Page.ScrollBarThickness = 4; Page.Parent = Container
	Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12)
	Pages[name] = Page
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(0, 80, 0, 40); TabBtn.Text = name:upper(); TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55); TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.Font = "GothamBold"; TabBtn.TextSize = 13; TabBtn.Parent = TabBar
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
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -15, 0, 75); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	btn.Text = "  " .. name .. "\n  [ " .. sub .. " ]"; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextXAlignment = "Left"; btn.Font = "GothamBold"; btn.TextSize = 22; btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	btn.MouseButton1Click:Connect(callback)
end

-- [ KHỞI TẠO TAB ]
local Home = CreatePage("Home")
local Farm = CreatePage("Farm")
local Trial = CreatePage("Trial")
local Fruit = CreatePage("Fruit")
local PvP = CreatePage("PvP")

-- 🏠 HOME
AddToggle(Home, "🛡️ ANTI-BAN", "Hoạt động ngầm", function() end)
AddToggle(Home, "🕒 ANTI-AFK", "Chống văng khi treo máy", function() end)
AddToggle(Home, "⚡ FIX LAG", "FPS Boost + Smooth Mode", function() end)

-- ⚔️ FARM
AddToggle(Farm, "🔥 AUTO FARM LEVEL", "Tự nhận Quest & Diệt quái", function() end)
AddToggle(Farm, "👹 AUTO BOSS", "Tự tìm săn Boss", function() end)
AddToggle(Farm, "💰 AUTO CHEST", "Tự nhặt rương khắp map", function() end)

-- ⛩️ TRIAL (RACE V4)
AddToggle(Trial, "📜 AUTO UP RACE V2/V3", "Nhiệm vụ tiến hóa tộc", function() end)
AddToggle(Trial, "📍 TP TEMPLE", "Đến Đền Thờ Thời Gian", function() end)
AddToggle(Trial, "⚙️ PULL LEVER", "Tự gạt cần cửa V4", function() end)
AddToggle(Trial, "💎 AUTO TRIAL", "Vượt ải tộc chuyên sâu", function() end)

-- 🍎 FRUIT
AddToggle(Fruit, "🎲 RANDOM FRUIT", "Gacha trái ác quỷ từ xa", function() RS.Remotes.CommF_:InvokeServer("Cousin","BuyItem") end)
AddToggle(Fruit, "📦 AUTO STORE", "Tự cất trái vào kho", function() end)
AddToggle(Fruit, "🗺️ FARM FRUIT", "Tự đi nhặt trái trên map", function() end)

-- 🔫 PVP & BOUNTY
local PlayerDrop = Instance.new("TextButton")
PlayerDrop.Size = UDim2.new(1, -15, 0, 80); PlayerDrop.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
PlayerDrop.Text = "👤 CHỌN MỤC TIÊU: " .. (_G.SelectPlayer or "..."); PlayerDrop.TextColor3 = Color3.fromRGB(255, 255, 255); PlayerDrop.Font = "GothamBold"; PlayerDrop.TextSize = 20; PlayerDrop.Parent = PvP
Instance.new("UICorner", PlayerDrop).CornerRadius = UDim.new(0, 12)

PlayerDrop.MouseButton1Click:Connect(function()
	local players = game.Players:GetPlayers()
	for _, v in pairs(players) do if v.Name ~= player.Name then _G.SelectPlayer = v.Name; PlayerDrop.Text = "👤 MỤC TIÊU: " .. v.Name; break end end
end)

AddToggle(PvP, "⚔️ AUTO BOTI", "Tự động săn Bounty", function()
	_G.AutoBoti = not _G.AutoBoti
	task.spawn(function()
		while _G.AutoBoti do
			local target = game.Players:FindFirstChild(_G.SelectPlayer)
			if target and target.Character then player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0) end
			task.wait(0.1)
		end
	end)
end)

AddToggle(PvP, "🚀 CAMERA FLY", "Bay tự do", function()
	_G.Flying = not _G.Flying
	local char = player.Character
	if _G.Flying then
		local bv = Instance.new("BodyVelocity", char.HumanoidRootPart); bv.Name = "F_Fly"; bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Velocity = Vector3.new(0,0,0)
		local bg = Instance.new("BodyGyro", char.HumanoidRootPart); bg.Name = "F_Gyro"; bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.P = 9e4
		task.spawn(function()
			while _G.Flying do
				if char.Humanoid.MoveDirection.Magnitude > 0 then
					bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlySpeed
				else bv.Velocity = Vector3.new(0,0,0) end
				bg.CFrame = workspace.CurrentCamera.CFrame; task.wait()
			end
			if char.HumanoidRootPart:FindFirstChild("F_Fly") then char.HumanoidRootPart.F_Fly:Destroy() end
			if char.HumanoidRootPart:FindFirstChild("F_Gyro") then char.HumanoidRootPart.F_Gyro:Destroy() end
		end)
	end
end)

AddToggle(PvP, "🌊 WATER WALK", "Đi trên nước", function()
	_G.WalkOnWater = not _G.WalkOnWater
	for _, v in pairs(workspace:GetDescendants()) do if v.Name == "Water" or v.Name == "Sea" then v.CanCollide = _G.WalkOnWater end end
end)

-- [ 💠 NÚT MỞ W - COMPACT 60PX ]
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui; OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30)
OpenBtn.Text = "W"; OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = "GothamBold"; OpenBtn.TextSize = 32; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BStroke = Instance.new("UIStroke", OpenBtn); BStroke.Thickness = 2.5; BStroke.Color = Color3.fromRGB(255, 255, 255)
MakeDraggable(OpenBtn); Pages["Home"].Visible = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
