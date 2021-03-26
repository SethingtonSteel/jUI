-- PortToFriendsHouseLibraryData
-- By @s0rdrak (PC / EU)

local PortToFriend = _G['PortToFriend']
PortToFriend.libData = PortToFriend.libData or {}
local PortToFriendData = PortToFriend.libData

PortToFriendData.euData = {}
PortToFriendData.naData = {}
PortToFriendData.currentData = {}

function PortToFriendData.CreateEuDataList()
	local i = 1
	local list = PortToFriendData.euData
	list[#list + 1] = {
		name = "@schorse4044",
		houseId = 62,
		description = "If you want to have fun with hard Jump and Run stuff feel free to visit me. At the moment there are 5 tracks. Purple marks the start of each track and yellow the goal. Have fun!",
		category = {PortToFriend.constants.FILTER_ID_JUMPNRUN, PortToFriend.constants.FILTER_ID_LABYRINTH}
	}
	list[#list + 1] = {
		name = "@s0rdrak",
		houseId = 47,
		description = "This surreal estate contains a labyrinth that is in a building and built on different floors.\r\n\r\nYou might want to think a bit out of the box at a later point in the labyrinth.",
		category = {PortToFriend.constants.FILTER_ID_LABYRINTH}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 81,
		description = "Big Toy House\r\n\r\nTwo life sized doll's houses and a inn beneath the stairs",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 75,
		description = "Icy Falls Inn\r\n\r\nTwo Nord lodges serving mead and snacks",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 80,
		description = "Blue-ice Palace\r\n\r\nJust like Solitude, but on a frozen lake",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 47,
		description = "Mushroom Manor\r\n\r\nA giant mushroom house",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 38,
		description = "Vampire Academy with wine bar\r\n\r\nCome for the nibbles; stay for eternity",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 29,
		description = "Three Pillows War\r\n\r\nRe-enact the three banners war with pillow forts and floof balls",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 71,
		description = "Treefern House\r\n\r\nA treehouse build around a giant treefern",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 62,
		description = "Artaeum Threatre/Operahouse/Divine Chapel\r\n\r\nTiered Balcony with many seats",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 46,
		description = "Imperial Bridal Suite\r\n\r\nExtension with Alinor wedding theme",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 69,
		description = "Dragonguard Penthouse\r\n\r\n3 Extra floors, with indoor conservatory and top floor gym",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 79,
		description = "Lava Submarine Base\r\n\r\nAn evil vampire alchemy lab, accessible only via a lava submarine",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 72,
		description = "Spirit-tree Library\r\n\r\nA library built atop an ancient forest that is growing in an even more ancient daedric ruin",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 76,
		description = "Golden Beach Palace\r\n\r\nA dwarven inspired Redguard pool and beach resort",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 25,
		description = "Mad Scientists House\r\n\r\nWorkshop in the garage with an experimental De-lore-ean",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 47,
		description = "Former Guild House of Just Traders and Tamriel Stock Exchange and current main Guild House of First Trading Guild. All sets, all munduses, different dummies, transmute station.",
		category = {PortToFriend.constants.FILTER_ID_GUILD, PortToFriend.constants.FILTER_ID_CRAFTING}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 10,
		description = "Cozy small house for lil' smoky sessions.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 26,
		description = "Built by an unknown imperial explorer, this house started to become an awkward merge of imperial and mechanical architecture.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 23,
		description = "A sweet summer grill party garden.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 31,
		description = "Rumours say, this house has been a secret retreat of a Direnni.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 58,
		description = "Cozy bathroom.",
		category = {PortToFriend.constants.FILTER_ID_ERP}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 22,
		description = "A house for all the nice things in life: Smoke skooma, drink a lot of alcohol...and well...maybe some fine dancers.",
		category = {PortToFriend.constants.FILTER_ID_ERP}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 4,
		description = "You need some place for you and your friend alone? This luxurious and romantic bedroom might be perfect. ",
		category = {PortToFriend.constants.FILTER_ID_ERP}
	}
	list[#list + 1] = {
		name = "@Holy_Mary",
		houseId = 20,
		description = "The place, where ruthless magicians study.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@MayhemGrrr",
		houseId = 36,
		description = "Pirate theme park with gambling, beach and waterslide!",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Lausebengel",
		houseId = 54,
		description = "Gildenhalle der Legendary Revolution",
		category = {PortToFriend.constants.FILTER_ID_GUILD, PortToFriend.constants.FILTER_ID_CRAFTING, PortToFriend.constants.FILTER_ID_RAID}
	}
	list[#list + 1] = {
		name = "@Cyberqueen01",
		houseId = 39,
		description = "",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Cyberqueen01",
		houseId = 81,
		description = "",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Cyberqueen01",
		houseId = 36,
		description = "",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@OgieOgilthorpe",
		houseId = 38,
		description = "If this castle appears inviting and hospitable at the first glance, on closer inspection you can see which god its owner actually serves. Beware of the six-legged spider in the dungeon.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@OgieOgilthorpe",
		houseId = 62,
		description = "Welcome to my noble main house, enjoy the beauty of Artaeum. All Mundus Stones available and an assassin cult site for Sithis in the vaults.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@OgieOgilthorpe",
		houseId = 39,
		description = "Celebrate your parties in the huge hall, watch the dragon from the tower or meet up with Prince Irnskar at the bar and chat about your heroics.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@OgieOgilthorpe",
		houseId = 37,
		description = "Stroll with your partners in the romantic garden and enjoy the end of a peaceful day with a relaxing Skooma Pipe.",
		category = {PortToFriend.constants.FILTER_ID_ERP}
	}
	list[#list + 1] = {
		name = "@OgieOgilthorpe",
		houseId = 36,
		description = "This romantic holiday home is located in a secluded bay. Ideal for weddings and a quiet honeymoons. The well-guarded treasury reveals that the owner has more gold than a single person should own.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@OgieOgilthorpe",
		houseId = 47,
		description = "For just a million gold I couldn´t resist. A dark cult place, some craft tables and a deadric library.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Cox14",
		houseId = 62,
		description = "Family guild house with a beatiful aquarium.",
		category = {PortToFriend.constants.FILTER_ID_GUILD}
	}
	list[#list + 1] = {
		name = "@SonneMond13",
		houseId = 62,
		description = "Entspannungszone - sogar mit Toilette",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@SonneMond13",
		houseId = 78,
		description = "Friseursalon, Sauna + Wellnessbad",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@SonneMond13",
		houseId = 39,
		description = "Gruselfaktor garantiert! Am besten nach Mitternacht anschauen!",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@SonneMond13",
		houseId = 70,
		description = "Für Entdecker und Höhlenforscher",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Sturmfaenger",
		houseId = 48,
		description = "Explore the old tomb and try to solve the following quest:\r\n\r\nThree syllables are hidden somewhere in here. Find them and use the orcish clan seals in the main burial chamber to bring them into the right order. Who is buried in this grave?",
		category = {PortToFriend.constants.FILTER_ID_JUMPNRUN, PortToFriend.constants.FILTER_ID_LABYRINTH}
	}
	list[#list + 1] = {
		name = "@fred4",
		houseId = 62,
		description = "Parkour House",
		category = {PortToFriend.constants.FILTER_ID_JUMPNRUN, PortToFriend.constants.FILTER_ID_LABYRINTH}
	}
	list[#list + 1] = {
		name = "@Greetha",
		houseId = 78,
		description = "Mit Spielzimmer für lange Winterabende.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Greetha",
		houseId = 63,
		description = "",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@sheitana",
		houseId = 47,
		description = "Optimized for fast and easy crafting",
		category = {PortToFriend.constants.FILTER_ID_CRAFTING}
	}
	list[#list + 1] = {
		name = "@Nalos",
		houseId = 81,
		description = "Nicht Soli sondern Multitude",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Nalos",
		houseId = 80,
		description = "Shoemaker's Memorial",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Nalos",
		houseId = 45,
		description = "hmmm",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Nalos",
		houseId = 61,
		description = "Rückzugsort",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Nalos",
		houseId = 49,
		description = "Gemütlichkeit im Nebel",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Grila",
		houseId = 81,
		description = "Dschungelhaus",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Grila",
		houseId = 15,
		description = "Baumhaus",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Grila",
		houseId = 35,
		description = "Nachbau der Schatzkammer aus Prince of Persia Sands of Time",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Grila",
		houseId = 70,
		description = "Only, in the ancient legends it is stated, that one day an undead shall be chosen to leave the undead asylum, in pilgrimage, to the land of ancient lords, Lordran. Enjoy your visit to beautiful Blighttown, Dukes Archive, Lost Izalith and Darkroot Forest!",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@LordStorm1978",
		houseId = 71,
		description = "Kirche",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Koshjuha",
		houseId = 56,
		description = "I love to build with colorlights and trees. Dark broderhood? Well not really. A hain for assassins.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Koshjuha",
		houseId = 72,
		description = "I love to build with colorlights and trees. My home is my castle enjoy it;)",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Koshjuha",
		houseId = 81,
		description = "Ritual site of a nord. Visit it at night and enjoy the light and atmosphere.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Koshjuha",
		houseId = 34,
		description = "A Redguard tavern with charm and rock garden.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Koshjuha",
		houseId = 25,
		description = "Enjoy food and drink or chill out with a game of redguard billiards.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Radulf_Silberwolf",
		houseId = 62,
		description = "Ein Ort für Templer, zum Treffen und Meditieren",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Radulf_Silberwolf",
		houseId = 28,
		description = "Jägertreff eines Nord",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Radulf_Silberwolf",
		houseId = 34,
		description = "Kleine Taverne am Rande des Weges",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
end

function PortToFriendData.CreateNaDataList()
	local i = 1
	local list = PortToFriendData.naData
end

function PortToFriendData.CreateDataList()
	if GetWorldName() == "EU Megaserver" then
		PortToFriendData.CreateEuDataList()
	else
		PortToFriendData.CreateNaDataList()
	end
end

function PortToFriendData.GetLibraryData()
	PortToFriendData.CreateDataList()
	if GetWorldName() == "EU Megaserver" then
		return PortToFriendData.euData
	else
		return PortToFriendData.naData
	end
end