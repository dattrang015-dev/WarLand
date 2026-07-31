-- =====================================================================
-- Roblox Client Script: Hệ thống Quét Toàn Diện 9 Tab (Giao diện thiết kế mới)
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

-- Xóa GUI cũ nếu chạy lại
if PlayerGui:FindFirstChild("UltimateScannerGui") then
    PlayerGui.UltimateScannerGui:Destroy()
end

-- 1. Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateScannerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Khung menu chính (Thiết kế rộng rãi, hiện đại hơn)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 400)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
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

-- Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🚀 ULTIMATE GAME SCANNER (9 TABS)"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleLabel

-- Nút Đóng GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.Parent = titleLabel

-- 2. Thanh Menu 9 Tab phía trên
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -20, 0, 36)
tabContainer.Position = UDim2.new(0, 10, 0, 48)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.CanvasSize = UDim2.new(0, 680, 0, 0)
tabContainer.ScrollBarThickness = 0
tabContainer.Parent = mainFrame

local function createTabButton(name, index)
    local btnWidth = 72
    local spacing = 4
    local posX = (index - 1) * (btnWidth + spacing)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnWidth, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.Parent = tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local tabHome   = createTabButton("1. Home", 1)
local tabScript = createTabButton("2. Script", 2)
local tabServer = createTabButton("3. S.Script", 3)
local tabSStore = createTabButton("4. S.Store", 4)
local tabEvent  = createTabButton("5. Event", 5)
local tabTool   = createTabButton("6. Tool", 6)
local tabClient = createTabButton("7. Client", 7)
local tabSound  = createTabButton("8. Sound", 8)
local tabWksp   = createTabButton("9. Wksp", 9)

-- 3. Các khung nội dung (Pages) tương ứng với 9 Tab
local function createContentPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -145)
    page.Position = UDim2.new(0, 10, 0, 92)
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

-- Trang chủ (Home) hiển thị thông tin tổng quan
local homeText = Instance.new("TextLabel")
homeText.Size = UDim2.new(1, -12, 1, -12)
homeText.Position = UDim2.new(0, 6, 0, 6)
homeText.BackgroundTransparency = 1
homeText.TextColor3 = Color3.fromRGB(240, 240, 240)
homeText.TextSize = 13
homeText.Font = Enum.Font.Gotham
homeText.TextXAlignment = Enum.TextXAlignment.Left
homeText.TextYAlignment = Enum.TextYAlignment.Top
homeText.TextWrapped = true
homeText.Text = "✨ Chào mừng bạn đến với Ultimate Game Scanner!\n\nNhấn nút 'QUÉT NGAY' bên dưới để hệ thống phân tích sâu toàn bộ game qua 9 danh mục khác nhau.\n\n- Các tài nguyên được tự động lọc chống trùng lặp giúp hiển thị cực kỳ gọn gàng."
homeText.Parent = pageHome

-- 4. Nút Quét Ngay ở đáy menu chính
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 36)
scanBtn.Position = UDim2.new(0, 10, 1, -44)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 14
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Text = "⚡ QUÉT TOÀN BỘ GAME NGAY"
scanBtn.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 8)
scanCorner.Parent = scanBtn

-- 5. Hàm chuyển đổi qua lại giữa các Tab
local function switchTab(selectedPage, selectedBtn)
    local pages = {pageHome, pageScript, pageServer, pageSStore, pageEvent, pageTool, pageClient, pageSound, pageWksp}
    local buttons = {tabHome, tabScript, tabServer, tabSStore, tabEvent, tabTool, tabClient, tabSound, tabWksp}
    
    for _, p in ipairs(pages) do p.Visible = (p == selectedPage) end
    
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

-- Mặc định mở tab Home
switchTab(pageHome, tabHome)

-- 6. Hàm chống trùng lặp tên
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

-- 7. Hàm cập nhật dữ liệu vào danh sách
local function populateList(scrollFrame, items)
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
        empty.Text = " Không tìm thấy dữ liệu trong mục này."
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
        lbl.Text = "  • " .. name
        lbl.Parent = scrollFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 24)
end

-- 8. Logic Quét Toàn Diện 9 Tab
local function runScan()
    local rawScripts, rawServerScripts, rawSStore, rawEvents, rawTools, rawClients, rawSounds, rawWksp = {}, {}, {}, {}, {}, {}, {}, {}
    
    -- Các service chung
    local targets = {ReplicatedStorage, ReplicatedFirst, ServerScriptService, Lighting, StarterPlayer, StarterGui, SoundService}
    
    pcall(function()
        -- Quét các service chính
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
        
        -- Quét riêng ServerStorage
        for _, descendant in ipairs(ServerStorage:GetDescendants()) do
            table.insert(rawSStore, descendant.Name)
        end
        
        -- Quét riêng Workspace (Mô hình, vật thể trong map)
        for _, descendant in ipairs(Workspace:GetChildren()) do
            if descendant ~= LocalPlayer.Character then
                table.insert(rawWksp, descendant.Name)
            end
        end
    end)
    
    -- Lọc bỏ trùng lặp dữ liệu
    local scripts = getUniqueList(rawScripts)
    local serverScripts = getUniqueList(rawServerScripts)
    local sstoreItems = getUniqueList(rawSStore)
    local events = getUniqueList(rawEvents)
    local tools = getUniqueList(rawTools)
    local clients = getUniqueList(rawClients)
    local sounds = getUniqueList(rawSounds)
    local wkspItems = getUniqueList(rawWksp)
    
    -- Đưa vào danh sách hiển thị
    populateList(pageScript, scripts)
    populateList(pageServer, serverScripts)
    populateList(pageSStore, sstoreItems)
    populateList(pageEvent, events)
    populateList(pageTool, tools)
    populateList(pageClient, clients)
    populateList(pageSound, sounds)
    populateList(pageWksp, wkspItems)
    
    homeText.Text = string.format("📊 Thống kê kết quả quét mới nhất:\n\n• Script (Client/Module): %d mục\n• Server Script: %d mục\n• ServerStorage: %d mục\n• Event & Function: %d mục\n• Tool (Vật phẩm): %d mục\n• Client (UI/Gui): %d mục\n• Sound (Âm thanh): %d mục\n• Workspace Objects: %d mục", 
        #scripts, #serverScripts, #sstoreItems, #events, #tools, #clients, #sounds, #wkspItems)
    
    print("Quét toàn bộ hệ thống 9 Tab thành công!")
end

-- Gắn sự kiện nút bấm
scanBtn.MouseButton1Click:Connect(runScan)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tự động chạy quét lần đầu tiên khi load script
runScan()
