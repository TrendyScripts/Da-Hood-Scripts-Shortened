local Config = { CamlockSettings = { Smoothness = 1, MaxLockDistance = 600, AutoUnlockOnKill = true, PredictionStrength = 0.045 }, UI = { LockColor = Color3.fromRGB(255, 215, 0), DefaultColor = Color3.fromRGB(40, 40, 40), Size = UDim2.new(0, 90, 0, 90), Position = UDim2.new(0.85, 0, 0.2, 0), }, Display = { Position = UDim2.new(0.1, 0, 0.06, 0), Size = UDim2.new(0, 160, 0, 40), Color = Color3.fromRGB(40, 40, 40), Duration = 2 } }

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Camera = workspace.CurrentCamera local LocalPlayer = Players.LocalPlayer local CamlockEnabled = false local LockTarget = nil

local LockGui = Instance.new("ScreenGui", game.CoreGui) local LockButton = Instance.new("TextButton", LockGui) LockButton.Size = Config.UI.Size LockButton.Position = Config.UI.Position LockButton.BackgroundColor3 = Config.UI.DefaultColor LockButton.Text = "⭐ ZIED'S LOCK ⭐" LockButton.TextColor3 = Color3.fromRGB(255, 255, 255) LockButton.Font = Enum.Font.GothamBold LockButton.TextScaled = true LockButton.AutoButtonColor = false LockButton.Active = true LockButton.Draggable = true LockButton.ZIndex = 10

local Corner = Instance.new("UICorner", LockButton) Corner.CornerRadius = UDim.new(0, 18)

local function GetTargetInSight() local BestTarget = nil local ShortestDistance = math.huge local CameraDirection = Camera.CFrame.LookVector

for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Root = Player.Character.HumanoidRootPart
        local Distance = (Root.Position - Camera.CFrame.Position).Magnitude
        local Direction = (Root.Position - Camera.CFrame.Position).Unit
        local DotProduct = CameraDirection:Dot(Direction)

        if Distance < Config.CamlockSettings.MaxLockDistance and DotProduct > 0.95 and Distance < ShortestDistance then
            BestTarget = Root
            ShortestDistance = Distance
        end
    end
end

return BestTarget

end

local DisplayFrame = Instance.new("Frame", LockGui) DisplayFrame.Size = Config.Display.Size DisplayFrame.Position = Config.Display.Position DisplayFrame.BackgroundColor3 = Config.Display.Color DisplayFrame.Visible = false

local DisplayText = Instance.new("TextLabel", DisplayFrame) DisplayText.Size = UDim2.new(1, 0, 0.6, 0) DisplayText.BackgroundTransparency = 1 DisplayText.TextColor3 = Color3.fromRGB(255, 255, 255) DisplayText.Font = Enum.Font.GothamBold DisplayText.TextScaled = true

local CreatorText = Instance.new("TextLabel", DisplayFrame) CreatorText.Size = UDim2.new(1, 0, 0.4, 0) CreatorText.Position = UDim2.new(0, 0, 0.6, 0) CreatorText.BackgroundTransparency = 1 CreatorText.TextColor3 = Color3.fromRGB(255, 255, 255) CreatorText.Font = Enum.Font.GothamBold CreatorText.TextScaled = true CreatorText.Text = "Made by JustNotZied | Discord"

LockButton.MouseButton1Click:Connect(function() if CamlockEnabled then CamlockEnabled = false LockTarget = nil LockButton.BackgroundColor3 = Config.UI.DefaultColor LockButton.Text = "⭐ ZIED'S LOCK ⭐" DisplayFrame.Visible = false else LockTarget = GetTargetInSight() if LockTarget then CamlockEnabled = true LockButton.BackgroundColor3 = Config.UI.LockColor LockButton.Text = "⭐ LOCKED ⭐"

local TargetPlayer = Players:GetPlayerFromCharacter(LockTarget.Parent)
        if TargetPlayer then
            DisplayText.Text = TargetPlayer.DisplayName
            DisplayFrame.Visible = true
            task.wait(Config.Display.Duration)
            DisplayFrame.Visible = false
        end
    end
end

end)

RunService.RenderStepped:Connect(function() if CamlockEnabled and LockTarget and LockTarget.Parent then local TargetPosition = LockTarget.Position + LockTarget.Velocity * Config.CamlockSettings.PredictionStrength local TargetCFrame = CFrame.lookAt(Camera.CFrame.Position, TargetPosition) Camera.CFrame = TargetCFrame end end)

LocalPlayer.CharacterAdded:Connect(function(Char) local Humanoid = Char:FindFirstChild("Humanoid") if Humanoid then Humanoid.Died:Connect(function() if Config.CamlockSettings.AutoUnlockOnKill then CamlockEnabled = false LockButton.BackgroundColor3 = Config.UI.DefaultColor LockButton.Text = "⭐ ZIED'S LOCK ⭐" LockTarget = nil DisplayFrame.Visible = false end end) end end)
