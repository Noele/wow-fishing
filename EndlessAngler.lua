EndlessAngler.LootFrame = CreateFrame("Frame")
EndlessAngler.LootFrame:RegisterEvent("LOOT_OPENED")

local JournalLoot = CreateFrame("Frame")
JournalLoot:RegisterEvent("LOOT_OPENED")


EndlessAnglerPlayerData = EndlessAnglerPlayerData or {
	["xp"] = 0,
	["catch_count"] = 0,
}

BASE_EXP = 15
ITEM_QUALITY = {
	[0] = {["Quality"] = "Poor",        ["Experience"] = 0  },
	[1] = {["Quality"] = "Common",      ["Experience"] = 0  },
	[2] = {["Quality"] = "Uncommon",    ["Experience"] = 15 },
	[3] = {["Quality"] = "Rare",        ["Experience"] = 20 },
	[4] = {["Quality"] = "Epic",        ["Experience"] = 25 },
	[5] = {["Quality"] = "Legendary",   ["Experience"] = 30 },
	[6] = {["Quality"] = "Artifact",    ["Experience"] = 30 },
	[7] = {["Quality"] = "Heirloom",    ["Experience"] = 30 },
	[8] = {["Quality"] = "WoW Token",   ["Experience"] = 30 },
}

local RANKS = {
    {   1, "Landlubber",        "ff9d9d9d" },
    {   5, "Bait Handler",      "ffffffff" },
    {  10, "Novice Angler",     "ff1eff00" },
    {  20, "Apprentice Angler", "ff1eff00" },
    {  30, "Journeyman Angler", "ff0070dd" },
    {  45, "Expert Angler",     "ff0070dd" },
    {  60, "Adept Angler",      "ffa335ee" },
    {  80, "Master Angler",     "ffa335ee" },
    { 100, "Grandmaster Angler","ffff8000" },
    { 130, "Champion Angler",   "ffff8000" },
    { 160, "Legend of the Deep","ffe6cc80" },
    { 200, "Mythic Angler",     "ffe6cc80" },
    { 250, "Tidecaller",        "ff00ccff" },
    { 300, "Leviathan Hunter",  "ff00ccff" },
    { 400, "Ascended Angler",   "ffff3399" },
}

function EndlessAngler.XPToNext(level)
    return 100 + 25 * level + math.floor(level ^ 1.5)
end

function EndlessAngler.LevelFromXP(totalXP)
    local level, remaining = 1, totalXP
    local need = EndlessAngler.XPToNext(level)
    while remaining >= need do
        remaining = remaining - need
        level = level + 1
        need = EndlessAngler.XPToNext(level)
    end
    return level, remaining, need
end

function EndlessAngler.RankForLevel(level)
    local current, nextRank = RANKS[1], nil
    for i, r in ipairs(RANKS) do
        if level >= r[1] then
            current = r
            nextRank = RANKS[i + 1]
        end
    end
    return current, nextRank
end

function EndlessAngler.GetPlayerData()
	data = {}
	data.xp = EndlessAnglerPlayerData.xp
	data.name, data.realm = UnitName("player")
	data.catch_count = EndlessAnglerPlayerData.catch_count
	return data
end

function EndlessAngler.RankString(level)
    local r = EndlessAngler.RankForLevel(level)
    return "|c" .. r[3] .. r[2] .. "|r"
end

append = ""

local function GainExperience(exp)
	if EndlessAngler.XPToNext(EndlessAngler.LevelFromXP(EndlessAnglerPlayerData.xp)) - exp <= 0 then
		PlaySound(888)
	end
	EndlessAnglerPlayerData.xp = EndlessAnglerPlayerData.xp + exp

end
EndlessAngler.LootFrame:SetScript("OnEvent", function()
	if IsFishingLoot() then
		local ok, number_of_items = pcall(GetNumLootItems)
		if ok then
			for i = 1, number_of_items do
				local ok, lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = pcall(GetLootSlotInfo, i)
				if ok then
					local _, _, _, hex = GetItemQualityColor(lootQuality)
					if ITEM_QUALITY[lootQuality].Quality == "Poor" then return end

					GainExperience(BASE_EXP + ITEM_QUALITY[lootQuality].Experience)
					-- print("[EndlessAngler] " .. ITEM_QUALITY[lootQuality].Quality ..  " Catch |c" .. hex .. lootName .. "|r +" .. BASE_EXP + ITEM_QUALITY[lootQuality].Experience .. " EXP")
					EndlessAngler.PopulateFrame(EndlessAngler.GetPlayerData())
					append = " [+" .. BASE_EXP + ITEM_QUALITY[lootQuality].Experience .." EXP]"
					EndlessAnglerPlayerData.catch_count = EndlessAnglerPlayerData.catch_count + 1
				end
			end
		end
	end
end)

local function AppendLootText(self, event, msg, ...)
	payload = append
	append = ""
    return false, msg .. payload, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", AppendLootText)

SLASH_ENDLESSANGLER1 = "/ea"
SlashCmdList["ENDLESSANGLER"] = function(msg)
	EndlessAngler.PopulateFrame(EndlessAngler.GetPlayerData())
	EndlessAngler.UIFrame:Show()
end

local ITEM_IDS = {}
for _, section in ipairs(EndlessAngler.FishList) do
    for _, fish in ipairs(section.fish) do
        ITEM_IDS[fish[1]] = true
    end
end

-- Recording catches for journal
JournalLoot:SetScript("OnEvent", function()
    if not IsFishingLoot() then return end

    EndlessAnglerPlayerData.journal = EndlessAnglerPlayerData.journal or {}

    for i = 1, GetNumLootItems() do
        local link = GetLootSlotLink(i)
        local itemID = link and tonumber(link:match("item:(%d+)"))

        if itemID and ITEM_IDS[itemID] then
            local _, _, quantity = GetLootSlotInfo(i)
            EndlessAnglerPlayerData.journal[itemID] = (EndlessAnglerPlayerData.journal[itemID] or 0) + (quantity or 1)
        end
    end

    if EndlessAngler.JournalFrame:IsShown() then
        EndlessAngler.PopulateJournal()
    end
end)
