local COLUMNS, ICON_SIZE, SPACING = 6, 36, 6
local CELL = ICON_SIZE + SPACING
local HEADER_HEIGHT = 24
local QUESTION_MARK = 134400

Fishing.JournalFrame = CreateFrame("Frame", nil, Fishing.UIFrame)
Fishing.JournalFrame:SetPoint("TOPLEFT", Fishing.UIFrame, "TOPLEFT", 10, -30)
Fishing.JournalFrame:SetPoint("BOTTOMRIGHT", Fishing.UIFrame, "BOTTOMRIGHT", -10, 8)
Fishing.JournalFrame:Hide()

Fishing.JournalSummary = Fishing.JournalFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Fishing.JournalSummary:SetPoint("TOPLEFT", Fishing.JournalFrame, "TOPLEFT", 6, -6)

Fishing.JournalScroll = CreateFrame("ScrollFrame", "FishingJournalScroll", Fishing.JournalFrame, "UIPanelScrollFrameTemplate")
Fishing.JournalScroll:SetPoint("TOPLEFT", Fishing.JournalFrame, "TOPLEFT", 0, -28)
Fishing.JournalScroll:SetPoint("BOTTOMRIGHT", Fishing.JournalFrame, "BOTTOMRIGHT", 0, 4)


Fishing.JournalScroll:SetClipsChildren(true)

local scrollBar = Fishing.JournalScroll.ScrollBar
scrollBar:ClearAllPoints()
scrollBar:SetPoint("TOPRIGHT", Fishing.JournalScroll, "TOPRIGHT", -4, -18)
scrollBar:SetPoint("BOTTOMRIGHT", Fishing.JournalScroll, "BOTTOMRIGHT", -4, 18)

local scrollChild = CreateFrame("Frame", nil, Fishing.JournalScroll)
scrollChild:SetSize(16 + COLUMNS * CELL, 1)
scrollChild:SetPoint("TOPLEFT", Fishing.JournalScroll, "TOPLEFT", 0, 0)
Fishing.JournalScroll:SetScrollChild(scrollChild)

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

    for _, section in reversedipairs(Fishing.FishList) do
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

function Fishing.PopulateJournal()
    if #sections == 0 then BuildJournal() end

    local caught = FishingPlayerData.journal or {}
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

    Fishing.JournalSummary:SetText("Discovered: " .. discovered .. " / " .. total)
end