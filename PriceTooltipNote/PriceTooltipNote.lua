PriceTooltipNote = {}


PriceTooltipNote.Version = 1
PriceTooltipNote.StringVersion = "1.0.1"
PriceTooltipNote.AddOnName = "PriceTooltipNote"
PriceTooltipNote.SavedVariablesFileName = "PriceTooltipNote_Settings"


PriceTooltipNote_Load = function(eventCode, addonName)
    if addonName ~= PriceTooltipNote.AddOnName then return end

    EVENT_MANAGER:UnregisterForEvent(addonName, eventCode)

	PriceTooltipNote.SavedVariables = ZO_SavedVars:NewAccountWide(PriceTooltipNote.SavedVariablesFileName, PriceTooltipNote.Version, nil, {}, nil, PriceTooltipNote.AddOnName)

	if (not PriceTooltipNote.SavedVariables.Data) then PriceTooltipNote.SavedVariables.Data = {} end
end


PriceTooltipNote_Trim = function(text) return (text or ""):match "^%s*(.-)%s*$" end


PriceTooltipNote_EditNote = function(text)
	local result = PriceTooltipNote_EditNoteInternal(text)
	if (not result) then d("PTN: Could not resolve link") end
end


function PriceTooltipNote_EditNoteInternal(text)
	text = PriceTooltipNote_Trim(text)
	if (string.len(text) <= 0) then return false end

	local linkText = string.match(PriceTooltipNote_FirstWord(text), "^|H[0-9]:item:.*|h|h$")
	if (not linkText) then return false end

	local linkId = GetItemLinkItemId(linkText)
	if (not linkId) then return false end

	local note = PriceTooltipNote_GetText(text, 1)
	note = PriceTooltipNote_Trim(note)

	if (string.len(note) > 0) then
		PriceTooltipNote.SavedVariables.Data[linkId] = note
		d("PTN: Updated '" .. linkText .. "' with NOTE '" .. note .. "'")
	else
		PriceTooltipNote.SavedVariables.Data[linkId] = nil
		d("PTN: Deleted NOTE for '" .. linkText .. "'")
	end

	return true
end


PriceTooltipNote_DeleteNote = function(text)
	local result = PriceTooltipNote_DeleteNoteInternal(text)
	if (not result) then d("PTN: Could not resolve link") end
end


function PriceTooltipNote_DeleteNoteInternal(text)
	text = PriceTooltipNote_Trim(text)
	if (string.len(text) <= 0) then return false end

	local linkText = string.match(PriceTooltipNote_FirstWord(text), "^|H[0-9]:item:.*|h|h$")
	if (not linkText) then return false end

	local linkId = GetItemLinkItemId(linkText)
	if (not linkId) then return false end

	PriceTooltipNote.SavedVariables.Data[linkId] = nil
	d("PTN: Deleted NOTE for '" .. linkText .. "'")

	return true
end


PriceTooltipNote_FirstWord = function(text)
	if text then
		for substring in text:gmatch("%S+") do
		   return substring
		end
	end

	return ""
end


PriceTooltipNote_GetText = function(text, skip)
	local result = ""

	if text and skip then
		for substring in text:gmatch("%S+") do
			if skip <= 0 then result = result .. " " .. substring
			else skip = skip - 1 end
		end
	end

	return result or ""
end


PriceTooltipNote_NoteToChat_Edit = function(link)
	if CHAT_SYSTEM and CHAT_SYSTEM.textEntry and CHAT_SYSTEM.textEntry.editControl then
		local chat = CHAT_SYSTEM.textEntry.editControl
		if (not chat:HasFocus()) then StartChatInput() end

		local note = PriceTooltipNote_GetData(link) or "TEXT"

		chat:InsertText("/ptn_edit_note " .. string.gsub(link, '|H0', '|H1') .. " " .. note)
	end
end


PriceTooltipNote_NoteToChat_Delete = function(link)
	if CHAT_SYSTEM and CHAT_SYSTEM.textEntry and CHAT_SYSTEM.textEntry.editControl then
		local chat = CHAT_SYSTEM.textEntry.editControl
		if (not chat:HasFocus()) then StartChatInput() end

		chat:InsertText("/ptn_delete_note " .. string.gsub(link, '|H0', '|H1'))
	end
end


PriceTooltipNote_GetData = function(link)
	if (not link) then return nil end

	local linkId = GetItemLinkItemId(link)
	if (not linkId) then return nil end

	local value = PriceTooltipNote.SavedVariables.Data[linkId]
	if (not value) then return nil end

	return value
end


SLASH_COMMANDS["/ptn_edit_note"] = PriceTooltipNote_EditNote
SLASH_COMMANDS["/ptn_delete_note"] = PriceTooltipNote_DeleteNote


EVENT_MANAGER:RegisterForEvent("PriceTooltipNote_Load", EVENT_ADD_ON_LOADED, PriceTooltipNote_Load)