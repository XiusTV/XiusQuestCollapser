--[[
    Xius Quest Collapser
    An arrow on the seam between the world map and the quest log.
    Click it to fold the list away, or to open it again.
    The same button works on the default map and while OpenMap is loaded.
]]

local SIZE = 30
local TOP_GAP = 4

local btn
local mapHooked = false
local logHooked = false
local watching = false

local function Say(text)
    local frame = DEFAULT_CHAT_FRAME
    if frame then
        frame:AddMessage("|cffffd100Xius Quest Collapser:|r " .. text)
    end
end

local function MapFrame()
    return _G.WorldMapFrame
end

local function IsMaximized(map)
    if map and map.IsMaximized then
        local ok, value = pcall(map.IsMaximized, map)
        if ok then
            return value and true or false
        end
    end
    return false
end

local function LogFrame(map)
    if map and map.QuestLog then
        return map.QuestLog
    end
    return _G.QuestMapFrame
end

local function Canvas(map)
    if map.ScrollContainer then
        return map.ScrollContainer
    end
    if map.GetCanvasContainer then
        local ok, canvas = pcall(map.GetCanvasContainer, map)
        if ok and canvas then
            return canvas
        end
    end
    return map
end

local function LogOpen(map)
    local log = LogFrame(map)
    return log and log:IsShown() and true or false
end

local function HasAtlas(name)
    if not (C_Texture and C_Texture.GetAtlasInfo) then
        return false
    end
    local ok, info = pcall(C_Texture.GetAtlasInfo, name)
    return ok and info ~= nil
end

local function ClickSound()
    if not PlaySound then
        return
    end
    if SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        return
    end
    pcall(PlaySound, "igMainMenuOptionCheckBoxOn")
end

local function ApplyArrow(button, collapsed)
    -- Open: point at the quest list. Collapsed: point back at the map.
    local icon = button.icon
    local atlas = "common-icon-forwardarrow"
    if icon and icon.SetAtlas and icon.SetRotation and HasAtlas(atlas) then
        icon:SetAtlas(atlas)
        icon:SetSize(16, 16)
        icon:SetRotation(collapsed and math.pi or 0)
        icon:Show()
        button.label:Hide()
        return
    end
    if icon then
        icon:Hide()
    end
    button.label:Show()
    button.label:SetText(collapsed and "<" or ">")
end

local function Paint(button, hot, down)
    if button.SetBackdropColor then
        if hot then
            button:SetBackdropColor(0.18, 0.13, 0.05, 0.98)
            button:SetBackdropBorderColor(1, 0.86, 0.38, 1)
        else
            button:SetBackdropColor(0.07, 0.05, 0.03, 0.96)
            button:SetBackdropBorderColor(0.82, 0.66, 0.24, 1)
        end
    end
    local x, y = 0, 0
    if down then
        x, y = 1, -1
    end
    button.icon:ClearAllPoints()
    button.icon:SetPoint("CENTER", x, y)
    button.label:ClearAllPoints()
    button.label:SetPoint("CENTER", x, 1 + y)
end

local function UpdateTip(button)
    if not button:IsMouseOver() or GameTooltip:GetOwner() ~= button then
        return
    end
    local open = LogOpen(MapFrame())
    GameTooltip:ClearLines()
    GameTooltip:SetText(open and "Collapse quest log" or "Expand quest log", 1, 0.82, 0)
    GameTooltip:AddLine("Folds the list on the right into this edge, or opens it again.", 1, 1, 1, true)
    GameTooltip:Show()
end

local function Raise(button, map)
    local log = LogFrame(map)
    local strata = "HIGH"
    if log and log.GetFrameStrata then
        strata = log:GetFrameStrata() or strata
    end
    button:SetFrameStrata(strata)
    local level = 400
    if log and log.GetFrameLevel then
        level = math.max(level, (log:GetFrameLevel() or 1) + 200)
    end
    local canvas = Canvas(map)
    if canvas and canvas.GetFrameLevel then
        level = math.max(level, (canvas:GetFrameLevel() or 1) + 200)
    end
    if level > 9999 then
        level = 9999
    end
    button:SetFrameLevel(level)
end

local function Supported(map)
    if not map then
        return false
    end
    if LogFrame(map) then
        return true
    end
    if map.HandleUserActionToggleSidePanel then
        return true
    end
    return false
end

local Place
local HookLog

local function HideStock(frame)
    if not frame or frame == btn or frame.qlcSuppressed then
        return
    end
    frame.qlcSuppressed = true
    frame:Hide()
    frame:HookScript("OnShow", function(self)
        self:Hide()
    end)
end

local function HideStockToggles(map)
    if map.SidePanelToggle then
        HideStock(map.SidePanelToggle)
    end
    local okChildren, children = pcall(function()
        return { map:GetChildren() }
    end)
    if not okChildren or not children then
        return
    end
    local i
    for i = 1, #children do
        local child = children[i]
        local okMatch, match = pcall(function()
            return child and child ~= btn and child.OpenButton and child.CloseButton and child.Refresh
        end)
        if okMatch and match then
            HideStock(child)
        end
    end
end

Place = function(button, map)
    if not button or not map then
        return
    end
    if InCombatLockdown() then
        button.pending = true
        return
    end
    button.pending = nil
    if not Supported(map) then
        button:Hide()
        return
    end
    local open = LogOpen(map)
    local host = Canvas(map)
    button:ClearAllPoints()
    if open then
        local log = LogFrame(map)
        -- Same height as the collapsed arrow. Horizontally it stays on the seam.
        button:SetPoint("TOP", host, "TOP", 0, -TOP_GAP)
        button:SetPoint("LEFT", log, "LEFT", -math.floor(SIZE / 2), 0)
    else
        button:SetPoint("TOPRIGHT", host, "TOPRIGHT", -2, -TOP_GAP)
    end
    ApplyArrow(button, not open)
    Paint(button, button:IsMouseOver(), false)
    Raise(button, map)
    HideStockToggles(map)
    button:Show()
    HookLog(LogFrame(map))
    UpdateTip(button)
end

local refreshQueued = false

local function RefreshSoon()
    local map = MapFrame()
    if btn and map then
        Place(btn, map)
    end
    if refreshQueued or not (C_Timer and C_Timer.After) then
        return
    end
    refreshQueued = true
    C_Timer.After(0.05, function()
        refreshQueued = false
        local current = MapFrame()
        if btn and current then
            Place(btn, current)
        end
    end)
end

local function Toggle()
    if InCombatLockdown() then
        Say("The quest log can't be opened or closed while you are in combat.")
        return
    end
    local map = MapFrame()
    if not map then
        Say("Open the world map first.")
        return
    end
    local log = LogFrame(map)
    if not log and not map.HandleUserActionToggleSidePanel then
        Say("This map has no quest log beside it.")
        return
    end

    local maximized = IsMaximized(map)
    if maximized then
        local on = not (log and log:IsShown())
        if type(OpenMapDB) == "table" and type(OpenMapDB.worldmap) == "table" then
            OpenMapDB.worldmap.maxQuestLog = on and true or false
        end
        if log then
            log:SetShown(on)
        end
        if map.UpdateSpacerFrameAnchoring then
            pcall(map.UpdateSpacerFrameAnchoring, map)
        end
        pcall(SetCVar, "questLogOpen", on and "1" or "0")
    else
        local ok = false
        if map.HandleUserActionToggleSidePanel then
            ok = pcall(map.HandleUserActionToggleSidePanel, map)
        end
        if not ok and log then
            local on = not log:IsShown()
            log:SetShown(on)
            if map.UpdateSpacerFrameAnchoring then
                pcall(map.UpdateSpacerFrameAnchoring, map)
            end
            pcall(SetCVar, "questLogOpen", on and "1" or "0")
        end
    end

    ClickSound()
    RefreshSoon()
end

local function CreateButton(map)
    local template = BackdropTemplateMixin and "BackdropTemplate" or nil
    local ok, button = pcall(CreateFrame, "Button", "XiusQuestCollapserButton", map, template)
    if not ok or not button then
        return nil
    end

    button:SetSize(SIZE, SIZE)
    button:SetFrameStrata("HIGH")
    button:SetClampedToScreen(false)
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp")

    if button.SetBackdrop then
        button:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
    end

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(22, 22)
    icon:SetPoint("CENTER")
    button.icon = icon

    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    label:SetPoint("CENTER", 0, 1)
    label:SetTextColor(1, 0.86, 0.35)
    local fontPath = label:GetFont()
    if fontPath then
        pcall(label.SetFont, label, fontPath, 20, "OUTLINE")
    end
    label:SetTextColor(1, 0.86, 0.35)
    label:SetText("<")
    button.label = label

    local highlight = button:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    highlight:SetBlendMode("ADD")
    highlight:SetAlpha(0.28)

    Paint(button, false, false)

    button:SetScript("OnEnter", function(self)
        Paint(self, true, false)
        local open = LogOpen(MapFrame())
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText(open and "Collapse quest log" or "Expand quest log", 1, 0.82, 0)
        GameTooltip:AddLine("Folds the list on the right into this edge, or opens it again.", 1, 1, 1, true)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        Paint(self, false, false)
        GameTooltip:Hide()
    end)

    button:SetScript("OnMouseDown", function(self, mouseButton)
        if mouseButton ~= "LeftButton" then
            return
        end
        Paint(self, true, true)
    end)

    button:SetScript("OnMouseUp", function(self, mouseButton)
        if mouseButton ~= "LeftButton" then
            return
        end
        local over = self:IsMouseOver()
        Paint(self, over, false)
        if over then
            Toggle()
        end
    end)

    button:Hide()
    return button
end

HookLog = function(log)
    if logHooked or not log or not log.HookScript then
        return
    end
    logHooked = true
    log:HookScript("OnShow", RefreshSoon)
    log:HookScript("OnHide", RefreshSoon)
end

local function HookMap(map)
    if mapHooked then
        return
    end
    mapHooked = true
    map:HookScript("OnShow", RefreshSoon)
    map:HookScript("OnSizeChanged", function()
        if btn then
            Place(btn, map)
        end
    end)

    local names = {
        "HandleUserActionToggleSidePanel",
        "HandleUserActionOpenSidePanel",
        "HandleUserActionCloseSidePanel",
        "Maximize",
        "Minimize",
        "SetDisplayState",
    }
    local n
    for n = 1, #names do
        local name = names[n]
        if type(map[name]) == "function" then
            hooksecurefunc(map, name, RefreshSoon)
        end
    end
end

local function TrySetup()
    local map = MapFrame()
    if not map then
        return
    end
    HookMap(map)
    if not btn then
        btn = CreateButton(map)
    end
    if not btn then
        return
    end
    if btn:GetParent() ~= map then
        btn:SetParent(map)
    end
    HookLog(LogFrame(map))
    Place(btn, map)
end

local function StartWatcher()
    if watching then
        return
    end
    watching = true
    local elapsed = 0
    local watcher = CreateFrame("Frame")
    watcher:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + (dt or 0)
        if WorldMapFrame then
            TrySetup()
        end
        if btn or elapsed > 20 then
            self:SetScript("OnUpdate", nil)
        end
    end)
end

local driver = CreateFrame("Frame")
driver:RegisterEvent("ADDON_LOADED")
driver:RegisterEvent("PLAYER_LOGIN")
driver:RegisterEvent("PLAYER_REGEN_ENABLED")
driver:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" then
        if name == "Blizzard_WorldMap" or name == "OpenMap" or name == "XiusQuestCollapser" then
            TrySetup()
        end
        return
    end
    if event == "PLAYER_REGEN_ENABLED" then
        if not btn or (btn and btn.pending) then
            TrySetup()
        end
        return
    end
    TrySetup()
    if not btn then
        StartWatcher()
    end
end)

SLASH_XIUSQUESTCOLLAPSER1 = "/qlc"
SLASH_XIUSQUESTCOLLAPSER2 = "/xqc"
SlashCmdList.XIUSQUESTCOLLAPSER = function()
    local map = MapFrame()
    if not map or not map:IsShown() then
        Say("Open the map, then click the arrow at the top of the line between the map and the quest log.")
        return
    end
    Toggle()
end
