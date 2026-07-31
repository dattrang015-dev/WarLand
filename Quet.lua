-- =====================================================================
-- Roblox Client Script: Giao diện 4 Tab (Home, Script, Server Script, Event)
-- =====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu chạy lại
if PlayerGui:FindFirstChild("FourTabScannerGui") then
    PlayerGui.FourTabScannerGui:Destroy()
end

-- 1. Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FourTabScannerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Khung menu chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Hỗ trợ kéo thả trên mobile
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "⚡ HỆ THỐNG QUÉT THÔNG MINH (4 TABS)"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Nút Đóng GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Text = "X"
closeBtn.Parent = titleLabel

-- 2. Thanh Menu 4 Tab ở phía trên
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 42)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local function createTabButton(name, posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.235, 0, 1, 0)
    btn.Position = UDim2.new(posX, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.Parent = tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local tabHome   = createTabButton("1. Home", 0)
local tabScript = createTabButton("2. Script", 0.25)
local tabServer = createTabButton("3. Server", 0.50)
local tabEvent  = createTabButton("4. Event", 0.75)

-- 3. Các khung nội dung (Pages) tương ứng với 4 Tab
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
local pageEvent  = createContentPage()

-- Trang chủ (Home) hiển thị thông tin tổng quan
local homeText = Instance.new("TextLabel")
homeText.Size = UDim2.new(1, -10, 1, 0)
homeText.Position = UDim2.new(0, 5, 0, 5)
homeText.BackgroundTransparency = 1
homeText.TextColor3 = Color3.fromRGB(255, 255, 255)
homeText.TextSize = 13
homeText.Font = Enum.Font.SourceSans
homeText.TextXAlignment = Enum.TextXAlignment.Left
homeText.TextYAlignment = Enum.TextYAlignment.Top
homeText.TextWrapped = true
homeText.Text = "Nhấn nút 'Quét Ngay' bên dưới để bắt đầu quét toàn bộ hệ thống trò chơi.\n\n- Tab 1: Home (Thông tin)\n- Tab 2: Script\n- Tab 3: Server Script\n- Tab 4: Event"
homeText.Parent = pageHome

-- 4. Nút Quét Ngay ở đáy menu chính
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -20, 0, 32)
scanBtn.Position = UDim2.new(0, 10, 1, -38)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 13
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Text = "QUÉT NGAY"
scanBtn.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

-- 5. Hàm chuyển đổi qua lại giữa các Tab
local function switchTab(selectedPage, selectedBtn)
    pageHome.Visible   = (pageHome == selectedPage)
    pageScript.Visible = (pageScript == selectedPage)
    pageServer.Visible = (pageServer == selectedPage)
    pageEvent.Visible  = (pageEvent == selectedPage)
    
    tabHome.BackgroundColor3   = (tabHome == selectedBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(45, 45, 55)
    tabScript.BackgroundColor3 = (tabScript == selectedBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(45, 45, 55)
    tabServer.BackgroundColor3 = (tabServer == selectedBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(45, 45, 55)
    tabEvent.BackgroundColor3  = (tabEvent == selectedBtn) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(45, 45, 55)
end

tabHome.MouseButton1Click:Connect(function() switchTab(pageHome, tabHome) end)
tabScript.MouseButton1Click:Connect(function() switchTab(pageScript, tabScript) end)
tabServer.MouseButton1Click:Connect(function() switchTab(pageServer, tabServer) end)
tabEvent.MouseButton1Click:Connect(function() switchTab(pageEvent, tabEvent) end)

-- Mặc định mở tab Home
switchTab(pageHome, tabHome)

-- 6. Hàm cập nhật dữ liệu vào các danh sách
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
        empty.Text = "Không tìm thấy dữ liệu."
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
        lbl.Text = " • " .. name
        lbl.Parent = scrollFrame
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 22)
end

-- 7. Logic Quét Dữ Liệu An Toàn
local function runScan()
    local scripts, serverScripts, events = {}, {}, {}
    local targets = {ReplicatedStorage, game:GetService("Players"), workspace}
    
    pcall(function()
        for _, folder in ipairs(targets) do
            for _, descendant in ipairs(folder:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                    table.insert(scripts, descendant.Name)
                elseif descendant:IsA("Script") then
                    table.insert(serverScripts, descendant.Name)
                elseif descendant:IsA("RemoteEvent") or descendant:IsA("BindableEvent") or descendant.Name:lower():find("event") then
                    table.insert(events, descendant.Name)
                end
            end
        end
    end)
    
    populateList(pageScript, scripts)
    populateList(pageServer, serverScripts)
    populateList(pageEvent, events)
    
    homeText.Text = string.format("Trạng thái quét mới nhất:\n- Script: %d\n- Server Script: %d\n- Event: %d", #scripts, #serverScripts, #events)
    print("Đã quét và cập nhật thành công vào 4 tab!")
end

-- Gắn sự kiện nút bấm
scanBtn.MouseButton1Click:Connect(runScan)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tự động chạy quét lần đầu
runScan()
