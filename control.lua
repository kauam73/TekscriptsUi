-- LaboryNotification - Sistema modular de notificações
-- Desenvolvido pela equipe TekScripts
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Módulo principal
local LaboryNotification = {}
LaboryNotification.__index = LaboryNotification

-- Configurações padrão
LaboryNotification.Config = {
    DefaultTitle = "Notificação",
    DefaultContent = "Conteúdo aqui...",
    DefaultDuration = 4,
    ContainerName = "LaboryNotifyGui",
    Theme = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        TitleColor = Color3.fromRGB(255, 255, 255),
        ContentColor = Color3.fromRGB(200, 200, 200),
        AccentColor = Color3.fromRGB(100, 100, 255),
        Transparency = 0.2
    },
    Animation = {
        Duration = 0.3,
        Offset = UDim2.new(0, 0, 0, 20)
    }
}

-- Módulo de utilitários para criação de UI
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
        container = self:CreateScreenGui(LaboryNotification.Config.ContainerName)
    end
    return container
end

function UIUtils:CreateFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(1, -320, 1, -120)
    frame.BackgroundColor3 = LaboryNotification.Config.Theme.BackgroundColor
    frame.BackgroundTransparency = LaboryNotification.Config.Theme.Transparency
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(1, 1)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    return frame
end

function UIUtils:CreateTitleLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = LaboryNotification.Config.Theme.TitleColor
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
    label.TextColor3 = LaboryNotification.Config.Theme.ContentColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = true
    return label
end

-- Novo componente: Botão
function UIUtils:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.Position = UDim2.new(1, -90, 1, -40)
    button.BackgroundColor3 = LaboryNotification.Config.Theme.AccentColor
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    button.Activated:Connect(callback or function() end)
    return button
end

-- Novo componente: Ícone
function UIUtils:CreateIcon(imageId)
    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0, 24, 0, 24)
    image.Position = UDim2.new(0, 10, 0, 10)
    image.BackgroundTransparency = 1
    image.Image = imageId and "rbxassetid://" .. imageId or ""
    return image
end

-- Animações
local AnimationUtils = {}

function AnimationUtils:Appear(frame)
    local targetPos = frame.Position - LaboryNotification.Config.Animation.Offset
    local tween = TweenService:Create(frame, TweenInfo.new(LaboryNotification.Config.Animation.Duration), {
        Position = targetPos
    })
    tween:Play()
    return tween
end

function AnimationUtils:Disappear(frame)
    local targetPos = frame.Position + LaboryNotification.Config.Animation.Offset
    local tween = TweenService:Create(frame, TweenInfo.new(LaboryNotification.Config.Animation.Duration), {
        Position = targetPos,
        BackgroundTransparency = 1
    })
    tween:Play()
    return tween
end

-- Função principal para criar notificações
function LaboryNotification:Notify(input)
    -- Inicialização de parâmetros
    local params = {
        Title = self.Config.DefaultTitle,
        Content = self.Config.DefaultContent,
        Duration = self.Config.DefaultDuration,
        Button = nil,
        Icon = nil
    }

    -- Processamento de entrada
    if typeof(input) == "table" then
        params.Title = input.Title or input[1] or params.Title
        params.Content = input.Content or input[2] or params.Content
        params.Duration = input.Duration or input[3] or params.Duration
        params.Button = input.Button
        params.Icon = input.Icon
    elseif typeof(input) == "string" then
        params.Title = input
    end

    -- Criação dos elementos
    local container = UIUtils:GetOrCreateContainer()
    local frame = UIUtils:CreateFrame()
    frame.Parent = container

    if params.Icon then
        local icon = UIUtils:CreateIcon(params.Icon)
        icon.Parent = frame
        -- Ajusta o título para não sobrepor o ícone
        UIUtils:CreateTitleLabel(params.Title).Position = UDim2.new(0, 40, 0, 10)
    end

    local titleLabel = UIUtils:CreateTitleLabel(params.Title)
    titleLabel.Parent = frame

    local contentLabel = UIUtils:CreateContentLabel(params.Content)
    contentLabel.Parent = frame

    if params.Button then
        local button = UIUtils:CreateButton(params.Button.Text, params.Button.Callback)
        button.Parent = frame
    end

    -- Animação
    AnimationUtils:Appear(frame)
    task.delay(params.Duration, function()
        local disappearTween = AnimationUtils:Disappear(frame)
        disappearTween.Completed:Wait()
        frame:Destroy()
    end)
end

-- Função para personalizar configurações
function LaboryNotification:CustomizeConfig(newConfig)
    for key, value in pairs(newConfig) do
        if self.Config[key] then
            self.Config[key] = value
        end
    end
end

return LaboryNotification