--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                         SYSHUB UI LIBRARY                         ║
    ║        Next-Gen Obsidian Dashboard • SysHub Electric Blue         ║
    ║   Dual-Column Grid • Compact Sidebar • Accordions • Full Suite   ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- GUI Container Parent (Mendukung Executor & Roblox Studio)
local function GetGuiParent()
    local success, parent = pcall(function()
        if gethui then return gethui() end
        if syn and syn.protect_gui then
            local g = Instance.new("Folder")
            syn.protect_gui(g)
            g.Parent = CoreGui
            return g
        end
        return CoreGui
    end)
    if success and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local SysHubUI = {
    Version = "3.0.1",
    Windows = {},
    DefaultKeybind = Enum.KeyCode.RightControl
}

-- HTTP Request Wrapper (Kompatibel dengan WindUI.Creator.Request & SysHubUI.Creator.Request)
SysHubUI.Creator = {
    Request = function(req)
        local fn = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if fn then
            return fn(req)
        end
        local success, res = pcall(function()
            return game:HttpGet(req.Url)
        end)
        return { Body = success and res or "{}" }
    end
}

-- ==============================================================================
-- THEME: SYSHUB ELECTRIC BLUE PALETTE (SESUAI LOGO RESMI SYSHUB)
-- ==============================================================================
local Theme = {
    -- Backgrounds
    Bg = Color3.fromRGB(12, 15, 22),                 -- Obsidian Matte Midnight Navy
    BgHeader = Color3.fromRGB(9, 12, 18),            -- Deep Header Navy
    Sidebar = Color3.fromRGB(10, 13, 19),            -- Compact Slim Sidebar
    Surface = Color3.fromRGB(18, 23, 34),            -- Groupbox / Section Card Surface
    SurfaceHover = Color3.fromRGB(26, 34, 48),       -- Interactive Hover
    SurfaceAlt = Color3.fromRGB(14, 18, 27),         -- Inner Containers / Input boxes

    -- SysHub Electric Blue Brand Accents (Dari Logo Resmi S Monogram)
    Primary = Color3.fromRGB(0, 140, 255),           -- Electric Azure Blue
    PrimaryDark = Color3.fromRGB(0, 85, 255),        -- Royal Cobalt Blue
    PrimaryLight = Color3.fromRGB(56, 189, 255),     -- Sky Cyan Glow
    PrimaryGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 160, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 80, 255))
    }),

    -- Functional Colors
    Success = Color3.fromRGB(34, 197, 94),           -- Emerald Active State
    Warning = Color3.fromRGB(245, 158, 11),          -- Amber
    Danger = Color3.fromRGB(239, 68, 68),            -- Crimson

    -- Borders & Strokes
    Border = Color3.fromRGB(30, 40, 58),             -- Subtle Navy Slate Border
    BorderActive = Color3.fromRGB(0, 140, 255),      -- Glowing Electric Blue Border
    BorderTransparency = 0.45,

    -- Typography
    Text = Color3.fromRGB(255, 255, 255),            -- Crisp White
    TextMuted = Color3.fromRGB(148, 163, 184),       -- Slate Muted Text
    TextDark = Color3.fromRGB(95, 110, 130),         -- Dark Secondary Text
}

-- Utility Animation Helper
local function Tween(instance, info, properties)
    if not instance or typeof(instance) ~= "Instance" then
        return nil
    end
    local success, anim = pcall(function()
        return TweenService:Create(instance, info, properties)
    end)
    if success and anim then
        anim:Play()
        return anim
    end
    return nil
end

-- ==============================================================================
-- [1] NOTIFICATION SYSTEM (Pojok Kanan Bawah)
-- ==============================================================================
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "SysHubNotifications"
NotificationGui.ResetOnSpawn = false
NotificationGui.DisplayOrder = 999
NotificationGui.Parent = GetGuiParent()

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "Container"
NotificationContainer.Size = UDim2.new(0, 310, 1, -40)
NotificationContainer.Position = UDim2.new(1, -326, 0, 20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = NotificationGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.Parent = NotificationContainer

function SysHubUI:Notify(notifConfig)
    notifConfig = notifConfig or {}
    local title = notifConfig.Title or "SysHub Notification"
    local content = notifConfig.Content or notifConfig.Text or ""
    local duration = notifConfig.Duration or 3.5
    local color = notifConfig.Color or Theme.Primary

    local NotifCard = Instance.new("Frame")
    NotifCard.Name = "NotifCard"
    NotifCard.Size = UDim2.new(1, 0, 0, 0)
    NotifCard.BackgroundColor3 = Theme.Surface
    NotifCard.BackgroundTransparency = 0.15
    NotifCard.ClipsDescendants = true
    NotifCard.Parent = NotificationContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifCard

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = color
    Stroke.Thickness = 1
    Stroke.Transparency = 0.3
    Stroke.Parent = NotifCard

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 3, 1, 0)
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.BackgroundColor3 = color
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = NotifCard

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12.5
    TitleLabel.TextColor3 = color
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Size = UDim2.new(1, -24, 0, 16)
    TitleLabel.Position = UDim2.new(0, 14, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = NotifCard

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = content
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 11
    DescLabel.TextColor3 = Theme.TextMuted
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Size = UDim2.new(1, -24, 0, 32)
    DescLabel.Position = UDim2.new(0, 14, 0, 24)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Parent = NotifCard

    Tween(NotifCard, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 64)
    })

    task.delay(duration, function()
        if NotifCard and NotifCard.Parent then
            local closeAnim = Tween(NotifCard, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1
            })
            if closeAnim then
                closeAnim.Completed:Connect(function()
                    NotifCard:Destroy()
                end)
            else
                NotifCard:Destroy()
            end
        end
    end)
end

-- ==============================================================================
-- [2] CREATE WINDOW (Obsidian 2-Column Dashboard Style)
-- ==============================================================================
function SysHubUI:CreateWindow(windowConfig)
    windowConfig = windowConfig or {}

    -- Deteksi Nama Game Roblox Asli secara Otomatis
    local detectedGameName = "Roblox Game"
    pcall(function()
        local prod = MarketplaceService:GetProductInfo(game.PlaceId)
        if prod and prod.Name and prod.Name ~= "" then
            detectedGameName = prod.Name
        end
    end)

    local TitleText = windowConfig.Title or ("SysHub - " .. detectedGameName)

    -- Sinkronisasi Footer Game Sesuai Game yang Dimainkan
    local FooterText = windowConfig.Footer
    if not FooterText or FooterText:find("Loot To Forge") then
        if windowConfig.Subtitle and not windowConfig.Subtitle:find("Glassmorphism") then
            FooterText = windowConfig.Subtitle
        else
            FooterText = detectedGameName .. " • SysHub Edition"
        end
    end

    local ToggleKey = windowConfig.Keybind or SysHubUI.DefaultKeybind

    -- Responsive Viewport Adaptation (Menyesuaikan Layar HP & PC agar TIDAK KEPOTONG)
    local Camera = workspace.CurrentCamera
    local vp = Camera and Camera.ViewportSize or Vector2.new(1280, 720)

    local defaultW = 750
    local defaultH = 480
    if windowConfig.Size and windowConfig.Size.X.Offset > 0 then
        defaultW = windowConfig.Size.X.Offset
        defaultH = windowConfig.Size.Y.Offset
    end

    -- Pastikan window selalu muat 100% di layar (PC, Tablet, maupun HP)
    local maxAvailW = math.max(340, vp.X - 16)
    local maxAvailH = math.max(260, vp.Y - 20)
    local safeW = math.clamp(defaultW, 340, maxAvailW)
    local safeH = math.clamp(defaultH, 260, maxAvailH)
    local WindowSize = UDim2.fromOffset(safeW, safeH)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SysHub_ObsidianDashboard"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = GetGuiParent()

    -- Window Outer Main Frame (AnchorPoint 0.5, 0.5: SELALU DI TENGAH LAYAR)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = WindowSize
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Theme.Bg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.35
    MainStroke.Parent = MainFrame

    -- Drop Shadow Layer
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    Shadow.Size = UDim2.new(1, 36, 1, 36)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.45
    Shadow.ZIndex = MainFrame.ZIndex - 1
    Shadow.Parent = MainFrame

    -- ==============================================================================
    -- HEADER BAR (Title, Active Tab Info, Search Bar, Window Controls)
    -- ==============================================================================
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 44)
    Header.BackgroundColor3 = Theme.BgHeader
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header

    -- Fix corner rounding at bottom of header
    local HeaderBottomCover = Instance.new("Frame")
    HeaderBottomCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderBottomCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderBottomCover.BackgroundColor3 = Theme.BgHeader
    HeaderBottomCover.BorderSizePixel = 0
    HeaderBottomCover.Parent = Header

    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.BackgroundColor3 = Theme.Border
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    -- SysHub S Monogram Logo Emblem (Pojok Kiri Header - Persis Logo Resmi)
    local LogoEmblem = Instance.new("Frame")
    LogoEmblem.Name = "LogoEmblem"
    LogoEmblem.Size = UDim2.new(0, 26, 0, 26)
    LogoEmblem.Position = UDim2.new(0, 14, 0.5, -13)
    LogoEmblem.BackgroundColor3 = Theme.Primary
    LogoEmblem.BorderSizePixel = 0
    LogoEmblem.Parent = Header

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = LogoEmblem

    local LogoGrad = Instance.new("UIGradient")
    LogoGrad.Color = Theme.PrimaryGradient
    LogoGrad.Rotation = 135
    LogoGrad.Parent = LogoEmblem

    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = Color3.fromRGB(80, 190, 255)
    LogoStroke.Thickness = 1
    LogoStroke.Transparency = 0.4
    LogoStroke.Parent = LogoEmblem

    local LogoIcon = Instance.new("TextLabel")
    LogoIcon.Text = "S"
    LogoIcon.Font = Enum.Font.GothamBold
    LogoIcon.TextSize = 14
    LogoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoIcon.Size = UDim2.new(1, 0, 1, 0)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Parent = LogoEmblem

    -- Current Active Tab Title
    local HeaderTabTitle = Instance.new("TextLabel")
    HeaderTabTitle.Name = "ActiveTabTitle"
    HeaderTabTitle.Text = "Info"
    HeaderTabTitle.Font = Enum.Font.GothamBold
    HeaderTabTitle.TextSize = 14.5
    HeaderTabTitle.TextColor3 = Theme.Text
    HeaderTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabTitle.Size = UDim2.new(0, 160, 1, 0)
    HeaderTabTitle.Position = UDim2.new(0, 50, 0, 0)
    HeaderTabTitle.BackgroundTransparency = 1
    HeaderTabTitle.Parent = Header

    -- Central Search Bar Capsule
    -- Central Search Bar Capsule (Presisi Dead-Center)
    local SearchBoxFrame = Instance.new("Frame")
    SearchBoxFrame.Name = "SearchCapsule"
    SearchBoxFrame.Size = UDim2.new(0, 220, 0, 28)
    SearchBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SearchBoxFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SearchBoxFrame.BackgroundColor3 = Theme.Surface
    SearchBoxFrame.Parent = Header

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(1, 0)
    SearchCorner.Parent = SearchBoxFrame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Theme.Border
    SearchStroke.Thickness = 1
    SearchStroke.Parent = SearchBoxFrame

    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Text = "🔍"
    SearchIcon.TextSize = 11
    SearchIcon.Size = UDim2.new(0, 26, 1, 0)
    SearchIcon.Position = UDim2.new(0, 6, 0, 0)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.TextColor3 = Theme.TextMuted
    SearchIcon.Parent = SearchBoxFrame

    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "Input"
    SearchInput.Size = UDim2.new(1, -38, 1, 0)
    SearchInput.Position = UDim2.new(0, 32, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.PlaceholderText = "Search..."
    SearchInput.PlaceholderColor3 = Theme.TextDark
    SearchInput.Text = ""
    SearchInput.TextColor3 = Theme.Text
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.TextSize = 11.5
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchBoxFrame

    SearchInput.Focused:Connect(function()
        Tween(SearchStroke, TweenInfo.new(0.2), { Color = Theme.Primary })
    end)
    SearchInput.FocusLost:Connect(function()
        Tween(SearchStroke, TweenInfo.new(0.2), { Color = Theme.Border })
    end)

    -- Window Controls (Notification bell & Minimize)
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "Controls"
    WindowControls.Size = UDim2.new(0, 68, 1, 0)
    WindowControls.Position = UDim2.new(1, -78, 0, 0)
    WindowControls.BackgroundTransparency = 1
    WindowControls.Parent = Header

    local CtrlLayout = Instance.new("UIListLayout")
    CtrlLayout.FillDirection = Enum.FillDirection.Horizontal
    CtrlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    CtrlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    CtrlLayout.Padding = UDim.new(0, 6)
    CtrlLayout.Parent = WindowControls

    -- 1. Bell Button
    local BellBtn = Instance.new("TextButton")
    BellBtn.Name = "Bell"
    BellBtn.Text = "🔔"
    BellBtn.TextSize = 12
    BellBtn.Size = UDim2.new(0, 26, 0, 26)
    BellBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BellBtn.BackgroundTransparency = 0.95
    BellBtn.AutoButtonColor = false
    BellBtn.Parent = WindowControls
    local BellCorner = Instance.new("UICorner")
    BellCorner.CornerRadius = UDim.new(0, 6)
    BellCorner.Parent = BellBtn

    -- 2. Minimize Button (Menggunakan Garis Frame Presisi Anti-Tofu)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "Minimize"
    MinBtn.Text = ""
    MinBtn.Size = UDim2.new(0, 26, 0, 26)
    MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.BackgroundTransparency = 0.95
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = WindowControls
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn

    local MinBar = Instance.new("Frame")
    MinBar.Size = UDim2.new(0, 11, 0, 2)
    MinBar.AnchorPoint = Vector2.new(0.5, 0.5)
    MinBar.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinBar.BackgroundColor3 = Theme.TextMuted
    MinBar.BorderSizePixel = 0
    MinBar.Parent = MinBtn

    for _, btn in ipairs({ BellBtn, MinBtn }) do
        btn.MouseEnter:Connect(function()
            Tween(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.85 })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.95 })
        end)
    end

    BellBtn.MouseButton1Click:Connect(function()
        SysHubUI:Notify({
            Title = "⚡ SysHub Notifications",
            Content = "Game: " .. detectedGameName .. "\nStatus: All systems operational",
            Duration = 3,
            Color = Theme.Primary
        })
    end)

    -- ==============================================================================
    -- DRAG & RESIZE ENGINE (BULLETPROOF UNIVERSAL DRAGGING DENGAN CLAMP VIEWPORT)
    -- ==============================================================================
    local isDragging = false
    local dragStartMouse = Vector2.new()
    local dragStartPos = UDim2.new()

    local function StartDragging(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
            dragStartPos = MainFrame.Position
        end
    end

    Header.InputBegan:Connect(StartDragging)

    local isResizing = false
    local resizeStartMouse = Vector2.new()
    local startFrameSize = Vector2.new()

    -- Reset status drag & resize saat jari diangkat / mouse dilepas di mana saja
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            isResizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local deltaX = input.Position.X - dragStartMouse.X
            local deltaY = input.Position.Y - dragStartMouse.Y

            local cam = workspace.CurrentCamera
            local vpSize = cam and cam.ViewportSize or Vector2.new(1280, 720)
            local halfW = MainFrame.AbsoluteSize.X / 2
            local halfH = MainFrame.AbsoluteSize.Y / 2

            -- Clamp aman agar window TIDAK BISA KELUAR DARI LAYAR
            local maxMoveX = math.max(0, vpSize.X / 2 - halfW - 8)
            local maxMoveY = math.max(0, vpSize.Y / 2 - halfH - 8)

            local targetOffsetX = math.clamp(dragStartPos.X.Offset + deltaX, -maxMoveX, maxMoveX)
            local targetOffsetY = math.clamp(dragStartPos.Y.Offset + deltaY, -maxMoveY, maxMoveY)

            MainFrame.Position = UDim2.new(0.5, targetOffsetX, 0.5, targetOffsetY)
        elseif isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local deltaX = input.Position.X - resizeStartMouse.X
            local deltaY = input.Position.Y - resizeStartMouse.Y

            local cam = workspace.CurrentCamera
            local vpSize = cam and cam.ViewportSize or Vector2.new(1280, 720)
            local minW = 340
            local maxW = math.max(minW, math.min(vpSize.X - 16, 1100))
            local minH = 260
            local maxH = math.max(minH, math.min(vpSize.Y - 20, 750))

            local newW = math.clamp(startFrameSize.X + deltaX, minW, maxW)
            local newH = math.clamp(startFrameSize.Y + deltaY, minH, maxH)

            local actualDeltaX = newW - startFrameSize.X
            local actualDeltaY = newH - startFrameSize.Y

            MainFrame.Size = UDim2.fromOffset(newW, newH)
            MainFrame.Position = UDim2.new(
                0.5,
                dragStartPos.X.Offset + (actualDeltaX / 2),
                0.5,
                dragStartPos.Y.Offset + (actualDeltaY / 2)
            )
        end
    end)

    -- Visibility Toggle Logic
    local isVisible = true
    local openButtonInstance = nil

    local function SetUIVisibility(visible)
        isVisible = visible
        MainFrame.Visible = isVisible
        if openButtonInstance then
            openButtonInstance.Visible = not isVisible
        end
    end

    local function ToggleVisibility()
        SetUIVisibility(not isVisible)
    end

    MinBtn.MouseButton1Click:Connect(function()
        SetUIVisibility(false)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            ToggleVisibility()
        end
    end)

    -- ==============================================================================
    -- FOOTER BAR (Bottom: Discord Link, Game Title, Version, Resize Grip)
    -- ==============================================================================
    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, 0, 0, 24)
    Footer.Position = UDim2.new(0, 0, 1, -24)
    Footer.BackgroundColor3 = Theme.BgHeader
    Footer.BorderSizePixel = 0
    Footer.Parent = MainFrame

    local FooterCorner = Instance.new("UICorner")
    FooterCorner.CornerRadius = UDim.new(0, 10)
    FooterCorner.Parent = Footer

    local FooterTopCover = Instance.new("Frame")
    FooterTopCover.Size = UDim2.new(1, 0, 0, 6)
    FooterTopCover.Position = UDim2.new(0, 0, 0, 0)
    FooterTopCover.BackgroundColor3 = Theme.BgHeader
    FooterTopCover.BorderSizePixel = 0
    FooterTopCover.Parent = Footer

    local FooterLine = Instance.new("Frame")
    FooterLine.Size = UDim2.new(1, 0, 0, 1)
    FooterLine.Position = UDim2.new(0, 0, 0, 0)
    FooterLine.BackgroundColor3 = Theme.Border
    FooterLine.BorderSizePixel = 0
    FooterLine.Parent = Footer

    local FooterLabel = Instance.new("TextButton")
    FooterLabel.Name = "FooterInfo"
    FooterLabel.Text = "https://discord.gg/syshub 📋  │  " .. FooterText
    FooterLabel.Font = Enum.Font.Gotham
    FooterLabel.TextSize = 10.5
    FooterLabel.TextColor3 = Theme.PrimaryLight
    FooterLabel.Size = UDim2.new(1, -40, 1, 0)
    FooterLabel.Position = UDim2.new(0, 12, 0, 0)
    FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.Parent = Footer

    FooterLabel.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("https://discord.gg/syshub")
                SysHubUI:Notify({ Title = "Clipboard", Content = "Discord invite copied!", Duration = 2 })
            end
        end)
    end)

    -- Interaktif Handle Resize Grip (Image Diagonal 2-Way Expand Resmi)
    local ResizeGrip = Instance.new("ImageButton")
    ResizeGrip.Name = "ResizeGrip"
    ResizeGrip.Size = UDim2.new(0, 16, 0, 16)
    ResizeGrip.Position = UDim2.new(1, -20, 0.5, -8)
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.Image = "rbxassetid://6031091004" -- Official Roblox Corner Expand Grip
    ResizeGrip.ImageColor3 = Theme.Primary
    ResizeGrip.ScaleType = Enum.ScaleType.Fit
    ResizeGrip.Parent = Footer

    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isResizing = true
            resizeStartMouse = Vector2.new(input.Position.X, input.Position.Y)
            startFrameSize = MainFrame.AbsoluteSize
            dragStartPos = MainFrame.Position
        end
    end)

    -- ==============================================================================
    -- SIDEBAR (Slim Compact Icon Sidebar - Sisi Kiri Lebar 50px)
    -- ==============================================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "SlimSidebar"
    Sidebar.Size = UDim2.new(0, 50, 1, -68)
    Sidebar.Position = UDim2.new(0, 0, 0, 44)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.BackgroundColor3 = Theme.Border
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Size = UDim2.new(1, 0, 1, -12)
    SidebarScroll.Position = UDim2.new(0, 0, 0, 6)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.Parent = Sidebar

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = SidebarScroll

    -- ==============================================================================
    -- MAIN CONTENT CONTAINER (DUAL-COLUMN GRID ENGINE)
    -- ==============================================================================
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -50, 1, -68)
    ContentContainer.Position = UDim2.new(0, 50, 0, 44)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame

    -- Helper Icon Matcher Komprehensif (100% Emoji Standar Anti-Tofu Kotak)
    local function GetIconChar(iconName)
        if not iconName then return "🔹" end
        local l = iconName:lower()
        if l:find("user") or l:find("player") or l:find("profile") then return "👤"
        elseif l:find("farm") or l:find("sprout") or l:find("game") then return "🎮"
        elseif l:find("coop") or l:find("feeder") or l:find("recycler") or l:find("warehouse") then return "🌾"
        elseif l:find("flock") or l:find("feather") or l:find("ayam") or l:find("chicken") then return "🐔"
        elseif l:find("sell") or l:find("coin") or l:find("money") then return "💰"
        elseif l:find("promote") or l:find("fuse") or l:find("roll") or l:find("charm") or l:find("fav") then return "✨"
        elseif l:find("tower") or l:find("castle") then return "🏰"
        elseif l:find("sword") or l:find("dungeon") or l:find("boss") or l:find("goose") or l:find("arena") or l:find("battle") then return "⚔️"
        elseif l:find("ufo") or l:find("chaos") then return "🛸"
        elseif l:find("event") or l:find("diamond") or l:find("gem") then return "💎"
        elseif l:find("reward") or l:find("gift") or l:find("claim") or l:find("code") or l:find("milestone") then return "🎁"
        elseif l:find("misc") or l:find("tool") or l:find("pickaxe") then return "⛏️"
        elseif l:find("server") then return "🌐"
        elseif l:find("fps") or l:find("boost") or l:find("speed") or l:find("fast") then return "⚡"
        elseif l:find("config") or l:find("setting") or l:find("gear") or l:find("manager") then return "⚙️"
        elseif l:find("esp") or l:find("visual") then return "👁️"
        elseif l:find("streamer") or l:find("video") then return "🎥"
        elseif l:find("webhook") or l:find("link") then return "🔗"
        elseif l:find("info") or l:find("about") or l:find("help") or l:find("problem") then return "ℹ️"
        elseif l:find("egg") or l:find("ancient") or l:find("jurassic") then return "🥚"
        end
        return "🔹"
    end

    local WindowHandler = {
        Tabs = {},
        CurrentTab = nil
    }

    -- REAL-TIME LIVE SEARCH FILTER ENGINE
    local function UpdateSearch(query)
        query = (query or ""):lower():gsub("%s+", "")
        local curTab = WindowHandler.CurrentTab
        if not curTab or not curTab.Page then return end

        for _, card in ipairs(curTab.Page:GetChildren()) do
            if card:IsA("Frame") and (card.Name:find("Groupbox_") or card.Name:find("Card_")) then
                local cardTitle = card.Name:gsub("Groupbox_", ""):gsub("Card_", ""):lower():gsub("%s+", "")
                local cardMatches = (query == "") or cardTitle:find(query, 1, true) ~= nil
                local content = card:FindFirstChild("Content")

                local anyChildMatches = false
                if content then
                    for _, elem in ipairs(content:GetChildren()) do
                        if elem:IsA("GuiObject") and not elem:IsA("UIPadding") and not elem:IsA("UIListLayout") then
                            if query == "" then
                                elem.Visible = true
                            else
                                local elemMatches = cardMatches
                                if not elemMatches then
                                    for _, desc in ipairs(elem:GetDescendants()) do
                                        if desc:IsA("TextLabel") and desc.Text:lower():gsub("%s+", ""):find(query, 1, true) then
                                            elemMatches = true
                                            break
                                        end
                                    end
                                end
                                elem.Visible = elemMatches
                                if elemMatches then anyChildMatches = true end
                            end
                        end
                    end
                end

                if query == "" then
                    card.Visible = true
                else
                    card.Visible = cardMatches or anyChildMatches
                end
            end
        end
    end

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        UpdateSearch(SearchInput.Text)
    end)

    -- Sleek Top Minimize Pill (Tampil saat window di-minimize)
    function WindowHandler:EditOpenButton(cfg)
        cfg = cfg or {}
        local pillTitle = cfg.Title or TitleText
        local iconEmoji = "🥚"
        if cfg.Icon then
            iconEmoji = GetIconChar(cfg.Icon)
        end

        local OpenScreen = Instance.new("ScreenGui")
        OpenScreen.Name = "SysHubOpenBtnGui"
        OpenScreen.ResetOnSpawn = false
        OpenScreen.DisplayOrder = 999
        OpenScreen.Parent = GetGuiParent()

        local Pill = Instance.new("TextButton")
        Pill.Name = "SysHubTopPill"
        Pill.AnchorPoint = Vector2.new(0.5, 0)
        Pill.Size = UDim2.fromOffset(265, 32)
        Pill.Position = UDim2.new(0.5, 0, 0, 10)
        Pill.BackgroundColor3 = Theme.Bg
        Pill.BackgroundTransparency = 0.2
        Pill.Text = ""
        Pill.AutoButtonColor = false
        Pill.Visible = not isVisible
        Pill.Parent = OpenScreen

        local PCorner = Instance.new("UICorner")
        PCorner.CornerRadius = UDim.new(1, 0)
        PCorner.Parent = Pill

        local PStroke = Instance.new("UIStroke")
        PStroke.Color = Theme.Primary
        PStroke.Thickness = 1.2
        PStroke.Transparency = 0.35
        PStroke.Parent = Pill

        local DragHandleImg = Instance.new("ImageLabel")
        DragHandleImg.Image = "rbxassetid://6031225882"
        DragHandleImg.ImageColor3 = Theme.Primary
        DragHandleImg.Size = UDim2.new(0, 14, 0, 14)
        DragHandleImg.Position = UDim2.new(0, 10, 0.5, -7)
        DragHandleImg.BackgroundTransparency = 1
        DragHandleImg.Parent = Pill

        local SepLine = Instance.new("Frame")
        SepLine.Size = UDim2.new(0, 1, 0, 16)
        SepLine.Position = UDim2.new(0, 30, 0.5, -8)
        SepLine.BackgroundColor3 = Theme.Border
        SepLine.BorderSizePixel = 0
        SepLine.Parent = Pill

        local POrb = Instance.new("TextLabel")
        POrb.Text = iconEmoji
        POrb.Font = Enum.Font.GothamBold
        POrb.TextSize = 13
        POrb.TextColor3 = Theme.PrimaryLight
        POrb.Size = UDim2.new(0, 20, 1, 0)
        POrb.Position = UDim2.new(0, 36, 0, 0)
        POrb.BackgroundTransparency = 1
        POrb.Parent = Pill

        local PTitle = Instance.new("TextLabel")
        PTitle.Text = pillTitle
        PTitle.Font = Enum.Font.GothamBold
        PTitle.TextSize = 11.5
        PTitle.TextColor3 = Theme.Text
        PTitle.Size = UDim2.new(1, -66, 1, 0)
        PTitle.Position = UDim2.new(0, 60, 0, 0)
        PTitle.TextXAlignment = Enum.TextXAlignment.Left
        PTitle.TextTruncate = Enum.TextTruncate.AtEnd
        PTitle.BackgroundTransparency = 1
        PTitle.Parent = Pill

        openButtonInstance = Pill

        -- Drag on Pill
        local draggingPill = false
        local dragStartPill, startPosPill

        Pill.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingPill = true
                dragStartPill = input.Position
                startPosPill = Pill.Position
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingPill = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingPill and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartPill
                Pill.Position = UDim2.new(
                    startPosPill.X.Scale,
                    startPosPill.X.Offset + delta.X,
                    startPosPill.Y.Scale,
                    startPosPill.Y.Offset + delta.Y
                )
            end
        end)

        Pill.MouseButton1Click:Connect(function()
            SetUIVisibility(true)
        end)
    end

    -- ==============================================================================
    -- [3] CREATE TAB (Tab Ikon Ramping + Dual-Column Content Page)
    -- ==============================================================================
    function WindowHandler:Tab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Title or tabConfig.Name or "Tab"
        local iconChar = GetIconChar(tabConfig.Icon or tabName)

        -- Slim Sidebar Icon Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "TabBtn_" .. tabName
        TabBtn.Size = UDim2.new(0, 36, 0, 36)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = iconChar
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 16
        TabBtn.TextColor3 = Theme.TextMuted
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = SidebarScroll

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabBtn

        -- Tooltip Hover on Slim Icon
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.Text = "  " .. tabName .. "  "
        Tooltip.Font = Enum.Font.GothamMedium
        Tooltip.TextSize = 11
        Tooltip.TextColor3 = Theme.Text
        Tooltip.BackgroundColor3 = Theme.Surface
        Tooltip.Size = UDim2.new(0, 0, 0, 24)
        Tooltip.Position = UDim2.new(1, 10, 0.5, -12)
        Tooltip.AutomaticSize = Enum.AutomaticSize.X
        Tooltip.Visible = false
        Tooltip.ZIndex = 100
        Tooltip.Parent = TabBtn

        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 6)
        TCorner.Parent = Tooltip

        local TStroke = Instance.new("UIStroke")
        TStroke.Color = Theme.Border
        TStroke.Thickness = 1
        TStroke.Parent = Tooltip

        TabBtn.MouseEnter:Connect(function()
            Tooltip.Visible = true
            if WindowHandler.CurrentTab ~= TabObject then
                Tween(TabBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 40, 58),
                    BackgroundTransparency = 0.6,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            Tooltip.Visible = false
            if WindowHandler.CurrentTab ~= TabObject then
                Tween(TabBtn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextMuted
                })
            end
        end)

        -- Main Content Scrolling Frame for this Tab (Margin Pas Anti-Kepotong)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page_" .. tabName
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Primary
        Page.ScrollBarImageTransparency = 0.5
        Page.Visible = false
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = ContentContainer

        -- Layout Halaman Penuh Simetris (Margin Kiri & Kanan Sama Persis 14px)
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 12)
        PagePadding.PaddingBottom = UDim.new(0, 20)
        PagePadding.PaddingLeft = UDim.new(0, 14)
        PagePadding.PaddingRight = UDim.new(0, 14)
        PagePadding.Parent = Page

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Parent = Page

        -- Alias Container agar kompatibel penuh dengan pemanggilan terdahulu
        local LeftColumn = Page
        local RightColumn = Page

        local TabObject = {
            Button = TabBtn,
            Page = Page,
            Name = tabName,
            Container = Page,
            LeftColumn = LeftColumn,
            RightColumn = RightColumn,
            SectionCount = 0
        }

        local function ActivateTab()
            for _, t in ipairs(WindowHandler.Tabs) do
                if t.Page then
                    t.Page.Visible = false
                end
                if t.Button then
                    Tween(t.Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        TextColor3 = Theme.TextMuted
                    })
                end
            end

            Page.Visible = true
            HeaderTabTitle.Text = tabName
            Tween(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })
            WindowHandler.CurrentTab = TabObject
            UpdateSearch(SearchInput.Text)
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        if #WindowHandler.Tabs == 0 then
            ActivateTab()
        end

        table.insert(WindowHandler.Tabs, TabObject)

        -- ==============================================================================
        -- BUILDER HELPER (Membuat Komponen UI persis seperti Obsidian Screenshot)
        -- ==============================================================================
        local function BuildElements(targetParent)
            local Elements = {}

            -- 1. BUTTON
            function Elements:Button(btnConfig)
                btnConfig = btnConfig or {}
                local name = btnConfig.Title or btnConfig.Name or "Button"
                local callback = btnConfig.Callback or function() end

                local BtnFrame = Instance.new("TextButton")
                BtnFrame.Size = UDim2.new(1, 0, 0, 32)
                BtnFrame.BackgroundColor3 = Theme.SurfaceAlt
                BtnFrame.BackgroundTransparency = 0.2
                BtnFrame.Text = name
                BtnFrame.Font = Enum.Font.GothamMedium
                BtnFrame.TextSize = 11.5
                BtnFrame.TextColor3 = Theme.Text
                BtnFrame.AutoButtonColor = false
                BtnFrame.Parent = targetParent

                local BCorner = Instance.new("UICorner")
                BCorner.CornerRadius = UDim.new(0, 6)
                BCorner.Parent = BtnFrame

                local BStroke = Instance.new("UIStroke")
                BStroke.Color = Theme.Border
                BStroke.Thickness = 1
                BStroke.Parent = BtnFrame

                BtnFrame.MouseEnter:Connect(function()
                    Tween(BtnFrame, TweenInfo.new(0.18), { BackgroundColor3 = Theme.SurfaceHover })
                    Tween(BStroke, TweenInfo.new(0.18), { Color = Theme.Primary })
                end)
                BtnFrame.MouseLeave:Connect(function()
                    Tween(BtnFrame, TweenInfo.new(0.18), { BackgroundColor3 = Theme.SurfaceAlt })
                    Tween(BStroke, TweenInfo.new(0.18), { Color = Theme.Border })
                end)
                BtnFrame.MouseButton1Click:Connect(function()
                    task.spawn(callback)
                end)

                return { Instance = BtnFrame }
            end

            -- 2. TOGGLE (Saklar Persegi Modern Persis Gambar - SysHub Electric Blue)
            function Elements:Toggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local name = toggleConfig.Title or toggleConfig.Name or "Toggle Option"
                local state = toggleConfig.Value
                if state == nil then state = toggleConfig.Default end
                if state == nil then state = false end
                local callback = toggleConfig.Callback or function() end

                local ToggleFrame = Instance.new("TextButton")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Text = ""
                ToggleFrame.AutoButtonColor = false
                ToggleFrame.Parent = targetParent

                local TLabel = Instance.new("TextLabel")
                TLabel.Text = name
                TLabel.Font = Enum.Font.GothamMedium
                TLabel.TextSize = 11.5
                TLabel.TextColor3 = Theme.Text
                TLabel.TextXAlignment = Enum.TextXAlignment.Left
                TLabel.Size = UDim2.new(1, -54, 1, 0)
                TLabel.Position = UDim2.new(0, 8, 0, 0)
                TLabel.BackgroundTransparency = 1
                TLabel.Parent = ToggleFrame

                -- Track Persegi Rounded
                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(0, 36, 0, 18)
                Track.Position = UDim2.new(1, -44, 0.5, -9)
                Track.BackgroundColor3 = state and Theme.Primary or Color3.fromRGB(36, 44, 60)
                Track.BorderSizePixel = 0
                Track.Parent = ToggleFrame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 4)
                TrackCorner.Parent = Track

                local TrackStroke = Instance.new("UIStroke")
                TrackStroke.Color = state and Theme.PrimaryLight or Theme.Border
                TrackStroke.Thickness = 1
                TrackStroke.Transparency = 0.5
                TrackStroke.Parent = Track

                -- Knob Persegi Rounded Putih
                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 14, 0, 14)
                Knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Knob.BorderSizePixel = 0
                Knob.Parent = Track

                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(0, 3)
                KnobCorner.Parent = Knob

                local ToggleObj = { Value = state }

                local function UpdateState(val)
                    state = (val == true)
                    ToggleObj.Value = state
                    local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local targetTrackColor = state and Theme.Primary or Color3.fromRGB(36, 44, 60)
                    local targetStrokeColor = state and Theme.PrimaryLight or Theme.Border

                    Tween(Knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = targetPos })
                    Tween(Track, TweenInfo.new(0.18), { BackgroundColor3 = targetTrackColor })
                    Tween(TrackStroke, TweenInfo.new(0.18), { Color = targetStrokeColor })
                    task.spawn(callback, state)
                end

                ToggleFrame.MouseButton1Click:Connect(function()
                    UpdateState(not state)
                end)

                ToggleObj.Set = UpdateState
                ToggleObj.SetValue = UpdateState
                return ToggleObj
            end

            -- 3. SLIDER (Bar Horizontal Presisi dengan Label Angka)
            function Elements:Slider(sliderConfig)
                sliderConfig = sliderConfig or {}
                local name = sliderConfig.Title or sliderConfig.Name or "Slider"
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Value or sliderConfig.Default or min
                local suffix = sliderConfig.Suffix or ""
                local callback = sliderConfig.Callback or function() end

                local currentVal = default

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 42)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = targetParent

                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Text = name
                TitleLabel.Font = Enum.Font.GothamMedium
                TitleLabel.TextSize = 11.5
                TitleLabel.TextColor3 = Theme.Text
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.Size = UDim2.new(1, -60, 0, 16)
                TitleLabel.Position = UDim2.new(0, 2, 0, 0)
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Parent = SliderFrame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Text = tostring(currentVal) .. suffix
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.TextSize = 11
                ValLabel.TextColor3 = Theme.PrimaryLight
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Size = UDim2.new(0, 60, 0, 16)
                ValLabel.Position = UDim2.new(1, -62, 0, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Parent = SliderFrame

                local TrackBar = Instance.new("TextButton")
                TrackBar.Name = "Track"
                TrackBar.Size = UDim2.new(1, -4, 0, 8)
                TrackBar.Position = UDim2.new(0, 2, 0, 24)
                TrackBar.BackgroundColor3 = Color3.fromRGB(28, 36, 52)
                TrackBar.Text = ""
                TrackBar.AutoButtonColor = false
                TrackBar.Parent = SliderFrame

                local TBCorner = Instance.new("UICorner")
                TBCorner.CornerRadius = UDim.new(1, 0)
                TBCorner.Parent = TrackBar

                local Fill = Instance.new("Frame")
                local pct = math.clamp((currentVal - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Fill.BackgroundColor3 = Theme.Primary
                Fill.BorderSizePixel = 0
                Fill.Parent = TrackBar

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                local SliderKnob = Instance.new("Frame")
                SliderKnob.Size = UDim2.new(0, 12, 0, 12)
                SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
                SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderKnob.BorderSizePixel = 0
                SliderKnob.Parent = Fill

                local SKCorner = Instance.new("UICorner")
                SKCorner.CornerRadius = UDim.new(1, 0)
                SKCorner.Parent = SliderKnob

                local SliderObj = { Value = currentVal }

                local function UpdateVal(val, triggerCallback)
                    val = math.clamp(val, min, max)
                    currentVal = val
                    SliderObj.Value = val
                    ValLabel.Text = tostring(val) .. suffix
                    local p = (val - min) / (max - min)
                    Tween(Fill, TweenInfo.new(0.08), { Size = UDim2.new(p, 0, 1, 0) })
                    if triggerCallback then
                        task.spawn(callback, val)
                    end
                end

                local isDraggingSlider = false
                TrackBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDraggingSlider = true
                        local percentage = math.clamp((input.Position.X - TrackBar.AbsolutePosition.X) / TrackBar.AbsoluteSize.X, 0, 1)
                        UpdateVal(math.floor(min + (max - min) * percentage), true)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDraggingSlider = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percentage = math.clamp((input.Position.X - TrackBar.AbsolutePosition.X) / TrackBar.AbsoluteSize.X, 0, 1)
                        UpdateVal(math.floor(min + (max - min) * percentage), true)
                    end
                end)

                SliderObj.Set = function(v) UpdateVal(tonumber(v) or min, true) end
                SliderObj.SetValue = SliderObj.Set
                return SliderObj
            end

            -- 4. DROPDOWN (Selector Modern dengan Panah Ekspansi)
            function Elements:Dropdown(dropConfig)
                dropConfig = dropConfig or {}
                local name = dropConfig.Title or dropConfig.Name or "Dropdown"
                local options = dropConfig.Values or dropConfig.Options or {}
                local isMulti = dropConfig.Multi or false
                local default = dropConfig.Value or dropConfig.Default or (isMulti and {} or options[1])
                local callback = dropConfig.Callback or function() end

                local isExpanded = false
                local selected = default

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, 34)
                DropFrame.BackgroundColor3 = Theme.SurfaceAlt
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = targetParent

                local DCorner = Instance.new("UICorner")
                DCorner.CornerRadius = UDim.new(0, 6)
                DCorner.Parent = DropFrame

                local DStroke = Instance.new("UIStroke")
                DStroke.Color = Theme.Border
                DStroke.Thickness = 1
                DStroke.Parent = DropFrame

                local DTrigger = Instance.new("TextButton")
                DTrigger.Size = UDim2.new(1, 0, 0, 34)
                DTrigger.BackgroundTransparency = 1
                DTrigger.Text = ""
                DTrigger.Parent = DropFrame

                local DLabel = Instance.new("TextLabel")
                DLabel.Font = Enum.Font.GothamMedium
                DLabel.TextSize = 11.5
                DLabel.TextColor3 = Theme.Text
                DLabel.Size = UDim2.new(1, -36, 1, 0)
                DLabel.Position = UDim2.new(0, 10, 0, 0)
                DLabel.TextXAlignment = Enum.TextXAlignment.Left
                DLabel.TextTruncate = Enum.TextTruncate.AtEnd
                DLabel.BackgroundTransparency = 1
                DLabel.Parent = DTrigger

                local Chevron = Instance.new("ImageLabel")
                Chevron.Image = "rbxassetid://10709790948" -- Lucide Chevron Down
                Chevron.ImageColor3 = Theme.Primary
                Chevron.Size = UDim2.new(0, 14, 0, 14)
                Chevron.Position = UDim2.new(1, -22, 0.5, -7)
                Chevron.BackgroundTransparency = 1
                Chevron.Parent = DTrigger

                local OptionList = Instance.new("ScrollingFrame")
                OptionList.Size = UDim2.new(1, -12, 0, 130)
                OptionList.Position = UDim2.new(0, 6, 0, 38)
                OptionList.BackgroundTransparency = 1
                OptionList.ScrollBarThickness = 2
                OptionList.ScrollBarImageColor3 = Theme.Primary
                OptionList.Visible = false
                OptionList.Parent = DropFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 3)
                ListLayout.Parent = OptionList

                local DropdownObj = { Value = selected, Values = options }

                local function FormatLabel()
                    if isMulti then
                        if type(selected) == "table" and #selected > 0 then
                            DLabel.Text = name .. ": (" .. #selected .. " Selected)"
                        else
                            DLabel.Text = name .. ": (None)"
                        end
                    else
                        DLabel.Text = name .. ": " .. tostring(selected or "-")
                    end
                end
                FormatLabel()

                local function RenderOptions()
                    for _, c in ipairs(OptionList:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end

                    for _, opt in ipairs(options) do
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Size = UDim2.new(1, -4, 0, 26)
                        OptBtn.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
                        OptBtn.Text = tostring(opt)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.TextSize = 11

                        local isSelected = false
                        if isMulti and type(selected) == "table" then
                            isSelected = table.find(selected, opt) ~= nil
                        else
                            isSelected = (selected == opt)
                        end

                        OptBtn.TextColor3 = isSelected and Theme.Primary or Theme.TextMuted
                        OptBtn.Parent = OptionList

                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 4)
                        OptCorner.Parent = OptBtn

                        OptBtn.MouseButton1Click:Connect(function()
                            if isMulti then
                                if type(selected) ~= "table" then selected = {} end
                                local idx = table.find(selected, opt)
                                if idx then
                                    table.remove(selected, idx)
                                else
                                    table.insert(selected, opt)
                                end
                                OptBtn.TextColor3 = table.find(selected, opt) and Theme.Primary or Theme.TextMuted
                                FormatLabel()
                                DropdownObj.Value = selected
                                task.spawn(callback, selected)
                            else
                                selected = opt
                                DropdownObj.Value = selected
                                FormatLabel()
                                isExpanded = false
                                OptionList.Visible = false
                                Tween(DropFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 34) })
                                Tween(Chevron, TweenInfo.new(0.2), { Rotation = 0 })
                                task.spawn(callback, selected)
                            end
                        end)
                    end
                    OptionList.CanvasSize = UDim2.new(0, 0, 0, #options * 29)
                end
                RenderOptions()

                DTrigger.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    OptionList.Visible = isExpanded
                    local targetH = isExpanded and (42 + math.min(#options * 29, 130)) or 34
                    Tween(DropFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, targetH)
                    })
                    Tween(Chevron, TweenInfo.new(0.2), { Rotation = isExpanded and 180 or 0 })
                end)

                DropdownObj.Set = function(v)
                    selected = v
                    DropdownObj.Value = selected
                    FormatLabel()
                    RenderOptions()
                    task.spawn(callback, selected)
                end
                DropdownObj.SetValue = DropdownObj.Set
                DropdownObj.Select = DropdownObj.Set

                DropdownObj.SetValues = function(newOpts)
                    options = newOpts or {}
                    DropdownObj.Values = options
                    RenderOptions()
                end

                DropdownObj.Refresh = function(newOpts, newDefault)
                    options = newOpts or {}
                    DropdownObj.Values = options
                    if newDefault ~= nil then
                        selected = newDefault
                        DropdownObj.Value = selected
                        FormatLabel()
                    end
                    RenderOptions()
                end

                return DropdownObj
            end

            -- 5. INPUT
            function Elements:Input(inputConfig)
                inputConfig = inputConfig or {}
                local name = inputConfig.Title or inputConfig.Name or "Input"
                local val = inputConfig.Value or inputConfig.Default or ""
                local placeholder = inputConfig.Placeholder or "Type here..."
                local callback = inputConfig.Callback or function() end

                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, 34)
                InputFrame.BackgroundColor3 = Theme.SurfaceAlt
                InputFrame.Parent = targetParent

                local ICorner = Instance.new("UICorner")
                ICorner.CornerRadius = UDim.new(0, 6)
                ICorner.Parent = InputFrame

                local IStroke = Instance.new("UIStroke")
                IStroke.Color = Theme.Border
                IStroke.Thickness = 1
                IStroke.Parent = InputFrame

                local ILabel = Instance.new("TextLabel")
                ILabel.Text = name
                ILabel.Font = Enum.Font.GothamMedium
                ILabel.TextSize = 11.5
                ILabel.TextColor3 = Theme.Text
                ILabel.TextXAlignment = Enum.TextXAlignment.Left
                ILabel.Size = UDim2.new(1, -114, 1, 0)
                ILabel.Position = UDim2.new(0, 8, 0, 0)
                ILabel.BackgroundTransparency = 1
                ILabel.Parent = InputFrame

                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0, 96, 0, 24)
                Box.Position = UDim2.new(1, -104, 0.5, -12)
                Box.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
                Box.Text = tostring(val)
                Box.PlaceholderText = placeholder
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 11
                Box.TextColor3 = Theme.PrimaryLight
                Box.ClearTextOnFocus = false
                Box.Parent = InputFrame

                local BCorner = Instance.new("UICorner")
                BCorner.CornerRadius = UDim.new(0, 4)
                BCorner.Parent = Box

                local InputObj = { Value = val }

                Box.FocusLost:Connect(function()
                    InputObj.Value = Box.Text
                    task.spawn(callback, Box.Text)
                end)

                InputObj.Set = function(newText)
                    Box.Text = tostring(newText)
                    InputObj.Value = Box.Text
                    task.spawn(callback, Box.Text)
                end
                InputObj.SetValue = InputObj.Set

                return InputObj
            end

            -- 6. PARAGRAPH
            function Elements:Paragraph(pConfig)
                pConfig = pConfig or {}
                local title = pConfig.Title or "Info"
                local desc = pConfig.Desc or pConfig.Content or ""

                local PFrame = Instance.new("Frame")
                PFrame.Size = UDim2.new(1, 0, 0, 48)
                PFrame.AutomaticSize = Enum.AutomaticSize.Y
                PFrame.BackgroundColor3 = Theme.SurfaceAlt
                PFrame.Parent = targetParent

                local PCorner = Instance.new("UICorner")
                PCorner.CornerRadius = UDim.new(0, 6)
                PCorner.Parent = PFrame

                local PStroke = Instance.new("UIStroke")
                PStroke.Color = Theme.Border
                PStroke.Thickness = 1
                PStroke.Parent = PFrame

                local PPadding = Instance.new("UIPadding")
                PPadding.PaddingLeft = UDim.new(0, 10)
                PPadding.PaddingRight = UDim.new(0, 10)
                PPadding.PaddingTop = UDim.new(0, 8)
                PPadding.PaddingBottom = UDim.new(0, 8)
                PPadding.Parent = PFrame

                local PLayout = Instance.new("UIListLayout")
                PLayout.Padding = UDim.new(0, 4)
                PLayout.SortOrder = Enum.SortOrder.LayoutOrder
                PLayout.Parent = PFrame

                local PTitle = Instance.new("TextLabel")
                PTitle.Text = title
                PTitle.Font = Enum.Font.GothamBold
                PTitle.TextSize = 11.5
                PTitle.TextColor3 = Theme.PrimaryLight
                PTitle.TextXAlignment = Enum.TextXAlignment.Left
                PTitle.Size = UDim2.new(1, 0, 0, 14)
                PTitle.BackgroundTransparency = 1
                PTitle.Parent = PFrame

                local PDesc = Instance.new("TextLabel")
                PDesc.Text = desc
                PDesc.Font = Enum.Font.Gotham
                PDesc.TextSize = 10.5
                PDesc.TextColor3 = Theme.TextMuted
                PDesc.TextXAlignment = Enum.TextXAlignment.Left
                PDesc.TextWrapped = true
                PDesc.Size = UDim2.new(1, 0, 0, 0)
                PDesc.AutomaticSize = Enum.AutomaticSize.Y
                PDesc.BackgroundTransparency = 1
                PDesc.Parent = PFrame

                return {
                    SetTitle = function(self, t) PTitle.Text = tostring(t) end,
                    SetDesc = function(self, d) PDesc.Text = tostring(d) end,
                    Instance = PFrame
                }
            end

            -- 7. SECTION (Collapsible Card Groupbox dengan Aksen SysHub Electric Blue)
            function Elements:Section(secConfig)
                secConfig = secConfig or {}
                local secTitle = secConfig.Title or secConfig.Name or "Section"
                local isOpened = secConfig.Opened
                if isOpened == nil then isOpened = true end
                local categoryIcon = GetIconChar(secTitle)

                TabObject.SectionCount = TabObject.SectionCount + 1

                -- Card Outer Frame (Full-Width Seimbang Sempurna Sisi Kiri & Kanan)
                local SecCard = Instance.new("Frame")
                SecCard.Name = "Groupbox_" .. secTitle
                SecCard.LayoutOrder = TabObject.SectionCount
                SecCard.Size = UDim2.new(1, 0, 0, 36)
                SecCard.AutomaticSize = isOpened and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
                SecCard.BackgroundColor3 = Theme.Surface
                SecCard.ClipsDescendants = false
                SecCard.Parent = Page

                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 8)
                CardCorner.Parent = SecCard

                local CardStroke = Instance.new("UIStroke")
                CardStroke.Color = isOpened and Theme.Primary or Theme.Border
                CardStroke.Thickness = 1
                CardStroke.Parent = SecCard

                -- Header Button (Bisa Diklik Buka / Tutup)
                local SecHeader = Instance.new("TextButton")
                SecHeader.Name = "Header"
                SecHeader.Size = UDim2.new(1, 0, 0, 36)
                SecHeader.BackgroundTransparency = 1
                SecHeader.Text = ""
                SecHeader.AutoButtonColor = false
                SecHeader.Parent = SecCard

                -- Category Icon (Electric Blue)
                local CatIcon = Instance.new("TextLabel")
                CatIcon.Text = categoryIcon
                CatIcon.Font = Enum.Font.GothamBold
                CatIcon.TextSize = 13
                CatIcon.TextColor3 = Theme.Primary
                CatIcon.Size = UDim2.new(0, 20, 1, 0)
                CatIcon.Position = UDim2.new(0, 10, 0, 0)
                CatIcon.BackgroundTransparency = 1
                CatIcon.Parent = SecHeader

                local SecTitleLabel = Instance.new("TextLabel")
                SecTitleLabel.Name = "Title"
                SecTitleLabel.Text = secTitle
                SecTitleLabel.Font = Enum.Font.GothamBold
                SecTitleLabel.TextSize = 12
                SecTitleLabel.TextColor3 = Theme.Text
                SecTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                SecTitleLabel.Size = UDim2.new(1, -64, 1, 0)
                SecTitleLabel.Position = UDim2.new(0, 34, 0, 0)
                SecTitleLabel.BackgroundTransparency = 1
                SecTitleLabel.Parent = SecHeader

                -- Panah Chevron 100% Anti-Tofu Kotak Menggunakan ImageLabel
                local Arrow = Instance.new("ImageLabel")
                Arrow.Name = "Chevron"
                Arrow.Image = "rbxassetid://10709790948" -- Lucide Chevron Down
                Arrow.ImageColor3 = Theme.Primary
                Arrow.Size = UDim2.new(0, 14, 0, 14)
                Arrow.Position = UDim2.new(1, -26, 0.5, -7)
                Arrow.Rotation = isOpened and 0 or -90
                Arrow.BackgroundTransparency = 1
                Arrow.Parent = SecHeader

                -- Content Container (Menyimpan seluruh kontrol toggle/slider di section ini)
                local SecContent = Instance.new("Frame")
                SecContent.Name = "Content"
                SecContent.Size = UDim2.new(1, 0, 0, 0)
                SecContent.Position = UDim2.new(0, 0, 0, 36)
                SecContent.AutomaticSize = Enum.AutomaticSize.Y
                SecContent.BackgroundTransparency = 1
                SecContent.Visible = isOpened
                SecContent.Parent = SecCard

                local ContentPadding = Instance.new("UIPadding")
                ContentPadding.PaddingLeft = UDim.new(0, 8)
                ContentPadding.PaddingRight = UDim.new(0, 8)
                ContentPadding.PaddingTop = UDim.new(0, 2)
                ContentPadding.PaddingBottom = UDim.new(0, 10)
                ContentPadding.Parent = SecContent

                local ContentLayout = Instance.new("UIListLayout")
                ContentLayout.Padding = UDim.new(0, 6)
                ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ContentLayout.Parent = SecContent

                local function ToggleSection()
                    isOpened = not isOpened
                    SecContent.Visible = isOpened
                    SecCard.AutomaticSize = isOpened and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
                    if not isOpened then
                        SecCard.Size = UDim2.new(1, 0, 0, 36)
                    end
                    local targetRot = isOpened and 0 or -90
                    Tween(Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = targetRot })
                    Tween(CardStroke, TweenInfo.new(0.2), {
                        Color = isOpened and Theme.Primary or Theme.Border
                    })
                end

                SecHeader.MouseButton1Click:Connect(ToggleSection)

                -- Child elements build into SecContent!
                -- Catatan Penting: Method constructor :Toggle TETAP UTUH dan TIDAK DITIMPA!
                local SecElements = BuildElements(SecContent)
                SecElements.ToggleSection = function(self, state)
                    if state ~= nil then
                        if state ~= isOpened then ToggleSection() end
                    else
                        ToggleSection()
                    end
                end
                SecElements.SetOpened = SecElements.ToggleSection
                SecElements.Open = function() if not isOpened then ToggleSection() end end
                SecElements.Close = function() if isOpened then ToggleSection() end end
                SecElements.Instance = SecCard
                SecElements.Content = SecContent

                return SecElements
            end

            -- 8. USER PROFILE CARD (Komponen Khusus Profil Pemain Persis Gambar 1)
            function Elements:PlayerCard()
                local Card = Instance.new("Frame")
                Card.Name = "Card_UserProfileCard"
                Card.Size = UDim2.new(1, 0, 0, 0)
                Card.AutomaticSize = Enum.AutomaticSize.Y
                Card.BackgroundColor3 = Theme.Surface
                Card.Parent = LeftColumn

                local CCorner = Instance.new("UICorner")
                CCorner.CornerRadius = UDim.new(0, 8)
                CCorner.Parent = Card

                local CStroke = Instance.new("UIStroke")
                CStroke.Color = Theme.Border
                CStroke.Thickness = 1
                CStroke.Parent = Card

                -- Header User
                local HeaderRow = Instance.new("Frame")
                HeaderRow.Size = UDim2.new(1, 0, 0, 34)
                HeaderRow.BackgroundTransparency = 1
                HeaderRow.Parent = Card

                local UserIcon = Instance.new("TextLabel")
                UserIcon.Text = "👤"
                UserIcon.TextSize = 13
                UserIcon.Size = UDim2.new(0, 24, 1, 0)
                UserIcon.Position = UDim2.new(0, 10, 0, 0)
                UserIcon.BackgroundTransparency = 1
                UserIcon.TextColor3 = Theme.Primary
                UserIcon.Parent = HeaderRow

                local UserTitle = Instance.new("TextLabel")
                UserTitle.Text = "User"
                UserTitle.Font = Enum.Font.GothamBold
                UserTitle.TextSize = 12
                UserTitle.TextColor3 = Theme.Text
                UserTitle.TextXAlignment = Enum.TextXAlignment.Left
                UserTitle.Size = UDim2.new(1, -64, 1, 0)
                UserTitle.Position = UDim2.new(0, 34, 0, 0)
                UserTitle.BackgroundTransparency = 1
                UserTitle.Parent = HeaderRow

                local Chevron = Instance.new("ImageLabel")
                Chevron.Image = "rbxassetid://10709790948"
                Chevron.ImageColor3 = Theme.Primary
                Chevron.Size = UDim2.new(0, 14, 0, 14)
                Chevron.Position = UDim2.new(1, -26, 0.5, -7)
                Chevron.BackgroundTransparency = 1
                Chevron.Parent = HeaderRow

                local ContentFrame = Instance.new("Frame")
                ContentFrame.Name = "Content"
                ContentFrame.Size = UDim2.new(1, 0, 0, 0)
                ContentFrame.Position = UDim2.new(0, 0, 0, 34)
                ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
                ContentFrame.BackgroundTransparency = 1
                ContentFrame.Parent = Card

                local CPadding = Instance.new("UIPadding")
                CPadding.PaddingLeft = UDim.new(0, 10)
                CPadding.PaddingRight = UDim.new(0, 10)
                CPadding.PaddingTop = UDim.new(0, 4)
                CPadding.PaddingBottom = UDim.new(0, 10)
                CPadding.Parent = ContentFrame

                local CLayout = Instance.new("UIListLayout")
                CLayout.Padding = UDim.new(0, 6)
                CLayout.SortOrder = Enum.SortOrder.LayoutOrder
                CLayout.Parent = ContentFrame

                -- Avatar Image Thumbnail
                local AvatarImg = Instance.new("ImageLabel")
                AvatarImg.Size = UDim2.new(1, 0, 0, 130)
                AvatarImg.BackgroundColor3 = Color3.fromRGB(13, 16, 24)
                AvatarImg.ScaleType = Enum.ScaleType.Fit
                AvatarImg.Parent = ContentFrame

                local ACorner = Instance.new("UICorner")
                ACorner.CornerRadius = UDim.new(0, 6)
                ACorner.Parent = AvatarImg

                pcall(function()
                    local thumbType = Enum.ThumbnailType.AvatarBust
                    local thumbSize = Enum.ThumbnailSize.Size420x420
                    local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)
                    AvatarImg.Image = content
                end)

                -- Stat Info Lines
                local function AddStat(label, val, valColor)
                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 16)
                    Row.BackgroundTransparency = 1
                    Row.Parent = ContentFrame

                    local L = Instance.new("TextLabel")
                    L.Text = label .. " - "
                    L.Font = Enum.Font.GothamMedium
                    L.TextSize = 11
                    L.TextColor3 = Theme.TextMuted
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.Size = UDim2.new(0, 65, 1, 0)
                    L.BackgroundTransparency = 1
                    L.Parent = Row

                    local V = Instance.new("TextLabel")
                    V.Text = tostring(val)
                    V.Font = Enum.Font.GothamBold
                    V.TextSize = 11
                    V.TextColor3 = valColor or Theme.PrimaryLight
                    V.TextXAlignment = Enum.TextXAlignment.Left
                    V.Size = UDim2.new(1, -70, 1, 0)
                    V.Position = UDim2.new(0, 68, 0, 0)
                    V.BackgroundTransparency = 1
                    V.Parent = Row
                    return V
                end

                AddStat("User", LocalPlayer.DisplayName .. " @" .. LocalPlayer.Name, Theme.Text)
                AddStat("UserId", tostring(LocalPlayer.UserId), Theme.PrimaryLight)
                local execName = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Executor"
                AddStat("Executor", execName .. " ready", Theme.Success)

                local CopyUserBtn = Instance.new("TextButton")
                CopyUserBtn.Size = UDim2.new(1, 0, 0, 26)
                CopyUserBtn.BackgroundColor3 = Theme.SurfaceAlt
                CopyUserBtn.Text = "Copy Username"
                CopyUserBtn.Font = Enum.Font.Gotham
                CopyUserBtn.TextSize = 10.5
                CopyUserBtn.TextColor3 = Theme.TextMuted
                CopyUserBtn.AutoButtonColor = false
                CopyUserBtn.Parent = ContentFrame

                local CUCorner = Instance.new("UICorner")
                CUCorner.CornerRadius = UDim.new(0, 4)
                CUCorner.Parent = CopyUserBtn

                CopyUserBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if setclipboard then
                            setclipboard(LocalPlayer.Name)
                            SysHubUI:Notify({ Title = "Profile", Content = "Username copied to clipboard!", Duration = 2 })
                        end
                    end)
                end)

                return Card
            end

            -- 9. SESSION & SOCIALS CARD (Komponen Sesi Permainan Persis Gambar 1)
            function Elements:SessionCard()
                local Card = Instance.new("Frame")
                Card.Name = "Card_SessionCard"
                Card.Size = UDim2.new(1, 0, 0, 0)
                Card.AutomaticSize = Enum.AutomaticSize.Y
                Card.BackgroundColor3 = Theme.Surface
                Card.Parent = RightColumn

                local CCorner = Instance.new("UICorner")
                CCorner.CornerRadius = UDim.new(0, 8)
                CCorner.Parent = Card

                local CStroke = Instance.new("UIStroke")
                CStroke.Color = Theme.Border
                CStroke.Thickness = 1
                CStroke.Parent = Card

                local HeaderRow = Instance.new("Frame")
                HeaderRow.Size = UDim2.new(1, 0, 0, 34)
                HeaderRow.BackgroundTransparency = 1
                HeaderRow.Parent = Card

                local SIcon = Instance.new("TextLabel")
                SIcon.Text = "📊"
                SIcon.TextSize = 13
                SIcon.Size = UDim2.new(0, 24, 1, 0)
                SIcon.Position = UDim2.new(0, 10, 0, 0)
                SIcon.BackgroundTransparency = 1
                SIcon.TextColor3 = Theme.Primary
                SIcon.Parent = HeaderRow

                local STitle = Instance.new("TextLabel")
                STitle.Text = "Session"
                STitle.Font = Enum.Font.GothamBold
                STitle.TextSize = 12
                STitle.TextColor3 = Theme.Text
                STitle.TextXAlignment = Enum.TextXAlignment.Left
                STitle.Size = UDim2.new(1, -64, 1, 0)
                STitle.Position = UDim2.new(0, 34, 0, 0)
                STitle.BackgroundTransparency = 1
                STitle.Parent = HeaderRow

                local Chevron = Instance.new("ImageLabel")
                Chevron.Image = "rbxassetid://10709790948"
                Chevron.ImageColor3 = Theme.Primary
                Chevron.Size = UDim2.new(0, 14, 0, 14)
                Chevron.Position = UDim2.new(1, -26, 0.5, -7)
                Chevron.BackgroundTransparency = 1
                Chevron.Parent = HeaderRow

                local ContentFrame = Instance.new("Frame")
                ContentFrame.Name = "Content"
                ContentFrame.Size = UDim2.new(1, 0, 0, 0)
                ContentFrame.Position = UDim2.new(0, 0, 0, 34)
                ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
                ContentFrame.BackgroundTransparency = 1
                ContentFrame.Parent = Card

                local CPadding = Instance.new("UIPadding")
                CPadding.PaddingLeft = UDim.new(0, 10)
                CPadding.PaddingRight = UDim.new(0, 10)
                CPadding.PaddingTop = UDim.new(0, 4)
                CPadding.PaddingBottom = UDim.new(0, 10)
                CPadding.Parent = ContentFrame

                local CLayout = Instance.new("UIListLayout")
                CLayout.Padding = UDim.new(0, 6)
                CLayout.SortOrder = Enum.SortOrder.LayoutOrder
                CLayout.Parent = ContentFrame

                local function AddStat(label, val, valColor)
                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 16)
                    Row.BackgroundTransparency = 1
                    Row.Parent = ContentFrame

                    local L = Instance.new("TextLabel")
                    L.Text = label .. " - "
                    L.Font = Enum.Font.GothamMedium
                    L.TextSize = 11
                    L.TextColor3 = Theme.TextMuted
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.Size = UDim2.new(0, 65, 1, 0)
                    L.BackgroundTransparency = 1
                    L.Parent = Row

                    local V = Instance.new("TextLabel")
                    V.Text = tostring(val)
                    V.Font = Enum.Font.GothamBold
                    V.TextSize = 11
                    V.TextColor3 = valColor or Theme.PrimaryLight
                    V.TextXAlignment = Enum.TextXAlignment.Left
                    V.Size = UDim2.new(1, -70, 1, 0)
                    V.Position = UDim2.new(0, 68, 0, 0)
                    V.BackgroundTransparency = 1
                    V.Parent = Row
                    return V
                end

                AddStat("Game", detectedGameName, Theme.PrimaryLight)
                AddStat("Players", tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers), Theme.Success)
                local jobStr = (game.JobId and game.JobId ~= "") and (game.JobId:sub(1, 16) .. "...") or "Studio/Private"
                AddStat("Job", jobStr, Theme.TextMuted)

                local PingLabel = AddStat("Ping", "Calculating...", Theme.Warning)
                task.spawn(function()
                    while Card and Card.Parent do
                        pcall(function()
                            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                            if ping then PingLabel.Text = ping end
                        end)
                        task.wait(2)
                    end
                end)

                local RejoinBtn = Instance.new("TextButton")
                RejoinBtn.Size = UDim2.new(1, 0, 0, 26)
                RejoinBtn.BackgroundColor3 = Theme.SurfaceAlt
                RejoinBtn.Text = "Rejoin Place"
                RejoinBtn.Font = Enum.Font.Gotham
                RejoinBtn.TextSize = 10.5
                RejoinBtn.TextColor3 = Theme.Text
                RejoinBtn.AutoButtonColor = false
                RejoinBtn.Parent = ContentFrame

                local RJCorner = Instance.new("UICorner")
                RJCorner.CornerRadius = UDim.new(0, 4)
                RJCorner.Parent = RejoinBtn

                RejoinBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if #Players:GetPlayers() <= 1 then
                            LocalPlayer:Kick("\nRejoining...")
                            task.wait(0.1)
                            TeleportService:Teleport(game.PlaceId, LocalPlayer)
                        else
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                        end
                    end)
                end)

                local CopyJobBtn = Instance.new("TextButton")
                CopyJobBtn.Size = UDim2.new(1, 0, 0, 26)
                CopyJobBtn.BackgroundColor3 = Theme.SurfaceAlt
                CopyJobBtn.Text = "Copy Job ID"
                CopyJobBtn.Font = Enum.Font.Gotham
                CopyJobBtn.TextSize = 10.5
                CopyJobBtn.TextColor3 = Theme.TextMuted
                CopyJobBtn.AutoButtonColor = false
                CopyJobBtn.Parent = ContentFrame

                local CJCorner = Instance.new("UICorner")
                CJCorner.CornerRadius = UDim.new(0, 4)
                CJCorner.Parent = CopyJobBtn

                CopyJobBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if setclipboard then
                            setclipboard(game.JobId)
                            SysHubUI:Notify({ Title = "Server", Content = "Job ID copied to clipboard!", Duration = 2 })
                        end
                    end)
                end)

                return Card
            end

            return Elements
        end

        local TabElements = BuildElements(LeftColumn)
        TabObject.Section = TabElements.Section
        for k, v in pairs(TabElements) do
            TabObject[k] = v
        end

        -- Jika Tab adalah "Player" atau memiliki flag PlayerProfile, render komponen Profil & Sesi
        if tabName:lower():find("player") or tabConfig.PlayerProfile == true then
            pcall(function()
                TabElements:PlayerCard()
                TabElements:SessionCard()
            end)
        end

        return TabObject
    end

    -- Alias CreateTab = Tab
    WindowHandler.CreateTab = WindowHandler.Tab

    SysHubUI:Notify({
        Title = "⚡ SysHub Electric Dashboard",
        Content = "Press [" .. ToggleKey.Name .. "] to toggle UI",
        Duration = 4,
        Color = Theme.Primary
    })

    return WindowHandler
end

-- Export Global & Return
SysHubUI.Notify = SysHubUI.Notify
return SysHubUI
