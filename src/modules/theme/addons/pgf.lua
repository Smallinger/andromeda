local F = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

function THEME:ReskinPGF()
    if not _G.ANDROMEDA_ADB.ReskinPremadeGroupsFilter then
        return
    end

    if not IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    local tipStyled
    hooksecurefunc(_G.PremadeGroupsFilter.Debug, 'PopupMenu_Initialize', function()
        if tipStyled then
            return
        end
        for i = 1, _G.PremadeGroupsFilterDialog:GetNumChildren() do
            local child = select(i, _G.PremadeGroupsFilterDialog:GetChildren())
            if child and child.Shadow then
                F:GetModule('Tooltip').ReskinTooltip(child)
                tipStyled = true
                break
            end
        end
    end)

    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'SetPoint', function(self, _, parent)
        if parent ~= _G.LFGListFrame then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', _G.LFGListFrame, 'TOPRIGHT', 5, 0)
        end
    end)

    local styled
    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'Show', function(self)
        if styled then
            return
        end

        F.StripTextures(self)
        F.SetBD(self):SetAllPoints()
        F.ReskinClose(self.CloseButton)
        F.Reskin(self.ResetButton)
        F.Reskin(self.RefreshButton)
        F.ReskinDropDown(self.Difficulty.DropDown)
        F.StripTextures(self.Advanced)
        F.ReskinInput(self.Expression)
        F.ReskinInput(self.Sorting.SortingExpression)
        if self.MoveableToggle then
            F.ReskinArrow(self.MoveableToggle, 'left')
            self.MoveableToggle:SetPoint('TOPLEFT', 5, -5)
        end
        if self.MinimizeButton then
            F.ReskinArrow(self.MinimizeButton, 'down')
            self.MinimizeButton:ClearAllPoints()
            self.MinimizeButton:SetPoint('RIGHT', self.CloseButton, 'LEFT', -3, 0)
            F.ReskinArrow(self.MaximizeButton, 'up')
            self.MaximizeButton:ClearAllPoints()
            self.MaximizeButton:SetPoint('RIGHT', self.CloseButton, 'LEFT', -3, 0)
        end

        local names = {
            'Difficulty',
            'Ilvl',
            'Noilvl',
            'Defeated',
            'Members',
            'Tanks',
            'Heals',
            'Dps',
        }

        for _, name in pairs(names) do
            local check = self[name].Act
            if check then
                check:SetSize(26, 26)
                check:SetPoint('TOPLEFT', 5, -3)
                F.ReskinCheck(check)
            end
            local input = self[name].Min
            if input then
                F.ReskinInput(input)
                F.ReskinInput(self[name].Max)
            end
        end

        styled = true
    end)

    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'SetSize', function(self, width, height)
        if height == 427 then
            self:SetSize(width, 428)
        end
    end)

    _G.UsePFGButton:ClearAllPoints()
    _G.UsePFGButton:SetPoint('RIGHT', _G.LFGListFrame.SearchPanel.RefreshButton, 'LEFT', -40, 0)
    _G.UsePFGButton:SetSize(20, 20)
    F.ReskinCheck(_G.UsePFGButton, true)
    _G.UsePFGButton.text:SetWidth(35)
    _G.UsePFGButton.text:SetFontObject(_G.Game12Font)
end