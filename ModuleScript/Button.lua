-- Components/Button.lua

local Button = {}

Button.name = "button"

-- Função para criar o botão
function Button.create(config)
    -- Cria o botão
    local button = Instance.new("TextButton")
    button.Size = config.size or UDim2.new(0, 200, 0, 50)
    button.Position = config.position or UDim2.new(0.5, -100, 0.5, -25)
    button.Text = config.text or "Clique aqui!"
    button.Parent = config.parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
    
    -- Configurações adicionais do botão
    button.BackgroundColor3 = config.bgColor or Color3.fromRGB(255, 255, 255)
    button.TextColor3 = config.textColor or Color3.fromRGB(0, 0, 0)

    -- Ação de clique
    if config.callback and type(config.callback) == "function" then
        button.MouseButton1Click:Connect(config.callback)
    end

    return button
end

return Button
