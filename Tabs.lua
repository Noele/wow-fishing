local function ShowTab(id)
    PanelTemplates_SetTab(EndlessAngler.UIFrame, id)


    EndlessAngler.ProfileFrame:SetShown(id == 1)
    EndlessAngler.JournalFrame:SetShown(id == 2)

    if id == 1 then
        EndlessAngler.UIFrame:SetSize(320, 220)
    else
        EndlessAngler.UIFrame:SetSize(320, 420)
        EndlessAngler.PopulateJournal()
    end
end

local tab1 = CreateFrame("Button", "FishingTab1", EndlessAngler.UIFrame, "PanelTabButtonTemplate")
tab1:SetID(1)
tab1:SetText("Profile")
tab1:SetPoint("TOPLEFT", EndlessAngler.UIFrame, "BOTTOMLEFT", 11, 2)
tab1:SetScript("OnClick", function() ShowTab(1) end)
PanelTemplates_TabResize(tab1, 0)

local tab2 = CreateFrame("Button", "FishingTab2", EndlessAngler.UIFrame, "PanelTabButtonTemplate")
tab2:SetID(2)
tab2:SetText("Journal")
tab2:SetPoint("LEFT", tab1, "RIGHT", -16, 0)
tab2:SetScript("OnClick", function() ShowTab(2) end)
PanelTemplates_TabResize(tab2, 0)

EndlessAngler.UIFrame.Tabs = { tab1, tab2 }
PanelTemplates_SetNumTabs(EndlessAngler.UIFrame, 2)
ShowTab(1)