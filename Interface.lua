Fishing = {}

Fishing.UIFrame = CreateFrame("Frame", "Fishing", UIParent, "BasicFrameTemplateWithInset")
Fishing.UIFrame:SetPoint("CENTER")
Fishing.UIFrame:SetSize(320, 220)
Fishing.UIFrame:Hide()
Fishing.UIFrame.TitleText:SetText("Fishing")
Fishing.UIFrame:SetMovable(true)
Fishing.UIFrame:EnableMouse(true)
Fishing.UIFrame:RegisterForDrag("LeftButton")
Fishing.UIFrame:SetClampedToScreen(true)

Fishing.UIFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

Fishing.UIFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

Fishing.UIFrame.nameText = Fishing.UIFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
Fishing.UIFrame.nameText:SetPoint("TOPLEFT", Fishing.UIFrame, "TOPLEFT", 20, -40)

Fishing.UIFrame.levelText = Fishing.UIFrame:CreateFontString(nil,"OVERLAY","GameFontHighlightLarge")
Fishing.UIFrame.levelText:SetPoint("TOPLEFT", Fishing.UIFrame, "TOPLEFT", 20, -65)

Fishing.UIFrame.rankText = Fishing.UIFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
Fishing.UIFrame.rankText:SetPoint("TOPLEFT", Fishing.UIFrame, "TOPLEFT", 20, -87)

Fishing.XPBar = CreateFrame("StatusBar","FishingXPBar",Fishing.UIFrame)
Fishing.XPBar:SetSize(280, 18)
Fishing.XPBar:SetPoint("TOPLEFT", Fishing.UIFrame, "TOPLEFT", 20, -115)
Fishing.XPBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

-- Background behind the fill
Fishing.XPBar.bg = Fishing.XPBar:CreateTexture(nil, "BACKGROUND")
Fishing.XPBar.bg:SetAllPoints()
Fishing.XPBar.bg:SetColorTexture(0, 0, 0, 0.5)

-- Set the fill colour
Fishing.XPBar:SetStatusBarColor(0.1, 0.5, 0.9)

Fishing.XPBar.XPBarText = Fishing.XPBar:CreateFontString(nil, "OVERLAY","GameFontHighlightSmall")
Fishing.XPBar.XPBarText:SetPoint("CENTER", Fishing.XPBar, "CENTER", 0, 0)

function Fishing.PopulateFrame(data)
    Fishing.UIFrame.nameText:SetText(data.name)
	local level, remaining, need = Fishing.LevelFromXP(data.xp)
    Fishing.UIFrame.rankText:SetText("Rank: " .. Fishing.RankString(level))

	Fishing.XPBar:SetMinMaxValues(0, need)
	Fishing.XPBar:SetValue(remaining)

	Fishing.XPBar.XPBarText:SetText(remaining .. " / " .. need .. " XP")

	Fishing.UIFrame.levelText:SetText("Fishing Level " ..level)
end