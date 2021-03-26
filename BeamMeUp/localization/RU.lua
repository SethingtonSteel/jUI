local mkstr = ZO_CreateStringId
local SI = Teleporter.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELECLOSE, "Закрыть")
mkstr(SI.TELE_UI_PLAYER, "Игрок")
mkstr(SI.TELE_UI_ZONE, "Локация")
mkstr(SI.TELE_UI_TOTAL, "Всего:")
mkstr(SI.TELE_UI_GOLD, "Сохр. золото:")
mkstr(SI.TELE_UI_GOLD_ABBR, "k")
mkstr(SI.TELE_UI_GOLD_ABBR2, "m")
mkstr(SI.TELE_UI_TOTAL_PORTS, "Перемещений:")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_SEARCH_PLAYER, "Поиск по игроку")
mkstr(SI.TELE_UI_BTN_SEARCH_ZONE, "Поиск по локации")
mkstr(SI.TELE_UI_BTN_REFRESH_ALL, "Обновить все локации")
mkstr(SI.TELE_UI_BTN_UNLOCK_WS, "Разблокировка дорожных святилищ в текущей локации")
mkstr(SI.TELE_UI_BTN_CURRENT_ZONE, "Текущая локация")
mkstr(SI.TELE_UI_BTN_CURRENT_ZONE_DELVES, "Вылазки в текущей локации")
mkstr(SI.TELE_UI_BTN_RELATED_ITEMS, "Карты и зацепки")
mkstr(SI.TELE_UI_BTN_SETTINGS, "Настройки")
mkstr(SI.TELE_UI_BTN_FEEDBACK, "Обратная связь")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW, "За/разморозить окно")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE, "Показать BeamMeUp")
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU, "Показать Zone Guide")
mkstr(SI.TELE_UI_BTN_RELATED_QUESTS, "Зоны с квестами")
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE, "Свои дома")
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP, "Открепить / Прикрепить")
mkstr(SI.TELE_UI_BTN_GUILD_BMU, "Официальная гильдия и партнёры BeamMeUp")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU, "Гильдхолл BeamMeUp")
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION, "Поддержка \"Port to Friend's House\"")
---------
--------- List
mkstr(SI.TELE_UI_SOURCE_GROUP, "Группа")
mkstr(SI.TELE_UI_SOURCE_FRIEND, "Друзья")
mkstr(SI.TELE_UI_NO_MATCHES, "Нет совпадений")
mkstr(SI.TELE_UI_UNRELATED_ITEMS, "Другие карты сокровищ.")
mkstr(SI.TELE_UI_UNRELATED_QUESTS, "Квесты в других зонах")
mkstr(SI.TELE_UI_SAME_INSTANCE, "Тот же инстанс")
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE, "Разные инстансы")
mkstr(SI.TELE_UI_DISCOVERED_WAYSHRINES, "Открытые дорожные святилища:")
mkstr(SI.TELE_UI_DISCOVERED_SKYSHARDS, "Collected skyshards:")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER, "Избранный игрок")
mkstr(SI.TELE_UI_FAVORITE_ZONE, "Избранная локация")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER, "Уралить игрока из Избранного")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE, "Уралить локацию из Избранного")
mkstr(SI.TELE_UI_ADD_TO_GROUP, "Пригласить в группу")
mkstr(SI.TELE_UI_PROMOTE_TO_LEADER, "Передать Лидера")
mkstr(SI.TELE_UI_VOTE_TO_LEADER, "Голосовать за Лидера")
mkstr(SI.TELE_UI_KICK_FROM_GROUP, "Исключить из Группы")
mkstr(SI.TELE_UI_VOTE_KICK_FROM_GROUP, "Голосовать за Исключение")
mkstr(SI.TELE_UI_LEAVE_GROUP, "Покинуть группу")
mkstr(SI.TELE_UI_WHISPER_PLAYER, "Шепнуть")
mkstr(SI.TELE_UI_JUMP_TO_HOUSE, "Посетить дом")
mkstr(SI.TELE_UI_ADD_FRIEND, "Добавить в друзья")
mkstr(SI.TELE_UI_REMOVE_FRIEND, "Удалить из друзей")
mkstr(SI.TELE_UI_SEND_MAIL, "Отправить почту")
mkstr(SI.TELE_UI_FILTER_GROUP, "Только Группа")
mkstr(SI.TELE_UI_FILTER_FRIENDS, "Только Друзья")
mkstr(SI.TELE_UI_FILTER_GUILDS, "Только Гильдия")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE, "Сбросить счетчик")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD, "Пригласить в гильдию BeamMeUp")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Показать маркер квеста")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME, "Сменить название дома")
mkstr(SI.TELE_UI_SET_PRIMARY_HOUSE, "Сделать основным домом")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME, "Показать названия домов")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM, "Показать свиток")
mkstr(SI.TELE_UI_BANK, "Банк:")
mkstr(SI.TELE_UI_LEAD, "Зацепк:")
mkstr(SI.TELE_UI_TOGGLE_SURVEY_MAP, "Карты исследований")
mkstr(SI.TELE_UI_TOGGLE_TREASURE_MAP, "Карты сокровищ")
mkstr(SI.TELE_UI_TOGGLE_LEADS_MAP, "Зацепки")
mkstr(SI.TELE_UI_VIEW_ANTIQUITY, "Кодекс просмотра")
mkstr(SI.TELE_UI_JUMP_IN_FRONT_HOUSE, "Переместиться к дому")
mkstr(SI.TELE_UI_JUMP_IN_HOUSE, "Переместиться в дом")

mkstr(SI.TELE_UI_SUBMENU_FAVORITES, "Избранное")
mkstr(SI.TELE_UI_SUBMENU_MISC, "Разное")
mkstr(SI.TELE_UI_SUBMENU_GROUP, "Группа")
mkstr(SI.TELE_UI_SUBMENU_FILTER, "Фильтр")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_ERROR_WHILE_PORTING, "Невозможно переместиться к игроку")
mkstr(SI.TELE_CHAT_TO_PLAYER, "Перемещение к игроку:")
mkstr(SI.TELE_CHAT_UNLOCK_START_INFO, "Начинаю авторазблокировку ...")
mkstr(SI.TELE_CHAT_ERROR, "Ошибка при перемещении к игроку")
mkstr(SI.TELE_CHAT_UNLOCK_WS_SUCCESS, "Авторазблокировка успешно завершена")
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_CALC, "Рассчитать разблокированные дорожные святилища ...")
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_PLU, "Новые дорожные святилища были разблокированы")
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_SING, "Новое дорожное святилище было разблокировано")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NO_PLAYERS, "Нет игроков для перемещения")
mkstr(SI.TELE_CHAT_FAVORITE_UNSET, "Избранный слот не установлен")
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL, "Игрок не в сети или скрыт фильтрами")
mkstr(SI.TELE_CHAT_FAVORITE_ZONE_NO_FAST_TRAVEL, "Опция быстрого перемещения не найдена")
mkstr(SI.TELE_CHAT_NOT_IN_GROUP, "Вы не в группе")
mkstr(SI.TELE_CHAT_PORTING_NOT_POSSIBLE, "Сейчас быстрое перемещение невозможно")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_HOUSE, "Перемещаемся в свой дом:")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "Основной дом не установлен!")
mkstr(SI.TELE_CHAT_WHISPER_NOTE, "Внимание! Установлен режим оффлайн, сообщения шепотом не принимаются!")
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF, "Вы лидер группы")
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL, "Всего святилищ открыто в этой зоне:")
mkstr(SI.TELE_CHAT_UNLOCK_WS_ALL_KNOWN, "Все дорожные святилища в этой зоне известны и могут использоваться для перемещения.")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED, "Эти дорожные святилища все еще надо посетить лично:")
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK, "Следуем по ссылке ...")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Открывать BeamMeUp при открытии карты")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Когда вы откроете карту, автоматически откроется BeamMeUp, в противном случае вы получите кнопку в левом верхнем углу карты.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Показыть локацию только один раз")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Показать только одну запись для каждой найденной локации.")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Частота разблокировки дорожных святилищ (мс)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Регулировка частоты автоматической разблокировки дорожных святилищ. Для медленных компьютеров или для предотвращения возможных вылетов из игры, может помочь более высокое значение.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Обновить и сбросить при открытии")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Обновляйть список каждый раз, когда вы открываете BeamMeUp. Поля ввода будут очищены.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Черный список")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Скрыть недоступные локации")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Скрыть такие локации, как Maelstrom Arena, Outlaw Refuges и одиночные локации.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Скрыть PvP локации")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Скрыть локации, такие как Сиродил, Имперский город и Поля Битвы.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Скрыть Групповые Подземелья и Испытания")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Скрыть Групповые Подземелья (4 игрока), Испытания (12 игроков) и Групповые Подземелья в Краглорне. Участники группы в этих зонах все равно будут отображаться!")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Скрыть дома")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Скрыть дома.")
mkstr(SI.TELE_SETTINGS_DISABLE_DIALOG, "Скрыть подтверждения Авторазблокировки")
mkstr(SI.TELE_SETTINGS_DISABLE_DIALOG_TOOLTIP, "Не показывать диалоговое окно подтверждения при использовании Авторазблокировки.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Держать BeamMeUp открытым")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Когда вы открываете BeamMeUp через привязанную клавишу, он останется открытым, даже если вы откроете другие окна. Если вы используете эту опцию, рекомендуется отключить опцию «Открыть/Закрыть BeamMeUp с картой».")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Показать только Регионы/Сухопутные Карты")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Показать только основные регионы, такие как Дешаан или Саммерсет.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Интервал обновления (с)")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Когда BeamMeUp открыт, обновление результатов выполняется автоматически каждые x секунд. Установите значение на 0, чтобы отключить автоматическое обновление.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Фокус области поиска локации")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Фокус области поиска локации, когда BeamMeUp открыт вместе с картой.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Скрыть Вылазки")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Скрыть все Вылазки.")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Скрыть Публичные Подземелья")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Скрыть все Публичные Подземелья.")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Скрыть артикли у названий локаций")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Скрыть артикул у названий локаций, чтобы обеспечить лучшую сортировку и быстрее находить нужные локации.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Количество строк/записей")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Установив количество видимых строк/записей, вы можете контролировать общую высоту аддона.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Дополнительные функции")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "Общие настройки")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Записи")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Автоматически закрывать карту и BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Закрывать карту и BeamMeUp после начала перемещения.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Показывать число игроков на карте")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Показывать число игроков, доступных для перемещения на картах. Нажмите на число, чтобы увидеть их список.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Смещение кнопки в окне текста")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Увеличть горизонтальный отступ кнопки в заголовке окна текста во избедание наложений на иконки дргих адд-онов.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Искать имена персонажей")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "При поиске игроков искать также имена персонажей.")
mkstr(SI.TELE_SETTINGS_SORTING, "Сортировка")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Выберите один из вариантов сортировки списка.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Второй язык поиска")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "Вы можете искать названия зон на языке клиента игры и на этом втором языке одновременно. Подсказка на названии зоны всегда показывается на втором языке.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Оповещение об избранных игроках")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Выдавать оповещение (в центре экрана) когда избранный игрок появляется онлайн.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Закрывать BeamMeUp при закрытии карты")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Когда карта закрывается, BeamMeUp тоже закрывается.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Смещение крепления к карте - по горизонтали")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Здесь можно задать горизонтальное смещение прикрепления к карте.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Смещение крепления к карте - по вертикали")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Здесь можно задать вертикальное смещение прикрепления к карте.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Сбросить счетчик зон")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Будут сброшены все счетчики зон. Так что сортировка по частоте использования тоже будет сброшена.")
mkstr(SI.TELE_SETTINGS_WHISPER_NOTE, "Заметка о шепоте")
mkstr(SI.TELE_SETTINGS_WHISPER_NOTE_TOOLTIP, "Если будучи оффлайн шепнуть кому-нибудь, в чат будет выдано сообщение о том, что вы не сможете получить ответный шепот. Это помогает избежать нежелательной блокировки ответов.")
mkstr(SI.TELE_SETTINGS_SCALE, "Масштаб UI")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Масштабирование окна и всего интерфейса BeamMeUp. Для применения нужна перезагрузка.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Сброс UI")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Сбросить интерфейс BeamMeUp установкой на значения по умолчанию опций: Масштаб, Смещение кнопки, Смещение привязки к карте и местоположение окна. Весь интерфейс будет перезагружен.")
mkstr(SI.TELE_SETTINGS_HOUSE_NICKNAMES, "Показывать имена домов")
mkstr(SI.TELE_SETTINGS_HOUSE_NICKNAMES_TOOLTIP, "Показывать (редактируемые) имена своих домов вместо стандартных названий.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Оповещение о карте исследований")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Если вы собираете ресурсы на карте исследований, а в инвентаре есть идентичные карты (на том же месте), в центре экрана будет показано оповещение.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Приоритеты")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Команды чата")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Минимизировать выдачу в чат")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Уменьшить количество выдаваемых в чат сообщений при использовании автоматической разблокировки святилищ.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Здесь можно выбрать каких игроков предпочтительнее выбирать для быстрого перемещения. После вступления или выхода из гильдии требуется перезагрузка для корректного отображения. |ca20000Эта настройка действует только для персонажа (не для всего аккаунта)!|r")
mkstr(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS, "Искать карты в банке")
mkstr(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS_TOOLTIP, "Искать карты сокровищ и исследований не тольков инвентаре, но и в банке.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Показывать кнопку на карте")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Показывать дополнительную текстовую кнопку для вызова BeamMeUp в левом верхнем углу карты мира.")
mkstr(SI.TELE_SETTINGS_SCAN_LEADS, "Показывать лоцируемые зацепки")
mkstr(SI.TELE_SETTINGS_SCAN_LEADS_TOOLTIP, "Показывать доступные для лоцирования зацепки вместе с картами сокровищ и исследований.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Звуковое оповещение")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Оповещать звуком при показе оповещения")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Автоматически подтверждать телепорт")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Отключить диалог подтверждения при быстром перемещении")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Текущая зона всегда первая")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Показывать текущую зону всегда в начале списка.")



-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Открыть BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Карты и зацепки")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_CURRENT_ZONE, "Текущая локация")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DELVES, "Вылазки в текущей локации")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Обновить")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Разблокировка дорожных святилищ")
mkstr(SI.TELE_KEYBINDING_GROUP_LEADER, "Перемещение к Лидеру Группы")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_ACTIVE_QUESTS, "Активные квесты")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Переместиться в основной дом")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Посетить гильдхолл BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "Перемещение в текущее локацие")



-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Начать авторазблокировку дорожных святилищ?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "Подтверждая, начнётся серия перемещений к игрокам в текущей локации, если эти игроки находятся в близости от неизвестных дорожных святилищ. Этого достаточно для того, чтобы вы могли использовать эти дорожные святилища в будущем. Чтобы прервать этот процесс вам достаточно начать движение персонажем. Учтите, что заполнение карты/Zone Guide не произойдет, пока вы лично не посетите дорожные святилища.")
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "К сожалению на этом сервере еще нет гильдии BeamMeUp.\n\nМожете связаться с нами через сайт ESOUI и создать гильдию BeamMeUp на этом сервере.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Привет и спасибо за использование BeamMeUp. В 2019 мы создали несколько гильдий BeamMeUp для доступных быстрых перемещений. Принимаются все, никаких требований или обязательств!\n\nСогласившись с этим диалогом вы увидите список официальных гильдий BeamMeUp и партнёров. Добро пожаловать, вступайте! Также гильдии можно найти, нажав на иконку в левом верхнем углу.\nВаша команда BeamMeUp.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "Разблокирование больше не требуется")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "Все дорожные святилища в этой зоне уже разблокированы.")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "Вы получите оповещение (в центре экрана) когда избранный игрок появится онлайн.\n\nВключить эту функцию?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "Если вы собираете ресурсы на карте исследований, а в инвентаре есть идентичные карты (на том же месте), в центре экрана будет показано оповещение.\n\nВключить эту функцию?")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE2, "Разблокирование невозможно")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "Разблокирование дорожных святилищ невозможно в этой зоне. Эта функция доступна только для основных зон / регионов.")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Интеграция с \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "Для использования функции интеграции установите аддон \"Port to Friend's House\". Тогда вы увидите ваш список домов и гильдхолов здесь.\n\nОткрыть сайт аддона \"Port to Friend's House\"?")


-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "карта сокровищ") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "карта исследований:") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft
