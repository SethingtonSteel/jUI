DressingRoomAbilityFixupTool = {
	name = "DressingRoomAbilityFixupTool",
};

function DressingRoomAbilityFixupTool.OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= DressingRoomAbilityFixupTool.name) then return end

	EVENT_MANAGER:UnregisterForEvent(DressingRoomAbilityFixupTool.name, EVENT_ADD_ON_LOADED);

	SLASH_COMMANDS["/fixdr"] = DressingRoomAbilityFixupTool.Fix;
end

function DressingRoomAbilityFixupTool.Fix( )
	local count = 0;

	CHAT_SYSTEM:AddMessage("Dressing Room Ability Fixup Tool – Update 13 (Homestead) – Do not use this more than once per character!");

	if (DressingRoom) then
		if (DressingRoom.sv and DressingRoom.sv.skillSet) then
			for i = 1, #DressingRoom.sv.skillSet do
				for j = 1, #DressingRoom.sv.skillSet[i] do
					for k = 1, #DressingRoom.sv.skillSet[i][j] do
						local ability = DressingRoom.sv.skillSet[i][j][k].ability;

						-- Fix for the swap of sorc armor and ward
						if (DressingRoom.sv.skillSet[i][j][k].type == 1 and DressingRoom.sv.skillSet[i][j][k].line == 2 and GetUnitClassId("player") == 2) then
							if (ability == 5) then
								DressingRoom.sv.skillSet[i][j][k].ability = 6;
								count = count + 1;
							end

							if (ability == 6) then
								DressingRoom.sv.skillSet[i][j][k].ability = 5;
								count = count + 1;
							end
						end

						-- Fix for the swap of NB cloak and concealed weapon
						if (DressingRoom.sv.skillSet[i][j][k].type == 1 and DressingRoom.sv.skillSet[i][j][k].line == 2 and GetUnitClassId("player") == 3) then
							if (ability == 2) then
								DressingRoom.sv.skillSet[i][j][k].ability = 3;
								count = count + 1;
							end

							if (ability == 3) then
								DressingRoom.sv.skillSet[i][j][k].ability = 2;
								count = count + 1;
							end
						end

						-- Fix for the swap of 2H cleave and uppercut
						if (DressingRoom.sv.skillSet[i][j][k].type == 2 and DressingRoom.sv.skillSet[i][j][k].line == 1) then
							if (ability == 2) then
								DressingRoom.sv.skillSet[i][j][k].ability = 4;
								count = count + 1;
							end

							if (ability == 4) then
								DressingRoom.sv.skillSet[i][j][k].ability = 2;
								count = count + 1;
							end
						end

						-- Fix for the swap of DW slashes and flurry
						if (DressingRoom.sv.skillSet[i][j][k].type == 2 and DressingRoom.sv.skillSet[i][j][k].line == 3) then
							if (ability == 2) then
								DressingRoom.sv.skillSet[i][j][k].ability = 3;
								count = count + 1;
							end

							if (ability == 3) then
								DressingRoom.sv.skillSet[i][j][k].ability = 2;
								count = count + 1;
							end
						end

						-- Fix for the swap of bow poison arrow and snipe
						if (DressingRoom.sv.skillSet[i][j][k].type == 2 and DressingRoom.sv.skillSet[i][j][k].line == 4) then
							if (ability == 2) then
								DressingRoom.sv.skillSet[i][j][k].ability = 6;
								count = count + 1;
							end

							if (ability == 6) then
								DressingRoom.sv.skillSet[i][j][k].ability = 2;
								count = count + 1;
							end
						end

						-- Fix for the swap of destro touch and pulse
						if (DressingRoom.sv.skillSet[i][j][k].type == 2 and DressingRoom.sv.skillSet[i][j][k].line == 5) then
							if (ability == 2) then
								DressingRoom.sv.skillSet[i][j][k].ability = 4;
								count = count + 1;
							end

							if (ability == 4) then
								DressingRoom.sv.skillSet[i][j][k].ability = 2;
								count = count + 1;
							end
						end
					end
				end
			end
		end
	else
		CHAT_SYSTEM:AddMessage("Dressing Room is not loaded.");
	end

	CHAT_SYSTEM:AddMessage(string.format("Abilities updated: %d – Please reload the UI or relog for the changes to take effect", count));
	StartChatInput("/reloadui");
end

EVENT_MANAGER:RegisterForEvent(DressingRoomAbilityFixupTool.name, EVENT_ADD_ON_LOADED, DressingRoomAbilityFixupTool.OnAddOnLoaded);
