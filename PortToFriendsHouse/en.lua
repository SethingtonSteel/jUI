-- PortToFriendsHouse
-- By @s0rdrak (PC / EU)

local PortToFriend = _G['PortToFriend']

PortToFriend.HOUSES =
{
    [1] = "Mara's Kiss Public House",
    [2] = "The Rosy Lion",
    [3] = "The Ebony Flask Inn Room",
    [4] = "Barbed Hook Private Room",
    [5] = "Sisters of the Sands Apartment",
    [6] = "Flaming Nix Deluxe Garret",
    [7] = "Black Vine Villa",
    [8] = "Cliffshade",
    [9] = "Mathiisen Manor",
    [10] = "Humblemud",
    [11] = "The Ample Domicile",
    [12] = "Stay-Moist Mansion",
    [13] = "Snugpod",
    [14] = "Bouldertree Refuge",
    [15] = "The Gorinir Estate",
    [16] = "Captain Margaux's Place",
    [17] = "Ravenhurst",
    [18] = "Gardner House",
    [19] = "Kragenhome",
    [20] = "Velothi Reverie",
    [21] = "Quondam Indorilia",
    [22] = "Moonmirth House",
    [23] = "Sleek Creek House",
    [24] = "Dawnshadow",
    [25] = "Cyrodilic Jungle House",
    [26] = "Domus Phrasticus",
    [27] = "Strident Springs Demesne",
    [28] = "Autumn's-Gate",
    [29] = "Grymharth's Woe",
    [30] = "Old Mistveil Manor",
    [31] = "Hammerdeath Bungalow",
    [32] = "Mournoth Keep",
    [33] = "Forsaken Stronghold",
    [34] = "Twin Arches",
    [35] = "House of the Silent Magnifico",
    [36] = "Hunding's Palatial Hall",
    [37] = "Serenity Falls Estate",
    [38] = "Daggerfall Overlook",
    [39] = "Ebonheart Chateau",
    [40] = "Grand Topal Hideaway",
    [41] = "Earthtear Cavern",
    [42] = "Saint Delyn Penthouse",
    [43] = "Amaya Lake Lodge",
    [44] = "Ald Velothi Harbor House",
    [45] = "Tel Galen Tower",
	[46] = "Linchal Grand Manor",
	[47] = "Coldharbour Surreal Estate",
	[48] = "Hakkvild's High Hall",
	[49] = "Exorcised Coven Cottage",
	[54] = "Pariah's Pinnacle",
	[55] = "The Orbservatory Prior",
	[56] = "The Erstwhile Sanctuary",
	[57] = "Princely Dawnlight Palace",
	[58] = "Golden Gryphon Garret",
	[59] = "Alinor Crest Townhouse",
	[60] = "Colossal Aldmeri Grotto",
	[61] = "Hunter's Glade",
	[62] = "Grand Psijic Villa",
	[63] = "Enchanted Snow Globe Home",
	[64] = "Lakemire Xanmeer Manor",
	[65] = "Frostvault Chasm",
	[66] = "Elinhir Private Arena",
	[68] = "Sugar Bowl Suite",
	[69] = "Jode's Embrace",
	[70] = "Hall of the Lunar Champion",
	[71] = "Moon-Sugar Meadow",
	[72] = "Wraithhome",
	[73] = "Lucky Cat Landing",
	[74] = "Potentate's Retreat",
	[75] = "Forgemaster Falls",
	[76] = "Thieves' Oasis",
	[77] = "Snowmelt Suite",
	[78] = "Proudspire Manor",
	[79] = "Bastion Sanguinaris",
	[80] = "Stillwaters Retreat",
	[81] = "Antiquarian's Alpine Gallery"
}
PortToFriend.constants.HEADER_TITLE = "Port to Friend's House"
PortToFriend.constants.LABEL_PLAYER = "Player:"
PortToFriend.constants.BUTTON_PORT = "Port"
PortToFriend.constants.BUTTON_ADD_FAVORITE = "Add Favorite"
PortToFriend.constants.BUTTON_SEND_VISITCARD = "Send visit card"
PortToFriend.constants.BUTTON_MAIN_RESIDENCE = "Main Residence"
PortToFriend.constants.VC_HEADER_TITLE = "Visit Cards"
PortToFriend.constants.VC_PLAYER = "Player: "
PortToFriend.constants.VC_HOUSE = "House: "
PortToFriend.constants.BUTTON_REMOVE = "Remove"
PortToFriend.constants.BUTTON_VC = "VC"
PortToFriend.constants.TOGGLE_PORT_WINDOW = "Toggle Port Window"
PortToFriend.constants.PORT_TO_FAVORITE = "Port to favorite #%d"
PortToFriend.constants.INVALID_FAVORITE_ID = "An invalid ID has been specified"
PortToFriend.constants.SORT_NAME = "Player"
PortToFriend.constants.SORT_HOUSE = "House"
PortToFriend.constants.CMD_HELP_1 = " open: opens the Port to Friend's House menu"
PortToFriend.constants.CMD_HELP_2 = " show: displays the IDs of all possible houses"
PortToFriend.constants.CMD_HELP_3 = " port <player> <ID>: tries to port to the specified house. The ID is optional"
PortToFriend.constants.CMD_HELP_4 = " fav <ID>: Port to favorite <ID>"
PortToFriend.constants.TAB_HOUSE_TITLE = "Houses"
PortToFriend.constants.TAB_VC_TITLE = "Visit Cards"
PortToFriend.constants.TAB_MYHOUSES_TITLE = "My Houses"
PortToFriend.constants.TAB_LIBRARY_TITLE = "Library"
PortToFriend.constants.TAB_DONATE_TITLE = "Donation"
PortToFriend.constants.DONATION_WRONG_SERVER = "Thank you for considering donating some gold.\r\nBut as I do play on PC EU it wouldn't make sense to send me gold on PC NA."
PortToFriend.constants.DONATION_MESSAGE = "Thank you for considering donating some gold."
PortToFriend.constants.BUTTON_DONATION_PERSONAL = "Donate"
PortToFriend.constants.BUTTON_DONATION_5 = "Donate 5'000 gold"
PortToFriend.constants.BUTTON_DONATION_50 = "Donate 50'000 gold"
PortToFriend.constants.DONATE_MAIL_SUBJECT = "PortToFriend Donation"
PortToFriend.constants.LIBRARY_MESSAGE = "The library contains player supplied houses. If you want your house to be part of the library, leave a note in one of the PTF threads on the ESO forums or ESOUI (AddOn comment)."
PortToFriend.constants.SORT_LABEL = "Order"
PortToFriend.constants.SORT_HOUSE = "House"
PortToFriend.constants.SORT_LOCATION = "Location"
PortToFriend.constants.FILTER_LABEL = "Category Filter"
PortToFriend.constants.FILTER_NONE = "--NONE--"
PortToFriend.constants.FILTER_HIGHLIGHT = "Highlight"
PortToFriend.constants.FILTER_LABYRINTH = "Labyrinth"
PortToFriend.constants.FILTER_JUMPNRUN = "Jump 'n' Run"
PortToFriend.constants.FILTER_CRAFTING = "Crafting / Mundus"
PortToFriend.constants.FILTER_GUILD = "Guild Hall"
PortToFriend.constants.FILTER_ROLEPLAY = "Roleplay"
PortToFriend.constants.FILTER_RAID = "Raid / DPS"
PortToFriend.constants.FILTER_HIDE_SEEK = "Hide and Seek"
PortToFriend.constants.FILTER_ERP = "ERP"
PortToFriend.constants.MYHOUSES_FRONT_DOOR = "Front Door"
PortToFriend.constants.MYHOUSES_PORT_INSIDE = "Port Inside"

PortToFriend.constants.menu = {}
PortToFriend.constants.menu.DISPLAY_NAME = "|c4592FFPort To Friend's House Configuration|r"
PortToFriend.constants.menu.AUTHOR = string.format("|cFF8174%s|r\r\nThanks to: |cFF8174%s|r\r\n", PortToFriend.author, PortToFriend.credits)
PortToFriend.constants.menu.VERSION = string.format("|cFF8174%s|r", PortToFriend.versionString)
PortToFriend.constants.menu.TITLE = "Chat Configuration"
PortToFriend.constants.menu.DESCRIPTION = "Configure the chats which should be allowed to add visit cards"

PortToFriend.constants.menu.G1 = "Guild 1"
PortToFriend.constants.menu.O1 = "Officer 1"
PortToFriend.constants.menu.G2 = "Guild 2"
PortToFriend.constants.menu.O2 = "Officer 2"
PortToFriend.constants.menu.G3 = "Guild 3"
PortToFriend.constants.menu.O3 = "Officer 3"
PortToFriend.constants.menu.G4 = "Guild 4"
PortToFriend.constants.menu.O4 = "Officer 4"
PortToFriend.constants.menu.G5 = "Guild 5"
PortToFriend.constants.menu.O5 = "Officer 5"
PortToFriend.constants.menu.EMOTE = "Emote"
PortToFriend.constants.menu.SAY = "Say"
PortToFriend.constants.menu.YELL = "Yell"
PortToFriend.constants.menu.GROUP = "Group"
PortToFriend.constants.menu.TELL = "Tell"
PortToFriend.constants.menu.ZONE = "Zone"
PortToFriend.constants.menu.ENZONE = "Zone - English"
PortToFriend.constants.menu.FRZONE = "Zone - French"
PortToFriend.constants.menu.DEZONE = "Zone - German"
PortToFriend.constants.menu.JPZONE = "Zone - Japan"
PortToFriend.constants.menu.ALLOW_SELF = "Allow Self VC"

PortToFriend.constants.CONTEXT_MENU_SEND = "Send to PTF"