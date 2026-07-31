-- =====================================================================
-- Roblox Client Script với GUI (Tối ưu cho Mobile)
-- =====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 1. Tạo Giao Diện (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScannerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Khung chính (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Cho phép kéo thả trên màn hình điện thoại
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "QUÉT SCRIPT, SERVER & EVENT"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Khung hiển thị kết quả (ScrollingFrame)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -120)
scrollFrame.Position = UDim2.new(0, 10, 0, 55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = scrollFrame

local textList = Instance.new("TextLabel")
textList.Size = UDim2.new(1, -10, 1, 0)
textList.Position = UDim2.new(0, 5, 0, 0)
textList.BackgroundTransparency = 1
textList.TextColor3 = Color3.fromRGB(0, 255, 128)
textList.TextSize = 13
textList.Font = Enum.Font.Code
textList.TextXAlignment = Enum.TextXAlignment.Left
textList.TextYAlignment = Enum.TextYAlignment.Top
textList.TextWrapped = true
textList.Text = "Nhấn nút 'Quét Ngay' bên dưới để bắt đầu..."
textList.Parent = scrollFrame

-- Nút Quét Ngay
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.46, 0, 0, 40)
scanBtn.Position = UDim2.new(0.03, 0, 1, -50)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextSize = 14
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Text = "QUÉT NGAY"
scanBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 6)
btnCorner1.Parent = scanBtn

-- Nút Đóng / Ẩn GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.46, 0, 0, 40)
closeBtn.Position = UDim2.new(0.51, 0, 1, -50)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Text = "ĐÓNG"
closeBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = closeBtn

-- 2. Logic Quét và Đẩy dữ liệu lên GUI
local function runSafeScan()
    local outputText = "=== KẾT QUẢ QUÉT HỆ THỐNG ===\n\n"
    local scripts, servers, events = {}, {}, {}

    local targets = {ReplicatedStorage, game:GetService("Players"), workspace}
    
    pcall(function()
        for _, folder in ipairs(targets) do
            for _, descendant in ipairs(folder:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                    table.insert(scripts, descendant:GetFullName())
                elseif descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                    table.insert(servers, "["..descendant.ClassName.."] "..descendant.Name)
                elseif descendant.Name:lower():find("event") then
                    table.insert(events, descendant.Name)
                end
            end
        end
    end)

    outputText = outputText .. "[ SCRIPT: " .. #scripts .. " ]\n"
    for i, name in ipairs(scripts) do
        if i <= 10 then outputText = outputText .. " - " .. name .. "\n" end
    end
    if #scripts > 10 then outputText = outputText .. " ... và " .. (#scripts - 10) .. " script khác.\n" end

    outputText = outputText .. "\n[ SERVER / REMOTE: " .. #servers .. " ]\n"
    for i, name in ipairs(servers) do
        if i <= 10 then outputText = outputText .. " - " .. name .. "\n" end
    end

    outputText = outputText .. "\n[ EVENT: " .. #events .. " ]\n"
    for i, name in ipairs(events) do
        if i <= 10 then outputText = outputText .. " - " .. name .. "\n" end
    end

    textList.Text = outputText
    print("Quét hoàn tất! Đã cập nhật lên GUI.")
end

-- 3. Gắn sự kiện cho các nút bấm
scanBtn.MouseButton1Click:Connect(function()
    textList.Text = "Đang quét dữ liệu..."
    task.spawn(runSafeScan)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
