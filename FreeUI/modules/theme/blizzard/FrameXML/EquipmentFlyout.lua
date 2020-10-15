local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FreeADB.appearance.reskin_blizz then return end

	local navFrame = EquipmentFlyoutFrame.NavigationFrame
	EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
	EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")

	navFrame:SetWidth(204)
	navFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 1, 0)

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local button = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]

		button.icon:SetTexCoord(unpack(C.TexCoord))
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button.bg = F.CreateBDFrame(button)
		F.ReskinIconBorder(button.IconBorder)
	end)

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		local border = button.IconBorder
		if not location or not border then return end

		border:SetShown(location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION)
	end)

	local function reskinButtonFrame()
		local frame = EquipmentFlyoutFrame.buttonFrame
		if not frame.bg then
			frame.bg = F.SetBD(EquipmentFlyoutFrame.buttonFrame)
		end
		frame:SetWidth(frame:GetWidth()+3)
	end
	hooksecurefunc("EquipmentFlyout_UpdateItems", reskinButtonFrame)

	local navigationFrame = EquipmentFlyoutFrame.NavigationFrame
	F.SetBD(navigationFrame)
	navigationFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 0, -3)
	navigationFrame:SetPoint("TOPRIGHT", EquipmentFlyoutFrameButtons, "BOTTOMRIGHT", 0, -3)
	F.ReskinArrow(navigationFrame.PrevButton, "left")
	F.ReskinArrow(navigationFrame.NextButton, "right")
end)
