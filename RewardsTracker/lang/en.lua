local localization_strings = {
    SI_BINDING_NAME_REWARDS_TRACKER_TOGGLE = "Toggle Rewards Tracker",
    SI_REWARDS_TRACKER_SO = "Sanctum Ophidia",
    SI_REWARDS_TRACKER_AA = "Aetherian Archive",
    SI_REWARDS_TRACKER_HRC = "Hel Ra Citadel",
    SI_REWARDS_TRACKER_MOL = "Maw of Lorkhaj",
    SI_REWARDS_TRACKER_HOF = "Halls of Fabrication",
    SI_REWARDS_TRACKER_AS = "Asylum Sanctorium",
    SI_REWARDS_TRACKER_CR = "Cloudrest",
    SI_REWARDS_TRACKER_SS = "Sunspire",
    SI_REWARDS_TRACKER_KA = "Kyne's Aegis",
    SI_REWARDS_TRACKER_RG = "Rockgrove",
    SI_REWARDS_TRACKER_RD = "Random Dungeon",
    SI_REWARDS_TRACKER_RB = "Random Battleground",
    SI_REWARDS_TRACKER_SHS = "Shadowy Supplier",
    SI_REWARDS_TRACKER_CM80 = "Crafting Motif 80: Shield of Senchal",
    SI_REWARDS_TRACKER_CM81 = "Crafting Motif 81: New Moon Priest",
    SI_REWARDS_TRACKER_CM86 = "Crafting Motif 86: Sea Giant",
    SI_REWARDS_TRACKER_CM95 = "Crafting Motif 95: Nighthollow",
    SI_REWARDS_TRACKER_CM97 = "Crafting Motif 97: Wayward Guardian",
    SI_REWARDS_TRACKER_CM101 = "Crafting Motif 101: Ivory Brigade",
}

for stringId, stringValue in pairs(localization_strings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end
