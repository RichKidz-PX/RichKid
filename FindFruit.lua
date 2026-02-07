if queue_on_teleport then 
	queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/RichKidz-PX/RichKid/main/FindFruit.lua"))()()]])
end
repeat task.wait() until game:IsLoaded()
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local JobId = game.JobId
local PlaceId=game.PlaceId
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
task.spawn(function()
if not Player.LocalPlayer.Team then
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end
end)
local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&t="
local function HopServer()
    local success,result
    repeat
    success,result = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(url))
    end)
    task.wait(1)
    until success and result and result.data
    local Server= result.data
    local MainServer = Player.LocalPlayer.UserId % 100 + 1
    local StartServer = math.max(1 , MainServer - 2)
    local LastServer = math.min(100,MainServer + 2)
    for i = StartServer , LastServer do
        if Server[i].id ~= JobId and Server[i].playing < Server[i].maxPlayers then
            pcall(function()
			TeleportService:TeleportToPlaceInstance(PlaceId , Server[i].id)
			end)
	    task.wait(2)
        end
    end
end
local function FindFruit() 
    local found = false
    local Character = Player.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local RootPart = Character.HumanoidRootPart
    for i,v in ipairs(workspace:GetChildren()) do
        if v and (v:IsA("Tool") or v:IsA("Model")) and v.Name:find("Fruit") then
            if #v:GetChildren() > 0 then 
            found = true
            local Handle = v:FindFirstChild("Handle")
            RootPart.CFrame = Handle.CFrame
            end
        end
    end
    if not found then
        task.wait(3)
        HopServer()
    end
end
task.spawn(function()
    while true do
        FindFruit()
        task.wait(0.5)
    end
end)
