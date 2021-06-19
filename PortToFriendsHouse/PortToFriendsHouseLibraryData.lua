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
		houseId = 61,
		description = "Hircine's Hunt Club\r\n\r\nA relaxing villa for all werewolves to come and feast in the ever flowing hunting grounds",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 82,
		description = "Lost Dwarven Kingdom\r\n\r\nThe palace of a lost Dwemer king has been found in a mage's pocket realm",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 49,
		description = "Witch Tower Inn\r\n\r\nAn abandoned witch tower, converted into a little inn",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 40,
		description = "Topal Fishing Resort\r\n\r\nA resort in the middle of a fishing lake on a private island",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 59,
		description = "Castleton Manor\r\n\r\nThe house of Lord Castleton and his daughter Sonja",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 41,
		description = "Cave of BBQ N Ribs\r\n\r\nA secret dome, built inside a dank and secluded cavern, hosts the best BBQ and ribs restaurant",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 11,
		description = "Who Lived in a Shoe\r\n\r\nThere was an old reach witch who lived in a shoe",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 70,
		description = "Dwemer Party Tower\r\n\r\nA dwarven flying tower redesigned for parties",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 23,
		description = "A Taste of Alinor\r\n\r\nA small piece of Alinor situated beside a Rawl’kha creek",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 83,
		description = "Markarth Bath House\r\n\r\nA relaxing spa and bath house with an arts and craft centre for visitors to unwind. Or pay extra to stay the night in our VIP suite.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 15,
		description = "Treeboat house\r\n\r\nNo one know how an imperial ship ended up in the treetops, but it makes a great treehouse.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 86,
		description = "Varlaisvea College\r\n\r\nAn ancient library has been discovered deep inside an Ayleid ruin.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 55,
		description = "City on the Moon\r\n\r\nCity Moonbase with housing and an inn under the stars.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@seecodenotgames",
		houseId = 64,
		description = "Lakemire Water Gardens\r\n\r\nRelaxing hanging gardens and a fish restaurant beneath the Xanmeer.",
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
		name = "@Nalos",
		houseId = 66,
		description = "Jump'n Run, bitte beachten, das Haus ist ein PvP Gebiet: Ihr könnt euch heilen, an Ort und Stelle wieder beleben und euch auch gegenseitig liebevoll behandeln :D\r\nFür den optimalen Genuss bitte alle 3 Hebel im Raum links ziehen.",
		category = {PortToFriend.constants.FILTER_ID_JUMPNRUN, PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Nalos",
		houseId = 62,
		description = "Pompeji vor dem Ausbruch des Vulkans",
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
		name = "@Grila",
		houseId = 25,
		description = "Grüne Laube",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@LordStorm1978",
		houseId = 71,
		description = "Kirche",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@LordStorm1978",
		houseId = 83,
		description = "Dampflok zurück in die Zukunft",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
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
	list[#list + 1] = {
		name = "@Kyatos",
		houseId = 81,
		description = "Just a vampiric styled house. All munduses, about 3/4 crafting set stations collected for now (still in progress), training dummies, ayleid well, vampire thrall/fountain, transmute station",
		category = {PortToFriend.constants.FILTER_ID_CRAFTING, PortToFriend.constants.FILTER_ID_GUILD, PortToFriend.constants.FILTER_ID_RAID}
	}
	list[#list + 1] = {
		name = "@Nemedon",
		houseId = 81,
		description = "Escape House",
		category = {PortToFriend.constants.FILTER_ID_LABYRINTH, PortToFriend.constants.FILTER_ID_JUMPNRUN}
	}
	list[#list + 1] = {
		name = "@ClevaTreva",
		houseId = 81,
		description = "Antiquarians College",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT, PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@ClevaTreva",
		houseId = 49,
		description = "Witch Evicted by Covenant Forces",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT, PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@ClevaTreva",
		houseId = 32,
		description = "Adventurers beware!",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT, PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@ClevaTreva",
		houseId = 80,
		description = "Nord themed Wedding Venue - with Nightclub!",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT, PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@ClevaTreva",
		houseId = 86,
		description = "Warden's Retreat & Spa",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT, PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@ClevaTreva",
		houseId = 59,
		description = "Museum with scratchbuilt courtyard extension",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 62,
		description = "Ein Ort für Handwerk und Transmutieren oder einfach zur geistigen Entspannung und zum Abschalten. Inkl. alle Antiquitäten",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT, PortToFriend.constants.FILTER_ID_ROLEPLAY, PortToFriend.constants.FILTER_ID_RAID}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 59,
		description = "Gemütlich",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 81,
		description = "Nicht nur für Vampire",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 23,
		description = "Teppiche mal anders ;)",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 70,
		description = "Liebe Elsweyr einfach. Gemütlich",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 64,
		description = "Relaxen, Fische schauen",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 73,
		description = "Gemütlich",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 83,
		description = "Dwemer Idylle",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Lokia99",
		houseId = 78,
		description = "Gemütliches Stadthaus",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Heynrich1976",
		houseId = 41,
		description = "Felsgold-Kaverne/Rockgold Cavern\r\n\r\nRebuild cave ruins with merchants & bank, training & crafing area.",
		category = {PortToFriend.constants.FILTER_ID_GUILD}
	}
	list[#list + 1] = {
		name = "@Heynrich1976",
		houseId = 70,
		description = "Elsweyr-Heldenhalle/Elweyr Heroes Hall\r\n\r\nService Hall with portals to POI.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Heynrich1976",
		houseId = 1,
		description = "Vulkhelwacht Stube/Vulkhel Guard Room\r\n\r\nNice fireplace.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Heynrich1976",
		houseId = 13,
		description = "Eldenwurz Baumhaus/Elden Root Treehouse\r\n\r\nBuild in a second floor.",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@mae_glunenstein",
		houseId = 64,
		description = "Argonische Wohlfühloase",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@mae_glunenstein",
		houseId = 71,
		description = "Niederländisches Dorf",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@mae_glunenstein",
		houseId = 70,
		description = "Dekadentes Katzenhaus ganz ohne Mäuse",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@mae_glunenstein",
		houseId = 61,
		description = "Poolhaus in Stein gemeißelt",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Moytira",
		houseId = 71,
		description = "Alle Settische, Transmutation, Monturtisch, Übungspuppen. Gemütliches Strandcafé",
		category = {PortToFriend.constants.FILTER_ID_CRAFTING}
	}
	list[#list + 1] = {
		name = "@Moytira",
		houseId = 62,
		description = "Ein Ort des Wissens und Forschens",
		category = {PortToFriend.constants.FILTER_ID_HIGHLIGHT}
	}
	list[#list + 1] = {
		name = "@Troodon80",
		houseId = 47,
		description = "",
		category = {PortToFriend.constants.FILTER_ID_CRAFTING}
	}
end

function PortToFriendData.CreateNaDataList()
	local i = 1
	local list = PortToFriendData.naData
	list[#list + 1] = {
		name = "@craybest",
		houseId = 78,
		description = "The new abandoned Ravenhill Manor, up in the Skyrim ravines. It's still a mystery what truly happened in there, but you can feel an uneasy feeling whenever you get close to it. Signs of failed summonings, corpses lying around in a darkness that envelopps the area. what is its true story? maybe you can help finally solving the mystery, if you're brave enough to enter, that is.",
		category = {PortToFriend.constants.FILTER_ID_ROLEPLAY}
	}
	list[#list + 1] = {
		name = "@Gadolyah",
		houseId = 47,
		description = "Maw of Lorkaj Training Centre",
		category = {PortToFriend.constants.FILTER_ID_RAID}
	}
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