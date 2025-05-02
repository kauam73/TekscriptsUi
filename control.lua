local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = script:WaitForChild("Components")

local UIController = {}
UIController.Components = {}

-- Carrega todos os módulos em Components automaticamente
for _, moduleScript in ipairs(Components:GetChildren()) do
	if moduleScript:IsA("ModuleScript") then
		local success, component = pcall(require, moduleScript)
		if success and component.name then
			UIController.Components[component.name:lower()] = component
		end
	end
end

-- Função principal para criar componentes dinamicamente
function UIController:Create(config)
	local componentType = config.type:lower()
	local component = self.Components[componentType]

	if component then
		return component.create(config)
	else
		warn("Componente desconhecido: " .. tostring(componentType))
	end
end

return UIController
