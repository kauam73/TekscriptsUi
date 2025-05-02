-- UIController.lua
local UIController = {}
UIController.Components = {}

-- Função para copiar os módulos de componentes para o Workspace
function UIController:TransferToWorkspace(componentsFolder)
    -- Cria uma pasta no Workspace chamada "UIComponents"
    local workspaceFolder = game:GetService("Workspace"):FindFirstChild("UIComponents")
    if not workspaceFolder then
        workspaceFolder = Instance.new("Folder")
        workspaceFolder.Name = "UIComponents"
        workspaceFolder.Parent = game:GetService("Workspace")
    end

    -- Copia todos os módulos de components para a pasta do Workspace
    for _, moduleScript in ipairs(componentsFolder:GetChildren()) do
        if moduleScript:IsA("ModuleScript") then
            -- Cria uma cópia do módulo no Workspace
            local moduleCopy = moduleScript:Clone()
            moduleCopy.Parent = workspaceFolder
        end
    end
end

-- Inicializa os componentes a partir de uma pasta no Workspace
function UIController:Init(componentsFolder)
    if not componentsFolder then
        error("[UIController] Pasta de componentes não fornecida.")
    end

    -- Copiar os módulos para o Workspace
    self:TransferToWorkspace(componentsFolder)

    -- Carrega os módulos de componentes da pasta no Workspace
    local workspaceFolder = game:GetService("Workspace"):WaitForChild("UIComponents")

    for _, moduleScript in ipairs(workspaceFolder:GetChildren()) do
        if moduleScript:IsA("ModuleScript") then
            local success, component = pcall(require, moduleScript)
            if success and component.name and component.create then
                self.Components[component.name:lower()] = component
            else
                warn("[UIController] Componente inválido ou erro ao carregar:", moduleScript.Name)
            end
        end
    end
end

-- Função para criar componentes dinamicamente
function UIController:Create(config)
    if typeof(config) ~= "table" or not config.type then
        warn("[UIController] Configuração inválida")
        return
    end

    local componentType = config.type:lower()
    local component = self.Components[componentType]

    if not component then
        warn("[UIController] Componente desconhecido: " .. tostring(componentType))
        return
    end

    local instance = component.create(config)

    -- Criar filhos, se houver
    if config.children then
        for _, child in ipairs(config.children) do
            child.parent = instance
            self:Create(child)
        end
    end

    return instance
end

return UIController
