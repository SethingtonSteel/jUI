--[[ Umlauts & special characters list
	ä --> \195\164
	Ä --> \195\132
	ö --> \195\182
	Ö --> \195\150
	ü --> \195\188
	Ü --> \195\156
	ß --> \195\159

   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
      	 		   ë : \195\171    ï : \195\175
   æ : \195\166    ø : \195\184
   ç : \195\167                                    œ : \197\147
   Ä : \195\132    Ö : \195\150    Ü : \195\156    ß : \195\159
   ä : \195\164    ö : \195\182    ü : \195\188
   ã : \195\163    õ : \195\181  				   \195\177 : \195\177
]]
local FCOLP = FCOLP
FCOLP.localizationVars.localizationAll = {
	--English
    [1] = {
		-- Options menu
        ["options_description"] 				 = "FCO Lockpicker shows the lockpicks you got left during opening of a chest in different colors",
		["options_header1"] 			 		 = "General settings",
    	["options_language"] 					 = "Language",
		["options_language_tooltip"] 			 = "Choose the language",
		["options_language_use_client"] 		 = "Use client language",
		["options_language_use_client_tooltip"]  = "Always let the addon use the game client's language.",
		["options_language_dropdown_selection1"] = "English",
		["options_language_dropdown_selection2"] = "German",
		["options_language_dropdown_selection3"] = "French",
		["options_language_dropdown_selection4"] = "Spanish",
		["options_language_dropdown_selection5"] = "Italian",
		["options_language_dropdown_selection6"] = "Japanese",
		["options_language_dropdown_selection7"] = "Russian",
		["options_language_description1"]		 = "CAUTION: Changing the language/save option will reload the user interface!",
        ["options_savedvariables"]				 = "Save settings",
        ["options_savedvariables_tooltip"]       = "Save the addon settings for all your characters of your account, or single for each character",
        ["options_savedVariables_dropdown_selection1"] = "Each character",
        ["options_savedVariables_dropdown_selection2"] = "Account wide",
		--Colors & values
		["options_header_color"]				 = "Colors",
		["options_normal_color"] 				 = "Normal color",
		["options_normal_color_tooltip"] 		 = "The color of the lockpicks left text if you got enough lockpicks left",
		["options_normal_value"] 				 = "Normal threshold value",
		["options_normal_value_tooltip"] 		 = "How many lockpicks do you need at least for 'normal' color?",
		["options_medium_color"] 				 = "Medium color",
		["options_medium_color_tooltip"] 		 = "The color of the lockpicks left text if you got some lockpicks left",
		["options_medium_value"] 				 = "Medium threshold value",
		["options_medium_value_tooltip"] 		 = "How many lockpicks do you need at least for 'medium' color?",
		["options_low_color"] 					 = "Low color",
		["options_low_color_tooltip"] 			 = "The color of the lockpicks left text if you got only a few lockpicks left",
		["options_low_value"] 					 = "Low threshold value",
		["options_low_value_tooltip"] 			 = "How many lockpicks do you need at least for 'low' color?",
		["options_header_chamber_resolved"] 	 = "Chamber resolved",
        ["options_show_chamber_resolved_icon"]	 = "Show chamber resolved icon",
        ["options_show_chamber_resolved_icon_tooltip"]	 = "Show an icon if the actual lock's chamber has been resolved",
		["options_show_chamber_resolved_green_springs"]	= "Show green springs",
		["options_show_chamber_resolved_green_springs_tooltip"] = "Colorize the srping of the lock green if the chamber is resolved.",
        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
        ["chatcommands_help"]					 = "|cFFFFFF'help' / 'list'|cFFFF00: Shows this information about the addon",
        ["chatcommands_debug"]					 = "|cFFFFFF'debug'|cFFFF00: Enable/Disable debug messages. |c990000[Attention]|cFFFF00 This will  flood your local chat!",
        ["chatcommands_debug_on"]				 = "Debug: ON",
        ["chatcommands_debug_off"]				 = "Debug: OFF",
        ["chatcommands_deepdebug_on"]			 = "Deep debug: ON",
        ["chatcommands_deepdebug_off"]			 = "Deep debug: OFF",
    },
--==============================================================================
	--German / Deutsch
    [2] = {
		-- Options menu
        ["options_description"] 				 = "FCO Lockpicker zeigt Ihnen die restlichen Dietriche beim Öffnen einer Kiste farblich markiert an",
		["options_header1"] 			 		 = "Generelle Einstellungen",
    	["options_language"] 					 = "Sprache",
		["options_language_tooltip"] 			 = "Wählen Sie die Sprache aus",
		["options_language_use_client"] 		 = "Benutze Spiel Sprache",
		["options_language_use_client_tooltip"]  = "Lässt das AddOn immer die Sprache des Spiel Clients nutzen.",
		["options_language_dropdown_selection1"] = "Englisch",
		["options_language_dropdown_selection2"] = "Deutsch",
		["options_language_dropdown_selection3"] = "Französisch",
		["options_language_dropdown_selection4"] = "Spanisch",
		["options_language_dropdown_selection5"] = "Italienisch",
		["options_language_dropdown_selection6"] = "Japanisch",
		["options_language_dropdown_selection7"] = "Russisch",
		["options_language_description1"]		 = "ACHTUNG: Veränderungen der Sprache/der Speicherart laden die Benutzeroberfläche neu!",
        ["options_savedvariables"]				 = "Einstellungen speichern",
        ["options_savedvariables_tooltip"]       = "Die Einstellungen dieses Addons werden für alle Charactere Ihres Accounts, oder für jeden Character einzeln gespeichert",
        ["options_savedVariables_dropdown_selection1"] = "Jeder Charakter",
        ["options_savedVariables_dropdown_selection2"] = "Ganzer Account",
		--Colors & values
		["options_header_color"]				 = "Colors",
		["options_normal_color"] 				 = "Normale Farbe",
		["options_normal_color_tooltip"] 		 = "Die Farbe des Dietriche übrig Text, wenn Sie genug Dietriche übrig haben",
		["options_normal_value"] 				 = "Normaler Schwellenwert",
		["options_normal_value_tooltip"] 		 = "Wie viele Dietriche benötigen Sie noch mindestens, damit die 'normale' Farbe benutzt wird?",
		["options_medium_color"] 				 = "Mittlere Farbe",
		["options_medium_color_tooltip"] 		 = "Die Farbe des Dietriche übrig Text, wenn Sie noch einige Dietriche übrig haben",
		["options_medium_value"] 				 = "Mittlerer Schwellenwert",
		["options_medium_value_tooltip"] 		 = "Wie viele Dietriche benötigen Sie noch mindestens, damit die 'mittlere' Farbe benutzt wird?",
		["options_low_color"] 					 = "Geringe Farbe",
		["options_low_color_tooltip"] 			 = "Die Farbe des Dietriche übrig Text, wenn Sie fast keine Dietriche mehr übrig haben",
		["options_low_value"] 					 = "Geringer Schwellenwert",
		["options_low_value_tooltip"] 			 = "Wie viele Dietriche benötigen Sie noch mindestens, damit die 'geringe' Farbe benutzt wird?",
		["options_header_chamber_resolved"] 	 = "Kammer gelöst",
        ["options_show_chamber_resolved_icon"]	 = "Zeige Kammer gelöst Symbol",
        ["options_show_chamber_resolved_icon_tooltip"]	 = "Zeit ein Symbol an, wenn die aktuelle Kammer des Schlosses gelöst wurde",
        ["options_show_chamber_resolved_green_springs"]	= "Färbe Schloss Federn grün",
        ["options_show_chamber_resolved_green_springs_tooltip"] = "Färbe die Federn des Schlosses grün, wenn eine Kammer gelöst wurde.",
        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
        ["chatcommands_help"]					 = "|cFFFFFF'hilfe' / 'liste'|cFFFF00: Zeigt diese Information zum Addon an",
        ["chatcommands_debug"]					 = "|cFFFFFF'debug'|cFFFF00: Aktiviere/Deaktive Debug Nachrichten. |c990000[Achtung]|cFFFF00 Ihr lokaler Chat wird mit Nachrichten überschwemmt!",
        ["chatcommands_debug_on"]				 = "Debug: AN",
        ["chatcommands_debug_off"]				 = "Debug: AUS",
        ["chatcommands_deepdebug_on"]			 = "Deep debug: AN",
        ["chatcommands_deepdebug_off"]			 = "Deep debug: AUS",
    },
--==============================================================================
--French / Französisch
	[3] = {
		-- Options menu
		["options_description"] 						 = "FCO LockPicker montre les crochets restant, lors de l'ouverture d'un coffre, en différentes couleurs",
		["options_header1"] 							 = "Général",
		["options_language"]							 = "Langue",
		["options_language_tooltip"]					 = "Choisir la langue",
		["options_language_use_client"] 		 		 = "Utilisez le langage client",
		["options_language_use_client_tooltip"]  		 = "Toujours laisser l'addon utiliser la langue du client de jeu.",
		["options_language_dropdown_selection1"]		 = "Anglais",
		["options_language_dropdown_selection2"]		 = "Allemand",
		["options_language_dropdown_selection3"]		 = "Français",
		["options_language_dropdown_selection4"] 		 = "Espagnol",
        ["options_language_dropdown_selection5"]	 	 = "Italien",
		["options_language_dropdown_selection6"] 		 = "Japonais",
        ["options_language_dropdown_selection7"] 		 = "Russe",
		["options_language_description1"]				 = "ATTENTION : Modifier un de ces réglages provoquera un chargement",
		["options_savedvariables"]						 = "Sauvegarder",
		["options_savedvariables_tooltip"] 				 = "Sauvegarder les données de l'addon pour tous les personages du compte, ou individuellement pour chaque personage",
		["options_savedVariables_dropdown_selection1"]	 = "Individuellement",
		["options_savedVariables_dropdown_selection2"]	 = "Compte",
		--Colors & values
		["options_header_color"]				 = "Couleurs",
		["options_normal_color"] 				 = "Couleur normale",
		["options_normal_color_tooltip"] 		 = "La couleur des crochets vous indique s'il vous reste assez de crochets",
		["options_normal_value"] 				 = "Seuil de valeur normal",
		["options_normal_value_tooltip"] 		 = "D'au moins combien de crochets avez-vous besoin pour afficher la couleur 'normale'?",
		["options_medium_color"] 				 = "Couleur moyenne",
		["options_medium_color_tooltip"] 		 = "La couleur des crochets vous indique s'il vous reste assez de crochets",
		["options_medium_value"] 				 = "Seuil de valeur moyenne",
		["options_medium_value_tooltip"] 		 = "D'au moins combien de crochets avez-vous besoin pour afficher la couleur 'moyenne'?",
		["options_low_color"] 					 = "Couleur faible",
		["options_low_color_tooltip"] 			 = "La couleur des crochets vous indique s'il vous reste assez de crochets",
		["options_low_value"] 					 = "Seuil de valeur faible",
		["options_low_value_tooltip"] 			 = "D'au moins combien de crochets avez-vous besoin pour afficher la couleur 'faible'?",
		["options_header_chamber_resolved"] 	 = "Goupille résolue",
		["options_show_chamber_resolved_icon"]	 = "Affiche l'icône de goupille résolue",
		["options_show_chamber_resolved_icon_tooltip"]	 = "Afficher une icône lorsque la goupille actuelle a été résolu",
		["options_show_chamber_resolved_green_springs"] = "Afficher les ressorts en verts",
		["options_show_chamber_resolved_green_springs_tooltip"] = "Affiche le verrouillage en vert si la goupille est résolue.",
		--Chat commands
		["chatcommands_info"]	 				 = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
		["chatcommands_help"]	 				 = "|cFFFFFF'aide' / 'lister'|cFFFF00: Affiche cette information à propos de l'extension",
		["chatcommands_debug"]					 = "|cFFFFFF'debug'|cFFFF00: Activer/désactiver les messages de debug. Attention, ceci peut polluer votre fenêtre de discussion!",
		["chatcommands_debug_on"]				 = "Debug: ON",
		["chatcommands_debug_off"]				 = "Debug: OFF",
		["chatcommands_deepdebug_on"]			 = "Debug profond: ON",
		["chatcommands_deepdebug_off"]			 = "Debug profond: OFF",
	},
--==============================================================================
--Spanish
	[4] = {
		-- Options menu
        ["options_description"] 				 		 = "FCO Lockpicker shows the lockpicks you got left during opening of a chest in different colors",
		["options_header1"] 							 = "General",
		["options_language"]							 = "Idioma",
		["options_language_tooltip"]					 = "Elegir idioma",
		["options_language_use_client"] 		 		 = "Utilizar el idioma del cliente",
		["options_language_use_client_tooltip"]  		 = "Deje siempre que el addon de utilizar el idioma del cliente de juego.",
		["options_language_dropdown_selection1"]		 = "Inglés",
		["options_language_dropdown_selection2"]		 = "Alemán",
		["options_language_dropdown_selection3"]		 = "Francés",
		["options_language_dropdown_selection4"]		 = "Espa\195\177ol",
        ["options_language_dropdown_selection5"] 		 = "Italiano",
		["options_language_dropdown_selection6"] 		 = "Japonés",
        ["options_language_dropdown_selection7"] 		 = "Ruso",
		["options_language_description1"]				 = "CUIDADO: Modificar uno de esos parámetros recargará la interfaz",
		["options_savedvariables"]						 = "Guardar",
		["options_savedvariables_tooltip"] 				 = "Guardar los parámetros del addon para toda la cuenta o individualmente para cada personaje",
		["options_savedVariables_dropdown_selection1"]	 = "Individualmente",
		["options_savedVariables_dropdown_selection2"]	 = "Cuenta",
		--Colors & values
		["options_header_color"]				 = "Colors",
		["options_normal_color"] 				 = "Normal color",
		["options_normal_color_tooltip"] 		 = "The color of the lockpicks left text if you got enough lockpicks left",
		["options_normal_value"] 				 = "Normal threshold value",
		["options_normal_value_tooltip"] 		 = "How many lockpicks do you need at least for 'normal' color?",
		["options_medium_color"] 				 = "Medium color",
		["options_medium_color_tooltip"] 		 = "The color of the lockpicks left text if you got some lockpicks left",
		["options_medium_value"] 				 = "Medium threshold value",
		["options_medium_value_tooltip"] 		 = "How many lockpicks do you need at least for 'medium' color?",
		["options_low_color"] 					 = "Low color",
		["options_low_color_tooltip"] 			 = "The color of the lockpicks left text if you got only a few lockpicks left",
		["options_low_value"] 					 = "Low threshold value",
		["options_low_value_tooltip"] 			 = "How many lockpicks do you need at least for 'low' color?",
		["options_header_chamber_resolved"] 	 = "Chamber resolved",
        ["options_show_chamber_resolved_icon"]	 = "Show chamber resolved icon",
        ["options_show_chamber_resolved_icon_tooltip"]	 = "Show an icon if the actual lock's chamber has been resolved",
        ["options_show_chamber_resolved_green_springs"]	= "Show green springs",
        ["options_show_chamber_resolved_green_springs_tooltip"] = "Colorize the srping of the lock green if the chamber is resolved.",
		--Chat commands
		["chatcommands_info"]	 				 = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
		["chatcommands_help"]	 				 = "|cFFFFFF'help' / 'list'|cFFFF00: Muestra esta información acerca del addon",
        ["chatcommands_debug"]					 = "|cFFFFFF'debug'|cFFFF00: Activar/Desactivar los mensajes de debug. [Advertencia] ¡Esto llenará la ventana de chat!",
        ["chatcommands_debug_on"]				 = "Debug: ON",
        ["chatcommands_debug_off"]				 = "Debug: OFF",
        ["chatcommands_deepdebug_on"]			 = "Deep debug: ON",
        ["chatcommands_deepdebug_off"]			 = "Deep debug: OFF",
	},
--==============================================================================
--Italian
	[5] = {
		-- Options menu
        ["options_description"] 				 		 = "FCO Lockpicker shows the lockpicks you got left during opening of a chest in different colors",
		["options_header1"] 							 = "General",
		["options_language"]							 = "Idioma",
		["options_language_tooltip"]					 = "Elegir idioma",
		["options_language_use_client"] 		 		 = "Utilizzare la lingua del client",
		["options_language_use_client_tooltip"]  		 = "Lasciate sempre l'addon usare il linguaggio del client di gioco.",
        ["options_language_dropdown_selection1"] = "Inglese",
        ["options_language_dropdown_selection2"] = "Germano",
        ["options_language_dropdown_selection3"] = "Francese",
        ["options_language_dropdown_selection4"] = "Spagnolo",
        ["options_language_dropdown_selection5"] = "Italiano",
		["options_language_dropdown_selection6"]  = "Giapponese",
        ["options_language_dropdown_selection7"] = "Russo",
		["options_language_description1"]				 = "CUIDADO: Modificar uno de esos parámetros recargará la interfaz",
		["options_savedvariables"]						 = "Guardar",
		["options_savedvariables_tooltip"] 				 = "Guardar los parámetros del addon para toda la cuenta o individualmente para cada personaje",
		["options_savedVariables_dropdown_selection1"]	 = "Individualmente",
		["options_savedVariables_dropdown_selection2"]	 = "Cuenta",
		--Colors & values
		["options_header_color"]				 = "Colors",
		["options_normal_color"] 				 = "Normal color",
		["options_normal_color_tooltip"] 		 = "The color of the lockpicks left text if you got enough lockpicks left",
		["options_normal_value"] 				 = "Normal threshold value",
		["options_normal_value_tooltip"] 		 = "How many lockpicks do you need at least for 'normal' color?",
		["options_medium_color"] 				 = "Medium color",
		["options_medium_color_tooltip"] 		 = "The color of the lockpicks left text if you got some lockpicks left",
		["options_medium_value"] 				 = "Medium threshold value",
		["options_medium_value_tooltip"] 		 = "How many lockpicks do you need at least for 'medium' color?",
		["options_low_color"] 					 = "Low color",
		["options_low_color_tooltip"] 			 = "The color of the lockpicks left text if you got only a few lockpicks left",
		["options_low_value"] 					 = "Low threshold value",
		["options_low_value_tooltip"] 			 = "How many lockpicks do you need at least for 'low' color?",
		["options_header_chamber_resolved"] 	 = "Chamber resolved",
        ["options_show_chamber_resolved_icon"]	 = "Show chamber resolved icon",
        ["options_show_chamber_resolved_icon_tooltip"]	 = "Show an icon if the actual lock's chamber has been resolved",
        ["options_show_chamber_resolved_green_springs"]	= "Show green springs",
        ["options_show_chamber_resolved_green_springs_tooltip"] = "Colorize the srping of the lock green if the chamber is resolved.",
		--Chat commands
		["chatcommands_info"]	 				 = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
		["chatcommands_help"]	 				 = "|cFFFFFF'help' / 'list'|cFFFF00: Muestra esta información acerca del addon",
        ["chatcommands_debug"]					 = "|cFFFFFF'debug'|cFFFF00: Activar/Desactivar los mensajes de debug. [Advertencia] ¡Esto llenará la ventana de chat!",
        ["chatcommands_debug_on"]				 = "Debug: ON",
        ["chatcommands_debug_off"]				 = "Debug: OFF",
        ["chatcommands_deepdebug_on"]			 = "Deep debug: ON",
        ["chatcommands_deepdebug_off"]			 = "Deep debug: OFF",
	},
--==============================================================================
	--Japanese
    [6] = {
		-- Options menu
        ["options_description"] 				 = "FCO Lockpickerは宝箱の開錠時にロックピックの残量を異なる色で表示します",
		["options_header1"] 			 		 = "一般設定",
    	["options_language"] 					 = "言語",
		["options_language_tooltip"] 			 = "言語を選択します",
		["options_language_use_client"] 		 = "クライアントの言語を使用する",
		["options_language_use_client_tooltip"]  = "アドオンが常にクライアントの言語を使用するようにします。",
		["options_language_dropdown_selection1"] = "英語",
		["options_language_dropdown_selection2"] = "ドイツ語",
		["options_language_dropdown_selection3"] = "フランス語",
		["options_language_dropdown_selection4"] = "スペイン語",
		["options_language_dropdown_selection5"] = "イタリア語",
		["options_language_dropdown_selection6"] = "日本語",
		["options_language_dropdown_selection7"] = "ロシア語",
		["options_language_description1"]		 = "注意: 言語の変更/設定の保存時にはUIがリロードされます！",
        ["options_savedvariables"]				 = "設定の保存",
        ["options_savedvariables_tooltip"]       = "アドオンの設定をアカウントの全キャラクターまたはキャラクター毎に保存します",
        ["options_savedVariables_dropdown_selection1"] = "キャラクター毎",
        ["options_savedVariables_dropdown_selection2"] = "アカウント全体",
		--Colors & values
		["options_header_color"]				 = "色",
		["options_normal_color"] 				 = "通常色",
		["options_normal_color_tooltip"] 		 = "ロックピックが十分にある場合の残量テキストの色です",
		["options_normal_value"] 				 = "通常のしきい値",
		["options_normal_value_tooltip"] 		 = "どれだけロックピックがあれば「通常」色を使うか？",
		["options_medium_color"] 				 = "中間色",
		["options_medium_color_tooltip"] 		 = "ロックピックがいくつかある場合の残量テキストの色です",
		["options_medium_value"] 				 = "中間のしきい値",
		["options_medium_value_tooltip"] 		 = "どれだけロックピックがあれば「中間」色を使うか？",
		["options_low_color"] 					 = "少量色",
		["options_low_color_tooltip"] 			 = "ロックピックが残りわずかな場合の残量テキストの色です",
		["options_low_value"] 					 = "少量のしきい値",
		["options_low_value_tooltip"] 			 = "どれだけロックピックがあれば「少量」色を使うか？",
		["options_header_chamber_resolved"] 	 = "タンブラーの固定",
        ["options_show_chamber_resolved_icon"]	 = "固定位置アイコンの表示",
        ["options_show_chamber_resolved_icon_tooltip"]	 = "タンブラーが固定位置に達した時にアイコンを表示します",
        ["options_show_chamber_resolved_green_springs"] = "緑の泉を表示する",
        ["options_show_chamber_resolved_green_springs_tooltip"] = "チャンバーが解決されていれば緑のロックを色づけします。",
--Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
        ["chatcommands_help"]					 = "|cFFFFFF'help' / 'list'|cFFFF00: アドオン情報の表示",
        ["chatcommands_debug"]					 = "|cFFFFFF'debug'|cFFFF00: デバッグメッセージの有効化/無効化 |c990000[注意]|cFFFF00 有効にするとチャット欄が埋め尽くされます！",
        ["chatcommands_debug_on"]				 = "Debug: ON",
        ["chatcommands_debug_off"]				 = "Debug: OFF",
        ["chatcommands_deepdebug_on"]			 = "Deep debug: ON",
        ["chatcommands_deepdebug_off"]			 = "Deep debug: OFF",
    },
--==============================================================================
--Russian
	[7]	= {
		["options_description"]                  = "FCO Lockpicker отображает разными цветам кол-во оставшихся отмычек в окне взлома замков",
		["options_header1"]                      = "Основные настройки",
		["options_language"]                     = "Язык",
		["options_language_tooltip"]             = "Выбepитe язык",
		["options_language_use_client"]          = "Использовать язык клиента",
		["options_language_use_client_tooltip"]  = "Всегда использовать аддоном язык клиента игры.",
		["options_language_dropdown_selection1"] = "Aнглийcкий",
		["options_language_dropdown_selection2"] = "Нeмeцкий",
		["options_language_dropdown_selection3"] = "Фpaнцузcкий",
		["options_language_dropdown_selection4"] = "Иcпaнcкий",
		["options_language_dropdown_selection5"] = "Итaльянcкий",
		["options_language_dropdown_selection6"] = "Япoнcкий",
		["options_language_dropdown_selection7"] = "Pуccкий",
		["options_language_description1"]        = "ВНИМAНИE: Измeнeниe языкa/нacтpoeк coxpaнeния пpивeдeт к пepeзaгpузкe интepфeйca!",
		["options_savedvariables"]               = "Нacтpoйки coxpaнeния",
		["options_savedvariables_tooltip"]       = "Coxpaнять oбщиe нacтpoйки для вcex пepcoнaжeй aккaунтa или oтдeльныe для кaждoгo пepcoнaжa",
		["options_savedVariables_dropdown_selection1"] = "Для кaждoгo пepcoнaжa",
		["options_savedVariables_dropdown_selection2"] = "Oбщиe нa aккaунт",
		--Colors & values
		["options_header_color"]                 = "Цвета",
		["options_normal_color"]                 = "Цвет: Достаточно",
		["options_normal_color_tooltip"]         = "Цвет текста \"Осталось отмычек\", если они есть в достаточном кол-ве",
		["options_normal_value"]                 = "Кол-во: Достаточно",
		["options_normal_value_tooltip"]         = "Сколько отмычек должно быть в наличие чтобы считать что их достаточно?",
		["options_medium_color"]                 = "Цвет: Умеренно",
		["options_medium_color_tooltip"]         = "Цвет текста \"Осталось отмычек\", если они есть в умеренном кол-ве",
		["options_medium_value"]                 = "Кол-во: Умеренно",
		["options_medium_value_tooltip"]         = "Сколько отмычек должно быть в наличие чтобы считать что они в умеренном кол-ве?",
		["options_low_color"]                    = "Цвет: Мало",
		["options_low_color_tooltip"]            = "Цвет текста \"Осталось отмычек\", если их осталось мало",
		["options_low_value"]                    = "Кол-во: Мало",
		["options_low_value_tooltip"]            = "Сколько должно остаться отмычек чтобы считать что их мало?",
		["options_header_chamber_resolved"]      = "Штифты замков",
		["options_show_chamber_resolved_icon"]   = "Показ.иконку когда штифт встал",
		["options_show_chamber_resolved_icon_tooltip"]   = "Показать иконку когда поддетый отмычкой штифт замка встал на место, т.е. когда нужно отпустить отмычку",
        [ "options_show_chamber_resolved_green_springs"] = "Показать зеленые источники",
        ["Options_show_chamber_resolved_green_springs_tooltip"] = "Раскрасить srping замыкающего зеленого цвета, если камера не будет решена.",
        --Chat commands
		["chatcommands_info"]                    = "|c00FF00FCO|cFFFF00Lockpicker|cFFFFFF",
		["chatcommands_help"]                    = "|cFFFFFF'help' / 'list'|cFFFF00: Показать данную информацию об аддоне",
		["chatcommands_debug"]                   = "|cFFFFFF'debug'|cFFFF00: Вкл./Выкл. отладочные сообщения. |c990000[Внимание]|cFFFF00 Они будут флудить в чат!",
		["chatcommands_debug_on"]                = "Отладка: Вкл.",
		["chatcommands_debug_off"]               = "Отладка: Выкл.",
		["chatcommands_deepdebug_on"]            = "Глубокая отладка: Вкл.",
		["chatcommands_deepdebug_off"]           = "Глубокая отладка: Выкл.",
	},
}
--Meta table trick to use english localization for german and french values, which are missing
local fco_lockpickerloc = FCOLP.localizationVars.localizationAll
setmetatable(fco_lockpickerloc[2], {__index = fco_lockpickerloc[1]})
setmetatable(fco_lockpickerloc[3], {__index = fco_lockpickerloc[1]})
setmetatable(fco_lockpickerloc[4], {__index = fco_lockpickerloc[1]})
setmetatable(fco_lockpickerloc[5], {__index = fco_lockpickerloc[1]})
setmetatable(fco_lockpickerloc[6], {__index = fco_lockpickerloc[1]})
setmetatable(fco_lockpickerloc[7], {__index = fco_lockpickerloc[1]})
