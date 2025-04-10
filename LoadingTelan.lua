-- Limpeza preventiva
local existingGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("PremiumLoadingScreen")
if existingGui then
    existingGui:Destroy()
end

-- Configurações iniciais
local tempoTotal = 8 -- segundos
local larguraTela = 1000
local alturaTela = 500

-- Cria a tela principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumLoadingScreen"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")


-- Cria o mainFrame primeiro
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, larguraTela, 0, alturaTela)
mainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Agora crie o background (já que mainFrame existe)
local background = Instance.new("ImageLabel")
background.Name = "FullscreenBackground"
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0.1, 0)
background.Image = "rbxassetid://88871521459866"
background.ScaleType = Enum.ScaleType.Crop
background.ImageTransparency = 0
background.Parent = mainFrame  -- Correto: mainFrame já foi criado

-- Configuração das partículas de nitro (faíscas azuis)
local nitroParticles = Instance.new("Frame")
nitroParticles.Name = "NitroParticles"
nitroParticles.Size = UDim2.new(1, 0, 1, 0)
nitroParticles.BackgroundTransparency = 1
nitroParticles.Parent = mainFrame

-- Efeito de faíscas (simulando nitro)
local function createNitroSpark()
    local spark = Instance.new("ImageLabel")
    spark.Name = "NitroSpark"
    spark.Size = UDim2.new(0, math.random(10, 30), 0, math.random(10, 30))
    spark.Position = UDim2.new(0, math.random(0, larguraTela), 1, 0) -- Começa na parte de baixo
    spark.BackgroundTransparency = 1
    spark.Image = "rbxassetid://109158608681076" -- Textura de brilho (pode usar "http://www.roblox.com/asset/?id=9658766691")
    spark.ImageColor3 = Color3.fromRGB(100, 180, 255) -- Azul brilhante
    spark.ScaleType = Enum.ScaleType.Fit
    spark.ZIndex = 5
    spark.Parent = nitroParticles

    -- Animação da faísca (sobe e desaparece)
    local speed = math.random(1, 3)
    local fadeTime = math.random(0.5, 1.5)
    
    spawn(function()
        for i = 1, 50 do
            spark.Position = spark.Position - UDim2.new(0, 0, 0.01 * speed, 0) -- Move para cima
            spark.ImageTransparency = spark.ImageTransparency + 0.02 -- Desaparece gradualmente
            spark.Rotation = spark.Rotation + math.random(-5, 5) -- Gira levemente
            wait(0.03)
        end
        spark:Destroy() -- Remove a partícula depois da animação
    end)
end

-- Cria faíscas continuamente
spawn(function()
    while nitroParticles.Parent do
        createNitroSpark()
        wait(math.random(0.1, 0.5)) -- Intervalo entre partículas
    end
end)

-- Limpeza quando a tela for fechada
screenGui.Destroying:Connect(function()
    nitroParticles:Destroy()
    
end)
-- Logo centralizado
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 100, 0, 100)
logo.Position = UDim2.new(0.53, -75, 0.4, -75)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://109158608681076" -- Substitua pelo ID da sua imagem
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = mainFrame


-- Texto de carregamento
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(0, 300, 0, 40)
loadingText.Position = UDim2.new(0.5, -150, 0.6, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "XLAUCH CARREGANDO..."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextColor3 = Color3.fromRGB(220, 220, 255)
loadingText.TextSize = 24
loadingText.TextStrokeColor3 = Color3.fromRGB(100, 150, 255)
loadingText.TextStrokeTransparency = 0.7
loadingText.Parent = mainFrame

-- Barra de progresso com bordas arredondadas
local progressBarBackground = Instance.new("Frame")
progressBarBackground.Name = "ProgressBarBackground"
progressBarBackground.Size = UDim2.new(0.7, 0, 0, 12)
progressBarBackground.Position = UDim2.new(0.15, 0, 0.75, 0)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.Parent = mainFrame

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0.5, 0)
progressBarCorner.Parent = progressBarBackground

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBackground

local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(0.5, 0)
progressBarInnerCorner.Parent = progressBar

-- Efeito de gradiente na barra
local progressGradient = Instance.new("UIGradient")
progressGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 130, 235)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 170, 255))
})
progressGradient.Parent = progressBar


-- Animação da barra de progresso
local startTime = tick()
local endTime = startTime + tempoTotal


local function update()
    local currentTime = tick()
    local elapsed = currentTime - startTime
    local progress = math.min(elapsed / tempoTotal, 1)
    
    -- Atualiza barra de progresso
    game:GetService("TweenService"):Create(
        progressBar,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(progress, 0, 1, 0)}
    ):Play()
    
    -- Atualiza texto
    loadingText.Text = "XLAUCH CARREGANDO "..string.format("%02d", math.floor(progress * 100)).."%"
    
    -- Quando completar
    if progress >= 1 then
        -- Desconecta o loop imediatamente
        if connection then
            connection:Disconnect()
            connection = nil
        end

        loadingText.Text = "COMPLETO!"
        
        -- Piscar o texto 3 vezes
        for i = 1, 3 do
            loadingText.TextTransparency = 0
            wait(0.2)
            loadingText.TextTransparency = 0.5
            wait(2)
        end

        -- Animação de fade out para todos os elementos
        local fadeTime = 2 -- Tempo do fade out
        local completed = Instance.new("BoolValue")
        completed.Value = false
        
        -- Função para verificar quando todas as animações terminarem
        local function onFadeComplete()
            if not completed.Value then
                completed.Value = true
                wait(3) -- Pequeno delay extra para garantir
                screenGui:Destroy()
            end
        end

        -- Configura os tweens com callbacks de conclusão
        local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        -- 1. Anima o mainFrame
        local mainTween = game:GetService("TweenService"):Create(
            mainFrame,
            tweenInfo,
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }
        )
        mainTween.Completed:Connect(onFadeComplete)
        mainTween:Play()

        -- 2. Anima o background e overlay
        local bgTween = game:GetService("TweenService"):Create(
            background,
            tweenInfo,
            {
                ImageTransparency = 1,
                BackgroundTransparency = 1
            }
        )
        bgTween.Completed:Connect(onFadeComplete)
        bgTween:Play()

        local overlayTween = game:GetService("TweenService"):Create(
            overlay,
            tweenInfo,
            {
                BackgroundTransparency = 1
            }
        )
        overlayTween.Completed:Connect(onFadeComplete)
        overlayTween:Play()

        -- 3. Anima o texto e logo
        local textTween = game:GetService("TweenService"):Create(
            loadingText,
            tweenInfo,
            {
                TextTransparency = 1,
                TextStrokeTransparency = 1
            }
        )
        textTween.Completed:Connect(onFadeComplete)
        textTween:Play()

        local logoTween = game:GetService("TweenService"):Create(
            logo,
            tweenInfo,
            {
                ImageTransparency = 1
            }
        )
        logoTween.Completed:Connect(onFadeComplete)
        logoTween:Play()

        return true
    end
    
    return false
end
-- Loop principal
local connection
connection = game:GetService("RunService").Heartbeat:Connect(function()
    if update() then
        connection:Disconnect()
    end
end)
