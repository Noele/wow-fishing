
Fishing.ProfileFrame = CreateFrame("Frame", nil, Fishing.UIFrame)
Fishing.ProfileFrame:SetPoint("TOPLEFT", Fishing.UIFrame, "TOPLEFT", 0, 0)
Fishing.ProfileFrame:SetPoint("BOTTOMRIGHT", Fishing.UIFrame, "BOTTOMRIGHT", 0, 0)
Fishing.ProfileFrame:Hide()

Fishing.ProfileFrame.nameText = Fishing.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
Fishing.ProfileFrame.nameText:SetPoint("TOPLEFT", Fishing.ProfileFrame, "TOPLEFT", 20, -40)

Fishing.ProfileFrame.levelText = Fishing.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontHighlightLarge")
Fishing.ProfileFrame.levelText:SetPoint("TOPLEFT", Fishing.ProfileFrame, "TOPLEFT", 20, -65)

Fishing.ProfileFrame.rankText = Fishing.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
Fishing.ProfileFrame.rankText:SetPoint("TOPLEFT", Fishing.ProfileFrame, "TOPLEFT", 20, -87)

Fishing.ProfileFrame.XPBar = CreateFrame("StatusBar","FishingXPBar",Fishing.ProfileFrame)
Fishing.ProfileFrame.XPBar:SetSize(280, 18)
Fishing.ProfileFrame.XPBar:SetPoint("TOPLEFT", Fishing.ProfileFrame, "TOPLEFT", 20, -115)
Fishing.ProfileFrame.XPBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

-- Background behind the fill
Fishing.ProfileFrame.XPBar.bg = Fishing.ProfileFrame.XPBar:CreateTexture(nil, "BACKGROUND")
Fishing.ProfileFrame.XPBar.bg:SetAllPoints()
Fishing.ProfileFrame.XPBar.bg:SetColorTexture(0, 0, 0, 0.5)

-- Set the fill colour
Fishing.ProfileFrame.XPBar:SetStatusBarColor(0.1, 0.5, 0.9)

Fishing.ProfileFrame.XPBar.XPBarText = Fishing.ProfileFrame.XPBar:CreateFontString(nil, "OVERLAY","GameFontHighlightSmall")
Fishing.ProfileFrame.XPBar.XPBarText:SetPoint("CENTER", Fishing.ProfileFrame.XPBar, "CENTER", 0, 0)

Fishing.ProfileFrame.catch_countText = Fishing.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontHighlight")
Fishing.ProfileFrame.catch_countText:SetPoint("TOPLEFT", Fishing.ProfileFrame, "TOPLEFT", 20, -145)

Fishing.ProfileFrame.nextRankText = Fishing.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontHighlight")
Fishing.ProfileFrame.nextRankText:SetPoint("TOPLEFT", Fishing.ProfileFrame, "TOPLEFT", 20, -160)


function Fishing.PopulateFrame(data)
    Fishing.ProfileFrame.nameText:SetText(data.name)
	local level, remaining, need = Fishing.LevelFromXP(data.xp)
	local current_rank, next_rank = Fishing.RankForLevel(level)
	local next_rank_level, next_rank_name = next_rank[1], next_rank[2]
    Fishing.ProfileFrame.rankText:SetText("Rank: " .. Fishing.RankString(level))

	Fishing.ProfileFrame.XPBar:SetMinMaxValues(0, need)
	Fishing.ProfileFrame.XPBar:SetValue(remaining)

	Fishing.ProfileFrame.XPBar.XPBarText:SetText(remaining .. " / " .. need .. " XP")

	Fishing.ProfileFrame.levelText:SetText("Fishing Level " ..level)

	Fishing.ProfileFrame.catch_countText:SetText("Total catches: " .. data.catch_count)

	Fishing.ProfileFrame.nextRankText:SetText("Next rank: " .. next_rank_name .. " at level " .. next_rank_level)

end