local function ShowTab(id)
    PanelTemplates_SetTab(Fishing.UIFrame, id)


    Fishing.ProfileFrame:SetShown(id == 1)
    Fishing.JournalFrame:SetShown(id == 2)

    if id == 1 then
        Fishing.UIFrame:SetSize(320, 220)
    else
        Fishing.UIFrame:SetSize(320, 420)
        Fishing.PopulateJournal()
    end
end

local tab1 = CreateFrame("Button", "FishingTab1", Fishing.UIFrame, "PanelTabButtonTemplate")
tab1:SetID(1)
tab1:SetText("Profile")
tab1:SetPoint("TOPLEFT", Fishing.UIFrame, "BOTTOMLEFT", 11, 2)
tab1:SetScript("OnClick", function() ShowTab(1) end)
PanelTemplates_TabResize(tab1, 0)

local tab2 = CreateFrame("Button", "FishingTab2", Fishing.UIFrame, "PanelTabButtonTemplate")
tab2:SetID(2)
tab2:SetText("Journal")
tab2:SetPoint("LEFT", tab1, "RIGHT", -16, 0)
tab2:SetScript("OnClick", function() ShowTab(2) end)
PanelTemplates_TabResize(tab2, 0)

Fishing.UIFrame.Tabs = { tab1, tab2 }
PanelTemplates_SetNumTabs(Fishing.UIFrame, 2)
ShowTab(1)