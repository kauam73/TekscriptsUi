local Button = {}

Button.name = "Button"

function Button.create(config)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, config.width or 150, 0, config.height or 40)
	btn.Position = config.position or UDim2.new(0, 0, 0, 0)
	btn.Text = config.label or "Clique aqui"
	btn.BackgroundColor3 = config.color or Color3.fromRGB(50, 150, 255)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18

	if config.onClick then
		btn.MouseButton1Click:Connect(config.onClick)
	end

	-- Inserir no Parent
	if config.parent then
		btn.Parent = config.parent
	end

	return btn
end

return Button
