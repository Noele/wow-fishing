Fishing.LootFrame = CreateFrame("Frame")
Fishing.LootFrame:RegisterEvent("LOOT_OPENED")

PLAYER_XP = 0

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

function Fishing.XPToNext(level)
    return 100 + 25 * level + math.floor(level ^ 1.5)
end

function Fishing.LevelFromXP(totalXP)
    local level, remaining = 1, totalXP
    local need = Fishing.XPToNext(level)
    while remaining >= need do
        remaining = remaining - need
        level = level + 1
        need = Fishing.XPToNext(level)
    end
    return level, remaining, need
end

function Fishing.RankForLevel(level)
    local current, nextRank = RANKS[1], nil
    for i, r in ipairs(RANKS) do
        if level >= r[1] then
            current = r
            nextRank = RANKS[i + 1]
        end
    end
    return current, nextRank
end

function Fishing.GetPlayerData()
	data = {}
	data.xp = PLAYER_XP
	data.name, data.realm = UnitName("player")

	return data
end

function Fishing.RankString(level)
    local r = Fishing.RankForLevel(level)
    return "|c" .. r[3] .. r[2] .. "|r"
end

apppend = ""

Fishing.LootFrame:SetScript("OnEvent", function()
	if IsFishingLoot() then
		local ok, number_of_items = pcall(GetNumLootItems)
		if ok then
			for i = 1, number_of_items do
				local ok, lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = pcall(GetLootSlotInfo, i)
				if ok then
					local _, _, _, hex = GetItemQualityColor(lootQuality)

					PLAYER_XP = PLAYER_XP + BASE_EXP + ITEM_QUALITY[lootQuality].Experience
					-- print("[Fishing] " .. ITEM_QUALITY[lootQuality].Quality ..  " Catch |c" .. hex .. lootName .. "|r +" .. BASE_EXP + ITEM_QUALITY[lootQuality].Experience .. " EXP")
					Fishing.PopulateFrame(Fishing.GetPlayerData())
					append = " [+" .. BASE_EXP + ITEM_QUALITY[lootQuality].Experience .." EXP]"
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

SLASH_FISHING1 = "/fishing"
SlashCmdList["FISHING"] = function(msg)
	Fishing.PopulateFrame(Fishing.GetPlayerData())
	Fishing.UIFrame:Show()
end