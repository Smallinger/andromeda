local F, C, L = unpack(select(2, ...))

-- Remove Boss Banner
if C.general.bossBanner == true then
	BossBanner.PlayBanner = function() end
end

-- Remove Talking Head Frame
if C.general.talkingHead == true then
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, addon)
		if addon == "Blizzard_TalkingHeadUI" then
			hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
				TalkingHeadFrame:Hide()
			end)
			self:UnregisterEvent(event)
		end
	end)
end

-- ALT + Right Click to buy a stack
local old_MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local cache = {}
function MerchantItemButton_OnModifiedClick(self, ...)
	if IsAltKeyDown() then
		local id = self:GetID()
		local itemLink = GetMerchantItemLink(id)
		if not itemLink then return end
		local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
		if ( maxStack and maxStack > 1 ) then
			if not cache[itemLink] then
				StaticPopupDialogs["BUY_STACK"] = {
					text = "Stack Buying Check",
					button1 = YES,
					button2 = NO,
					OnAccept = function()
						BuyMerchantItem(id, GetMerchantItemMaxStack(id))
						cache[itemLink] = true
					end,
					hideOnEscape = 1,
					hasItemFrame = 1,
				}
				local r, g, b = GetItemQualityColor(quality or 1)
				StaticPopup_Show("BUY_STACK", " ", " ", {["texture"] = texture, ["name"] = name, ["color"] = {r, g, b, 1}, ["link"] = itemLink, ["index"] = id, ["count"] = maxStack})
			else
				BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			end
		end
	end
	old_MerchantItemButton_OnModifiedClick(self, ...)
end

-- Fix Drag Collections taint
local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'ADDON_LOADED' )
EventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
		CollectionsJournal:HookScript("OnShow", function()
			if not self.init then
				if InCombatLockdown() then
					self:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					F.CreateMF(CollectionsJournal)
					self:UnregisterAllEvents()
				end
				self.init = true
			end
		end)
	elseif event == "PLAYER_REGEN_ENABLED" then
		F.CreateMF(CollectionsJournal)
		self:UnregisterAllEvents()
	end
end)

-- Temporary PVP queue taint fix
InterfaceOptionsFrameCancel:SetScript("OnClick", function()
	InterfaceOptionsFrameOkay:Click()
end)

-- Quickjoin for worldquests
do
	hooksecurefunc("BonusObjectiveTracker_OnBlockClick", function(self, button)
		if self.module.ShowWorldQuests then
			if button == "MiddleButton" then
				LFGListUtil_FindQuestGroup(self.TrackedQuest.questID)
			end
		end
	end)

	for i = 1, 10 do
		local bu = _G["LFGListSearchPanelScrollFrameButton"..i]
		if bu then
			bu:HookScript("OnDoubleClick", function()
				if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
					LFGListFrame.SearchPanel.SignUpButton:Click()
				end
				if LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
					LFGListApplicationDialog.SignUpButton:Click()
				end
			end)
		end
	end
end

-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G["RaidGroupButton"..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute("type", "target")
				bu:SetAttribute("unit", bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local EventFrame = CreateFrame( 'Frame' )
	EventFrame:RegisterEvent("ADDON_LOADED")
	EventFrame:SetScript("OnEvent", function(self, event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_RaidUI" then
			if not InCombatLockdown() then
				fixRaidGroupButton()
				self:UnregisterAllEvents()
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		elseif event == "PLAYER_REGEN_ENABLED" then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute("type") ~= "target" then
				fixRaidGroupButton()
				self:UnregisterAllEvents()
			end
		end
	end)
end

-- Fix blizz LFGList error in zhCN
if GetLocale() == "zhCN" then
	StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
		text = " 针对此项活动，你的队伍人数已满，将被移出列表。",
		button1 = OKAY,
		timeout = 0,
		whileDead = 1,
	}
end

-- Ctrl + left click to report spamer
local _ChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
function ChatFrame_OnHyperlinkShow (chatframe,link,text,button)
	if IsControlKeyDown() then
		local line = string.match(link,"player:[^:]+:(%d+):");
			if line then
				ReportPlayer("spam",line);
			return;
		end
	end
	return _ChatFrame_OnHyperlinkShow (chatframe,link,text,button);
end

-- Hide group member name while inside raid instance
if C.general.hideRaidNames then
	local HRN = CreateFrame("Frame")
	HRN:RegisterEvent("PLAYER_ENTERING_WORLD")
	HRN:SetScript("OnEvent", function(self, event)
		if event=="PLAYER_ENTERING_WORLD" then
			local _,instanceType = IsInInstance()
			if instanceType=="raid" then
				SetCVar("UnitNameFriendlyPlayerName",0);
			else
				SetCVar("UnitNameFriendlyPlayerName",1);
			end
		end
	end)
end

-- Take screenshots of defined events
if C.general.autoScreenShot then
	local function OnEvent( self, event, ... )
		C_Timer.After( 1, function() Screenshot() end )
	end

	local EventFrame = CreateFrame( 'Frame' )
	EventFrame:RegisterEvent( 'ACHIEVEMENT_EARNED' )
	EventFrame:SetScript( 'OnEvent', OnEvent )
end

-- Clean up Loss Of Control
local frame = _G.LossOfControlFrame
frame.RedLineTop:SetTexture(nil)
frame.RedLineBottom:SetTexture(nil)
frame.blackBg:SetTexture(nil)

F.ReskinIcon(frame.Icon)
F.CreateBG(frame.Icon)

-- Say sapped
if C.general.SaySapped then
	local SaySapped = CreateFrame("Frame")
	SaySapped.playername = UnitName("player")

	SaySapped:SetScript("OnEvent", function(_,_,_,event, _,_,sourceName, _,_,_,destName, _,_,spellId)
		if ((spellId == 6770)
		and (destName == SaySapped.playername)
		and (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH"))
		then
			if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
				SendChatMessage("我被闷棍: "..(sourceName or "(unknown)"),"SAY")
			else
				SendChatMessage("Sapped by: "..(sourceName or "(unknown)"),"SAY")
			end
			DEFAULT_CHAT_FRAME:AddMessage("Sapped by: "..(sourceName or "(unknown)"))
		end
	end)

	SaySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- ncShadow
if C.appearance.ncShadow then
	local f = CreateFrame("Frame", "ShadowBackground")
	f:SetPoint("TOPLEFT")
	f:SetPoint("BOTTOMRIGHT")
	f:SetFrameLevel(0)
	f:SetFrameStrata("BACKGROUND")
	f.tex = f:CreateTexture()
	f.tex:SetTexture([[Interface\Addons\FreeUI\media\shadow.tga]])
	f.tex:SetAllPoints(f)

	f:SetAlpha(.7)
	
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
end

-- temporary fix
_G.GarrisonLandingPageTutorialBox:Hide()