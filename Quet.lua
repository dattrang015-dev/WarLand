-- =====================================================================
-- Roblox Client Script: Giao diá»‡n 8 Tab (TĂ¡ch riĂªng ServerStorage)
-- =====================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- XĂ³a GUI cÅ© náº¿u cháº¡y láº¡i
if PlayerGui:FindFirstChild("EightTabScannerGui") then
    PlayerGui.EightTabScannerGui:Destroy()
end

-- 1. Táº¡o ScreenGui chĂ­nh
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EightTabScannerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Khung menu chĂ­nh
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 360)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- TiĂªu Ä‘á»
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "â¡ Há»† THá»NG QUĂ‰T GAME (8 TABS - TĂCH SERVERSTORAGE)"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- NĂºt ÄĂ³ng GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Text = "X"
closeBtn.Parent = titleLabel

-- 2. Thanh Menu 8 Tab á»Ÿ phĂ­a trĂªn
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 42)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local function createTabButton(name, posX, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(sizeX, 0, 1, 0)
    btn.Position = UDim2.new(posX, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 8
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.Parent = tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    return btn
end

-- Chia Ä‘á»u kĂ­ch thÆ°á»›c cho 8 tab
local tabWidth = 0.121
local tabHome     = createTabButton("1.Home", 0.000, tabWidth)
local tabScript   = createTabButton("2.Script", 0.125, tabWidth)
local tabServer   = createTabButton("3.S.Script", 0.250, tabWidth)
local tabSStore   = createTabButton("4.S.Store", 0.375, tabWidth)
local tabEvent    = createTabButton("5.Event", 0.500, tabWidth)
local tabTool     = createTabButton("6.Tool", 0.625, tabWidth)
local tabClient   = createTabButton("7.Client", 0.750, tabWidth)
local tabSound    = createTabButton("8.Sound", 0.875, tabWidth)

-- 3. CĂ¡c khung ná»™i dung (Pages) tÆ°Æ¡ng á»©ng vá»›i 8 Tab
local function createContentPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -125)
    page.Position = UDim2.new(0, 10, 0, 80)
    page.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = page
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)
    layout.Parent = page
    
    return page
end

local pageHome   = createContentPage()
local pageScript = createContentPage()
local pageServer = createContentPage()
local pageSStore = createContentPage()
local pageEvent  = createContentPage()
local pageTool   = createContentPage()
local pageClient = createContentPage()
local pageSound  = createContentPage()

-- Trang chá»§ (Home) hiá»ƒn thá»‹ thĂ´ng tin tá»•ng quan
local homeText = Instance.new("TextLabel")
homeText.Size = UDim2.new(1, -10, 1, 0)
homeText.Position = UDim2.new(0, 5, 0, 5)
homeText.BackgroundTransparency = 1
homeText.TextColor3 = Color3.fromRGB(255, 255, 255)
homeText.TextSize = 12
homeText.Font = Enum.Font.SourceSans
homeText.TextXAlignment = Enum.TextXAlignment.Left
homeText.TextYAlignment = Enum.TextYAlignment.Top
homeText.TextWrapped = true
homeText.Text = "Nháº¥n 'QUĂ‰T NGAY' Ä‘á»ƒ quĂ©t toĂ n bá»™ game (8 Tabs).\n\n- Tab 1: Home\n- Tab 2: Script\n- Tab 3: ServerScriptService\n- Tab 4: ServerStorage (RiĂªng biá»‡t)\n- Tab 5: Event\n- Tab 6: Tool\n- Tab 7: Client\n- Tab 8: Sound"
homeText.Parent = pageHome

-- 4. NĂºt QuĂ©t Ngay á»Ÿ Ä‘Ă¡y menu chĂ­nh
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 32)
scanBtn.Position = UDim2.new(0, 10, 1, -38)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 13
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Text = "QUĂ‰T NGAY"
scanBtn.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

-- 5. HĂ m chuyá»ƒn Ä‘á»•i qua láº¡i giá»¯a cĂ¡c Tab
local function switchTab(selectedPage, selectedBtn)
    pageHome.Visible   = (pageHome == selectedPage)
    pageScript.Visible = (pageScript == selectedPage)
    pageServer.Visible = (pageServer == selectedPage)
    pageSStore.Visible = (pageSStore == selectedPage)
    pageEvent.Visible  = (pageEvent == selectedPage)
    pageTool.Visible   = (pageTool == selectedPage)
    pageClient.Visible = (pageClient == selectedPage)
    pageSound.Visible  = (pageSound == selectedPage)
    
    local activeColor = Color3.fromRGB(0, 170, 127)
    local normalColor = Color3.fromRGB(45, 45, 55)
    
    tabHome.BackgroundColor3   = (tabHome == selectedBtn) and activeColor or normalColor
    tabScript.BackgroundColor3 = (tabScript == selectedBtn) and activeColor or normalColor
    tabServer.BackgroundColor3 = (tabServer == selectedBtn) and activeColor or normalColor
    tabSStore.BackgroundColor3 = (tabSStore == selectedBtn) and activeColor or normalColor
    tabEvent.BackgroundColor3  = (tabEvent == selectedBtn) and activeColor or normalColor
    tabTool.BackgroundColor3   = (tabTool == selectedBtn) and activeColor or normalColor
    tabClient.BackgroundColor3 = (tabClient == selectedBtn) and activeColor or normalColor
    tabSound.BackgroundColor3  = (tabSound == selectedBtn) and activeColor or normalColor
end

tabHome.MouseButton1Click:Connect(function() switchTab(pageHome, tabHome) end)
tabScript.MouseButton1Click:Connect(function() switchTab(pageScript, tabScript) end)
tabServer.MouseButton1Click:Connect(function() switchTab(pageServer, tabServer) end)
tabSStore.MouseButton1Click:Connect(function() switchTab(pageSStore, tabSStore) end)
tabEvent.MouseButton1Click:Connect(function() switchTab(pageEvent, tabEvent) end)
tabTool.MouseButton1Click:Connect(function() switchTab(pageTool, tabTool) end)
tabClient.MouseButton1Click:Connect(function() switchTab(pageClient, tabClient) end)
tabSound.MouseButton1Click:Connect(function() switchTab(pageSound, tabSound) end)

-- Máº·c Ä‘á»‹nh má»Ÿ tab Home
switchTab(pageHome, tabHome)

-- 6. HĂ m chá»‘ng trĂ¹ng láº·p tĂªn
local function getUniqueList(tbl)
    local uniqueMap = {}
    local uniqueList = {}
    for _, name in ipairs(tbl) do
        if not uniqueMap[name] then
            uniqueMap[name] = true
            table.insert(uniqueList, name)
        end
    end
    return uniqueList
end

-- 7. HĂ m cáº­p nháº­t dá»¯ liá»‡u vĂ o danh sĂ¡ch
local function populateList(scrollFrame, items)
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if #items == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 25)
        empty.BackgroundTransparency = 1
        empty.TextColor3 = Color3.fromRGB(150, 150, 150)
        empty.TextSize = 11
        empty.Font = Enum.Font.SourceSansItalic
        empty.Text = "KhĂ´ng tĂ¬m tháº¥y dá»¯ liá»‡u."
        empty.Parent = scrollFrame
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 25)
        return
    end
    
    for _, name in ipairs(items) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(0, 255, 128)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Text = " â€¢ " .. name
        lbl.Parent = scrollFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 22)
end

-- 8. Logic QuĂ©t TĂ¡ch RiĂªng ServerStorage
local function runScan()
    local rawScripts, rawServerScripts, rawSStore, rawEvents, rawTools, rawClients, rawSounds = {}, {}, {}, {}, {}, {}, {}
    
    -- QuĂ©t chung cĂ¡c service khĂ¡c
    local targets = {ReplicatedStorage, ReplicatedFirst, ServerScriptService, Lighting, Workspace, StarterPlayer, StarterGui, SoundService}
    
    pcall(function()
        for _, folder in ipairs(targets) do
            for _, descendant in ipairs(folder:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                    table.insert(rawScripts, descendant.Name)
                elseif descendant:IsA("Script") then
                    table.insert(rawServerScripts, descendant.Name)
                elseif descendant:IsA("RemoteEvent") or descendant:IsA("BindableEvent") or descendant:IsA("RemoteFunction") or descendant:IsA("BindableFunction") then
                    table.insert(rawEvents, descendant.Name)
                elseif descendant:IsA("Tool") then
                    table.insert(rawTools, descendant.Name)
                elseif descendant:IsA("ScreenGui") or descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") then
                    table.insert(rawClients, descendant.Name)
                elseif descendant:IsA("Sound") then
                    table.insert(rawSounds, descendant.Name)
                end
            end
        end
        
        -- QuĂ©t riĂªng toĂ n bá»™ ná»™i dung bĂªn trong ServerStorage vĂ o tab S.Store
        for _, descendant in ipairs(ServerStorage:GetDescendants()) do
            table.insert(rawSStore, descendant.Name)
        end
    end)
    
    -- Lá»c bá» trĂ¹ng láº·p
    local scripts = getUniqueList(rawScripts)
    local serverScripts = getUniqueList(rawServerScripts)
    local sstoreItems = getUniqueList(rawSStore)
    local events = getUniqueList(rawEvents)
    local tools = getUniqueList(rawTools)
    local clients = getUniqueList(rawClients)
    local sounds = getUniqueList(rawSounds)
    
    populateList(pageScript, scripts)
    populateList(pageServer, serverScripts)
    populateList(pageSStore, sstoreItems)
    populateList(pageEvent, events)
    populateList(pageTool, tools)
    populateList(pageClient, clients)
    populateList(pageSound, sounds)
    
    homeText.Text = string.format("Tráº¡ng thĂ¡i quĂ©t game (8 Tabs):\n- Script: %d\n- Server Script: %d\n- ServerStorage: %d\n- Event: %d\n- Tool: %d\n- Client: %d\n- Sound: %d", #scripts, #serverScripts, #sstoreItems, #events, #tools, #clients, #sounds)
    print("ÄĂ£ quĂ©t thĂ nh cĂ´ng, ServerStorage Ä‘Æ°á»£c tĂ¡ch riĂªng táº¡i tab 4!")
end

-- Gáº¯n sá»± kiá»‡n nĂºt báº¥m
scanBtn.MouseButton1Click:Connect(runScan)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tá»± Ä‘á»™ng cháº¡y quĂ©t láº§n Ä‘áº§u
runScan()
ServerStorage
