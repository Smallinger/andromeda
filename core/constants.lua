local _G = _G
local unpack = unpack
local select = select
local format = format
local tonumber = tonumber
local split = strsplit
local UnitName = UnitName
local UnitClass = UnitClass
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitFactionGroup = UnitFactionGroup
local UnitGUID = UnitGUID
local GetRealmName = GetRealmName
local GetLocale = GetLocale
local GetCVar = GetCVar
local GetPhysicalScreenSize = GetPhysicalScreenSize
local GetBuildInfo = GetBuildInfo
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local BAG_ITEM_QUALITY_COLORS = BAG_ITEM_QUALITY_COLORS
local WOW_PROJECT_ID = WOW_PROJECT_ID
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local Enum_ItemQuality_Poor = Enum.ItemQuality.Poor
local Enum_ItemQuality_Common = Enum.ItemQuality.Common
local Enum_ItemQuality_Uncommon = Enum.ItemQuality.Uncommon
local Enum_ItemQuality_Rare = Enum.ItemQuality.Rare
local Enum_ItemQuality_Epic = Enum.ItemQuality.Epic
local Enum_ItemQuality_Legendary = Enum.ItemQuality.Legendary
local Enum_ItemQuality_Artifact = Enum.ItemQuality.Artifact
local Enum_ItemQuality_Heirloom = Enum.ItemQuality.Heirloom

local F, C = unpack(select(2, ...))



C.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
C.IsNewPatch = C.IsRetail and select(4, GetBuildInfo()) >= 90100 -- 9.1.0
C.GameLocale = GetLocale()
C.IsChinses = C.GameLocale == 'zhCN' or C.GameLocale == 'zhTW'
C.IsCNPortal = GetCVar('portal') == 'CN'
C.MaxLevel = GetMaxLevelForPlayerExpansion()
C.MyClass = select(2, UnitClass('player'))
C.MyName = UnitName('player')
C.MyLevel = UnitLevel('player')
C.MyFaction = select(2, UnitFactionGroup('player'))
C.MyRace = select(2, UnitRace('player'))
C.MyRealm = GetRealmName()
C.MyFullName = C.MyName .. '-' .. C.MyRealm

local playerGUID = UnitGUID('player')
local _, serverID = split('-', playerGUID)
C.ServerID = tonumber(serverID)
C.MyGuid = playerGUID

C.ScreenWidth, C.ScreenHeight = GetPhysicalScreenSize()
C.isLowRes = C.ScreenHeight < 1500

C.AssetsPath = 'Interface\\AddOns\\FreeUI\\assets\\'
C.TexCoord = {.08, .92, .08, .92}
C.UIGap = 33


C.Assets = {
    ['norm_tex'] = C.AssetsPath .. 'textures\\norm_tex',
    ['grad_tex'] = C.AssetsPath .. 'textures\\grad_tex',
    ['flat_tex'] = C.AssetsPath .. 'textures\\flat_tex',
    ['statusbar_tex'] = C.AssetsPath .. 'textures\\norm_tex',
    ['bd_tex'] = 'Interface\\ChatFrame\\ChatFrameBackground',
    ['bg_tex'] = C.AssetsPath .. 'textures\\bg_tex',
    ['shadow_tex'] = C.AssetsPath .. 'textures\\shadow_tex',
    ['glow_tex'] = C.AssetsPath .. 'textures\\glow_tex',
    ['blank_tex'] = C.AssetsPath .. 'textures\\blank_tex',
    ['tick_tex'] = C.AssetsPath .. 'textures\\tick_tex',
    ['stripe_tex'] = C.AssetsPath .. 'textures\\stripe_tex',
    ['close_tex'] = C.AssetsPath .. 'textures\\close_tex',
    ['arrow_tex'] = C.AssetsPath .. 'textures\\arrow_tex',
    ['shield_tex'] = C.AssetsPath .. 'textures\\shield_tex',
    ['sword_tex'] = C.AssetsPath .. 'textures\\sword_tex',
    ['button_normal'] = C.AssetsPath .. 'button\\normal',
    ['button_flash'] = C.AssetsPath .. 'button\\flash',
    ['button_pushed'] = C.AssetsPath .. 'button\\pushed',
    ['button_checked'] = C.AssetsPath .. 'button\\checked',
    ['mask_tex'] = C.AssetsPath .. 'textures\\minimap_mask',
    ['diff_tex'] = C.AssetsPath .. 'textures\\minimap_diff',
    ['roles_icon'] = C.AssetsPath .. 'textures\\roles_icon',
    ['target_icon'] = C.AssetsPath .. 'textures\\UI-RaidTargetingIcons',
    ['vig_tex'] = C.AssetsPath .. 'textures\\vignetting',
    ['spark_tex'] = 'Interface\\CastingBar\\UI-CastingBar-Spark',
    ['gear_tex'] = C.AssetsPath .. 'textures\\gear_tex',
    ['classify_tex'] = C.AssetsPath .. 'textures\\state_icons',
    ['mail_tex'] = C.AssetsPath .. 'textures\\mail_tex',
    ['logo'] = C.AssetsPath .. 'textures\\logo_tex',
    ['mouse_left'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t ',
    ['mouse_right'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t ',
    ['mouse_middle'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t ',

    Textures = {}, -- #TODO

    Sounds = {
        Intro = C.AssetsPath .. 'sounds\\intro.ogg',
        Whisper = C.AssetsPath .. 'sounds\\whisper_normal.ogg',
        WhisperBattleNet = C.AssetsPath .. 'sounds\\whisper_battlenet.ogg',
        Notification = C.AssetsPath .. 'sounds\\notification.ogg',
        LowHealth = C.AssetsPath .. 'sounds\\lowhealth.ogg',
        LowMana = C.AssetsPath .. 'sounds\\lowmana.ogg',
        Interrupt = C.AssetsPath .. 'sounds\\interrupt.ogg',
        Dispel = C.AssetsPath .. 'sounds\\dispel.ogg',
        Missed = C.AssetsPath .. 'sounds\\missed.ogg',
        Proc = C.AssetsPath .. 'sounds\\proc.ogg',
        Exec = C.AssetsPath .. 'sounds\\exec.ogg',
        Pulse = C.AssetsPath .. 'sounds\\pulse.ogg',
        Error = C.AssetsPath .. 'sounds\\error.ogg',
        Warning = C.AssetsPath .. 'sounds\\warning.ogg',
        ForTheHorde = C.AssetsPath .. 'sounds\\forthehorde.ogg',
        Mario = C.AssetsPath .. 'sounds\\mario.ogg',
        Alarm = C.AssetsPath .. 'sounds\\alarm.ogg',
        Ding = C.AssetsPath .. 'sounds\\ding.ogg',
    },

    Fonts = {
        Regular = C.AssetsPath .. 'fonts\\regular.ttf',
        Condensed = C.AssetsPath .. 'fonts\\condensed.ttf',
        Bold = C.AssetsPath .. 'fonts\\bold.ttf',
        Header = C.AssetsPath .. 'fonts\\header.ttf',
        Combat = C.AssetsPath .. 'fonts\\combat.ttf',
        Pixel = C.AssetsPath .. 'fonts\\pixel.ttf',
        Square = C.AssetsPath .. 'fonts\\square.ttf',
        Roadway = C.AssetsPath .. 'fonts\\roadway.ttf',
    },
}

C.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
    C.ClassList[v] = k
end

C.ClassColors = {}
function F.UpdateCustomClassColors()
    local colors = _G.FREE_ADB.UseCustomClassColor and _G.FREE_ADB.CustomClassColors or RAID_CLASS_COLORS
    for class, value in pairs(colors) do
        C.ClassColors[class] = {}
        C.ClassColors[class].r = value.r
        C.ClassColors[class].g = value.g
        C.ClassColors[class].b = value.b
        C.ClassColors[class].colorStr = value.colorStr
    end

    C.r = C.ClassColors[C.MyClass].r
    C.g = C.ClassColors[C.MyClass].g
    C.b = C.ClassColors[C.MyClass].b

    C.MyColor = format('|cff%02x%02x%02x', C.r * 255, C.g * 255, C.b * 255)
    C.AddonName = 'Free' .. C.MyColor ..'UI|r'
end
F:RegisterEvent('ADDON_LOADED', F.UpdateCustomClassColors)

C.InfoColor = '|cffe9c55d'
C.YellowColor = '|cffffff00'
C.GreyColor = '|cff7f7f7f'
C.WhiteColor = '|cffffffff'
C.RedColor = '|cffff2020'
C.GreenColor = '|cff20ff20'
C.BlueColor = '|cff82c5ff'
C.OrangeColor = '|cffff7f3f'
C.PurpleColor = '|cffa571df'
C.LineString = C.GreyColor .. '---------------'

-- Deprecated
_G.LE_ITEM_QUALITY_POOR = Enum_ItemQuality_Poor
_G.LE_ITEM_QUALITY_COMMON = Enum_ItemQuality_Common
_G.LE_ITEM_QUALITY_UNCOMMON = Enum_ItemQuality_Uncommon
_G.LE_ITEM_QUALITY_RARE = Enum_ItemQuality_Rare
_G.LE_ITEM_QUALITY_EPIC = Enum_ItemQuality_Epic
_G.LE_ITEM_QUALITY_LEGENDARY = Enum_ItemQuality_Legendary
_G.LE_ITEM_QUALITY_ARTIFACT = Enum_ItemQuality_Artifact
_G.LE_ITEM_QUALITY_HEIRLOOM = Enum_ItemQuality_Heirloom

C.QualityColors = {}
local qualityColors = BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
    C.QualityColors[index] = {r = value.r, g = value.g, b = value.b}
end
C.QualityColors[-1] = {r = 0, g = 0, b = 0}
C.QualityColors[_G.LE_ITEM_QUALITY_POOR] = {r = .61, g = .61, b = .61}
C.QualityColors[_G.LE_ITEM_QUALITY_COMMON] = {r = 0, g = 0, b = 0}

_G.GOLD_AMOUNT_SYMBOL = format('|cffffd700%s|r', _G.GOLD_AMOUNT_SYMBOL)
_G.SILVER_AMOUNT_SYMBOL = format('|cffd0d0d0%s|r', _G.SILVER_AMOUNT_SYMBOL)
_G.COPPER_AMOUNT_SYMBOL = format('|cffc77050%s|r', _G.COPPER_AMOUNT_SYMBOL)
_G.COPPER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t'
_G.SILVER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t'
_G.GOLD_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t'

-- Update my role
local function CheckMyRole()
    local tree = GetSpecialization()
    if not tree then
        return
    end
    local _, _, _, _, role, primaryStat = GetSpecializationInfo(tree)
    if role == 'TANK' then
        C.MyRole = 'Tank'
    elseif role == 'HEALER' then
        C.MyRole = 'Healer'
    elseif role == 'DAMAGER' then
        if primaryStat == 4 then -- 1 - Strength, 2 - Agility, 4 - Intellect
            C.MyRole = 'Caster'
        else
            C.MyRole = 'Melee'
        end
    end
end
F:RegisterEvent('ADDON_LOADED', CheckMyRole)
F:RegisterEvent('PLAYER_TALENT_UPDATE', CheckMyRole)
