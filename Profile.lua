
EndlessAngler.ProfileFrame = CreateFrame("Frame", nil, EndlessAngler.UIFrame)
EndlessAngler.ProfileFrame:SetPoint("TOPLEFT", EndlessAngler.UIFrame, "TOPLEFT", 0, 0)
EndlessAngler.ProfileFrame:SetPoint("BOTTOMRIGHT", EndlessAngler.UIFrame, "BOTTOMRIGHT", 0, 0)
EndlessAngler.ProfileFrame:Hide()

EndlessAngler.ProfileFrame.nameText = EndlessAngler.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
EndlessAngler.ProfileFrame.nameText:SetPoint("TOPLEFT", EndlessAngler.ProfileFrame, "TOPLEFT", 20, -40)

EndlessAngler.ProfileFrame.levelText = EndlessAngler.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontHighlightLarge")
EndlessAngler.ProfileFrame.levelText:SetPoint("TOPLEFT", EndlessAngler.ProfileFrame, "TOPLEFT", 20, -65)

EndlessAngler.ProfileFrame.rankText = EndlessAngler.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
EndlessAngler.ProfileFrame.rankText:SetPoint("TOPLEFT", EndlessAngler.ProfileFrame, "TOPLEFT", 20, -87)

EndlessAngler.ProfileFrame.XPBar = CreateFrame("StatusBar","FishingXPBar",EndlessAngler.ProfileFrame)
EndlessAngler.ProfileFrame.XPBar:SetSize(280, 18)
EndlessAngler.ProfileFrame.XPBar:SetPoint("TOPLEFT", EndlessAngler.ProfileFrame, "TOPLEFT", 20, -115)
EndlessAngler.ProfileFrame.XPBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")

-- Background behind the fill
EndlessAngler.ProfileFrame.XPBar.bg = EndlessAngler.ProfileFrame.XPBar:CreateTexture(nil, "BACKGROUND")
EndlessAngler.ProfileFrame.XPBar.bg:SetAllPoints()
EndlessAngler.ProfileFrame.XPBar.bg:SetColorTexture(0, 0, 0, 0.5)

-- Set the fill colour
EndlessAngler.ProfileFrame.XPBar:SetStatusBarColor(0.1, 0.5, 0.9)

EndlessAngler.ProfileFrame.XPBar.XPBarText = EndlessAngler.ProfileFrame.XPBar:CreateFontString(nil, "OVERLAY","GameFontHighlightSmall")
EndlessAngler.ProfileFrame.XPBar.XPBarText:SetPoint("CENTER", EndlessAngler.ProfileFrame.XPBar, "CENTER", 0, 0)

EndlessAngler.ProfileFrame.catch_countText = EndlessAngler.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontHighlight")
EndlessAngler.ProfileFrame.catch_countText:SetPoint("TOPLEFT", EndlessAngler.ProfileFrame, "TOPLEFT", 20, -145)

EndlessAngler.ProfileFrame.nextRankText = EndlessAngler.ProfileFrame:CreateFontString(nil,"OVERLAY","GameFontHighlight")
EndlessAngler.ProfileFrame.nextRankText:SetPoint("TOPLEFT", EndlessAngler.ProfileFrame, "TOPLEFT", 20, -160)


function EndlessAngler.PopulateFrame(data)
    EndlessAngler.ProfileFrame.nameText:SetText(data.name)
	local level, remaining, need = EndlessAngler.LevelFromXP(data.xp)
	local current_rank, next_rank = EndlessAngler.RankForLevel(level)
	local next_rank_level, next_rank_name = next_rank[1], next_rank[2]
    EndlessAngler.ProfileFrame.rankText:SetText("Rank: " .. EndlessAngler.RankString(level))

	EndlessAngler.ProfileFrame.XPBar:SetMinMaxValues(0, need)
	EndlessAngler.ProfileFrame.XPBar:SetValue(remaining)

	EndlessAngler.ProfileFrame.XPBar.XPBarText:SetText(remaining .. " / " .. need .. " XP")

	EndlessAngler.ProfileFrame.levelText:SetText("Fishing Level " ..level)

	EndlessAngler.ProfileFrame.catch_countText:SetText("Total catches: " .. data.catch_count)

	EndlessAngler.ProfileFrame.nextRankText:SetText("Next rank: " .. next_rank_name .. " at level " .. next_rank_level)

end