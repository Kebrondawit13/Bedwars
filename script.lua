--!nocheck
local cloneref = cloneref or function(ref) return ref end
local players = cloneref(game:GetService("Players"))
local inputService = cloneref(game:GetService("UserInputService"))
local replicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local lplr = players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================================================
-- 1. ADVANCED DEEPLINK KNIT FRAMEWORK INTERCEPTOR (Borrowed from CatV6 Core)
-- ============================================================================
local BedwarsRemotes = {}
local success, err = pcall(function()
    -- Hook into Bedwars' active client-side script framework controllers
    local Knit = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 9)
    if Knit then
        BedwarsRemotes.SprintController = Knit.Controllers.SprintController
    end
    -- Extract underlying global remote client wrapper bypassing standard game pathing
    BedwarsRemotes.Client = require(replicatedStorage.TS.remotes).default.Client
end)

-- ============================================================================
-- 2. MODERN INTERACTIVE USER INTERFACE WITH NOTCH ALIGNMENT
-- ============================================================================
local sgui = Instance.new("ScreenGui")
sgui.Name = "CatV6InjectedIOSMenu"
sgui.Parent = gethui and gethui() or cloneref(game:GetService("CoreGui"))
sgui.ResetOnSpawn = false

-- Status Bar Floating Open/Close Button (Positions next to Top Mobile Clock Bar)
local logoButton = Instance.new("TextButton")
logoButton.Size = UDim2.new(0, 38, 0, 38)
logoButton.Position = UDim2.new(0.38, 0, 0, 8) -- Clears the phone notch area perfectly
logoButton.BackgroundColor3 = Color3.fromRGB(0, 150, 75)
logoButton.Text = "★"
logoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
logoButton.Font = Enum.Font.SourceSansBold
logoButton.TextSize = 20
logoButton.ZIndex = 10
logoButton.Parent = sgui

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logoButton

-- Main Window Premium Theme UI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 250)
mainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = sgui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
title.Text = "   CATV6 INJECTED"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.BorderSizePixel = 0
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Minimize Button (-) placed on the Title Bar Right Margin
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 4)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = mainFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, -45)
buttonContainer.Position = UDim2.new(0, 0, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buttonContainer

-- Menu Intercept Toggles
local isOpen = true
local function toggleMenuState()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
    logoButton.Text = isOpen and "★" or "⚙"
    logoButton.BackgroundColor3 = isOpen and Color3.fromRGB(0, 150, 75) or Color3.fromRGB(35, 35, 35)
end
minimizeBtn.MouseButton1Click:Connect(toggleMenuState)
logoButton.MouseButton1Click:Connect(toggleMenuState)

-- Mobile Drag Mechanics for Delta iOS Touch Engine
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
mainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
inputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function createToggle(name, callback)
    local enabled = false
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 204, 0, 40)
    btnFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btnFrame.BorderSizePixel = 0
    btnFrame.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btnFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = name .. "   [OFF]"
    button.TextColor3 = Color3.fromRGB(150, 150, 150)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = btnFrame
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        btnFrame.BackgroundColor3 = enabled and Color3.fromRGB(0, 130, 65) or Color3.fromRGB(28, 28, 28)
        button.Text = name .. (enabled and "   [ON]" or "   [OFF]")
        button.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        task.spawn(callback, enabled)
    end)
end

-- ============================================================================
-- 3. NATIVE CORE EXECUTIONS (Injected Memory Hook System)
-- ============================================================================

-- Feature 1: Standard Infinite Jump
local jumpConnection
createToggle("Infinite Jump", function(isActive)
    if isActive then
        jumpConnection = inputService.JumpRequest:Connect(function()
            local char = lplr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
    end
end)

-- Feature 2: Silent Packet-Injected KillAura (CatV6 Bypassed Logic)
createToggle("Bypassed KillAura", function(isActive)
    while isActive do
        local myChar = lplr.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local sword = myChar and myChar:FindFirstChildOfClass("Tool")
        
        -- Automatically verifies a network bypass handle exists before transmitting packets
        if myRoot and sword and BedwarsRemotes.Client then
            for _, player in players:GetPlayers() do
                if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyRoot = player.Character.HumanoidRootPart
                    local distance = (myRoot.Position - enemyRoot.Position).Magnitude
                    
                    -- Attacks anyone in 18 studs range smoothly without tracking camera angle
                    if distance <= 18 then
                        pcall(function()
                            -- Direct framework injection structure modeled directly off CatV6 game modules
                            BedwarsRemotes.Client:GetNamespace("Combat"):Get("Attack"):SendToServer({
                                ["chargedAttack"] = {["chargeRatio"] = 0},
                                ["entityInstance"] = player.Character,
                                ["validate"] = {
                                    ["targetPosition"] = {["value"] = enemyRoot.Position},
                                    ["selfPosition"] = {["value"] = myRoot.Position}
                                },
                                ["weapon"] = sword
                            })
                        end)
                    end
                end
            end
        end
        task.wait(0.05) -- Attacks safely and aggressively 20 times per second
    end
end)
