if queue_on_teleport then 
	queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/RichKidz-PX/RichKid/main/FindFruit.lua"))()]])
end
repeat task.wait() until game:IsLoaded()

local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Player.LocalPlayer

-- Khai báo thông tin server
local JobId = game.JobId
local PlaceId = game.PlaceId

-- 1. CHỈ CHỌN TEAM KHI CHƯA CÓ TEAM
task.spawn(function()
    if not LocalPlayer.Team then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
        end)
    end
end)

-- 2. HÀM TWEEN DI CHUYỂN MƯỢT MÀ
local function TweenTo(targetCFrame)
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local distance = (RootPart.Position - targetCFrame.Position).Magnitude
    local speed = 350 -- Tốc độ bay (Bạn có thể chỉnh lại tùy ý)
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- 3. HÀM HOP SERVER (Đã sửa lỗi URL và Rate Limit)
local function HopServer()
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&t=" .. tick()
    local success, result
    
    print("🔄 Đang tìm server mới...")
    repeat
        success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        task.wait(5) -- Tăng thời gian đợi để tránh lỗi "Đang HttpGet..." liên tục
    until success and result and result.data
    
    local Server = result.data
    for i = 1, #Server do
        -- Chỉ chọn server còn trống ít nhất 2 chỗ để tránh lỗi "Server is full"
        if Server[i].id ~= JobId and Server[i].playing <= (Server[i].maxPlayers - 2) then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, Server[i].id)
            end)
            task.wait(2)
        end
    end
end

-- 4. HÀM TÌM FRUIT (Sửa lỗi nil và ép tải dữ liệu)
local function FindFruit() 
    local found = false
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    for _, v in ipairs(workspace:GetChildren()) do
        -- Dựa vào cấu trúc FruitAnimator bạn gửi
        if v.Name:find("Fruit") and (v:IsA("Tool") or v:IsA("Model")) then
            -- Kiểm tra xem Model có dữ liệu không
            local Handle = v:FindFirstChild("Handle")
            
            if not Handle then
                -- Nếu không thấy Handle, bay tới Model để ép game tải vùng đó (Streaming)
                TweenTo(v:GetModelCFrame())
                Handle = v:WaitForChild("Handle", 5)
            end

            if Handle then 
                found = true
                print("🍎 Đang bay tới: " .. v.Name)
                local tween = TweenTo(Handle.CFrame)
                if tween then tween.Completed:Wait() end -- Đợi bay tới nơi rồi mới tính tiếp
                task.wait(1)
                break
            end
        end
    end

    if not found then
        print("❌ Không thấy Fruit, chuẩn bị đổi Server...")
        task.wait(3)
        HopServer()
    end
end

-- 5. VÒNG LẶP CHÍNH
task.spawn(function()
    while true do
        pcall(FindFruit)
        task.wait(2) -- Nghỉ 2 giây để tránh treo máy
    end
end)
