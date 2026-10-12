Fishing = {}

Fishing.UIFrame = CreateFrame("Frame", "Fishing", UIParent, "BasicFrameTemplate")
Fishing.UIFrame:SetPoint("CENTER")
Fishing.UIFrame:SetSize(300,300)
Fishing.UIFrame:Hide()
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

Fishing.UIFrame.titleText = Fishing.UIFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
Fishing.UIFrame.titleText:SetPoint("TOP", Fishing.UIFrame, "TOP", 0, -30)

Fishing.UIFrame.rankText = Fishing.UIFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
Fishing.UIFrame.rankText:SetPoint("TOP", Fishing.UIFrame, "TOP", 0, -60)

Fishing.UIFrame.levelText = Fishing.UIFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
Fishing.UIFrame.levelText:SetPoint("TOP", Fishing.UIFrame, "TOP", 110, -90)


Fishing.XPBar = CreateFrame("StatusBar","FishingXPBar",Fishing.UIFrame)
Fishing.XPBar:SetSize(200, 20)
Fishing.XPBar:SetPoint("TOP", Fishing.UIFrame, "TOP", 0, -90)
Fishing.XPBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

-- Background behind the fill
Fishing.XPBar.bg = Fishing.XPBar:CreateTexture(nil, "BACKGROUND")
Fishing.XPBar.bg:SetAllPoints()
Fishing.XPBar.bg:SetColorTexture(0.15, 0.15, 0.15, 1)

-- Set the fill colour
Fishing.XPBar:SetStatusBarColor(0.2, 0.8, 0.2)

Fishing.XPBar.XPBarText = Fishing.XPBar:CreateFontString(nil, "OVERLAY","GameFontNormalLarge")
Fishing.XPBar.XPBarText:SetPoint("CENTER", Fishing.XPBar, "CENTER", 0, 0)

function Fishing.PopulateFrame(data)
    Fishing.UIFrame.titleText:SetText(data.name)
	local level, remaining, need = Fishing.LevelFromXP(data.xp)
    Fishing.UIFrame.rankText:SetText(Fishing.RankString(level))

	Fishing.XPBar:SetMinMaxValues(0, need)
	Fishing.XPBar:SetValue(remaining)

	Fishing.XPBar.XPBarText:SetText(remaining .. "/" .. need)

	Fishing.UIFrame.levelText:SetText(level)
end