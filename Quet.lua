-- =====================================================================
-- Roblox Client Script (Tối ưu cho Mobile - Quét 1 lần)
-- =====================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function printCategory(title, list)
    print("==================================================")
    print("📂 " .. title .. " (Tổng: " .. #list .. ")")
    print("==================================================")
    for i, name in ipairs(list) do
        print(string.format("  [%02d] -> %s", i, tostring(name)))
    end
    print("==================================================")
end

-- Hàm quét an toàn tránh quá tải
local function runSafeScan()
    print("\n>>> BẮT ĐẦU QUÉT AN TOÀN...")
    
    local scripts, servers, events = {}, {}, {}

    -- Chỉ quét trong các dịch vụ cơ bản để không bị crash
    local targets = {ReplicatedStorage, game:GetService("Players"), workspace}
    
    for _, folder in ipairs(targets) do
        local success, err = pcall(function()
            for _, descendant in ipairs(folder:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                    table.insert(scripts, descendant:GetFullName())
                elseif descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                    table.insert(servers, string.format("[%s] %s", descendant.ClassName, descendant:GetFullName()))
                elseif descendant.Name:lower():find("event") then
                    table.insert(events, descendant:GetFullName())
                end
            end
        end)
    end

    printCategory("SCRIPT", scripts)
    printCategory("SERVER (REMOTE)", servers)
    printCategory("EVENT", events)
end

-- Chạy trực tiếp 1 lần
runSafeScan()
