EndlessAngler.UIFrame = CreateFrame("Frame", "EndlessAnglerUIFrame", UIParent, "BasicFrameTemplateWithInset")
EndlessAngler.UIFrame:SetPoint("CENTER")
EndlessAngler.UIFrame:SetSize(320, 220)
EndlessAngler.UIFrame:Hide()
EndlessAngler.UIFrame.TitleText:SetText("Endless Angler")
EndlessAngler.UIFrame:SetMovable(true)
EndlessAngler.UIFrame:EnableMouse(true)
EndlessAngler.UIFrame:RegisterForDrag("LeftButton")
EndlessAngler.UIFrame:SetClampedToScreen(true)


EndlessAngler.UIFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

EndlessAngler.UIFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
