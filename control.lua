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
		else
			warn("Erro ao carregar componente:", moduleScript.Name)
		end
	end
end

-- Função principal para criar componentes dinamicamente
function UIController:Create(config)
	local componentType = config.type:lower()
	local component = self.Components[componentType]

	if not component then
		warn("Componente desconhecido: " .. tostring(componentType))
		return
	end

	-- Cria o componente principal
	local instance = component.create(config)

	-- Se tiver filhos, cria eles dentro do pai
	if config.children and typeof(config.children) == "table" then
		for _, childConfig in ipairs(config.children) do
			childConfig.parent = instance
			self:Create(childConfig)
		end
	end

	return instance
end

return UIController
