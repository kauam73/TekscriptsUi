-- LaboryNotification - Sistema modular de notificações
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LaboryNotification = {}
LaboryNotification.__index = LaboryNotification

-- Configurações padrão
LaboryNotification.Config = {
	DefaultTitle = "Notificação",
	DefaultContent = "Conteúdo aqui...",
	DefaultDuration = 4,
	ContainerName = "LaboryNotifyGui"
}

-- Utilitários
local UIUtils = {}

function UIUtils:CreateScreenGui(name)
	local gui = Instance.new("ScreenGui")
	gui.Name = name
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	return gui
end

function UIUtils:GetOrCreateContainer()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local container = playerGui:FindFirstChild(LaboryNotification.Config.ContainerName)

	if not container then
		container = UIUtils:CreateScreenGui(LaboryNotification.Config.ContainerName)
	end

	return container
end

function UIUtils:CreateFrame()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 100)
	frame.Position = UDim2.new(1, -320, 1, -120)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.AnchorPoint = Vector2.new(1, 1)
	return frame
end

function UIUtils:CreateTitleLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 30)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	return label
end

function UIUtils:CreateContentLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, -50)
	label.Position = UDim2.new(0, 10, 0, 40)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextWrapped = true
	return label
end

-- Função pública
function LaboryNotification:Notify(input)
	local title, content, duration

	if typeof(input) == "table" then
		if input.Title then
			title = input.Title
			content = input.Content
			duration = input.Duration
		else
			title = input[1]
			content = input[2]
			duration = input[3]
		end
	elseif typeof(input) == "string" then
		title = input
	end

	title = title or self.Config.DefaultTitle
	content = content or self.Config.DefaultContent
	duration = duration or self.Config.DefaultDuration

	local container = UIUtils:GetOrCreateContainer()
	local frame = UIUtils:CreateFrame()
	frame.Parent = container

	local titleLabel = UIUtils:CreateTitleLabel(title)
	titleLabel.Parent = frame

	local contentLabel = UIUtils:CreateContentLabel(content)
	contentLabel.Parent = frame

	local appearTween = TweenService:Create(frame, TweenInfo.new(0.3), {
		Position = frame.Position - UDim2.new(0, 0, 0, 20)
	})
	appearTween:Play()

	task.delay(duration, function()
		local disappearTween = TweenService:Create(frame, TweenInfo.new(0.3), {
			Position = frame.Position + UDim2.new(0, 0, 0, 20),
			BackgroundTransparency = 1
		})
		disappearTween:Play()
		disappearTween.Completed:Wait()
		frame:Destroy()
	end)
end

return LaboryNotification