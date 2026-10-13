local COLUMNS, ICON_SIZE, SPACING = 6, 36, 6
local CELL = ICON_SIZE + SPACING
local HEADER_HEIGHT = 24
local QUESTION_MARK = 134400

EndlessAngler.JournalFrame = CreateFrame("Frame", nil, EndlessAngler.UIFrame)
EndlessAngler.JournalFrame:SetPoint("TOPLEFT", EndlessAngler.UIFrame, "TOPLEFT", 10, -30)
EndlessAngler.JournalFrame:SetPoint("BOTTOMRIGHT", EndlessAngler.UIFrame, "BOTTOMRIGHT", -10, 8)
EndlessAngler.JournalFrame:Hide()

EndlessAngler.JournalSummary = EndlessAngler.JournalFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
EndlessAngler.JournalSummary:SetPoint("TOPLEFT", EndlessAngler.JournalFrame, "TOPLEFT", 6, -6)

EndlessAngler.JournalScroll = CreateFrame("ScrollFrame", "FishingJournalScroll", EndlessAngler.JournalFrame, "UIPanelScrollFrameTemplate")
EndlessAngler.JournalScroll:SetPoint("TOPLEFT", EndlessAngler.JournalFrame, "TOPLEFT", 0, -28)
EndlessAngler.JournalScroll:SetPoint("BOTTOMRIGHT", EndlessAngler.JournalFrame, "BOTTOMRIGHT", 0, 4)


EndlessAngler.JournalScroll:SetClipsChildren(true)

local scrollBar = EndlessAngler.JournalScroll.ScrollBar
scrollBar:ClearAllPoints()
scrollBar:SetPoint("TOPRIGHT", EndlessAngler.JournalScroll, "TOPRIGHT", -4, -18)
scrollBar:SetPoint("BOTTOMRIGHT", EndlessAngler.JournalScroll, "BOTTOMRIGHT", -4, 18)

local scrollChild = CreateFrame("Frame", nil, EndlessAngler.JournalScroll)
scrollChild:SetSize(16 + COLUMNS * CELL, 1)
scrollChild:SetPoint("TOPLEFT", EndlessAngler.JournalScroll, "TOPLEFT", 0, 0)
EndlessAngler.JournalScroll:SetScrollChild(scrollChild)

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
end

local sections = {}
local function BuildJournal()
    local y = 8

    for _, section in reversedipairs(EndlessAngler.FishList) do
        local header = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8, -y)
        y = y + HEADER_HEIGHT

        local entry = { name = section.expansion, header = header, buttons = {} }

        for i, fish in ipairs(section.fish) do
            local row, col = math.floor((i - 1) / COLUMNS), (i - 1) % COLUMNS

            local button = CreateFrame("Button", nil, scrollChild)
            button:SetSize(ICON_SIZE, ICON_SIZE)
            button:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8 + col * CELL, -(y + row * CELL))
            button.itemID = fish[1]

            button.icon = button:CreateTexture(nil, "ARTWORK")
            button.icon:SetAllPoints()

            button.count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
            button.count:SetPoint("BOTTOMRIGHT", -2, 2)

            button:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetItemByID(self.itemID)
                GameTooltip:Show()
            end)
            button:SetScript("OnLeave", GameTooltip_Hide)

            entry.buttons[i] = button
        end

        y = y + math.ceil(#section.fish / COLUMNS) * CELL + 8
        sections[#sections + 1] = entry
    end

    scrollChild:SetHeight(y)
end

function EndlessAngler.PopulateJournal()
    if #sections == 0 then BuildJournal() end

    local caught = EndlessAnglerPlayerData.journal or {}
    local total, discovered = 0, 0

    for _, section in ipairs(sections) do
        local sectionDiscovered = 0

        for _, button in ipairs(section.buttons) do
            local count = caught[button.itemID] or 0
            button.icon:SetTexture(C_Item.GetItemIconByID(button.itemID) or QUESTION_MARK)
            button.icon:SetDesaturated(count == 0)
            button.icon:SetAlpha(count == 0 and 0.35 or 1)
            button.count:SetText(count > 0 and tostring(count) or "")
            if count > 0 then sectionDiscovered = sectionDiscovered + 1 end
        end

        section.header:SetText(section.name .. "  (" .. sectionDiscovered .. "/" .. #section.buttons .. ")")
        total = total + #section.buttons
        discovered = discovered + sectionDiscovered
    end

    EndlessAngler.JournalSummary:SetText("Discovered: " .. discovered .. " / " .. total)
end