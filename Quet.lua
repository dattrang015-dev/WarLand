-- =====================================================================
-- Roblox Client Script: Quét và In toàn bộ tên Script, Server, Event
-- =====================================================================

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local CONFIG = {
    currentScriptVersion = "1.0.5",
    scanInterval = 10,
}

-- Hàm hỗ trợ in danh sách tên rõ ràng, đẹp mắt
local function printCategory(title, list)
    print("==================================================")
    print("📂 " .. title .. " (Tổng: " .. #list .. ")")
    print("==================================================")
    if #list == 0 then
        print("  -> Trống / Không tìm thấy.")
    else
        for i, name in ipairs(list) do
            print(string.format("  [%02d] -> %s", i, tostring(name)))
        end
    end
    print("==================================================")
end

-- 1. Quét Script (Tìm tất cả LocalScript, ModuleScript, Script trong game)
local function scanAllScripts()
    local scriptNames = {}
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") or descendant:IsA("Script") then
            table.insert(scriptNames, descendant:GetFullName())
        end
    end
    printCategory("DANH SÁCH SCRIPT TRONG GAME", scriptNames)
    return scriptNames
end

-- 2. Quét Server (Tìm các RemoteEvent, RemoteFunction, BindableEvent hoặc cấu trúc Server)
local function scanServerObjects()
    local serverObjects = {}
    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") or descendant:IsA("BindableEvent") or descendant:IsA("BindableFunction") then
            table.insert(serverObjects, string.format("[%s] %s", descendant.ClassName, descendant:GetFullName()))
        end
    end
    printCategory("DANH SÁCH SERVER (REMOTE/COMMUNICATION)", serverObjects)
    return serverObjects
end

-- 3. Quét Event (Lọc và in tên các event đang hoạt động hoặc các kết nối sự kiện)
local function scanEvents()
    local eventNames = {}
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if descendant.Name:lower():find("event") or descendant.Name:lower():find("signal") then
            table.insert(eventNames, descendant:GetFullName())
        end
    end
    printCategory("DANH SÁCH EVENT", eventNames)
    return eventNames
end

-- --- HÀM THỰC THI CHÍNH ---
local function runScanner()
    print("\n>>> BẮT ĐẦU QUÉT HỆ THỐNG (ROBLOX)...")
    
    scanAllScripts()
    scanServerObjects()
    scanEvents()
end

-- Chạy định kỳ lặp lại theo chu kỳ quét (ví dụ mỗi 10 giây)
task.spawn(function()
    while true do
        runScanner()
        task.wait(CONFIG.scanInterval)
    end
end)
            table.insert(scriptNames, descendant:GetFullName())
        end
    end
    printCategory("DANH SÁCH SCRIPT TRONG GAME", scriptNames)
    return scriptNames
end

-- 2. Quét Server (Tìm các RemoteEvent, RemoteFunction, BindableEvent hoặc cấu trúc Server)
local function scanServerObjects()
    local serverObjects = {}
    for _, descendant in ipairs(game:GetDescendants()) do
        -- Lọc các thành phần giao tiếp mạng (Server/Client communication)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") or descendant:IsA("BindableEvent") or descendant:IsA("BindableFunction") then
            table.insert(serverObjects, string.format("[%s] %s", descendant.ClassName, descendant:GetFullName()))
        end
    end
    printCategory("DANH SÁCH SERVER (REMOTE/COMMUNICATION)", serverObjects)
    return serverObjects
end

-- 3. Quét Event (Lọc và in tên các event đang hoạt động hoặc các kết nối sự kiện)
local function scanEvents()
    local eventNames = {}
    
    -- Ví dụ quét các sự kiện nằm trong ReplicatedStorage hoặc các thư mục Event tùy chỉnh
    for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
        if descendant.Name:lower():find("event") or descendant.Name:lower():find("signal") then
            table.insert(eventNames, descendant:GetFullName())
        end
    end
    
    printCategory("DANH SÁCH EVENT", eventNames)
    return eventNames
end

-- 4. Gửi dữ liệu đã quét lên Server và kiểm tra bản vá (Patch)
local function sendDataToServerAndCheckPatch(scripts, servers, events)
    local payload = HttpService:JSONEncode({
        version = CONFIG.currentScriptVersion,
        scannedScripts = scripts,
        scannedServers = servers,
        scannedEvents = events,
        timestamp = os.time()
    })

    local success, response = pcall(function()
        -- Dùng syn.request hoặc http_request (hoặc request tùy executor)
        local httpRequest = (syn and syn.request) or (http_request) or (request)
        if httpRequest then
            return httpRequest({
                Url = CONFIG.serverUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload
            })
        end
        return nil
    end)

    if success and response and response.StatusCode == 200 then
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if decodeSuccess and data then
            print("[Server Response] Đã gửi dữ liệu quét thành công lên Server.")
            
            -- Kiểm tra nếu server trả về bản vá (patch) mới
            if data.requiresPatch and data.patchUrl then
                print("[Patch Alert] Tìm thấy bản vá mới từ Server! Đang tải...")
                local patchSuccess, patchCode = pcall(function()
                    return game:HttpGet(data.patchUrl)
                end)
                if patchSuccess and patchCode then
                    local runPatch = loadstring(patchCode)
                    if runPatch then
                        pcall(runPatch)
                        print("[Patch Success] Đã chạy bản vá thành công!")
                    end
                end
            end
        end
    else
        warn("[Scanner Warning] Không thể gửi dữ liệu lên server (hoặc lỗi HTTP).")
    end
end

-- --- HÀM THỰC THI CHÍNH ---
local function runScanner()
    print("\n>>> BẮT ĐẦU QUÉT HỆ THỐNG (ROBLOX)...")
    
    local scripts = scanAllScripts()
    local servers = scanServerObjects()
    local events = scanEvents()

    -- Gửi thông tin về server và kiểm tra patch
    sendDataToServerAndCheckPatch(scripts, servers, events)
end

-- Chạy định kỳ lặp lại theo chu kỳ quét (ví dụ mỗi 10 giây)
task.spawn(function()
    while true do
        runScanner()
        task.wait(CONFIG.scanInterval)
    end
end)
