--// ─────────────────────────────────────────────────────────────────────────────
--// Random Mutation – By ScripterX
--// Visual Mutation Randomizer (Clean)
--// Made By: ScripterX | Version 1.0
--// ─────────────────────────────────────────────────────────────────────────────

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")

-- Mutations
local Mutations = {
    "Shiny","Inverted","Frozen","Windy","Golden",
    "Mega","Tiny","IronSkin","Radiant","Rainbow","Shocked","Ascended"
}

-- Find Mutation Machine
local function findMachine()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("mutation") then
            local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if p then return p end
        end
    end
    return nil
end

-- Distance check
local function nearMachine(machine)
    if not HRP or not machine then return false end
    return (HRP.Position - machine.Position).Magnitude < 15
end

-- Show result on machine
local function showMutationOnMachine(machine, mutation)
    local bb = machine:FindFirstChild("MutationBillboard")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "MutationBillboard"
        bb.Size = UDim2.fromOffset(250, 70)
        bb.AlwaysOnTop = true
        bb.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
        bb.Adornee = machine
        bb.Parent = machine

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.Size = UDim2.fromScale(1,1)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(0,255,0)
        lbl.Parent = bb
    end

    bb.Label.Text = "✨ " .. mutation .. " ✨"
end

-- GUI setup
local CoreGui = game:GetService("CoreGui")
local RootGui = (gethui and gethui()) or CoreGui
local ScreenGui = Instance.new("ScreenGui", RootGui)
ScreenGui.Name = "MutationUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.fromOffset(280, 160)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.Active = true

-- Draggable UI
do
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Random Mutation"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0,255,0)
Title.TextScaled = true

-- Made By
local MadeBy = Instance.new("TextLabel", MainFrame)
MadeBy.Size = UDim2.new(1,0,0,20)
MadeBy.Position = UDim2.new(0,0,0.2,0)
MadeBy.BackgroundTransparency = 1
MadeBy.Text = "Made By: ScripterX"
MadeBy.Font = Enum.Font.Gotham
MadeBy.TextColor3 = Color3.fromRGB(255,255,255)
MadeBy.TextScaled = true

-- Button
local MutateButton = Instance.new("TextButton", MainFrame)
MutateButton.Size = UDim2.new(0.9,0,0,40)
MutateButton.Position = UDim2.new(0.05,0,0.45,0)
MutateButton.BackgroundColor3 = Color3.fromRGB(60,60,120)
MutateButton.Text = "🎲 Random Mutate 🎲"
MutateButton.Font = Enum.Font.GothamBold
MutateButton.TextScaled = true
MutateButton.TextColor3 = Color3.fromRGB(255,255,255)

-- Logic
MutateButton.MouseButton1Click:Connect(function()
    local machine = findMachine()
    if machine and nearMachine(machine) then
        local mutation = Mutations[math.random(1, #Mutations)]
        showMutationOnMachine(machine, mutation)
    else
        warn("You must be near a Mutation Machine!")
    end
end)
