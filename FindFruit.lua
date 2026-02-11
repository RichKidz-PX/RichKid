local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players")
local Filename = "SaveSetting_" .. Player.LocalPlayer.UserId .. ".json"
local function SaveSetting(value)
    local data = { Disable = value }
    pcall(function()
    writefile(Filename, HttpService:JSONEncode(data))
    end)
end
local function LoadSetting()
    local firsttime = true
    if isfile(Filename) then
    local success,result = pcall(function()
        return HttpService:JSONDecode(readfile(Filename))
    end)
        if success and result and result.Disable ~= nil then
            return result.Disable
        end
end
return firsttime
end
local Disable = LoadSetting()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 43)
Frame.Position = UDim2.new(0.03, 0, 0.245, 0) 
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(45, 45, 45)
UIStroke.Parent = Frame
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 140, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "Stop If Get Item"
Title.TextColor3 = Color3.fromRGB(230, 230, 230)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold 
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Frame
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 42, 0, 20)
TextButton.Position = UDim2.new(1, -52, 0.5, -10)
TextButton.BackgroundColor3 = Disable and Color3.fromRGB(60, 60, 65) or Color3.fromRGB(80, 200, 120)
TextButton.Text = ""
TextButton.AutoButtonColor = false
TextButton.Parent = Frame
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = TextButton
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 16, 0, 16)
Dot.Position = Disable and UDim2.new(0, 3, 0.5, -8) or UDim2.new(1, -19, 0.5, -8) 
Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Dot.BorderSizePixel = 0
Dot.Parent = TextButton
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(1, 0)
UICorner3.Parent = Dot
TextButton.MouseButton1Click:Connect(function()
    Disable = not Disable
    SaveSetting(Disable)
    local DotPos = Disable and UDim2.new(0, 3, 0.5, -8) or UDim2.new(1, -19, 0.5, -8)
    local Button = Disable and Color3.fromRGB(60, 60, 65) or Color3.fromRGB(80, 200, 120)
    local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Dot, TweenInfo, {Position = DotPos}):Play()
    TweenService:Create(TextButton, TweenInfo, {BackgroundColor3 = Button}):Play()
end)
