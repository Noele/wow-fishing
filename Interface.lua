Fishing.UIFrame = CreateFrame("Frame", "FishingUIFrame", UIParent, "BasicFrameTemplateWithInset")
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
