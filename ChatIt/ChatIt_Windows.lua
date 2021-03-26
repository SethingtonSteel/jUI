
-- Lots of code changes as of version 100012 changes made (2015-09-04)

--====================================================================================================================--
--====================================================================================================================--
-- Due to code changes after 100012 update they moved the newWindowTab control from SharedChatSystem.xml
-- It used to be a child of ZO_ChatContainerTemplate, and therefore inherited by ZO_ChatContainerTemplate
-- So when a new container was created using ZO_ChatContainerTemplate, the newWindowTab was there to grab
-- But newWindowTab has been made a direct child of ZO_ChatWindow. 

-- So now when a new container is created using
-- ZO_ChatContainerTemplate newWindowTab child does not exist. ChatContainer:Initialize() attempts to grab
-- the child newWindowTab, but it does not exist, and pass it to ZO_TabButton_Icon_Initialize which throws
-- an error because self is nil (its supposed to be newWindowTab).

-- Since we can't can't change the template (dont want to mess up the primary window), we'll just prehook
-- SharedChatSystem:LoadChatFromSettings so we can grab its parameter newContainerFn (since it must be
-- internal game code theres no where else to grab it from that I can find) and then we remake the
-- container pool. Adding a call to check if newWindowTab exists & if not we create it ourselves.

-- We also fix the anchors while were at it for new windows. The game does not properly anchor the 
-- container.windowContainer & that it and the currentBuffer  come out 0,0 dimensions. 
--====================================================================================================================--
--====================================================================================================================--


-- Fix the container.windowContainer Anchor so it & container.currentBuffer will have correct dimensions
local function FixContainerAnchor(container)
	-- Adjusting the scroll bar anchors for asthetic purposes only:
	local isValid0, point0, relativeTo0, relativePoint0, offsetX0, offsetY0 = container.scrollbar:GetAnchor(0)
	local isValid1, point1, relativeTo1, relativePoint1, offsetX1, offsetY1 = container.scrollbar:GetAnchor(1)
	
	container.scrollbar:ClearAnchors()
	container.scrollbar:SetAnchor(point0, relativeTo0, relativePoint0, offsetX0, 30)
	container.scrollbar:SetAnchor(point1, relativeTo1, relativePoint1, offsetX1, -40)
	
	-- Adjusting the windowContainer Anchors so it & currentBuffer will have correct dimensions
	container.windowContainer:ClearAnchors()
	container.windowContainer:SetAnchor(TOPRIGHT, container.scrollUpButton, TOPLEFT, 0, 0)
	container.windowContainer:SetAnchor(BOTTOMLEFT, container.windowContainer:GetParent(), BOTTOMLEFT, 20, 0)	
end


-- Used to make sure the container contains the NewWindowTab child
-- If not we create it ourselves
local function TryAddNewWindowTab(container)
    local newWindowTab = container:GetNamedChild("NewWindowTab")
	if newWindowTab then return end

	local newTabName = container:GetName().."NewWindowTab"
	local newWindowTab = CreateControlFromVirtual(newTabName, container, "ZO_SimpleIconWithHighlightTabButton")
	
	newWindowTab:SetHandler("OnMouseUp", function(self)
			ZO_ChatSystem_OnMouseEnter(self)
			ZO_TabButton_OnMouseEnter(self)
		end)
	newWindowTab:SetHandler("OnMouseDown", function(self)
			ZO_TabButton_Select(self)
		end)
end

-- Must prehook SharedChatSystem:LoadChatFromsettings in order to grab internal newContainerFn
-- then we can use it to rewrite the containerPool adding a call to ensure that the 
-- newWindowTab child exists (if not it gets added)
local function OnLoadChatFromSettings(self, newContainerFn, defaults)
	local function CreateContainer(objectPool)
		-- Code must be run in this order, we must add the newWindowTab (if needed)
		-- to the container control before attempting to pass it to newContainerFn
		-- newContainerFn is internal/server game code which is why we had to prehook LoadSettings
		-- to grab it before we could remake the containerPool
		
		-- This is the container control, for example CHAT_SYSTEM.containers[1].control
		local containerControl = ZO_ObjectPool_CreateControl("ZO_ChatContainerTemplate", objectPool, GuiRoot) 
		
		TryAddNewWindowTab(containerControl)
		
		-- This is the container itself, for example CHAT_SYSTEM.containers[1]
		local container = newContainerFn(self, containerControl, self.windowPool, self.tabPool)
		
		-- Fix windowContainer Anchors
		FixContainerAnchor(container)
		
		return container
	end

	self.containerPool = ZO_ObjectPool:New(CreateContainer, function(container) container:OnDestroy() end)
end
ZO_PreHook(SharedChatSystem, "LoadChatFromSettings", OnLoadChatFromSettings)


function SharedChatSystem:TransferWindow(window, previousContainer, targetContainer)
    local container = targetContainer or self:CreateChatContainer()
    
    self.isTransferring = true
    local tabIndex = window.tab.index
    local newTabIndex = container:TakeWindow(window, previousContainer)

    if not self.suppressSave then
        TransferChatContainerTab(previousContainer.id, tabIndex, container.id, newTabIndex)
    end

    container:FinalizeWindowTransfer(window)

    self.isTransferring = false
	-- See note above function for reason:
	self:NillAllContainerInsertIndices()
		
	-- Create the background for the new container --
	ChatIt.CreateExtraBg(container)
	
	-- Call the bg setup to set the backgrounds properties --
	ChatIt.UpdateChatPropertiesByContainer(container)
end


--====================================================================================================================--
--====================================================================================================================--
--[[ As of 100012
It is possible to transfer the main (1st) window tab of the primary container to another container. It is possible to transfer every window out of the primary container which throws an assert error when the game attempts to destroy the primary container because it has no windows left in it. Code below patches the holes preventing this from happening.
This happens when two contanier TabDropAreas overlap and you transfer windows between them. It sets the insertIndex on both containers when this happens. Whichever container the tab drops into properly has insertIndex set to nill, but the other container does not so we need to fix that by adding a call to nill out ALL container.insertIndex's. 

For extra safety I also added an IsPrimary() check to ensure that SharedChatContainer:TransferWindow will not even get called on the primary container if the window index == 1.
--]]
--====================================================================================================================--
--====================================================================================================================--

-- Nill out all container.InsertIndex 's
--============================================================================--
--*** This really isn't a SharedChatSystem game function. I'm just adding  ***--
--*** it to SharedChatSystem because...well it should already have/do this ***--
--============================================================================--
function SharedChatSystem:NillAllContainerInsertIndices()
	local tContainers = self.containers
	
    for i=1, #tContainers do
        tContainers[i].insertIndex = nil
    end
end

-- Again this isn't a real SharedChatContainer function. I'm creating it there so I can
-- pass self around to make it easier.
function SharedChatContainer:DockAllContainerWindowsToTargetContainer(insertIndex, targetContainer)
	-- Don't allow transfering windows out of the primary container
	if self:IsPrimary() then return end
	
	-- Since TransferWindow nills out the insert index we must store it
	local insertIndex = targetContainer.insertIndex
	
	-- Transfer in reverse order so the tabs keep 
	-- their tab order in the new container
	for i = #self.windows, 1, -1 do
		-- and reinitialize insertIndex before each window transfer
		targetContainer.insertIndex = insertIndex
		
		self:TransferWindow(i, targetContainer)
	end
end

--[[ ** This was the code to fix the bug, But I'm not going to use it. I'm going to add a feature while I'm at it.
So I'm going to fix it somewhere else. See next function rewrite of SharedChatSystem:StopContainersTabDrop(initiator)

-- Only allow SharedChatContainer:TransferWindow code to run if
-- the window.index ~= 1 or it is not the primary window
-- Prevents Transfer window code from running & transfering the 1st tab out of the primary container.
local function OnSharedChatContainerTransferWindow(self, index, targetContainer)
	-- If window.index ~= 1 then let the game call TransferWindow
	if index ~= 1 then return false end
	
	-- If we made it here window.index == 1 
	-- if its not the primary window then let the game call TransferWindow
	if not self:IsPrimary() then return false end
	
	-- else it is NOT the primary container & it IS window.index = 1
	-- return true so the TransferWindow code does not run
	return true
end
ZO_PreHook(SharedChatContainer, "TransferWindow", OnSharedChatContainerTransferWindow)
--]]

-- **** Instead of above code, while I'm at it rewriting all of this code, I'm going to 
-- add a feature to allow users to dock all window tabs to a target container
-- By dragging the first tab (of a non-primary container) to an index of another container
function SharedChatSystem:StopContainersTabDrop(initiator)
    local tabDropContainer, insertIndex
	
    for i, container in ipairs(self.containers) do
        if container ~= initiator then
            if not tabDropContainer and container:CanTakeTabDrop() then
                tabDropContainer = container
				insertIndex = container.insertIndex
            end
            container:StopTabDrop()
        end
    end
    
	-- tabDropContainer is always the first window since that's the only draggable tab
    if tabDropContainer and not initiator:IsPrimary() then
		initiator:DockAllContainerWindowsToTargetContainer(insertIndex, tabDropContainer)
    end
end







--====================================================================================================================--
--====================================================================================================================--
--====================================================================================================================--
--====================================================================================================================--


local function IsPhantomChatContainer(container)
	if #container.windows == 0 and not container:IsPrimary() then
		return true
	end
	-- Should I add a check in case windows == 0 & it is the primary window
	-- to automatically fix it by adding a window? It shouldn't ever happen.
	-- But, neither should a lot of things
	
	return false
end

-- Called from a button in the settings menu & on load:
-- Used by users in case of a problem to remove all of the "extra" chat containers
function ChatIt.DestroyExtraContainers()
	-- Since GetNumChatContainers is saved in game sv & can cause phantom containers
	-- wipe out all phantom containers
	local tContainers = CHAT_SYSTEM.containers
	
	--for i = GetNumChatContainers(), 1, -1 do
	for i = GetNumChatContainers(), 2, -1 do
		local container = tContainers[i]
		
		if IsPhantomChatContainer(container) then
			CHAT_SYSTEM:DestroyContainer(container)
		end
	end
end



--====================================================================================================================--
--====================================================================================================================--
--[[
This has nothing to do with game bugs, this is my toggle code for turning multiple chat windows ON/oFF
--]]
--====================================================================================================================--
--====================================================================================================================--
-- Toggle Multiple Windows ON/OFF, destroy all windows when toggling off --
function ChatIt.SetMultipleWindows(bAllow)
	local allowMultipleContainers = bAllow or ChatIt.SavedVariables["MULTIPLE_WINDOWS"]
	
	if allowMultipleContainers then
		CHAT_SYSTEM:SetAllowMultipleContainers(true)
	else
		CHAT_SYSTEM:SetAllowMultipleContainers(false)
		CHAT_SYSTEM:RedockContainersToPrimary()
	--========Removed version 100012 (2015-09-02) due to code changes =====================--
		--ChatIt.DestroyAllContainers()
	end
end
