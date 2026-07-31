-- =====================================================================
-- Roblox Client Script: Ultimate Game Scanner (Fix lỗi tab 4-9 trống dữ liệu)
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

if PlayerGui:FindFirstChild("UltimateScannerGui") then
    PlayerGui.UltimateScannerGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateScannerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 640, 0, 410)
mainFrame.Position = UDim2.new(0.5, -320, 0.5, -205)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 200, 150)
mainStroke.Transparency = 0.5
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 38)
titleLabel.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🚀 ULTIMATE GAME SCANNER (FIXED CLIENT/SERVER)"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleLabel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.Parent = titleLabel

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -16, 0, 34)
tabContainer.Position = UDim2.new(0, 8, 0, 44)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local function createTabButton(name, index)
    local totalTabs = 9
    local widthPercent = 1 / totalTabs
    local posX = (index - 1) * widthPercent
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(widthPercent, -2, 1, 0)
    btn.Position = UDim2.new(posX, 1, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.Parent = tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    return btn
end

local tabHome   = createTabButton("Home", 1)
local tabScript = createTabButton("Script", 2)
local tabServer = createTabButton("S.Script", 3)
local tabSStore = createTabButton("S.Store", 4)
local tabEvent  = createTabButton("Event", 5)
local tabTool   = createTabButton("Tool", 6)
local tabClient = createTabButton("Client", 7)
local tabSound  = createTabButton("Sound", 8)
local tabWksp   = createTabButton("Wksp", 9)

local function createContentPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -16, 1, -135)
    page.Position = UDim2.new(0, 8, 0, 86)
    page.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = page
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
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
local pageWksp   = createContentPage()

local homeText = Instance.new("TextLabel")
homeText.Size = UDim2.new(1, -12, 1, -12)
homeText.Position = UDim2.new(0, 6, 0, 6)
homeText.BackgroundTransparency = 1
homeText.TextColor3 = Color3.fromRGB(240, 240, 240)
homeText.TextSize = 12
homeText.Font = Enum.Font.Gotham
homeText.TextXAlignment = Enum.TextXAlignment.Left
homeText.TextYAlignment = Enum.TextYAlignment.Top
homeText.TextWrapped = true
homeText.Text = "✨ Chào mừng bạn đến với Ultimate Game Scanner!\n\nNhấn nút 'QUÉT TOÀN BỘ GAME NGAY' bên dưới để hệ thống phân tích sâu toàn bộ game."
homeText.Parent = pageHome

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -16, 0, 34)
scanBtn.Position = UDim2.new(0, 8, 1, -40)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 13
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Text = "⚡ QUÉT TOÀN BỘ GAME NGAY"
scanBtn.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 8)
scanCorner.Parent = scanBtn

local function switchTab(selectedPage, selectedBtn)
    local pages = {pageHome, pageScript, pageServer, pageSStore, pageEvent, pageTool, pageClient, pageSound, pageWksp}
    local buttons = {tabHome, tabScript, tabServer, tabSStore, tabEvent, tabTool, tabClient, tabSound, tabWksp}
    
    for _, p in ipairs(pages) do 
        p.Visible = false 
    end
    selectedPage.Visible = true
    
    for _, b in ipairs(buttons) do
        if b == selectedBtn then
            b.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end

tabHome.MouseButton1Click:Connect(function() switchTab(pageHome, tabHome) end)
tabScript.MouseButton1Click:Connect(function() switchTab(pageScript, tabScript) end)
tabServer.MouseButton1Click:Connect(function() switchTab(pageServer, tabServer) end)
tabSStore.MouseButton1Click:Connect(function() switchTab(pageSStore, tabSStore) end)
tabEvent.MouseButton1Click:Connect(function() switchTab(pageEvent, tabEvent) end)
tabTool.MouseButton1Click:Connect(function() switchTab(pageTool, tabTool) end)
tabClient.MouseButton1Click:Connect(function() switchTab(pageClient, tabClient) end)
tabSound.MouseButton1Click:Connect(function() switchTab(pageSound, tabSound) end)
tabWksp.MouseButton1Click:Connect(function() switchTab(pageWksp, tabWksp) end)

switchTab(pageHome, tabHome)

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

local function populateListSafe(scrollFrame, items, note)
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if #items == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 30)
        empty.BackgroundTransparency = 1
        empty.TextColor3 = Color3.fromRGB(130, 130, 140)
        empty.TextSize = 12
        empty.Font = Enum.Font.GothamItalic
        empty.Text = note or " Không tìm thấy dữ liệu trong mục này."
        empty.Parent = scrollFrame
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 30)
        return
    end
    
    for _, name in ipairs(items) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Text = "  • " .. tostring(name)
        lbl.Parent = scrollFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 24)
end

local function runScan()
    local rawScripts, rawServerScripts, rawSStore, rawEvents, rawTools, rawClients, rawSounds, rawWksp = {}, {}, {}, {}, {}, {}, {}, {}
    
    -- Quét toàn diện tất cả các service bao gồm cả ReplicatedStorage, Workspace, Lighting,...
    local targets = {ReplicatedStorage, ReplicatedFirst, Lighting, StarterPlayer, StarterGui, SoundService, Workspace}
    
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
        
        -- Quét ServerStorage và ServerScriptService (Lưu ý: Client chạy qua executor đôi khi bị hạn chế quyền đọc 2 thư mục này)
        pcall(function()
            for _, descendant in ipairs(ServerStorage:GetDescendants()) do
                table.insert(rawSStore, descendant.Name)
            end
        end)
        
        pcall(function()
            for _, descendant in ipairs(ServerScriptService:GetDescendants()) do
                if descendant:IsA("Script") then
                    table.insert(rawServerScripts, descendant.Name)
                end
            end
        end)
        
        for _, descendant in ipairs(Workspace:GetChildren()) do
            if descendant ~= LocalPlayer.Character then
                table.insert(rawWksp, descendant.Name)
            end
        end
    end)
    
    local scripts = getUniqueList(rawScripts)
    local serverScripts = getUniqueList(rawServerScripts)
    local sstoreItems = getUniqueList(rawSStore)
    local events = getUniqueList(rawEvents)
    local tools = getUniqueList(rawTools)
    local clients = getUniqueList(rawClients)
    local sounds = getUniqueList(rawSounds)
    local wkspItems = getUniqueList(rawWksp)
    
    populateListSafe(pageScript, scripts)
    populateListSafe(pageServer, serverScripts)
    populateListSafe(pageSStore, sstoreItems, " ServerStorage bị ẩn hoặc trống đối với Client.")
    populateListSafe(pageEvent, events)
    populateListSafe(pageTool, tools)
    populateListSafe(pageClient, clients)
    populateListSafe(pageSound, sounds)
    populateListSafe(pageWksp, wkspItems)
    
    homeText.Text = string.format("📊 Thống kê kết quả quét mới nhất:\n\n• Script (Client/Module): %d mục\n• Server Script: %d mục\n• ServerStorage: %d mục\n• Event & Function: %d mục\n• Tool (Vật phẩm): %d mục\n• Client (UI/Gui): %d mục\n• Sound (Âm thanh): %d mục\n• Workspace Objects: %d mục", 
        #scripts, #serverScripts, #sstoreItems, #events, #tools, #clients, #sounds, #wkspItems)
end

scanBtn.MouseButton1Click:Connect(runScan)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

runScan()
