local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('MISC')


local _G = getfenv(0)


local MISC_LIST = {}

function MISC:RegisterMisc(name, func)
	if not MISC_LIST[name] then
		MISC_LIST[name] = func
	end
end

function MISC:OnLogin()
	for name, func in next, MISC_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end



	self:BlowMyWhistle()

	self:ForceWarning()
	self:FasterCamera()

	self:Screenshot()

	self:QuestRewardHighlight()





end






-- Plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function MISC:BlowMyWhistle()
	if not FreeDB['blow_my_whistle'] then return end

	local whistleSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\whistle.ogg'
	local whistle_SpellID1 = 227334;
	-- for some reason the whistle is two spells which results in dirty events being called
	-- where spellID2 fires SUCCEEDED on spell cast start and spellID1 comes in later as the real SUCCEEDED
	local whistle_SpellID2 = 253937;

	local casting = false;

	local f = CreateFrame('frame')
	f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end);

	function f:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
		if (unit == 'player' and (spellID == whistle_SpellID1 or spellID == whistle_SpellID2)) then
			if casting then
				casting = false
				return
			end

			PlaySoundFile(whistleSound)
			casting = false
		end
	end

	function f:UNIT_SPELLCAST_START(event, castGUID, spellID)
		if spellID == whistle_SpellID1 then
			casting = true
		end
	end
	f:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
	f:RegisterEvent('UNIT_SPELLCAST_START')
end



function MISC:ForceWarning()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
	f:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH')
	f:RegisterEvent('LFG_PROPOSAL_SHOW')
	f:RegisterEvent('RESURRECT_REQUEST')
	f:SetScript('OnEvent', function(_, event)
		if event == 'UPDATE_BATTLEFIELD_STATUS' then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == 'confirm' then
					PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
					break
				end
				i = i + 1
			end
		elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
			PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
		elseif event == 'LFG_PROPOSAL_SHOW' then
			PlaySound(SOUNDKIT.READY_CHECK, 'Master')
		elseif event == 'RESURRECT_REQUEST' then
			PlaySound(37, 'Master')
		end
	end)
end

local ShowReadyCheckHook = function(_, initiator)
	if initiator ~= 'player' then
		PlaySound(SOUNDKIT.READY_CHECK, 'Master')
	end
end
hooksecurefunc('ShowReadyCheck', ShowReadyCheckHook)


function MISC:FasterCamera()
	if not FreeDB['faster_camera'] then return end

	local oldZoomIn = CameraZoomIn
	local oldZoomOut = CameraZoomOut
	local oldVehicleZoomIn = VehicleCameraZoomIn
	local oldVehicleZoomOut = VehicleCameraZoomOut
	local newZoomSpeed = 4

	function CameraZoomIn(distance)
		oldZoomIn(newZoomSpeed)
	end

	function CameraZoomOut(distance)
		oldZoomOut(newZoomSpeed)
	end

	function VehicleCameraZoomIn(distance)
		oldVehicleZoomIn(newZoomSpeed)
	end

	function VehicleCameraZoomOut(distance)
		oldVehicleZoomOut(newZoomSpeed)
	end
end


-- Highlight high value reward
local function CreateHighlight(reward)
	if not MISC.rewardHighlightFrame then
		MISC.rewardHighlightFrame = CreateFrame('Frame', 'QuesterRewardHighlight', QuestInfoRewardsFrame, 'AutoCastShineTemplate')
		MISC.rewardHighlightFrame:SetScript('OnHide', function(frame) AutoCastShine_AutoCastStop(frame) end)
	end

	MISC.rewardHighlightFrame:ClearAllPoints()
	MISC.rewardHighlightFrame:SetAllPoints(reward)
	MISC.rewardHighlightFrame:Show()

	AutoCastShine_AutoCastStart(MISC.rewardHighlightFrame)
end

local function UpdateHighlight()
	if MISC.rewardHighlightFrame then
		MISC.rewardHighlightFrame:Hide()
	end

	local bestprice, bestitem = 0, 0
	for i = 1, GetNumQuestChoices() do
		local link, _, _, qty = GetQuestItemLink('choice', i), GetQuestItemInfo('choice', i)
		local price = link and select(11, GetItemInfo(link))
		if not price then return end

		price = price * (qty or 1)

		if price > bestprice then
			bestprice = price
			bestitem = i
		end
	end

	local rewardButton = _G['QuestInfoRewardsFrameQuestInfoItem'..bestitem]

	if bestitem > 0 then
		CreateHighlight(_G[('QuestInfoRewardsFrameQuestInfoItem%dIconTexture'):format(bestitem)])

		_G.QuestInfoFrame.itemChoice = rewardButton:GetID()
	end
end

function MISC:QuestRewardHighlight()
	if FreeDB.misc.reward_highlight then
		F:RegisterEvent('QUEST_COMPLETE', UpdateHighlight)
	else
		F:UnregisterEvent('QUEST_COMPLETE', UpdateHighlight)
	end
end






do
	local delay, time = 1, 0
	local function OnUpdate(self, elapsed)
		time = time + elapsed

		if time >= delay then
			Screenshot()
			time = 0
			self:SetScript('OnUpdate', nil)
		end
	end

	local function OnEvent(self)
		self:SetScript('OnUpdate', OnUpdate)
	end

	function MISC:Screenshot()
		if not FreeDB.misc.auto_screenshot then return end

		local f = CreateFrame('Frame')

		if FreeDB.misc.screenshot_achievement then
			f:RegisterEvent('ACHIEVEMENT_EARNED')
		end

		if FreeDB.misc.screenshot_dead then
			f:RegisterEvent('PLAYER_DEAD')
		end

		if FreeDB.misc.screenshot_levelup then
			f:RegisterEvent('PLAYER_LEVEL_UP')
		end

		if FreeDB.misc.screenshot_challenge then
			f:RegisterEvent('CHALLENGE_MODE_COMPLETED')
		end

		f:SetScript('OnEvent', OnEvent)
	end
end


-- auto select current event boss from LFD tool
do
	local firstLFD
	LFDParentFrame:HookScript('OnShow', function()
		if not firstLFD then
			firstLFD = 1
			for i = 1, GetNumRandomDungeons() do
				local id = GetLFGRandomDungeonInfo(i)
				local isHoliday = select(15, GetLFGDungeonInfo(id))
				if isHoliday and not GetLFGDungeonRewards(id) then
					LFDQueueFrame_SetType(id)
				end
			end
		end
	end)
end
