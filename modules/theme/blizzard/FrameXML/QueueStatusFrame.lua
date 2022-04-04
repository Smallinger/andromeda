local F, C = unpack(select(2, ...))

local LFD_NUM_ROLES = _G.LFD_NUM_ROLES or 3

local function reskinEntry(self)
    if self.styled then
        return
    end

    F.ReskinRole(self.TanksFound, 'TANK')
    F.ReskinRole(self.HealersFound, 'HEALER')
    F.ReskinRole(self.DamagersFound, 'DPS')

    for i = 1, LFD_NUM_ROLES do
        local roleIcon = self['RoleIcon' .. i]
        roleIcon:SetTexture(C.Assets.Texture.LfgRole)
        roleIcon.bg = F.CreateBDFrame(roleIcon)
        if i > 1 then
            roleIcon:SetPoint('RIGHT', self['RoleIcon' .. (i - 1)], 'LEFT', -4, 0)
        end
    end

    self.styled = true
end

local function updateTexCoord(entry, index, role)
    local roleIcon = entry['RoleIcon' .. index]
    roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
    roleIcon:Show()
    roleIcon.bg:Show()
end

table.insert(C.BlizzThemes, function()
    hooksecurefunc('QueueStatusEntry_SetMinimalDisplay', function(entry)
        reskinEntry(entry)

        for i = 1, LFD_NUM_ROLES do
            entry['RoleIcon' .. i].bg:Hide()
        end
    end)

    hooksecurefunc('QueueStatusEntry_SetFullDisplay', function(entry, _, _, _, isTank, isHealer, isDPS)
        reskinEntry(entry)

        local nextRoleIcon = 1
        if isDPS then
            updateTexCoord(entry, nextRoleIcon, 'DPS')
            nextRoleIcon = nextRoleIcon + 1
        end
        if isHealer then
            updateTexCoord(entry, nextRoleIcon, 'HEALER')
            nextRoleIcon = nextRoleIcon + 1
        end
        if isTank then
            updateTexCoord(entry, nextRoleIcon, 'TANK')
            nextRoleIcon = nextRoleIcon + 1
        end

        for i = nextRoleIcon, LFD_NUM_ROLES do
            entry['RoleIcon' .. i]:Hide()
            entry['RoleIcon' .. i].bg:Hide()
        end
    end)
end)
