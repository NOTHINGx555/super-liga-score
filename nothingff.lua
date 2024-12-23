

--gui
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
Fluent:Notify({
    Title = "nothing",
    Content = "start load",
    Duration = 3
})
-- Create window
local Window = Fluent:CreateWindow({
    Title = "nothing",
    SubTitle = "Super League Soccer!",
    TabWidth = 150,
    Size = UDim2.fromOffset(550, 450),
    Acrylic = false,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Add tabs
local Tabs = {
    tab2 = Window:AddTab({ Title = "Custom Hitbox", Icon = "play" }),
    Main = Window:AddTab({ Title = "Football Controls", Icon = "play" }),
  emote = Window:AddTab({ Title = "Emotes", Icon = "play" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

}



-- Default hitbox settings
local defaultSizeX, defaultSizeY, defaultSizeZ = 4.521276473999023, 5.7297587394714355, 2.397878408432007
local defaultTransparency = 1
local defaultColor = Color3.fromRGB(255, 255, 255)


local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Usuwanie ekranu ładowania
local loadingScreen = playerGui:FindFirstChild("LoadingScreen")
if loadingScreen then
    loadingScreen:Destroy()
end

-- Referencje do GameGui
local gameGui = playerGui:FindFirstChild("GameGui")
if not gameGui then
    print("-error-")
    return
end

-- Funkcja do usuwania ekranów
local function deleteScreen(screen)
    if screen then
        screen:Destroy()
    end
end
--rest
local player = game.Players.LocalPlayer
local waitTime = 0.1 -- Define the wait time as a number
-- Function to set health to 0
local function setHealthToZero()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.Health = -999
    end
end

-- Repeat the process multiple times with a wait in between
for i = 1, 5 do
    setHealthToZero()
    wait(waitTime)  -- Wait for the specified time (1 second in this case)
end

-- Usuwanie Transition i KeyHints
deleteScreen(gameGui:FindFirstChild("Transition"))
deleteScreen(gameGui:FindFirstChild("KeyHints"))

-- Referencje do MatchHUD i EnergyBars
local matchHUD = gameGui:FindFirstChild("MatchHUD")
local energyBars = matchHUD and matchHUD:FindFirstChild("EngergyBars")

if not (matchHUD and energyBars) then
    print("-")
    return
end

-- Funkcja do ustawiania gradientu
local function setGradient(frame, startColor, endColor)
    if frame then
        local progressBar = frame:FindFirstChild("ProgressBar")
        if progressBar then
            local existingGradient = progressBar:FindFirstChild("UIGradient")
            if existingGradient then
                existingGradient:Destroy()
            end
            local newGradient = Instance.new("UIGradient")
            newGradient.Color = ColorSequence.new(startColor, endColor)
            newGradient.Rotation = 90
            newGradient.Parent = progressBar
        else
            print("-")
        end
    end
end

-- Ustawienie gradientu dla Power i Stamina
setGradient(energyBars:FindFirstChild("Power"), Color3.new(0, 0, 0), Color3.new(255, 0, 0)) -- Black to Red
setGradient(energyBars:FindFirstChild("Stamina"), Color3.new(0, 0, 0), Color3.new(255, 255, 255)) -- Black to White

-- Usuwanie PartyLeader
local party = gameGui:FindFirstChild("Party")
if party then
    local topbarLayout = party:FindFirstChild("TopbarLayout")
    local partyLayout = topbarLayout and topbarLayout:FindFirstChild("PartyLayout")
    local members = partyLayout and partyLayout:FindFirstChild("Members")

    if members then
        -- Szukamy odpowiedniego CircleButton
        local buttons = members:GetChildren()
        for _, button in ipairs(buttons) do
            if button.Name == "CircleButton" and button:FindFirstChild("Background") then
                local background = button.Background
                local partyLeader = background:FindFirstChild("PartyLeader")
                if partyLeader then
                    partyLeader:Destroy()
                    break -- Usuwamy tylko pierwszego lidera
                end
            end
        end
    else
        print("-")
    end
else
    print("-")
end






-- Boost Speed
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local boostActive = false

-- Function to boost speed
local function boostSpeed(character)
    if not boostActive and character then
        boostActive = true

        -- Add force to push the character forward
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)  -- Max force
            bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 400  -- Boost force
            bodyVelocity.Parent = humanoidRootPart

            -- Remove BodyVelocity after 0.05 seconds
            wait(0.05)
            bodyVelocity:Destroy()
        end

        -- Reset boost availability
        wait(1)
        boostActive = false
    end
end

-- Set up boost for the character
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Listen for the LeftShift key press to activate boost
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
            boostSpeed(character)
        end
    end)
end

-- Trigger setup for new characters
player.CharacterAdded:Connect(setupCharacter)

-- Handle current character setup (if it exists)
if player.Character then
    setupCharacter(player.Character)
end

--gol
local player = game.Players.LocalPlayer
local football = workspace.Junk:FindFirstChild("Football")

-- Pozycje dla drużyn
local homePosition = Vector3.new(-14.130847, 4.00001049, -188.18988)
local awayPosition = Vector3.new(14.0604515, 4.00001144, 187.836166)

-- Funkcja do teleportacji piłki
local function teleportFootball(position)
    if football and football:IsA("BasePart") then
        football.CFrame = CFrame.new(position)
    end
end

-- Sprawdzanie drużyny i teleportacja piłki
local function checkAndTeleportFootball()
    local team = player.Team -- Drużyna gracza

    if team then
        print("--->", team.Name)
        if team.Name == "Home" then
            teleportFootball(homePosition)
        elseif team.Name == "Away" then
            teleportFootball(awayPosition)
        end
    else
        print("--->Lobby")
    end
end

-- Obsługa klawisza G
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        checkAndTeleportFootball()
    end
end)

-- Restartowanie po zmianie futbolówki
local function updateFootballReference()
    football = workspace.Junk:FindFirstChild("Football")
    if football and football:IsA("BasePart") then
        football:GetPropertyChangedSignal("Parent"):Connect(updateFootballReference)
    end
end

-- Nasłuchiwanie na dodanie piłki do workspace
workspace.Junk.ChildAdded:Connect(function(child)
    if child.Name == "Football" and child:IsA("BasePart") then
        football = child
        football:GetPropertyChangedSignal("Parent"):Connect(updateFootballReference)
    end
end)

-- Początkowa konfiguracja piłki
if football and football:IsA("BasePart") then
    football:GetPropertyChangedSignal("Parent"):Connect(updateFootballReference)
end

-- Trigger dla nowych postaci
player.CharacterAdded:Connect(function()
    updateFootballReference()
end)







-- tp ball 
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Function to move parts to player's position
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")
    if not junkFolder or not junkFolder:IsA("Folder") then
        warn("Junk folder not found in Workspace")
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        warn("Player's HumanoidRootPart not found")
        return
    end

    local playerPosition = rootPart.Position
    for _, obj in ipairs(junkFolder:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
            pcall(function()
                obj.Position = playerPosition
            end)
        end
    end
end

-- Input handling for moving parts to the player
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.LeftControl then
        movePartsToPlayer()
    end
end)








---one good farming xp 2 players use same x
local clickInterval = 0.1 -- Time interval between clicks (in seconds)
local toggleKey = Enum.KeyCode.Two -- Key to toggle auto-clicker
local teleportKey = Enum.KeyCode.Two -- Key to toggle teleporting

local autoClicking = false -- State of the auto-clicker
local teleporting = false -- State of teleporting

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Debounce to prevent key spamming
local debounce = false

-- Function to simulate a mouse click
local function autoClick()
    local VirtualInputManager = game:GetService("VirtualInputManager")

    while autoClicking do
        if game.Players.LocalPlayer then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(clickInterval)
    end
end

-- Function to teleport objects to the player's position
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")

    if junkFolder and junkFolder:IsA("Folder") then
        local playerChar = Player.Character
        local playerHumanoidRootPart = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
        
        if playerHumanoidRootPart then
            local playerPosition = playerHumanoidRootPart.Position

            for _, obj in ipairs(junkFolder:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
                    obj.CFrame = CFrame.new(playerPosition)
                end
            end
        end
    end
end

-- Function to toggle auto-clicker and teleporting
local function onKeyPress(input, gameProcessedEvent)
    if gameProcessedEvent or debounce then return end

    debounce = true
    task.delay(0.2, function() debounce = false end) -- Debounce delay

    if input.KeyCode == toggleKey then
        autoClicking = not autoClicking
        if autoClicking then
            spawn(autoClick)
        end
    elseif input.KeyCode == teleportKey then
        teleporting = not teleporting
    end
end

-- Continuous teleporting when enabled
RunService.RenderStepped:Connect(function()
    if teleporting then
        movePartsToPlayer()
    end
end)

-- Connect the key press event to toggle functions
UserInputService.InputBegan:Connect(onKeyPress)




-- Auto Clicker
local clickInterval = 0 -- Interval between clicks (in seconds)
local toggleKey = Enum.KeyCode.V -- Key to toggle auto-clicker

local autoClicking = false -- Auto-clicker state

-- Function to simulate mouse click
local function autoClick()
    local VirtualInputManager = game:GetService("VirtualInputManager")

    while autoClicking do
        wait(clickInterval)
        
        -- Check if the player is present
        if game.Players.LocalPlayer then
            -- Simulate mouse click
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Left click down
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Left click up
        end
    end
end

-- Key press function to start/stop auto-clicking
local function onKeyPress(input, gameProcessedEvent)
    if input.KeyCode == toggleKey and not gameProcessedEvent then
        autoClicking = not autoClicking
        if autoClicking then
            spawn(autoClick) -- Run auto-clicker in a new thread
        end
    end
end

-- Connect key press event to toggle auto-clicker
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)





-- Ball Hitbox Size Check
local function checkAndSetTackleHitboxSize(hitbox)
    -- Check if the hitbox size is not (100, 100, 100)
    if hitbox.Size ~= Vector3.new(100, 100, 100) then
        -- If the size is different, set it to (100, 100, 100)
        hitbox.Size = Vector3.new(100, 100, 100)
    end
end

-- Function to handle player character
local function onCharacterAdded(character)
    -- Wait for the TackleHitbox in the player's character
    local hitbox = character:WaitForChild("TackleHitbox", 5)  -- Timeout 5 seconds for safety
    
    if hitbox then
        -- Set correct hitbox size
        checkAndSetTackleHitboxSize(hitbox)
        
        -- Watch for changes in size and fix it if needed
        hitbox:GetPropertyChangedSignal("Size"):Connect(function()
            checkAndSetTackleHitboxSize(hitbox)
        end)
    end
end

-- Connect to CharacterAdded event for the LocalPlayer
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(onCharacterAdded)

-- Handle current character if it exists
if player.Character then
    onCharacterAdded(player.Character)
end


-- Current hitbox settings (active)
local hitboxSizeX, hitboxSizeY, hitboxSizeZ = defaultSizeX, defaultSizeY, defaultSizeZ
local hitboxTransparency = defaultTransparency
local hitboxColor = defaultColor
local isHitboxActive = false


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hitbox = character:FindFirstChild("Hitbox") -- Assuming the hitbox is part of the character

-- Store the last position of the hitbox part before respawn
local lastHitboxPosition

-- Function to update the real hitbox part (size, transparency, color)
local function updateRealHitbox()
    if hitbox then
        -- Apply size, transparency, and color changes if toggle is ON
        hitbox.Size = Vector3.new(hitboxSizeX, hitboxSizeY, hitboxSizeZ)
        hitbox.Transparency = hitboxTransparency
        hitbox.Color = hitboxColor
    end
end

-- Function to reset the hitbox to default settings (size, transparency, color)
local function resetHitboxToDefault()
    if hitbox then
        -- Reset to default values when the toggle is OFF
        hitbox.Size = Vector3.new(defaultSizeX, defaultSizeY, defaultSizeZ)
        hitbox.Transparency = defaultTransparency
        hitbox.Color = defaultColor
    end
end

-- Function to move old hitbox to the new hitbox after respawn
local function moveOldHitboxToNewHitbox()
    -- Find the new hitbox part for repositioning
    local newHitboxPart = character:FindFirstChild("Hitbox") -- Adjust this based on your character setup

    if newHitboxPart and hitbox then
        -- Move the existing hitbox to the new part's position
        hitbox.CFrame = newHitboxPart.CFrame

        -- Only update size, transparency, and color if toggle is ON
        if isHitboxActive then
            updateRealHitbox()
        else
            -- Reset hitbox if toggle is OFF
            resetHitboxToDefault()
        end
    else
        warn("Hitbox not found!")
    end
end

-- Function to handle respawn and hitbox reset
player.CharacterAdded:Connect(function(character)
    -- Wait for the hitbox to be created
    hitbox = character:WaitForChild("Hitbox", 10)

end)

-- Add the toggle for custom hitbox to Tab 2
local Toggle = Tabs.tab2:AddToggle("MyToggle", { Title = "Custom Hitbox", Default = false })

Toggle:OnChanged(function()
    isHitboxActive = Toggle.Value

    -- If toggle is ON, update hitbox in loop
    if isHitboxActive then
        while isHitboxActive do
            updateRealHitbox()  -- Continuously update the real hitbox part size
            wait(0.1)  -- Small delay to avoid locking up the game
        end
    else
        resetHitboxToDefault()  -- Reset only once when toggle is OFF
    end
end)

-- Initialize the toggle value to false at start (off state)
Toggle:SetValue(false)

-- Input for size (X, Y, Z) of the hitbox
local InputX = Tabs.tab2:AddInput("InputX", { 
    Title = "Hitbox (X)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeX = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})

local InputY = Tabs.tab2:AddInput("InputY", { 
    Title = "Hitbox (Y)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeY = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})

local InputZ = Tabs.tab2:AddInput("InputZ", { 
    Title = "Hitbox  (Z)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeZ = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})


-- Transparency Slider
local TransparencySlider = Tabs.tab2:AddSlider("TransparencySlider", { 
    Title = "Transparency", 
    Description = "",
    Default = 10,  -- Default slider value is 1, which maps to 0.1
    Min = 1,      -- Minimum value of 1 (which maps to 0.1 transparency)
    Max = 10,     -- Maximum value of 10 (which maps to 1 transparency)
    Rounding = 1, 
    Callback = function(Value)
        -- Scale the value from 1-10 to 0.1-1
        hitboxTransparency = Value * 0.1
        if isHitboxActive then
            updateRealHitbox()  -- Update transparency of the real hitbox part only if toggle is ON
        end
    end
})

TransparencySlider:SetValue(1)  -- Set default transparency value to 1 (which maps to 0.1)

-- Color picker for hitbox color
local Colorpicker = Tabs.tab2:AddColorpicker("Colorpicker", {
    Title = "Hitbox Color",
    Default = Color3.fromRGB(255, 255, 255)
})

Colorpicker:OnChanged(function()
    hitboxColor = Colorpicker.Value
    if isHitboxActive then
        updateRealHitbox()  -- Update color of the real hitbox part only if toggle is ON
    end
end)

-- Initialize variables
local kickSpeed = 80  -- Default value for kick speed
local verticalMoveAmount = 80  -- Default vertical move amount for the football
local controlEnabled = false  -- Default value for control toggle (off)
local player = game.Players.LocalPlayer
local humanoid
local humanoidRootPart
local junkFolder = game.Workspace:WaitForChild("Junk")  -- Folder where all footballs are stored
local UserInputService = game:GetService("UserInputService")  -- Correct service reference

-- Function to set up the humanoid and character variables
local function setupCharacter(character)
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if controlEnabled then
        humanoid.WalkSpeed = 0
    else
        humanoid.WalkSpeed = 16
    end
end

-- Event listener for when the player's character is added (or respawns)
player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)

-- Initialize the character on the first load (in case the player is already loaded in)
if player.Character then
    setupCharacter(player.Character)
end

-- Add a slider to control the kick speed
local Slider = Tabs.Main:AddInput("Slider", {
    Title = "Speed",
    Description = "20-1000",
    Default = 80,
    Min = 30,
    Max = 700,
    Rounding = 1,
    Callback = function(Value)
        kickSpeed = Value  -- Update kickSpeed based on slider value
    end
})

-- Add a slider to control the vertical move amount for the ball
local VerticalSlider = Tabs.Main:AddInput("VerticalSlider", {
    Title = "up|down",
    Description = "20-600",
    Default = 80,  -- Default vertical move amount
    Min = 30,  -- Minimum move amount
    Max = 600,  -- Maximum move amount
    Rounding = 1,
    Callback = function(Value)
        verticalMoveAmount = Value  -- Update verticalMoveAmount based on slider value
    end
})

local function startControlLoop()
    controlCoroutine = coroutine.create(function()
        while controlEnabled do
            if humanoid then
                humanoid.WalkSpeed = 0
            end
            wait(0.01)  -- Short wait to prevent freezing
        end
    end)
    coroutine.resume(controlCoroutine)  -- Start the coroutine
end

-- Function to toggle controls
local function toggleControls()
    controlEnabled = not controlEnabled  -- Toggle controlEnabled state
    
    if controlEnabled then
        -- When controls are ON: Set WalkSpeed to 0 and start the control loop
        if humanoid then
            humanoid.WalkSpeed = 0
        end
        startControlLoop()
    else
        -- When controls are OFF: Restore normal movement by setting WalkSpeed to 16
        if humanoid then
            humanoid.WalkSpeed = 16
        end
        -- Stop the control loop by ending the coroutine
        controlCoroutine = nil
    end
end

-- Function to move the football up or down
local function moveFootballVertical(direction)
    if humanoidRootPart then
        -- Iterate through all "Football" parts in the Junk folder
        for _, football in pairs(junkFolder:GetChildren()) do
            if football.Name == "Football" then
                football.Anchored = false
                local bodyVelocity = Instance.new("BodyVelocity")
                -- Apply vertical movement force based on the slider value
                local moveAmount = direction == "up" and verticalMoveAmount or -verticalMoveAmount
                bodyVelocity.Velocity = Vector3.new(0, moveAmount, 0)  -- Only apply vertical force
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = football
                game.Debris:AddItem(bodyVelocity, 0.1)
            end
        end
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Function to kick the football in a specific direction
local function kickFootballInDirection(direction)
    if humanoidRootPart then
        local lookDirection
        if direction == "forward" then
            lookDirection = humanoidRootPart.CFrame.LookVector
        elseif direction == "backward" then
            lookDirection = -humanoidRootPart.CFrame.LookVector
        elseif direction == "left" then
            lookDirection = -humanoidRootPart.CFrame.RightVector
        elseif direction == "right" then
            lookDirection = humanoidRootPart.CFrame.RightVector
        end
        
        -- Iterate through all "Football" parts in the Junk folder
        for _, football in pairs(junkFolder:GetChildren()) do
            if football.Name == "Football" then
                football.Anchored = false
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = lookDirection * kickSpeed  -- Use kickSpeed from the slider
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = football
                game.Debris:AddItem(bodyVelocity, 0.1)
            end
        end
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Key bindings to kick the football in different directions using W, A, S, D
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if controlEnabled then  -- Only allow kicking if controls are enabled
        if input.KeyCode == Enum.KeyCode.W and not gameProcessed then
            kickFootballInDirection("forward")  -- Kick forward when "W" is pressed
        elseif input.KeyCode == Enum.KeyCode.S and not gameProcessed then
            kickFootballInDirection("backward")  -- Kick backward when "S" is pressed
        elseif input.KeyCode == Enum.KeyCode.A and not gameProcessed then
            kickFootballInDirection("left")  -- Kick left when "A" is pressed
        elseif input.KeyCode == Enum.KeyCode.D and not gameProcessed then
            kickFootballInDirection("right")  -- Kick right when "D" is pressed
        end
        
        -- Move the football up or down with X and Z keys
        if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
            moveFootballVertical("up")  -- Move ball up when "X" is pressed
        elseif input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
            moveFootballVertical("down")  -- Move ball down when "Z" is pressed
        end
    end
    
    -- Toggle controls when the "F" key is pressed
    if input.KeyCode == Enum.KeyCode.Two and not gameProcessed then
        toggleControls()
    end
end)

-- Old Emote IDs
local OldEmoteIds = {
    ["Floss Dance"] = 5917570207,
    ["Frosty Flair"] = 10214406616,
}

-- New Emote IDs
local NewEmoteIds = {
    ["Monkey"] = 3716636630,
    ["Elton John Piano Jump"] = 11453096488,
    ["Cower"] = 4940597758,
    ["Happy"] = 4849499887,
    ["Dizzy"] = 3934986896,
}

-- Combine old and new emote names for dropdown
local EmoteNames = {}
for name, _ in pairs(OldEmoteIds) do
    table.insert(EmoteNames, name)
end
for name, _ in pairs(NewEmoteIds) do
    table.insert(EmoteNames, name)
end

-- Dropdown for selecting emote
local Dropdown = Tabs.emote:AddDropdown("EmoteDropdown", {
    Title = "Select Emote",
    Values = EmoteNames,
    Multi = false,
    Default = 1
})

-- Toggle for enabling the emote loop
local Toggle = Tabs.emote:AddToggle("EmoteLoopToggle", {
    Title = "Enable Emote (Three)",
    Default = false
})

-- Function to play emote based on ID
local function PlayEmote(emoteId)
    local player = game.Players.LocalPlayer
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:PlayEmoteAndGetAnimTrackById(emoteId)
    end
end

-- Dropdown change event
Dropdown:OnChanged(function(Value)
    if Toggle.Value then  -- Only play emote if toggle is on
        local emoteId = OldEmoteIds[Value] or NewEmoteIds[Value]  -- Check both old and new emotes
        if emoteId then
            PlayEmote(emoteId)
        end
    end
end)

-- Toggle change event (for future extension)
Toggle:OnChanged(function(Value)
    -- No print statements, just handle the toggle change here
end)

-- Keybind to play selected emote (e.g., "P" key)
local UserInputService = game:GetService("UserInputService")
local keybind = Enum.KeyCode.Three  -- Change to any key you prefer

-- Function to handle key press
local function onKeyPress(input, gameProcessedEvent)
    if gameProcessedEvent then return end  -- Ignore if game processed the event (e.g., pressing inside a GUI)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keybind then
        local selectedEmote = Dropdown.Value  -- Get selected emote name
        local emoteId = OldEmoteIds[selectedEmote] or NewEmoteIds[selectedEmote]
        if emoteId then
            PlayEmote(emoteId)
        end
    end
end

-- Connect the function to detect key press
UserInputService.InputBegan:Connect(onKeyPress)

Fluent:Notify({
    Title = "nothing",
    Content = "end load",
    Duration = 3
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("nothing")
SaveManager:SetFolder("nothing/super-score-liga")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

wait ("2")
Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})
Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
})Fluent:Notify({
    Title = "nothing",
    Content = "script -> Super League Soccer!",
    Duration = 5
