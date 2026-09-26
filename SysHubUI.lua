--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                         SYSHUB UI FOR ROBLOX                      ║
    ║       Futuristic Frosted Glass & Holographic Component Suite      ║
    ║        Complete WindUI Compatibility & High-Performance Core      ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

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
    Version = "2.0.0",
    Windows = {},
    DefaultKeybind = Enum.KeyCode.RightControl
}

-- HTTP Request Wrapper (Kompatibel dengan WindUI.Creator.Request)
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

-- Theme Colors (SysHub Holographic Glass Palette)
local Theme = {
    Bg = Color3.fromRGB(11, 13, 20),
    BgTransparent = 0.16,
    Surface = Color3.fromRGB(18, 22, 34),
    SurfaceTransparent = 0.35,
    SurfaceHover = Color3.fromRGB(28, 34, 52),
    
    HoloCyan = Color3.fromRGB(0, 242, 254),
    HoloPurple = Color3.fromRGB(168, 85, 247),
    HoloPink = Color3.fromRGB(244, 63, 94),
    HoloEmerald = Color3.fromRGB(16, 185, 129),
    
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(148, 163, 184),
    Border = Color3.fromRGB(255, 255, 255),
    BorderTransparency = 0.82
}

-- Utility Animation Helper
local function Tween(instance, info, properties)
    local anim = TweenService:Create(instance, info, properties)
    anim:Play()
    return anim
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
NotificationContainer.Size = UDim2.new(0, 320, 1, -40)
NotificationContainer.Position = UDim2.new(1, -336, 0, 20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = NotificationGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.Parent = NotificationContainer

function SysHubUI:Notify(config)
    config = config or {}
    local title = config.Title or "SysHub UI"
    local content = config.Content or config.Desc or "Notifikasi sistem"
    local duration = config.Duration or 3.5
    local color = config.Color or Theme.HoloCyan

    local NotifCard = Instance.new("Frame")
    NotifCard.Name = "NotifCard"
    NotifCard.Size = UDim2.new(1, 0, 0, 0)
    NotifCard.BackgroundColor3 = Theme.Bg
    NotifCard.BackgroundTransparency = 0.15
    NotifCard.ClipsDescendants = true
    NotifCard.Parent = NotificationContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = NotifCard

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = color
    Stroke.Thickness = 1.2
    Stroke.Transparency = 0.3
    Stroke.Parent = NotifCard

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -24, 1, -16)
    ContentFrame.Position = UDim2.new(0, 12, 0, 8)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = NotifCard

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextColor3 = color
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = ContentFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = content
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 11.5
    DescLabel.TextColor3 = Theme.TextMuted
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Size = UDim2.new(1, 0, 1, -20)
    DescLabel.Position = UDim2.new(0, 0, 0, 18)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Parent = ContentFrame

    Tween(NotifCard, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 68)
    })

    task.delay(duration, function()
        if NotifCard and NotifCard.Parent then
            local closeAnim = Tween(NotifCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1
            })
            closeAnim.Completed:Connect(function()
                NotifCard:Destroy()
            end)
        end
    end)
end

-- ==============================================================================
-- [2] CREATE WINDOW (Kaca & Hologram)
-- ==============================================================================
function SysHubUI:CreateWindow(windowConfig)
    windowConfig = windowConfig or {}
    local TitleText = windowConfig.Title or "SYSHUB - GROW A CHICKEN FIGHTER"
    local SubtitleText = windowConfig.Subtitle or windowConfig.Author or "Premium Glass Suite"
    local ToggleKey = windowConfig.Keybind or SysHubUI.DefaultKeybind
    local WindowSize = windowConfig.Size or UDim2.fromOffset(680, 440)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SysHub_GlassUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = GetGuiParent()

    -- Main Floating Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = WindowSize
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset / 2, 0.5, -WindowSize.Y.Offset / 2)
    MainFrame.BackgroundColor3 = Theme.Bg
    MainFrame.BackgroundTransparency = Theme.BgTransparent
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    -- Holographic Iridescent Stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.4
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.2
    MainStroke.Parent = MainFrame

    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Theme.HoloCyan),
        ColorSequenceKeypoint.new(0.5, Theme.HoloPurple),
        ColorSequenceKeypoint.new(1.0, Theme.HoloPink)
    })
    StrokeGradient.Rotation = 45
    StrokeGradient.Parent = MainStroke

    -- Glow Shadow Layer
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "DropShadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    Shadow.Size = UDim2.new(1, 48, 1, 48)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Theme.HoloCyan
    Shadow.ImageTransparency = 0.82
    Shadow.ZIndex = MainFrame.ZIndex - 1
    Shadow.Parent = MainFrame

    -- HEADER BAR (Draggable)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 48)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local HeaderLine = Instance.new("Frame")
    HeaderLine.Name = "HeaderLine"
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeaderLine.BackgroundTransparency = 0.88
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    -- Brand Icon Orb
    local Orb = Instance.new("Frame")
    Orb.Name = "BrandOrb"
    Orb.Size = UDim2.new(0, 24, 0, 24)
    Orb.Position = UDim2.new(0, 16, 0.5, -12)
    Orb.BackgroundColor3 = Theme.HoloCyan
    Orb.BorderSizePixel = 0
    Orb.Parent = Header

    local OrbCorner = Instance.new("UICorner")
    OrbCorner.CornerRadius = UDim.new(1, 0)
    OrbCorner.Parent = Orb

    local OrbGradient = Instance.new("UIGradient")
    OrbGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Theme.HoloCyan),
        ColorSequenceKeypoint.new(1.0, Theme.HoloPurple)
    })
    OrbGradient.Rotation = 135
    OrbGradient.Parent = Orb

    local OrbIcon = Instance.new("TextLabel")
    OrbIcon.Text = "✦"
    OrbIcon.Font = Enum.Font.GothamBold
    OrbIcon.TextSize = 13
    OrbIcon.TextColor3 = Color3.fromRGB(10, 12, 18)
    OrbIcon.Size = UDim2.new(1, 0, 1, 0)
    OrbIcon.BackgroundTransparency = 1
    OrbIcon.Parent = Orb

    -- Window Titles
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = TitleText
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 50, 0, 9)
    Title.Size = UDim2.new(0, 350, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Text = SubtitleText
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 11
    Subtitle.TextColor3 = Theme.HoloCyan
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Position = UDim2.new(0, 50, 0, 26)
    Subtitle.Size = UDim2.new(0, 350, 0, 14)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Parent = Header

    -- Close & Minimize Buttons
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.TextColor3 = Theme.TextMuted
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundTransparency = 0.95
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.HoloPink,
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
    end)

    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.95,
            TextColor3 = Theme.TextMuted
        })
    end)

    local isVisible = true
    CloseBtn.MouseButton1Click:Connect(function()
        isVisible = false
        MainFrame.Visible = false
    end)

    -- Draggable Logic
    local dragging = false
    local dragInput, dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Keybind Visibility Toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end
    end)

    -- SIDEBAR NAVIGATION TABS
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -49)
    Sidebar.Position = UDim2.new(0, 0, 0, 49)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Name = "SidebarLine"
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarLine.BackgroundTransparency = 0.88
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, -12, 1, -12)
    TabScroll.Position = UDim2.new(0, 6, 0, 6)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabScroll

    -- MAIN CONTENT CONTAINER
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -152, 1, -59)
    ContentContainer.Position = UDim2.new(0, 146, 0, 53)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local WindowHandler = {
        Tabs = {},
        CurrentTab = nil
    }

    -- Floating Mobile Button Handler (Kompatibel dengan WindUI:EditOpenButton)
    function WindowHandler:EditOpenButton(cfg)
        cfg = cfg or {}
        local OpenScreen = Instance.new("ScreenGui")
        OpenScreen.Name = "SysHubOpenBtnGui"
        OpenScreen.ResetOnSpawn = false
        OpenScreen.Parent = GetGuiParent()

        local FloatBtn = Instance.new("TextButton")
        FloatBtn.Name = "SysHubFloatBtn"
        FloatBtn.Size = UDim2.fromOffset(50, 50)
        FloatBtn.Position = UDim2.new(0, 20, 0.5, -25)
        FloatBtn.BackgroundColor3 = Theme.Bg
        FloatBtn.BackgroundTransparency = 0.2
        FloatBtn.Text = "✦"
        FloatBtn.Font = Enum.Font.GothamBold
        FloatBtn.TextSize = 20
        FloatBtn.TextColor3 = Theme.HoloCyan
        FloatBtn.Parent = OpenScreen

        local FCorner = Instance.new("UICorner")
        FCorner.CornerRadius = UDim.new(1, 0)
        FCorner.Parent = FloatBtn

        local FStroke = Instance.new("UIStroke")
        FStroke.Color = Theme.HoloCyan
        FStroke.Thickness = 1.5
        FStroke.Parent = FloatBtn

        FloatBtn.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            MainFrame.Visible = isVisible
        end)
    end

    -- ==============================================================================
    -- [3] CREATE TAB
    -- ==============================================================================
    function WindowHandler:Tab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Title or tabConfig.Name or "Tab"
        local iconText = tabConfig.Icon or "✦"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "Tab_" .. tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 0.96
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabScroll

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabBtn

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 3, 0, 16)
        TabIndicator.Position = UDim2.new(0, 4, 0.5, -8)
        TabIndicator.BackgroundColor3 = Theme.HoloCyan
        TabIndicator.BackgroundTransparency = 1
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Parent = TabBtn

        local TabIndCorner = Instance.new("UICorner")
        TabIndCorner.CornerRadius = UDim.new(1, 0)
        TabIndCorner.Parent = TabIndicator

        local Label = Instance.new("TextLabel")
        Label.Text = tabName
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 12.5
        Label.TextColor3 = Theme.TextMuted
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Position = UDim2.new(0, 14, 0, 0)
        Label.Size = UDim2.new(1, -14, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Parent = TabBtn

        -- Tab Content Scroll
        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page_" .. tabName
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.HoloCyan
        Page.ScrollBarImageTransparency = 0.5
        Page.Visible = false
        Page.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 16)
        end)

        local TabObject = {
            Button = TabBtn,
            Page = Page
        }

        local function ActivateTab()
            for _, t in pairs(WindowHandler.Tabs) do
                t.Page.Visible = false
                Tween(t.Button, TweenInfo.new(0.2), { BackgroundTransparency = 0.96 })
                Tween(t.Button.Indicator, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
                t.Button.TextLabel.TextColor3 = Theme.TextMuted
                t.Button.TextLabel.Font = Enum.Font.GothamMedium
            end

            Page.Visible = true
            Tween(TabBtn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.88,
                BackgroundColor3 = Theme.HoloCyan
            })
            Tween(TabIndicator, TweenInfo.new(0.2), { BackgroundTransparency = 0 })
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamBold
            WindowHandler.CurrentTab = TabObject
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        if #WindowHandler.Tabs == 0 then
            ActivateTab()
        end

        table.insert(WindowHandler.Tabs, TabObject)

        -- Builder Helper
        local function BuildElements(targetParent)
            local Elements = {}

            -- 1. BUTTON
            function Elements:Button(btnConfig)
                btnConfig = btnConfig or {}
                local name = btnConfig.Title or btnConfig.Name or "Button"
                local callback = btnConfig.Callback or function() end

                local BtnFrame = Instance.new("TextButton")
                BtnFrame.Size = UDim2.new(1, -6, 0, 36)
                BtnFrame.BackgroundColor3 = Theme.Surface
                BtnFrame.BackgroundTransparency = Theme.SurfaceTransparent
                BtnFrame.Text = ""
                BtnFrame.AutoButtonColor = false
                BtnFrame.Parent = targetParent

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = BtnFrame

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Theme.Border
                BtnStroke.Transparency = Theme.BorderTransparency
                BtnStroke.Thickness = 1
                BtnStroke.Parent = BtnFrame

                local BtnLabel = Instance.new("TextLabel")
                BtnLabel.Text = name
                BtnLabel.Font = Enum.Font.GothamBold
                BtnLabel.TextSize = 12.5
                BtnLabel.TextColor3 = Theme.Text
                BtnLabel.Size = UDim2.new(1, -40, 1, 0)
                BtnLabel.Position = UDim2.new(0, 12, 0, 0)
                BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
                BtnLabel.BackgroundTransparency = 1
                BtnLabel.Parent = BtnFrame

                local Arrow = Instance.new("TextLabel")
                Arrow.Text = "➜"
                Arrow.Font = Enum.Font.GothamBold
                Arrow.TextSize = 11
                Arrow.TextColor3 = Theme.HoloCyan
                Arrow.Size = UDim2.new(0, 20, 1, 0)
                Arrow.Position = UDim2.new(1, -26, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Parent = BtnFrame

                BtnFrame.MouseEnter:Connect(function()
                    Tween(BtnFrame, TweenInfo.new(0.2), { BackgroundColor3 = Theme.SurfaceHover, BackgroundTransparency = 0.15 })
                    Tween(BtnStroke, TweenInfo.new(0.2), { Color = Theme.HoloCyan, Transparency = 0.3 })
                end)

                BtnFrame.MouseLeave:Connect(function()
                    Tween(BtnFrame, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Surface, BackgroundTransparency = Theme.SurfaceTransparent })
                    Tween(BtnStroke, TweenInfo.new(0.2), { Color = Theme.Border, Transparency = Theme.BorderTransparency })
                end)

                BtnFrame.MouseButton1Down:Connect(function()
                    Tween(BtnFrame, TweenInfo.new(0.08), { Size = UDim2.new(1, -12, 0, 34) })
                end)

                BtnFrame.MouseButton1Up:Connect(function()
                    Tween(BtnFrame, TweenInfo.new(0.08), { Size = UDim2.new(1, -6, 0, 36) })
                    task.spawn(callback)
                end)

                return {
                    Instance = BtnFrame
                }
            end

            -- 2. TOGGLE
            function Elements:Toggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local name = toggleConfig.Title or toggleConfig.Name or "Toggle Option"
                local state = toggleConfig.Value
                if state == nil then state = toggleConfig.Default end
                if state == nil then state = false end
                local callback = toggleConfig.Callback or function() end

                local ToggleFrame = Instance.new("TextButton")
                ToggleFrame.Size = UDim2.new(1, -6, 0, 38)
                ToggleFrame.BackgroundColor3 = Theme.Surface
                ToggleFrame.BackgroundTransparency = Theme.SurfaceTransparent
                ToggleFrame.Text = ""
                ToggleFrame.AutoButtonColor = false
                ToggleFrame.Parent = targetParent

                local TCorner = Instance.new("UICorner")
                TCorner.CornerRadius = UDim.new(0, 8)
                TCorner.Parent = ToggleFrame

                local TStroke = Instance.new("UIStroke")
                TStroke.Color = Theme.Border
                TStroke.Transparency = Theme.BorderTransparency
                TStroke.Thickness = 1
                TStroke.Parent = ToggleFrame

                local TLabel = Instance.new("TextLabel")
                TLabel.Text = name
                TLabel.Font = Enum.Font.GothamMedium
                TLabel.TextSize = 12.5
                TLabel.TextColor3 = Theme.Text
                TLabel.Size = UDim2.new(1, -65, 1, 0)
                TLabel.Position = UDim2.new(0, 12, 0, 0)
                TLabel.TextXAlignment = Enum.TextXAlignment.Left
                TLabel.BackgroundTransparency = 1
                TLabel.Parent = ToggleFrame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(0, 38, 0, 20)
                Track.Position = UDim2.new(1, -48, 0.5, -10)
                Track.BackgroundColor3 = state and Theme.HoloCyan or Color3.fromRGB(35, 40, 55)
                Track.Parent = ToggleFrame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 14, 0, 14)
                Knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Knob.Parent = Track

                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = Knob

                local ToggleObj = { Value = state }

                local function UpdateState(val)
                    state = (val == true)
                    ToggleObj.Value = state
                    local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    local targetColor = state and Theme.HoloCyan or Color3.fromRGB(35, 40, 55)

                    Tween(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = targetPos })
                    Tween(Track, TweenInfo.new(0.2), { BackgroundColor3 = targetColor })
                    task.spawn(callback, state)
                end

                ToggleFrame.MouseButton1Click:Connect(function()
                    UpdateState(not state)
                end)

                ToggleObj.Set = UpdateState
                ToggleObj.SetValue = UpdateState
                return ToggleObj
            end

            -- 3. SLIDER
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
                SliderFrame.Size = UDim2.new(1, -6, 0, 48)
                SliderFrame.BackgroundColor3 = Theme.Surface
                SliderFrame.BackgroundTransparency = Theme.SurfaceTransparent
                SliderFrame.Parent = targetParent

                local SCorner = Instance.new("UICorner")
                SCorner.CornerRadius = UDim.new(0, 8)
                SCorner.Parent = SliderFrame

                local SStroke = Instance.new("UIStroke")
                SStroke.Color = Theme.Border
                SStroke.Transparency = Theme.BorderTransparency
                SStroke.Thickness = 1
                SStroke.Parent = SliderFrame

                local SLabel = Instance.new("TextLabel")
                SLabel.Text = name
                SLabel.Font = Enum.Font.GothamMedium
                SLabel.TextSize = 12.5
                SLabel.TextColor3 = Theme.Text
                SLabel.Size = UDim2.new(1, -80, 0, 18)
                SLabel.Position = UDim2.new(0, 12, 0, 6)
                SLabel.TextXAlignment = Enum.TextXAlignment.Left
                SLabel.BackgroundTransparency = 1
                SLabel.Parent = SliderFrame

                local SValue = Instance.new("TextLabel")
                SValue.Text = tostring(default) .. suffix
                SValue.Font = Enum.Font.GothamBold
                SValue.TextSize = 12
                SValue.TextColor3 = Theme.HoloCyan
                SValue.Size = UDim2.new(0, 60, 0, 18)
                SValue.Position = UDim2.new(1, -72, 0, 6)
                SValue.TextXAlignment = Enum.TextXAlignment.Right
                SValue.BackgroundTransparency = 1
                SValue.Parent = SliderFrame

                local TrackBar = Instance.new("TextButton")
                TrackBar.Size = UDim2.new(1, -24, 0, 6)
                TrackBar.Position = UDim2.new(0, 12, 0, 32)
                TrackBar.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
                TrackBar.Text = ""
                TrackBar.AutoButtonColor = false
                TrackBar.Parent = SliderFrame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = TrackBar

                local FillBar = Instance.new("Frame")
                FillBar.Size = UDim2.new(math.clamp((default - min) / math.max(max - min, 1), 0, 1), 0, 1, 0)
                FillBar.BackgroundColor3 = Theme.HoloCyan
                FillBar.BorderSizePixel = 0
                FillBar.Parent = TrackBar

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = FillBar

                local SliderObj = { Value = currentVal }

                local function UpdateVal(val, fireCallback)
                    currentVal = math.clamp(val, min, max)
                    SliderObj.Value = currentVal
                    local percentage = math.clamp((currentVal - min) / math.max(max - min, 1), 0, 1)
                    FillBar.Size = UDim2.new(percentage, 0, 1, 0)
                    SValue.Text = tostring(currentVal) .. suffix
                    if fireCallback ~= false then
                        task.spawn(callback, currentVal)
                    end
                end

                local isDragging = false
                TrackBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        local percentage = math.clamp((input.Position.X - TrackBar.AbsolutePosition.X) / TrackBar.AbsoluteSize.X, 0, 1)
                        UpdateVal(math.floor(min + (max - min) * percentage), true)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percentage = math.clamp((input.Position.X - TrackBar.AbsolutePosition.X) / TrackBar.AbsoluteSize.X, 0, 1)
                        UpdateVal(math.floor(min + (max - min) * percentage), true)
                    end
                end)

                SliderObj.Set = function(v) UpdateVal(tonumber(v) or min, true) end
                SliderObj.SetValue = SliderObj.Set
                return SliderObj
            end

            -- 4. DROPDOWN (Multi & Single Select)
            function Elements:Dropdown(dropConfig)
                dropConfig = dropConfig or {}
                local name = dropConfig.Title or dropConfig.Name or "Pilihan Menu"
                local options = dropConfig.Values or dropConfig.Options or {}
                local isMulti = dropConfig.Multi or false
                local default = dropConfig.Value or dropConfig.Default or (isMulti and {} or options[1])
                local callback = dropConfig.Callback or function() end

                local isExpanded = false
                local selected = default

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -6, 0, 38)
                DropFrame.BackgroundColor3 = Theme.Surface
                DropFrame.BackgroundTransparency = Theme.SurfaceTransparent
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = targetParent

                local DCorner = Instance.new("UICorner")
                DCorner.CornerRadius = UDim.new(0, 8)
                DCorner.Parent = DropFrame

                local DStroke = Instance.new("UIStroke")
                DStroke.Color = Theme.Border
                DStroke.Transparency = Theme.BorderTransparency
                DStroke.Thickness = 1
                DStroke.Parent = DropFrame

                local DTrigger = Instance.new("TextButton")
                DTrigger.Size = UDim2.new(1, 0, 0, 38)
                DTrigger.BackgroundTransparency = 1
                DTrigger.Text = ""
                DTrigger.Parent = DropFrame

                local DLabel = Instance.new("TextLabel")
                DLabel.Font = Enum.Font.GothamMedium
                DLabel.TextSize = 12
                DLabel.TextColor3 = Theme.Text
                DLabel.Size = UDim2.new(1, -36, 0, 38)
                DLabel.Position = UDim2.new(0, 12, 0, 0)
                DLabel.TextXAlignment = Enum.TextXAlignment.Left
                DLabel.TextTruncate = Enum.TextTruncate.AtEnd
                DLabel.BackgroundTransparency = 1
                DLabel.Parent = DTrigger

                local Chevron = Instance.new("TextLabel")
                Chevron.Text = "▼"
                Chevron.Font = Enum.Font.GothamBold
                Chevron.TextSize = 10
                Chevron.TextColor3 = Theme.HoloCyan
                Chevron.Size = UDim2.new(0, 20, 0, 38)
                Chevron.Position = UDim2.new(1, -26, 0, 0)
                Chevron.BackgroundTransparency = 1
                Chevron.Parent = DTrigger

                local OptionList = Instance.new("ScrollingFrame")
                OptionList.Size = UDim2.new(1, -16, 0, 140)
                OptionList.Position = UDim2.new(0, 8, 0, 42)
                OptionList.BackgroundTransparency = 1
                OptionList.ScrollBarThickness = 3
                OptionList.ScrollBarImageColor3 = Theme.HoloCyan
                OptionList.Parent = DropFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 4)
                ListLayout.Parent = OptionList

                local DropdownObj = {
                    Value = selected,
                    Values = options
                }

                local function FormatLabel()
                    if isMulti then
                        if type(selected) == "table" and #selected > 0 then
                            DLabel.Text = name .. ": (" .. #selected .. " terpilih)"
                        else
                            DLabel.Text = name .. ": (Kosong)"
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
                        OptBtn.Size = UDim2.new(1, -4, 0, 28)
                        OptBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
                        OptBtn.BackgroundTransparency = 0.5
                        OptBtn.Text = tostring(opt)
                        OptBtn.Font = Enum.Font.Gotham
                        OptBtn.TextSize = 11.5
                        
                        local isSelected = false
                        if isMulti and type(selected) == "table" then
                            isSelected = table.find(selected, opt) ~= nil
                        else
                            isSelected = (selected == opt)
                        end

                        OptBtn.TextColor3 = isSelected and Theme.HoloCyan or Theme.TextMuted
                        OptBtn.Parent = OptionList

                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 6)
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
                                OptBtn.TextColor3 = table.find(selected, opt) and Theme.HoloCyan or Theme.TextMuted
                                FormatLabel()
                                DropdownObj.Value = selected
                                task.spawn(callback, selected)
                            else
                                selected = opt
                                DropdownObj.Value = selected
                                FormatLabel()
                                isExpanded = false
                                Tween(DropFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, -6, 0, 38) })
                                Tween(Chevron, TweenInfo.new(0.2), { Rotation = 0 })
                                task.spawn(callback, selected)
                            end
                        end)
                    end
                    OptionList.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
                end
                RenderOptions()

                local function ToggleMenu()
                    isExpanded = not isExpanded
                    local targetHeight = isExpanded and (48 + math.min(#options * 32, 140)) or 38
                    local targetRot = isExpanded and 180 or 0

                    Tween(DropFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -6, 0, targetHeight)
                    })
                    Tween(Chevron, TweenInfo.new(0.2), { Rotation = targetRot })
                end

                DTrigger.MouseButton1Click:Connect(ToggleMenu)

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
                local placeholder = inputConfig.Placeholder or "Ketik di sini..."
                local callback = inputConfig.Callback or function() end

                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, -6, 0, 38)
                InputFrame.BackgroundColor3 = Theme.Surface
                InputFrame.BackgroundTransparency = Theme.SurfaceTransparent
                InputFrame.Parent = targetParent

                local ICorner = Instance.new("UICorner")
                ICorner.CornerRadius = UDim.new(0, 8)
                ICorner.Parent = InputFrame

                local IStroke = Instance.new("UIStroke")
                IStroke.Color = Theme.Border
                IStroke.Transparency = Theme.BorderTransparency
                IStroke.Thickness = 1
                IStroke.Parent = InputFrame

                local ILabel = Instance.new("TextLabel")
                ILabel.Text = name
                ILabel.Font = Enum.Font.GothamMedium
                ILabel.TextSize = 12
                ILabel.TextColor3 = Theme.Text
                ILabel.Size = UDim2.new(0.5, -12, 1, 0)
                ILabel.Position = UDim2.new(0, 12, 0, 0)
                ILabel.TextXAlignment = Enum.TextXAlignment.Left
                ILabel.BackgroundTransparency = 1
                ILabel.Parent = InputFrame

                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.48, -12, 0, 26)
                Box.Position = UDim2.new(0.52, 0, 0.5, -13)
                Box.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
                Box.BackgroundTransparency = 0.5
                Box.Text = tostring(val)
                Box.PlaceholderText = placeholder
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 12
                Box.TextColor3 = Theme.HoloCyan
                Box.ClearTextOnFocus = false
                Box.Parent = InputFrame

                local BCorner = Instance.new("UICorner")
                BCorner.CornerRadius = UDim.new(0, 6)
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
                local title = pConfig.Title or "Information"
                local desc = pConfig.Desc or pConfig.Content or ""

                local PFrame = Instance.new("Frame")
                PFrame.Size = UDim2.new(1, -6, 0, 56)
                PFrame.BackgroundColor3 = Theme.Surface
                PFrame.BackgroundTransparency = 0.45
                PFrame.Parent = targetParent

                local PCorner = Instance.new("UICorner")
                PCorner.CornerRadius = UDim.new(0, 8)
                PCorner.Parent = PFrame

                local PStroke = Instance.new("UIStroke")
                PStroke.Color = Theme.HoloCyan
                PStroke.Transparency = 0.7
                PStroke.Thickness = 1
                PStroke.Parent = PFrame

                local PTitle = Instance.new("TextLabel")
                PTitle.Text = title
                PTitle.Font = Enum.Font.GothamBold
                PTitle.TextSize = 12.5
                PTitle.TextColor3 = Theme.HoloCyan
                PTitle.Size = UDim2.new(1, -20, 0, 18)
                PTitle.Position = UDim2.new(0, 10, 0, 8)
                PTitle.TextXAlignment = Enum.TextXAlignment.Left
                PTitle.BackgroundTransparency = 1
                PTitle.Parent = PFrame

                local PDesc = Instance.new("TextLabel")
                PDesc.Text = desc
                PDesc.Font = Enum.Font.Gotham
                PDesc.TextSize = 11
                PDesc.TextColor3 = Theme.TextMuted
                PDesc.TextXAlignment = Enum.TextXAlignment.Left
                PDesc.TextWrapped = true
                PDesc.Size = UDim2.new(1, -20, 1, -28)
                PDesc.Position = UDim2.new(0, 10, 0, 26)
                PDesc.BackgroundTransparency = 1
                PDesc.Parent = PFrame

                return {
                    SetTitle = function(self, t) PTitle.Text = tostring(t) end,
                    SetDesc = function(self, d) PDesc.Text = tostring(d) end,
                    Instance = PFrame
                }
            end

            -- 7. SECTION (Collapsible Card Section)
            function Elements:Section(secConfig)
                secConfig = secConfig or {}
                local secTitle = secConfig.Title or secConfig.Name or "Section"

                local SecContainer = Instance.new("Frame")
                SecContainer.Name = "Sec_" .. secTitle
                SecContainer.Size = UDim2.new(1, 0, 0, 24)
                SecContainer.BackgroundTransparency = 1
                SecContainer.Parent = targetParent

                local SecTitleLabel = Instance.new("TextLabel")
                SecTitleLabel.Text = "✦ " .. string.upper(secTitle)
                SecTitleLabel.Font = Enum.Font.GothamBold
                SecTitleLabel.TextSize = 11.5
                SecTitleLabel.TextColor3 = Theme.HoloPurple
                SecTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                SecTitleLabel.Size = UDim2.new(1, 0, 1, 0)
                SecTitleLabel.Position = UDim2.new(0, 4, 0, 0)
                SecTitleLabel.BackgroundTransparency = 1
                SecTitleLabel.Parent = SecContainer

                -- Section inherits all element methods to place inside this page!
                return BuildElements(targetParent)
            end

            return Elements
        end

        local TabElements = BuildElements(Page)
        TabObject.Section = TabElements.Section
        for k, v in pairs(TabElements) do
            TabObject[k] = v
        end

        return TabObject
    end

    -- Alias CreateTab = Tab
    WindowHandler.CreateTab = WindowHandler.Tab

    SysHubUI:Notify({
        Title = "✦ SysHub Glass UI Active",
        Content = "Tekan [" .. ToggleKey.Name .. "] untuk Buka/Tutup Menu",
        Duration = 4,
        Color = Theme.HoloCyan
    })

    return WindowHandler
end

-- Export Global & Return
SysHubUI.Notify = SysHubUI.Notify
return SysHubUI
