-- =====================================================================
-- Roblox Client Script: GUI Tự Điều Chỉnh & Phân Loại Script, Server, Event
-- =====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu chạy lại nhiều lần
if PlayerGui:FindFirstChild("AdvancedScannerGui") then
    PlayerGui.AdvancedScannerGui:Destroy()
end

-- 1. Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedScannerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Khung chính (Main Frame - Tự động điều chỉnh theo kích thước màn hình)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
mainFrame.MinSize = Vector2.new(300, 350)
mainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Cho phép kéo đi quanh màn hình điện thoại
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "🔍 TRÌNH QUÉT HỆ THỐNG (ROBLOX)"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Nút Đóng GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Text = "X"
closeBtn.Parent = titleLabel

-- 2. Thanh Menu Chọn Tab (Script, Server, Event)
local tabLayout = Instance.new("Frame")
tabLayout.Size = UDim2.new(1, -20, 0, 35)
tabLayout.Position = UDim2.new(0, 10, 0, 48)
tabLayout.BackgroundTransparency = 1
tabLayout.Parent = mainFrame

local function createTabButton(name, positionX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.32, 0, 1, 0)
    btn.Position = UDim2.new(positionX, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.Parent = tabLayout
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local btnScript = createTabButton("Scripts", 0)
local btnServer = createTabButton("Servers", 0.34)
local btnEvent  = createTabButton("Events", 0.68)

-- 3. Khung hiển thị danh sách (ScrollingFrame cho từng Tab)
local function createScrollingContainer()
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -135)
    scroll.Position = UDim2.new(0, 10, 0, 90)
    scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = false
    scroll.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = scroll
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = scroll
    
    return scroll
end

local scrollScript = createScrollingContainer()
local scrollServer = createScrollingContainer()
local scrollEvent  = createScrollingContainer()

-- Nút Quét Lại (Scan Button ở đáy)
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 1, -42)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 14
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Text = "QUÉT LẠI DỮ LIỆU"
scanBtn.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

-- 4. Hàm chuyển Tab
local function switchTab(activeScroll, activeBtn)
    scrollScript.Visible = (scrollScript == activeScroll)
    scrollServer.Visible = (scrollServer == activeScroll)
    scrollEvent.Visible  = (scrollEvent == activeScroll)
    
    btnScript.BackgroundColor3 = (btnScript == activeBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(50, 50, 60)
    btnServer.BackgroundColor3 = (btnServer == activeBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(50, 50, 60)
    btnEvent.BackgroundColor3  = (btnEvent == activeBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(50, 50, 60)
end

btnScript.MouseButton1Click:Connect(function() switchTab(scrollScript, btnScript) end)
btnServer.MouseButton1Click:Connect(function() switchTab(scrollServer, btnServer) end)
btnEvent.MouseButton1Click:Connect(function() switchTab(scrollEvent, btnEvent) end)

-- Mặc định mở tab Script đầu tiên
switchTab(scrollScript, btnScript)

-- 5. Hàm điền dữ liệu vào danh sách dạng Text dòng
local function populateList(scrollFrame, items)
    -- Xóa các dòng cũ
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if #items == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.TextSize = 13
        emptyLabel.Font = Enum.Font.SourceSansItalic
        emptyLabel.Text = "Không tìm thấy dữ liệu nào."
        emptyLabel.Parent = scrollFrame
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 30)
        return
    end
    
    for i, name in ipairs(items) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -10, 0, 24)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(0, 255, 128)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = string.format(" [%02d] %s", i, name)
        lbl.Parent = scrollFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 26)
end

-- 6. Logic Quét Dữ Liệu An Toàn
local function runScan()
    local scripts, servers, events = {}, {}, {}
    local targets = {ReplicatedStorage, game:GetService("Players"), workspace}
    
    pcall(function()
        for _, folder in ipairs(targets) do
            for _, descendant in ipairs(folder:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                    table.insert(scripts, descendant:GetFullName())
                elseif descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                    table.insert(servers, "[" .. descendant.ClassName .. "] " .. descendant:GetFullName())
                elseif descendant.Name:lower():find("event") then
                    table.insert(events, descendant:GetFullName())
                end
            end
        end
    end)
    
    populateList(scrollScript, scripts)
    populateList(scrollServer, servers)
    populateList(scrollEvent, events)
    print("Quét hoàn tất phân chia giao diện thành công!")
end

-- Gắn sự kiện nút bấm
scanBtn.MouseButton1Click:Connect(runScan)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tự động quét lần đầu khi mở GUI
runScan()
