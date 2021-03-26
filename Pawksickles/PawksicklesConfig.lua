local LAM = LibStub( 'LibAddonMenu-2.0', true )
local LMP = LibStub( 'LibMediaProvider-1.0', true )

if ( not LAM ) then return end
if ( not LMP ) then return end

local tsort = table.sort
local tinsert = table.insert

local PawksicklesConfig =
{
    _name = '_pawksickles',
    _headers = setmetatable( {}, { __mode = 'kv' } )
}

local CBM = CALLBACK_MANAGER

local THIN          = 'soft-shadow-thin'
local THICK         = 'soft-shadow-thick'
local SHADOW        = 'shadow'
local NONE          = 'none'

local defaults =
{
    ZoFontWinH1 = { face = 'Expressway', size = 30, decoration = outline },
    ZoFontWinH2 = { face = 'Expressway', size = 24, decoration = outline },
    ZoFontWinH3 = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontWinH4 = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontWinH5 = { face = 'Expressway', size = 16, decoration = outline },

    ZoFontWinT1 = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontWinT2 = { face = 'Expressway', size = 16, decoration = outline },

    ZoFontGame = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontGameMedium = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontGameBold = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontGameOutline = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontGameShadow = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontGameSmall = { face = 'Expressway', size = 13, decoration = outline },
    ZoFontGameLarge = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontGameLargeBold = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontGameLargeBoldShadow = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontHeader  = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontHeader2  = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontHeader3  = { face = 'Expressway', size = 24, decoration = outline },
    ZoFontHeader4  = { face = 'Expressway', size = 26, decoration = outline },

    ZoFontHeaderNoShadow  = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontCallout  = { face = 'Expressway', size = 36, decoration = outline },
    ZoFontCallout2  = { face = 'Expressway', size = 48, decoration = outline },
    ZoFontCallout3  = { face = 'Expressway', size = 54, decoration = outline },

    ZoFontEdit  = { face = 'Expressway', size = 18, decoration = SHADOW },

    --ZoFontChat  = { face = 'Expressway', size = 18, decoration = outline },
    ZoFontEditChat  = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontWindowTitle  = { face = 'Expressway', size = 30, decoration = outline },
    ZoFontWindowSubtitle  = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontTooltipTitle  = { face = 'Expressway', size = 22, decoration = outline },
    ZoFontTooltipSubtitle  = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontAnnounce  = { face = 'Expressway', size = 28, decoration = outline },
    ZoFontAnnounceMessage  = { face = 'Expressway', size = 24, decoration = outline },
    ZoFontAnnounceMedium  = { face = 'Expressway', size = 24, decoration = outline },
    ZoFontAnnounceLarge  = { face = 'Expressway', size = 36, decoration = outline },

    ZoFontAnnounceNoShadow  = { face = 'Expressway', size = 36, decoration = outline },

    ZoFontCenterScreenAnnounceLarge  = { face = 'Expressway', size = 40, decoration = outline },
    ZoFontCenterScreenAnnounceSmall  = { face = 'Expressway', size = 30, decoration = outline },

    ZoFontAlert  = { face = 'Expressway', size = 24, decoration = outline },

    ZoFontConversationName  = { face = 'Expressway', size = 28, decoration = outline },
    ZoFontConversationText  = { face = 'Expressway', size = 24, decoration = outline },
    ZoFontConversationOption  = { face = 'Expressway', size = 22, decoration = outline },
    ZoFontConversationQuestReward  = { face = 'Expressway', size = 20, decoration = outline },

    ZoFontKeybindStripKey  = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontKeybindStripDescription  = { face = 'Expressway', size = 25, decoration = outline },
    ZoFontDialogKeybindDescription  = { face = 'Expressway', size = 20, decoration = outline },

    ZoInteractionPrompt  = { face = 'Expressway', size = 24, decoration = outline },

    ZoFontCreditsHeader  = { face = 'Expressway', size = 24, decoration = outline },
    ZoFontCreditsText  = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontBookPaper  = { face = 'PT_Sans', size = 20, decoration = outline },
    ZoFontBookSkin  = { face = 'PT_Sans', size = 20, decoration = outline },
    ZoFontBookRubbing  = { face = 'PT_Sans', size = 20, decoration = outline },
    ZoFontBookLetter  = { face = 'PT_Sans', size = 20, decoration = outline },
    ZoFontBookNote  = { face = 'PT_Sans', size = 22, decoration = outline },
    ZoFontBookScroll  = { face = 'PT_Sans', size = 26, decoration = outline },
    ZoFontBookTablet  = { face = 'PT_Sans', size = 30, decoration = outline },

    ZoFontBookPaperTitle  = { face = 'OpenSans Semibold', size = 30, decoration = outline },
    ZoFontBookSkinTitle  = { face = 'OpenSans Semibold', size = 30, decoration = outline },
    ZoFontBookRubbingTitle  = { face = 'OpenSans Semibold', size = 30, decoration = outline },
    ZoFontBookLetterTitle  = { face = 'OpenSans Semibold', size = 30, decoration = outline },
    ZoFontBookNoteTitle  = { face = 'OpenSans Semibold', size = 32, decoration = outline },
    ZoFontBookScrollTitle  = { face = 'OpenSans Semibold', size = 34, decoration = outline },
    ZoFontBookTabletTitle  = { face = 'OpenSans Semibold', size = 48, decoration = outline },


    ZoFontGamepad61 = { face = 'Expressway', size = 61, decoration = outline },
    ZoFontGamepad54 = { face = 'Expressway', size = 54, decoration = outline },
    ZoFontGamepad45 = { face = 'Expressway', size = 45, decoration = outline },
    ZoFontGamepad42 = { face = 'Expressway', size = 42, decoration = outline },
    ZoFontGamepad36 = { face = 'Expressway', size = 36, decoration = outline },
    ZoFontGamepad34 = { face = 'Expressway', size = 34, decoration = outline },
    ZoFontGamepad27 = { face = 'Expressway', size = 27, decoration = outline },
    ZoFontGamepad25 = { face = 'Expressway', size = 25, decoration = outline },
    ZoFontGamepad22 = { face = 'Expressway', size = 22, decoration = outline },
    ZoFontGamepad20 = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepad18 = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontGamepad27NoShadow = { face = 'Expressway', size = 27, decoration = outline },
    ZoFontGamepad42NoShadow = { face = 'Expressway', size = 42, decoration = outline },

    ZoFontGamepadCondensed61 = { face = 'Expressway', size = 61, decoration = outline },
    ZoFontGamepadCondensed54 = { face = 'Expressway', size = 54, decoration = outline },
    ZoFontGamepadCondensed45 = { face = 'Expressway', size = 45, decoration = outline },
    ZoFontGamepadCondensed42 = { face = 'Expressway', size = 42, decoration = outline },
    ZoFontGamepadCondensed36 = { face = 'Expressway', size = 36, decoration = outline },
    ZoFontGamepadCondensed34 = { face = 'Expressway', size = 34, decoration = outline },
    ZoFontGamepadCondensed27 = { face = 'Expressway', size = 27, decoration = outline },
    ZoFontGamepadCondensed25 = { face = 'Expressway', size = 25, decoration = outline },
    ZoFontGamepadCondensed22 = { face = 'Expressway', size = 22, decoration = outline },
    ZoFontGamepadCondensed20 = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadCondensed18 = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontGamepadBold61 = { face = 'Expressway', size = 61, decoration = outline },
    ZoFontGamepadBold54 = { face = 'Expressway', size = 54, decoration = outline },
    ZoFontGamepadBold45 = { face = 'Expressway', size = 45, decoration = outline },
    ZoFontGamepadBold42 = { face = 'Expressway', size = 42, decoration = outline },
    ZoFontGamepadBold36 = { face = 'Expressway', size = 36, decoration = outline },
    ZoFontGamepadBold34 = { face = 'Expressway', size = 34, decoration = outline },
    ZoFontGamepadBold27 = { face = 'Expressway', size = 27, decoration = outline },
    ZoFontGamepadBold25 = { face = 'Expressway', size = 25, decoration = outline },
    ZoFontGamepadBold22 = { face = 'Expressway', size = 22, decoration = outline },
    ZoFontGamepadBold20 = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadBold18 = { face = 'Expressway', size = 18, decoration = outline },

    ZoFontGamepadChat = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadEditChat = { face = 'Expressway', size = 20, decoration = outline },

    ZoFontGamepadBookPaper  = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadBookSkin  = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadBookRubbing  = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadBookLetter  = { face = 'Expressway', size = 20, decoration = outline },
    ZoFontGamepadBookNote  = { face = 'Expressway', size = 22, decoration = outline },
    ZoFontGamepadBookScroll  = { face = 'Expressway', size = 26, decoration = outline },
    ZoFontGamepadBookTablet  = { face = 'Expressway', size = 30, decoration = outline },

    ZoFontGamepadBookPaperTitle  = { face = 'Expressway', size = 30, decoration = outline },
    ZoFontGamepadBookSkinTitle  = { face = 'Expressway', size = 30, decoration = outline },
    ZoFontGamepadBookRubbingTitle  = { face = 'Expressway', size = 30, decoration = outline },
    ZoFontGamepadBookLetterTitle  = { face = 'Expressway', size = 30, decoration = outline },
    ZoFontGamepadBookNoteTitle  = { face = 'Expressway', size = 32, decoration = outline },
    ZoFontGamepadBookScrollTitle  = { face = 'Expressway', size = 34, decoration = outline },
    ZoFontGamepadBookTabletTitle  = { face = 'Expressway', size = 48, decoration = outline },

    ZoFontGamepadHeaderDataValue = { face = 'Expressway', size = 42, decoration = outline },
}

local logical = {}
local decorations = { 'none', 'outline', 'thin-outline', 'thick-outline', 'soft-shadow-thin', 'soft-shadow-thick', 'shadow' }

function PawksicklesConfig:FormatFont( fontEntry )
    local str = '%s|%d'
    if ( fontEntry.decoration ~= outline ) then
        str = str .. '|%s'
    end

    fontEntry.face = string.gsub(fontEntry.face, '^Futura Std Condensed', 'EsoUI/Common/Fonts/ESO_FWNTLGUDC70-DB.ttf', 1)
    return string.format( str, LMP:Fetch( 'font', fontEntry.face ), fontEntry.size or 10, fontEntry.decoration )
end

function PawksicklesConfig:OnLoaded()
    self.db = ZO_SavedVars:NewAccountWide( 'PAWKSICKLES_DB_JP', 1.0, nil, defaults )

    --fonts removed in Update 7
    self.db[ 'ZoLargeFontEdit' ]  = nil
    self.db[ 'ZoFontAnnounceSmall' ]  = nil
    self.db[ 'ZoFontBossName' ]  = nil
    self.db[ 'ZoFontBoss' ]  = nil

    for k,_ in pairs( defaults ) do
        tinsert( logical, k )
    end

    tsort( logical )

    self.config_panel = LAM:RegisterAddonPanel(self._name, {
        type = panel,
        name = 'Pawksickles',
        displayName = ZO_HIGHLIGHT_TEXT:Colorize('Pawksickles'),
        author = "Pawkette (updated by Garkin)",
        version = "1.4",
        slashCommand = "/pawksickles",
        registerForRefresh = true,
        registerForDefaults = true,
    })

    self:BeginAddingOptions()

    local UpdateHeaders
    UpdateHeaders = function(panel)
        if panel == self.config_panel then
            for i, gameFont in ipairs(logical) do
                local newFont = self:FormatFont( self.db[ gameFont ] )
                self._headers[ gameFont ] = _G[self._name .. '_header_' .. i].header
                self._headers[ gameFont ]:SetFont( newFont )
            end
            CALLBACK_MANAGER:UnregisterCallback("LAM-PanelControlsCreated", UpdateHeaders)
        end
    end
    CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", UpdateHeaders)
end

function PawksicklesConfig:BeginAddingOptions()
    local optionsData = {}

    for i, gameFont in ipairs(logical) do
        if ( self.db[ gameFont ] ) then
            CBM:FireCallbacks( 'PAWKSICKLES_FONT_CHANGED', gameFont, self:FormatFont( self.db[ gameFont ] ) )

            tinsert( optionsData, {
                type = 'header',
                name = gameFont,
                reference = self._name .. '_header_' .. i,
                } )
            tinsert( optionsData, {
                type = 'dropdown',
                name = 'Font:',
                choices = LMP:List( 'font' ),
                getFunc = function() return self.db[ gameFont ].face end,
                setFunc = function( selection )  self:FontDropdownChanged( gameFont, selection ) end,
                default = defaults[ gameFont ].face,
                } )
            tinsert( optionsData, {
                type = 'slider',
                name = 'Size:',
                min = 5,
                max = 50,
                getFunc = function() return self.db[ gameFont ].size end,
                setFunc = function( size ) self:SliderChanged( gameFont, size ) end,
                default = defaults[ gameFont ].size,
                } )
            tinsert( optionsData, {
                type = 'dropdown',
                name = 'Decoration:',
                choices = decorations,
                getFunc = function() return self.db[ gameFont ].decoration end,
                setFunc = function( selection ) self:DecorationDropdownChanged( gameFont, selection ) end,
                default = defaults[ gameFont ].decoration,
                } )
        end
    end

    LAM:RegisterOptionControls(self._name, optionsData)
end

function PawksicklesConfig:FontDropdownChanged( gameFont, fontFace )
    self.db[ gameFont ].face = fontFace
    local newFont = self:FormatFont( self.db[ gameFont ] )
    if ( self._headers[ gameFont ] ) then
        self._headers[ gameFont ]:SetFont( newFont )
    end

    CBM:FireCallbacks( 'PAWKSICKLES_FONT_CHANGED', gameFont, newFont )
end

function PawksicklesConfig:SliderChanged( gameFont, size )
    self.db[ gameFont ].size = size
    local newFont = self:FormatFont( self.db[ gameFont ] )
    if ( self._headers[ gameFont ] ) then
        self._headers[ gameFont ]:SetFont( newFont )
    end

    CBM:FireCallbacks( 'PAWKSICKLES_FONT_CHANGED', gameFont, newFont )
end

function PawksicklesConfig:DecorationDropdownChanged( gameFont, decoration )
    self.db[ gameFont ].decoration = decoration
    local newFont = self:FormatFont( self.db[ gameFont ] )
    if ( self._headers[ gameFont ] ) then
        self._headers[ gameFont ]:SetFont( newFont )
    end

    CBM:FireCallbacks( 'PAWKSICKLES_FONT_CHANGED', gameFont, newFont )
end

CBM:RegisterCallback( 'PAWKSICKLES_LOADED', function( ... ) PawksicklesConfig:OnLoaded( ... ) end )