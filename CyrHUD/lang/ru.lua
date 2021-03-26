﻿-- This file is part of CyrHUD
--
-- (C) 2020 @mychaelo [EU]
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

ZO_CreateStringId("SI_CYRHUD_LANG", "ru")
ZO_CreateStringId("SI_CYRHUD_FONT", "$(CHAT_FONT)|18|soft-shadow-thick")
ZO_CreateStringId("SI_CYRHUD_HIDE_IC", "Скрыть сражения в районах ИГ")
ZO_CreateStringId("SI_CYRHUD_HIDE_IC_INFO", "Убирает сражения в Имперском городе из списка CyrHUD")
ZO_CreateStringId("SI_CYRHUD_QT_DEFAULT", "Скрывать стандартный трекер заданий")
ZO_CreateStringId("SI_CYRHUD_QT_TOOLTIP", "Убирает трекеры заданий с экрана при активном CyrHUD")
ZO_CreateStringId("SI_CYRHUD_QT_WYKKYD", "Скрывать Ravalox Quest Tracker")
ZO_CreateStringId("SI_CYRHUD_POPBAR", "Полосы населённости вместо флагов")
ZO_CreateStringId("SI_CYRHUD_POPBAR_INFO", "Показывает текущую численность войск на сервере вместо флага у альянсов в сводке")
ZO_CreateStringId("SI_BINDING_NAME_CYRHUD_TOGGLE", "Включить/отключить CyrHUD")

local CZ = "|cC5C29E" -- ZOS standard text color
local CR = "|cFFFFFF" -- Reset color
ZO_CreateStringId("SI_CYRHUD_KEYBIND_HEADER", "Назначения клавиш")
ZO_CreateStringId("SI_CYRHUD_KEYBIND_DESC",
    CZ .. "См. меню «Управление» для назначения клавиши на команду" .. CR .. " /cyrhud" .. CZ .. ".\n"
        .."Эта команда включает и выключает модификацию.")