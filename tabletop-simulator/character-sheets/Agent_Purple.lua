-- Delta Green TTS Agent Sheet — Purple
-- Version: r78
-- Published by Hellhorde
-- Date: 2026-09-30
-- Free to use, modify, and share provided this credit header remains intact.
-- Tabletop Simulator object script for Agent UI, physical dice, equipment,
-- psychology, funds/inventory, persistence, and Handler dashboard sync.
--
-- Sheet-specific GUIDs are configured directly below.

-- Sheet identity
SHEET_COLOR = "Purple"

-- Table nameplate object
NAME_DISPLAY_GUID = "cd232a"

-- Physical dice tower
DICE_TOWER_GUID = "7f7c67"

-- Shared dice storage
SHARED_DICE_STORAGE_GUID = "a50074"

-- Optional Handler dashboard GUID override
HANDLER_DASHBOARD_GUID = ""

local function getPhysicalDiceConfig(playerColor)
    return {
        storage = SHARED_DICE_STORAGE_GUID,
        tower = DICE_TOWER_GUID
    }
end

-------------------------------------------------
-- PHYSICAL DICE SETTINGS
-------------------------------------------------

PHYSICAL_DICE_RETURN_DELAY = 3.0
PHYSICAL_DICE_SETTLE_FRAMES = 12
PHYSICAL_DICE_TIMEOUT_FRAMES = 2400

-- Multi-die pools are launched as a stream instead of waiting for each die
-- to settle before the next one is taken from storage.
DICE_POOL_SPAWN_INTERVAL = 0.40

-- Random angular impulse applied to every physical die rolled by this sheet.
DICE_SPIN_MIN = 22
DICE_SPIN_MAX = 36




-----------------------------
-- CONFIGURATION
-----------------------------

-- UI panel size in XML pixels.
UI_WIDTH  = 1200
UI_HEIGHT = 820


-- Unified tablet screen geometry.
-- Header/nav shell and cached page helpers now use the same master dimensions.
local DG_MASTER_UI_WIDTH = 1200
local DG_MASTER_UI_HEIGHT = 820
local DG_MASTER_SIDE_INSET = 12
local DG_MASTER_CONTENT_WIDTH = DG_MASTER_UI_WIDTH - (DG_MASTER_SIDE_INSET * 2)

-- Position/rotation of UI relative to the physical object.
-- Common flat-card starting point:
UI_POSITION = "0 0 -22"
UI_ROTATION = "0 0 0"

-- Card face fit / resize behavior

-- Starting UI scale for the card face.
CARD_UI_SCALE_X = 0.186
CARD_UI_SCALE_Y = 0.390

-- Inset from the physical card edges.
-- Lower values leave more visible parchment border.
CARD_FILL_X = 0.96
CARD_FILL_Y = 0.96

-- Raise the UI just above the card surface so it does not z-fight.
UI_SURFACE_Z = -22

-- Landscape Custom Card: normal local X/Z axes.
RESIZE_WIDTH_AXIS  = "x"
RESIZE_HEIGHT_AXIS = "z"

-- Scale check cadence while the sheet is unlocked
SCALE_CHECK_FRAMES = 15

-----------------------------
--[[ CUSTOM CARD SETUP
Use ONE Custom Card object:
  1. Put your parchment/sheet artwork on the Custom Card face.
  2. Do NOT place the old parchment Custom Token on top of it.
  3. Put this Lua on that Custom Card.
The UI and artwork will then share the same physical object.
--]]

-- STATE
-----------------------------


-----------------------------
-- EXTERNAL TABLE COUNTERS
-----------------------------

-- Purple player resource counters.
-- This object uses the injected counter script you supplied.
RESOURCE_LIMITS = {
    hp = { min = 0, max = 999 },
    wp = { min = 0, max = 999 },
    san = { min = 0, max = 999 }
}
local physicalRoll = nil
local physicalRollMonitorRunning = false
local genericPhysicalRoll = nil
local genericPhysicalRollMonitorRunning = false



local state = {
    uiVisible = true,
    textLocked = false,
    ownerColor = nil,
    uiBaseColor = "Forest",
    uiAccentColor = "Green",
    baseObjectScale = nil,
    currentTab = "personnel",
    personnelSubtab = "profile",
    clearConfirm = false,
    uiWidthPercent = 100,
    uiHeightPercent = 100,
    cachedPageYOffset = -111,

    -- Manual UI fine-tuning. Top = permanent header/nav shell.
    -- Bottom = cached page helper. Values persist with the sheet.
    uiFineTune = {
        top = {
            x = 0, y = 2, z = 0,
            scaleX = 1.025, scaleY = 1.025
        },
        bottom = {
            x = 0, y = 2, z = 0,
            scaleX = 1.075, scaleY = 1.075
        }
    },
    pageHelperGuids = {},

    -- Automation controls
    multiQty1 = 1,
    multiDie1 = "d6",
    multiQty2 = 0,
    multiDie2 = "d4",
    multiQty3 = 0,
    multiDie3 = "d8",
    multiQty4 = 0,
    multiDie4 = "Hit Location",
    availableDice = nil,
    multiModifier = "0",
    sanLossFormula = "0/1d4",
    rollModifier = 0,
    incomingDamage = "0",
    incomingAP = "0",
    activeArmorIndex = 1,
    itemQuantities = {},
    ammoPools = {},
    addItemQuantity = 1,
    addItemBrowseLevel = "root",
    addItemCategory = "",
    addItemSubcategory = "",
    addItemName = "",
    addCaliberFilter = "ALL",
    addSelectedCaliber = "",
    addSelectedCapacity = "",
    addReserveRounds = 0,
    addReserveMags = 0,
    equipmentReplace = nil,

    -- Staged weapon attack -> damage/lethality flow.
    -- Kept in saved state so the UI can show the correct next action.
    pendingWeaponRoll = nil,

    handlerMode = false,
    skillsActiveOnly = false,
    skillEnabled = {},

    agent = {
        name = "AGENT TEST",
        profession = "Federal Agent",
        employer = "U.S. Government",
        nationality = "American",
        sex = "",
        age = "36",
        education = "Graduate Degree",

        distinguishing = {
            str = "", con = "", dex = "",
            int = "", pow = "", cha = ""
        },

        str = 12, con = 12, dex = 12,
        int = 14, pow = 13, cha = 11,

        hp = 12, hpMax = 12,
        wp = 13, wpMax = 13,
        san = 65, sanMax = 65,
        breakingPoint = 52,

        physicalDescription = "",
        motivation = "",
        wounds = "",
        portraitUrl = ""
    },

    skills = {
        ["Accounting"] = 10,
        ["Alertness"] = 50,
        ["Anthropology"] = 0,
        ["Archeology"] = 0,
        ["Art"] = 0,
        ["Athletics"] = 30,
        ["Bureaucracy"] = 50,
        ["Computer Science"] = 20,
        ["Criminology"] = 10,
        ["Disguise"] = 10,
        ["Dodge"] = 30,
        ["Drive"] = 20,
        ["Firearms"] = 40,
        ["First Aid"] = 10,
        ["Forensics"] = 0,
        ["Heavy Machinery"] = 10,
        ["Heavy Weapons"] = 0,
        ["History"] = 10,
        ["HUMINT"] = 40,
        ["Law"] = 30,
        ["Medicine"] = 0,
        ["Melee Weapons"] = 30,
        ["Military Science"] = 0,
        ["Navigate"] = 10,
        ["Occult"] = 10,
        ["Persuade"] = 20,
        ["Pharmacy"] = 0,
        ["Psychotherapy"] = 10,
        ["Ride"] = 10,
        ["Search"] = 20,
        ["SIGINT"] = 0,
        ["Stealth"] = 10,
        ["Surgery"] = 0,
        ["Survival"] = 10,
        ["Swim"] = 20,
        ["Unarmed Combat"] = 40,
        ["Unnatural"] = 0
    },

    equipment = {
        weapons = "SIG Sauer P320 | Firearms | 1D10 | Lethality --\nFolding Knife | Melee Weapons | 1D4",
        armor = "Concealable vest | Armor 3",
        gear = "Credentials\nPhone\nFlashlight\nEvidence bags",
        cash = "$400",
        notes = ""
    },

    psychology = {
        bonds = "Spouse — 10\nPartner — 8",
        disorders = "",
        adaptedViolence = false,
        adaptedHelplessness = false,
        violenceIncidents = 0,
        helplessnessIncidents = 0,
        violenceBoxes = {false,false,false},
        helplessnessBoxes = {false,false,false},
        sanSource = "Unnatural",
        pendingSanLoss = nil,
        pendingSanSource = nil,
        selectedBondIndex = 1,
        temporaryInsanityPending = false,
        motivationUsed = {},
        sessionSanLost = 0,
        sessionBreakingPoints = 0,
        sessionBondDamage = 0,
        motivations = "Protect innocent people.",
        notes = ""
    }
}


-- UI COLOR CONTROLS
-- Base controls the dark/background tones.
-- Accent controls buttons, borders, highlights, and green-tinted text.
local UI_BASE_COLOR_ORDER = {
    "Forest", "Black", "Charcoal", "Slate", "Navy",
    "Brown", "Burgundy", "Maroon", "Deep Red",
    "Purple", "Magenta", "Indigo", "Teal", "Emerald",
    "Midnight", "Mustard"
}

local UI_ACCENT_COLOR_ORDER = {
    "Green", "Emerald", "Olive", "Lime", "Bright Lime",
    "Teal", "Cyan", "Blue", "Indigo", "Purple",
    "Magenta", "Pink", "Red", "Maroon", "Orange",
    "Amber", "Yellow", "Gold", "Silver", "White"
}

local UI_BASE_COLORS = {
    ["Forest"]   = { dark="#09100C", dark2="#17201B" },
    ["Black"]    = { dark="#080808", dark2="#181818" },
    ["Charcoal"] = { dark="#111315", dark2="#24282B" },
    ["Slate"]    = { dark="#11171C", dark2="#26323A" },
    ["Navy"]     = { dark="#0C1320", dark2="#19283A" },
    ["Brown"]    = { dark="#17110D", dark2="#2B211A" },
    ["Burgundy"] = { dark="#190D11", dark2="#321B22" },
    ["Purple"]   = { dark="#130E19", dark2="#281D32" },
    ["Teal"]     = { dark="#091515", dark2="#183030" },
    ["Maroon"]   = { dark="#16090D", dark2="#32131D" },
    ["Deep Red"] = { dark="#180A0A", dark2="#351919" },
    ["Magenta"]  = { dark="#170A15", dark2="#35182F" },
    ["Indigo"]   = { dark="#0D0D19", dark2="#20213B" },
    ["Emerald"]  = { dark="#07130E", dark2="#123525" },
    ["Midnight"] = { dark="#070B13", dark2="#141C2C" },
    ["Mustard"]  = { dark="#171308", dark2="#332B13" }
}

local UI_ACCENT_COLORS = {
    ["Green"]  = { accent="#355845", accent2="#66836D", light="#D2E5D6", title="#A7C8B0" },
    ["Olive"]  = { accent="#565A32", accent2="#7D8250", light="#E1E3C8", title="#BEC28A" },
    ["Lime"]   = { accent="#4F6A2B", accent2="#79A043", light="#DDEBC8", title="#B1D37B" },
    ["Teal"]   = { accent="#2D625E", accent2="#4E8B86", light="#CBE5E2", title="#8FC5BF" },
    ["Cyan"]   = { accent="#2D5F70", accent2="#4D8799", light="#CCE5EC", title="#8FC1D0" },
    ["Blue"]   = { accent="#315F7A", accent2="#527C92", light="#C9DFEA", title="#8FB9CC" },
    ["Indigo"] = { accent="#414E7A", accent2="#63709B", light="#D1D6EB", title="#A0AAD2" },
    ["Purple"] = { accent="#563C6B", accent2="#73558B", light="#DDCFE8", title="#B69ACB" },
    ["Pink"]   = { accent="#70405B", accent2="#915C78", light="#E8D0DD", title="#C99AB4" },
    ["Red"]    = { accent="#6B3535", accent2="#875050", light="#E7CCCC", title="#C99393" },
    ["Orange"] = { accent="#76502D", accent2="#9A7147", light="#EAD9C7", title="#D0A373" },
    ["Amber"]  = { accent="#6A552B", accent2="#8A713D", light="#E8DDBF", title="#CDB276" },
    ["Gold"]   = { accent="#6C5A2A", accent2="#A08845", light="#EDE2BE", title="#D6BC6D" },
    ["Silver"]      = { accent="#4B555A", accent2="#7A878D", light="#DCE2E4", title="#B9C4C8" },
    ["Emerald"]     = { accent="#17603E", accent2="#2F9365", light="#C9EBDD", title="#70CDA5" },
    ["Bright Lime"] = { accent="#5C7D18", accent2="#8EBD2C", light="#E8F7C8", title="#BCE86B" },
    ["Magenta"]     = { accent="#7B286B", accent2="#A94994", light="#F0CFEA", title="#D77AC9" },
    ["Maroon"]      = { accent="#682737", accent2="#914052", light="#E8CDD4", title="#C77A8D" },
    ["Yellow"]      = { accent="#77651B", accent2="#B59B2B", light="#F3EABF", title="#E0C94F" },
    ["White"]       = { accent="#6E7370", accent2="#A7AEAA", light="#F3F5F4", title="#E2E7E4" }
}

local function applyUiTheme(xml)
    local baseName = tostring(state.uiBaseColor or "Forest")
    local accentName = tostring(state.uiAccentColor or "Green")

    local base = UI_BASE_COLORS[baseName] or UI_BASE_COLORS["Forest"]
    local accent = UI_ACCENT_COLORS[accentName] or UI_ACCENT_COLORS["Green"]

    local replacements = {
        -- deepest/background greens -> selected base
        {"#09100CCC", base.dark},
        {"#09100C",   base.dark},
        {"#101A14",   base.dark2},
        {"#0D1511EE", base.dark},
        {"#0D1511",   base.dark},
        {"#101712",   base.dark},
        {"#101813",   base.dark},
        {"#17201B",   base.dark2},
        {"#121A16",   base.dark},
        {"#111A15CC", base.dark},
        {"#111A15",   base.dark},
        {"#223229",   base.dark2},
        {"#26372D",   base.dark2},
        {"#293A30",   base.dark2},
        {"#293A31",   base.dark2},
        {"#293B31",   base.dark2},
        {"#33443A",   base.dark2},
        {"#26352C",   base.dark2},
        {"#1D2B24",   base.dark2},
        {"#1B2922",   base.dark2},
        {"#15201A",   base.dark},
        {"#121B16",   base.dark},

        -- green controls/highlights -> selected accent
        {"#284C39",   accent.accent},
        {"#294034",   accent.accent},
        {"#355845",   accent.accent},
        {"#355244",   accent.accent},
        {"#365C49",   accent.accent},
        {"#426A52",   accent.accent},
        {"#32483B",   accent.accent},
        {"#4F6D58",   accent.accent2},
        {"#55705D",   accent.accent2},
        {"#66836D",   accent.accent2},
        {"#78937E",   accent.accent2},
        {"#829287",   accent.accent2},
        {"#86A88F",   accent.accent2},
        {"#8FC79D",   accent.title},

        -- green-tinted labels
        {"#A7C8B0",   accent.title},
        {"#D2E5D6",   accent.light},
        {"#E3EEE6",   accent.light},
        {"#BFD2C4",   accent.light},
        {"#BBC8BE",   accent.light},
        {"#C6D6CA",   accent.light},
        {"#A9B8AD",   accent.light},
        {"#667D6D",   accent.accent2},
        -- remaining legacy green / gray-green UI colors
        {"#0D151100", base.dark .. "00"},
        {"#375B47",   accent.accent},
        {"#1C2922",   base.dark2},
        {"#28332D",   base.dark2},
        {"#708078",   accent.accent2},
        {"#DDE7DF",   accent.light},
        {"#68736B",   accent.accent2},
        {"#6D756F",   accent.accent2},
        {"#202521",   base.dark2},
        {"#252B27",   base.dark2},
        {"#646C66",   accent.accent2},
        {"#24342B",   base.dark2},
        {"#D7E8DB",   accent.light},
        {"#111A15F2", base.dark .. "F2"},
        {"#D7E7DA",   accent.light},
        {"#3B644D",   accent.accent},
        {"#A7B7AB",   accent.light},
        {"#111A15AA", base.dark .. "AA"},
        {"#35463B",   accent.accent},
        {"#9DB0A2",   accent.light},
        {"#33493C",   accent.accent},
        {"#D3DED6",   accent.light},
        {"#87A990",   accent.title},
        {"#355943",   accent.accent},
        {"#D5E1D8",   accent.light},
        {"#95A59A",   accent.light},
        {"#CDD8D0",   accent.light},
        {"#B7D0BC",   accent.title},
        {"#E7EEE9",   accent.light},
        {"#C5D2C8",   accent.light},
        {"#86B092",   accent.title},
        {"#9EB1A3",   accent.light},
        {"#343E38",   base.dark2},
    }

    for _, pair in ipairs(replacements) do
        xml = xml:gsub(pair[1], pair[2])
    end

    -- TTS Button defaults use ColorTint, which visibly dims/tints controls when
    -- hovered or pressed. Keep the sheet's chosen theme colors and white labels
    -- stable instead of changing appearance after a click.
    xml = xml:gsub("<Button ", '<Button transition="None" ')

    return xml
end

local originalObjectScale = nil
local lastScale = nil
local frameCounter = 0
local uiReady = false

-----------------------------
-- HELPERS
-----------------------------

local function clamp(n, lo, hi)
    n = tonumber(n) or 0
    if n < lo then return lo end
    if n > hi then return hi end
    return n
end


local function clampResourceValue(resourceKey, value)
    local n = math.floor(tonumber(value) or 0)

    if n < 0 then
        n = 0
    end

    local maxKeyMap = {
        hp = "hpMax",
        wp = "wpMax",
        san = "sanMax"
    }

    local maxKey = maxKeyMap[resourceKey]

    if maxKey and state and state.agent then
        local sheetMax = math.floor(tonumber(state.agent[maxKey]) or 0)

        if sheetMax < 0 then
            sheetMax = 0
        end

        if sheetMax > 999 then
            sheetMax = 999
        end

        if n > sheetMax then
            n = sheetMax
        end

        return n
    end

    if n > 999 then
        n = 999
    end

    return n
end


local function clampBaseStat(value)
    local n = math.floor(tonumber(value) or 3)
    if n < 3 then n = 3 end
    if n > 18 then n = 18 end
    return n
end

local function deriveHPMax()
    return math.ceil(
        (clampBaseStat(state.agent.str) + clampBaseStat(state.agent.con)) / 2
    )
end

local function deriveWPMax()
    return clampBaseStat(state.agent.pow)
end


-- Forward declarations for helpers referenced before their definitions.
local rebuildUI
local queueDashboardSnapshot
local pushAgentNameToDisplay
local status
local plainPosition
local appendRollToDmLog
local dgComputeTransform
local buildXml
local markAllCachedPagesDirty
local rebuildCachedPagesSequentially
local dgSyncActiveCachedHelperTransform
local dgLastFollowPosition
local dgLastFollowRotation
local rebuildCachedPage
local handleSanChange
local currentMarkedSkillsForDashboard
local startDiceExpressionRoll
local function deriveStartingSAN()
    local pow = clampBaseStat(state.agent.pow)
    return pow * 5
end

local function deriveInitialBreakingPoint()
    local startingSAN = deriveStartingSAN()
    local pow = clampBaseStat(state.agent.pow)

    return math.max(0, startingSAN - pow)
end

local function initializeStartingSanityAndBreakingPoint()
    state.agent.san = deriveStartingSAN()

    -- Keep SAN Max at least as high as starting SAN.
    -- If a save already has a higher SAN max because of later campaign logic,
    -- do not lower it here.
    local currentSanMax = math.floor(tonumber(state.agent.sanMax) or 0)
    if currentSanMax < state.agent.san then
        state.agent.sanMax = state.agent.san
    else
        state.agent.sanMax = currentSanMax
    end

    state.agent.breakingPoint = deriveInitialBreakingPoint()


    if uiReady then
        dgUISetValue("san", tostring(state.agent.san))
        dgUISetValue("sanMax", tostring(state.agent.sanMax))
        dgUISetValue("breakingPointDisplay", tostring(state.agent.breakingPoint))
    end
end


-------------------------------------------------
-- CACHED PAGE HELPER ARCHITECTURE
-------------------------------------------------

local PAGE_HELPER_TABS = {
    "personnel",
    "skills",
    "skills_active",
    "equipment",
    "psychology",
    "disorders",
    "import"
}

local pageHelpers = {}
local pageHelpersReady = {}
local pageHelpersBuilding = false
local pageCacheInitialized = false
local pageCacheBuildIndex = 0
local cachedPageDirty = {}

local PAGE_HELPER_OFFSETS = {
    personnel     = 0,
    skills        = 1,
    skills_active = 2,
    equipment     = 3,
    psychology    = 4,
    disorders     = 5,
    import        = 6
}

-- ScriptingTrigger-attached UI is horizontally compressed relative to the
-- Custom Card's attached UI even when both objects share the same transform.
-- Compensate only X; the screenshot shows Y already matches the sheet height.
local PAGE_HELPER_UI_X_COMPENSATION = 2.449
local function inactiveHelperPosition(tabName)
    local n = PAGE_HELPER_OFFSETS[tabName] or 0

    return {
        x = 1000 + (n * 8),
        y = -50,
        z = 1000
    }
end

local function helperOwnershipMarker(tabName)
    return "DG_OWNER_SHEET_GUID=" .. tostring(self.getGUID()) ..
        "\nDG_CACHE_TAB=" .. tostring(tabName or "")
end

local function helperBelongsToThisSheet(obj, tabName)
    if not obj then return false end

    local description = ""
    local ok, value = pcall(function()
        return obj.getDescription()
    end)

    if ok then
        description = tostring(value or "")
    end

    local ownerToken = "DG_OWNER_SHEET_GUID=" .. tostring(self.getGUID())
    local tabToken = "DG_CACHE_TAB=" .. tostring(tabName or "")

    return description:find(ownerToken, 1, true) ~= nil and
        description:find(tabToken, 1, true) ~= nil
end

local function getCachedHelper(tabName)
    state.pageHelperGuids = state.pageHelperGuids or {}

    -- Once a helper has been validated/recovered or spawned by this sheet,
    -- trust the in-memory reference. Re-reading its description on every UI
    -- access is unnecessary overhead.
    local cached = pageHelpers[tabName]
    if cached then
        return cached
    end

    local guid = tostring(state.pageHelperGuids[tabName] or "")
    if guid ~= "" then
        local obj = getObjectFromGUID(guid)

        if obj and helperBelongsToThisSheet(obj, tabName) then
            pageHelpers[tabName] = obj
            pageHelpersReady[tabName] = true
            return obj
        end

        -- Cloned sheets can inherit the source sheet's helper GUIDs.
        -- Forget foreign/stale GUIDs and allow this sheet to spawn its own.
        state.pageHelperGuids[tabName] = nil
    end

    return nil
end

local function forEachCachedUi(fn)
    pcall(function()
        fn(self.UI)
    end)

    for _, tabName in ipairs(PAGE_HELPER_TABS) do
        local helper = getCachedHelper(tabName)

        if helper then
            pcall(function()
                fn(helper.UI)
            end)
        end
    end
end

function dgUISetValue(id, value)
    forEachCachedUi(function(ui)
        ui.setValue(id, value)
    end)
end

function dgUISetAttribute(id, attribute, value)
    forEachCachedUi(function(ui)
        ui.setAttribute(id, attribute, value)
    end)
end

function dgUISetAttributes(id, attributes)
    forEachCachedUi(function(ui)
        ui.setAttributes(id, attributes)
    end)
end

function dgUISetCustomAssets(assets)
    forEachCachedUi(function(ui)
        ui.setCustomAssets(assets)
    end)
end

function dgUIShow(id)
    forEachCachedUi(function(ui)
        ui.show(id)
    end)
end

function dgUIHide(id)
    forEachCachedUi(function(ui)
        ui.hide(id)
    end)
end

local function retargetHelperCallbacks(xml)
    local guid = self.getGUID()

    local function qualifyAttribute(source, attributeName)
        local pattern = attributeName .. '="([^"]+)"'

        return source:gsub(pattern, function(callbackName)
            callbackName = tostring(callbackName or "")

            if callbackName == "" or callbackName:find("/", 1, true) then
                return attributeName .. '="' .. callbackName .. '"'
            end

            return attributeName .. '="' .. guid .. "/" .. callbackName .. '"'
        end)
    end

    xml = qualifyAttribute(xml, "onClick")
    xml = qualifyAttribute(xml, "onEndEdit")
    xml = qualifyAttribute(xml, "onValueChanged")

    return xml
end

local function placeHelper(tabName, active)
    local helper = getCachedHelper(tabName)
    if not helper then return end

    if active then
        local p = self.getPosition()
        local r = self.getRotation()
        local s = self.getScale()

        pcall(function()
            helper.setPosition({x=p.x, y=p.y, z=p.z})
            helper.setRotation({x=r.x, y=r.y, z=r.z})
            helper.setScale({x=s.x, y=s.y, z=s.z})
            helper.setLock(true)
        end)
    else
        local s = self.getScale()

        pcall(function()
            helper.setPosition(inactiveHelperPosition(tabName))
            helper.setRotation({0,0,0})
            helper.setScale({x=s.x, y=s.y, z=s.z})
            helper.setLock(true)
        end)
    end
end

local function activateCachedPage(tabName)
    local target = tostring(tabName or "personnel")

    for _, name in ipairs(PAGE_HELPER_TABS) do
        placeHelper(name, name == target)
    end

    dgLastFollowPosition = nil
    dgLastFollowRotation = nil
end

local function spawnPageHelper(tabName, callback)
    local existing = getCachedHelper(tabName)

    if existing then
        if callback then callback(existing) end
        return
    end

    local cardScale = self.getScale()

    spawnObject({
        type = "ScriptingTrigger",
        position = inactiveHelperPosition(tabName),
        rotation = {0,0,0},
        scale = {x=cardScale.x, y=cardScale.y, z=cardScale.z},
        sound = false,
        callback_function = function(obj)
            state.pageHelperGuids = state.pageHelperGuids or {}
            state.pageHelperGuids[tabName] = obj.getGUID()

            pageHelpers[tabName] = obj
            pageHelpersReady[tabName] = false

            pcall(function()
                obj.setName("DG PURPLE CACHE - " .. string.upper(tabName))
                obj.setDescription(
                    "Cached UI page helper for this Delta Green Agent sheet.\n" ..
                    helperOwnershipMarker(tabName)
                )
                obj.setLock(true)
                obj.tooltip = false
            end)

            if callback then callback(obj) end
        end
    })
end




local function esc(s)
    s = tostring(s or "")
    s = s:gsub("&", "&amp;")
    s = s:gsub("<", "&lt;")
    s = s:gsub(">", "&gt;")
    s = s:gsub('"', "&quot;")
    s = s:gsub("'", "&apos;")
    return s
end

local function boolText(v)
    return v and "YES" or "NO"
end

local function getComponent(v, key)
    if key == "x" then return v.x end
    if key == "y" then return v.y end
    return v.z
end

local function scaleChanged(a, b)
    if not a or not b then return true end
    return math.abs(a.x-b.x) > 0.001 or math.abs(a.y-b.y) > 0.001 or math.abs(a.z-b.z) > 0.001
end

local function input(id, value, width, label)
    local w = width or 180
    return string.format([[
      <Panel preferredWidth="%d" preferredHeight="80">

        <Text
            text="%s"
            rectAlignment="UpperLeft"
            width="%d"
            height="25"
            offsetXY="0 -2"
            fontSize="17"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"
            verticalOverflow="Overflow"/>

        <InputField
            id="%s"
            text="%s"
            onEndEdit="editField"
            rectAlignment="UpperLeft"
            width="%d"
            height="44"
            offsetXY="0 -31"
            fontSize="20"
            textColor="#F1F7F2"
            color="#17201B"
            selectionColor="#355845"/>

      </Panel>
    ]], w, esc(label or ""), w, esc(id), esc(value), w)
end

local function statBox(id, label, value)
    return string.format([[
      <Panel preferredWidth="110" preferredHeight="116">

        <Text
            text="%s"
            rectAlignment="UpperCenter"
            width="110"
            height="24"
            offsetXY="0 -2"
            fontSize="17"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleCenter"
            verticalOverflow="Overflow"/>

        <InputField
            id="%s"
            text="%s"
            onEndEdit="editField"
            characterValidation="Integer"
            rectAlignment="UpperCenter"
            width="96"
            height="42"
            offsetXY="0 -29"
            fontSize="22"
            textColor="#FFFFFF"
            color="#121A16"/>

        <Button
            id="stat_%s_roll"
            onClick="rollStat"
            text="ROLL"
            rectAlignment="UpperCenter"
            width="96"
            height="32"
            offsetXY="0 -76"
            fontSize="14"
            color="#284C39"
            textColor="#FFFFFF"/>

      </Panel>
    ]], esc(label), esc(id), esc(value), esc(id))
end

local function resourceBox(prefix, label, cur, maxv, derivedMax)
    local maxControl

    if derivedMax then
        maxControl = string.format([[
        <Text
            id="%sMaxDisplay"
            text="%s"
            rectAlignment="UpperLeft"
            width="48"
            height="42"
            offsetXY="115 -48"
            fontSize="20"
            fontStyle="Bold"
            color="#FFFFFF"
            alignment="MiddleCenter"/>
        ]], prefix, tostring(maxv))
    else
        maxControl = string.format([[
        <InputField
            id="%sMax"
            text="%s"
            onEndEdit="editField"
            characterValidation="Integer"
            rectAlignment="UpperLeft"
            width="48"
            height="42"
            offsetXY="115 -48"
            fontSize="20"
            textColor="#FFFFFF"
            color="#121A16"/>
        ]], prefix, tostring(maxv))
    end

    return string.format([[
      <Panel preferredWidth="215" preferredHeight="108">

        <Text
            text="%s"
            rectAlignment="UpperCenter"
            width="215"
            height="25"
            offsetXY="0 -18"
            fontSize="17"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleCenter"
            verticalOverflow="Overflow"/>

        <Button
            id="%s_minus"
            onClick="resourceAdjust"
            text="−"
            rectAlignment="UpperLeft"
            width="38"
            height="42"
            offsetXY="0 -48"
            fontSize="22"
            color="#26372D"
            textColor="#FFFFFF"/>

        <InputField
            id="%s"
            text="%s"
            onEndEdit="editField"
            characterValidation="Integer"
            rectAlignment="UpperLeft"
            width="48"
            height="42"
            offsetXY="42 -48"
            fontSize="20"
            textColor="#FFFFFF"
            color="#121A16"/>

        <Text
            text="/"
            rectAlignment="UpperLeft"
            width="17"
            height="42"
            offsetXY="94 -48"
            fontSize="18"
            color="#D2E5D6"
            alignment="MiddleCenter"/>

        %s

        <Button
            id="%s_plus"
            onClick="resourceAdjust"
            text="+"
            rectAlignment="UpperLeft"
            width="38"
            height="42"
            offsetXY="167 -48"
            fontSize="22"
            color="#26372D"
            textColor="#FFFFFF"/>

      </Panel>
    ]],
        esc(label),
        prefix,
        prefix, tostring(cur),
        maxControl,
        prefix
    )
end


local function breakingPointBox(value)
    return string.format([[
      <Panel preferredWidth="215" preferredHeight="108">

        <Text
            text="BREAKING POINT"
            rectAlignment="UpperCenter"
            width="215"
            height="25"
            offsetXY="0 -18"
            fontSize="17"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleCenter"
            verticalOverflow="Overflow"/>

        <Text
            id="breakingPointDisplay"
            text="%s"
            rectAlignment="UpperCenter"
            width="100"
            height="42"
            offsetXY="0 -48"
            fontSize="24"
            fontStyle="Bold"
            color="#FFFFFF"
            alignment="MiddleCenter"/>

      </Panel>
    ]], tostring(value))
end

local function navButton(id, label, active, x, y)
    local c = active and "#375B47" or "#1C2922"

    return string.format([[
      <Button id="tab_%s"
          onClick="switchTab"
          text="%s"
          rectAlignment="UpperLeft"
          width="235"
          height="38"
          offsetXY="%d %d"
          fontSize="17"
          color="%s"
          textColor="#FFFFFF"/>
    ]],
        tostring(id),
        esc(label),
        tonumber(x) or 0,
        tonumber(y) or -4,
        c
    )
end

local function multiline(id, label, value, height)
    local h = height or 150
    return string.format([[
      <Panel flexibleWidth="1" preferredHeight="%d">

        <Text
            text="%s"
            rectAlignment="UpperLeft"
            width="100%%"
            height="27"
            offsetXY="0 -2"
            fontSize="18"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"
            verticalOverflow="Overflow"/>

        <InputField
            id="%s"
            text="%s"
            onEndEdit="editField"
            lineType="MultiLineNewline"
            rectAlignment="UpperLeft"
            width="100%%"
            height="%d"
            offsetXY="0 -33"
            fontSize="19"
            textColor="#F1F7F2"
            color="#111A15"
            selectionColor="#355845"/>

      </Panel>
    ]], h + 36, esc(label), esc(id), esc(value), h)
end


local function multilineAt(id, label, value, width, inputHeight, x, y)
    local totalHeight = inputHeight + 36
    return string.format([[
      <Panel rectAlignment="UpperLeft"
          width="%d" height="%d"
          offsetXY="%d %d">

        <Text text="%s"
            rectAlignment="UpperLeft"
            width="%d" height="28"
            offsetXY="0 -2"
            fontSize="18"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"/>

        <InputField id="%s"
            text="%s"
            onEndEdit="editField"
            lineType="MultiLineNewline"
            rectAlignment="UpperLeft"
            width="%d" height="%d"
            offsetXY="0 -34"
            fontSize="19"
            textColor="#F1F7F2"
            color="#111A15"
            selectionColor="#355845"/>

      </Panel>
    ]], width, totalHeight, x, y,
        esc(label), width,
        esc(id), esc(value), width, inputHeight)
end

local function inputAt(id, label, value, width, x, y)
    return string.format([[
      <Panel rectAlignment="UpperLeft"
          width="%d" height="80"
          offsetXY="%d %d">

        <Text text="%s"
            rectAlignment="UpperLeft"
            width="%d" height="26"
            offsetXY="0 -2"
            fontSize="17"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"/>

        <InputField id="%s"
            text="%s"
            onEndEdit="editField"
            rectAlignment="UpperLeft"
            width="%d" height="44"
            offsetXY="0 -32"
            fontSize="20"
            textColor="#F1F7F2"
            color="#17201B"
            selectionColor="#355845"/>

      </Panel>
    ]], width, x, y, esc(label), width, esc(id), esc(value), width)
end

local function skillId(name)
    return "skill_" .. name:gsub("[^%w]", "_")
end

local function skillRowAt(name, value, x, y)
    local id = skillId(name)
    local enabled = state.skillEnabled[name] ~= false
    local marked = state.skillImprovementMarked and state.skillImprovementMarked[name] == true
    local canImprove = enabled and name ~= "Unnatural"

    local improveText = marked and "★" or "·"
    local improveColor = marked and "#B66D2E" or "#28332D"
    local improveTextColor = marked and "#FFFFFF" or "#708078"
    local labelColor = enabled and "#DDE7DF" or "#7C8A80"
    local inputTextColor = enabled and "#F1F7F2" or "#78827B"
    local inputColor = enabled and "#17201B" or "#202521"
    local rollColor = enabled and "#284C39" or "#252B27"
    local rollTextColor = enabled and "#FFFFFF" or "#646C66"
    local displayValue = tostring(math.floor(tonumber(value) or 0))

    -- Active skills are permanent during play. Only an inactive/unlearned
    -- skill gets an ADD control, and that control only appears in the
    -- "show inactive" version of the Skills page.
    local activationControl = ""
    local rowLeft = 10

    if not enabled and state.skillsActiveOnly == false then
        activationControl = string.format([[
        <Button id="%s_toggle"
            onClick="toggleSkillEnabled"
            text="✓"
            rectAlignment="UpperLeft"
            width="44" height="40"
            offsetXY="0 -1"
            fontSize="25"
            fontStyle="Bold"
            color="#355845"
            textColor="#FFFFFF"/>
        ]], esc(id))
        rowLeft = 56
    end

    return string.format([[
      <Panel id="%s_row" rectAlignment="UpperLeft" width="520" height="46" offsetXY="%d %d">

        %s

        <Button id="%s_improve"
            onClick="toggleSkillImprovementMark"
            text="%s"
            interactable="%s"
            rectAlignment="UpperLeft"
            width="34" height="40"
            offsetXY="%d -1"
            fontSize="19"
            fontStyle="Bold"
            color="%s"
            textColor="%s"/>

        <Text id="%s_label" text="%s"
            rectAlignment="UpperLeft"
            width="208" height="42"
            offsetXY="%d 0"
            fontSize="16"
            color="%s"
            alignment="MiddleLeft"/>

        <InputField id="%s"
            text="%s"
            onValueChanged="editSkillLive"
            onEndEdit="editSkill"
            lineType="SingleLine"
            characterValidation="Integer"
            interactable="%s"
            readOnly="%s"
            rectAlignment="UpperLeft"
            width="68" height="40"
            offsetXY="%d 1"
            fontSize="18"
            textColor="%s"
            color="%s"
            caretColor="#FFFFFF"
            selectionColor="#355845"/>

        <Text id="%s_pct" text="%%"
            rectAlignment="UpperLeft"
            width="28" height="40"
            offsetXY="%d 1"
            fontSize="16"
            color="%s"
            alignment="MiddleCenter"/>

        <Button id="%s_roll"
            onClick="rollSkill"
            text="ROLL"
            interactable="%s"
            rectAlignment="UpperLeft"
            width="100" height="38"
            offsetXY="%d 0"
            fontSize="15"
            color="%s"
            textColor="%s"/>

      </Panel>]],
      esc(id), x, y,
      activationControl,
      esc(id), improveText,
      canImprove and "true" or "false",
      rowLeft,
      improveColor, improveTextColor,
      esc(id), esc(name),
      rowLeft + 40,
      labelColor,
      esc(id), esc(displayValue),
      enabled and "true" or "false",
      enabled and "false" or "true",
      rowLeft + 250,
      inputTextColor, inputColor,
      esc(id),
      rowLeft + 322,
      labelColor,
      esc(id),
      enabled and "true" or "false",
      rowLeft + 360,
      rollColor, rollTextColor)
end

local function personnelTabButton(id, label, active, x)
    return string.format([[
      <Button id="personnel_tab_%s"
          onClick="switchPersonnelSubtab"
          text="%s"
          rectAlignment="UpperLeft"
          width="220" height="44"
          offsetXY="%d 0"
          fontSize="17"
          color="%s"
          textColor="#FFFFFF"/>
    ]],
        id,
        esc(label),
        x,
        active and "#426A52" or "#223229"
    )
end

local function buildPersonnelProfile()
    local a = state.agent
    local d = a.distinguishing or {}

    return string.format([[
    <VerticalScrollView id="scroll_personnel_profile"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_personnel_profile"
          width="1160" height="900"
          rectAlignment="UpperCenter">

        %s
        %s
        %s
        %s

        <HorizontalLayout
            rectAlignment="UpperLeft"
            width="1120" height="96"
            offsetXY="20 -74"
            spacing="10"
            childForceExpandWidth="false"
            childForceExpandHeight="false"
            childControlWidth="true"
            childControlHeight="true">
          %s
          %s
          %s
          %s
          %s
          %s
          %s
        </HorizontalLayout>

        <Text text="DISTINGUISHING FEATURES BY STAT"
            rectAlignment="UpperLeft"
            width="500" height="34"
            offsetXY="30 -190"
            fontSize="20"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"/>

        %s
        %s
        %s
        %s
        %s
        %s

        <Text text="These fields are preserved by the DELTA-GREEN-STATS / DD Form 315 import."
            rectAlignment="UpperLeft"
            width="1030" height="40"
            offsetXY="30 -600"
            fontSize="14"
            color="#A9B8AD"
            alignment="MiddleLeft"/>

      </Panel>
    </VerticalScrollView>
    ]],
        personnelTabButton("profile","PROFILE",true,35),
        personnelTabButton("stats","STATS",false,255),
        personnelTabButton("portrait","PORTRAIT",false,475),
        personnelTabButton("notes","NOTES",false,695),

        input("name", a.name, 205, "AGENT / NAME"),
        input("profession", a.profession, 160, "PROFESSION"),
        input("employer", a.employer, 180, "EMPLOYER"),
        input("nationality", a.nationality, 130, "NATIONALITY"),
        input("sex", a.sex or "", 95, "SEX"),
        input("age", a.age, 60, "AGE"),
        input("education", a.education, 210, "EDUCATION"),

        inputAt("dist_str","STR — DISTINGUISHING FEATURE",d.str or "",510,30,-245),
        inputAt("dist_con","CON — DISTINGUISHING FEATURE",d.con or "",510,590,-245),
        inputAt("dist_dex","DEX — DISTINGUISHING FEATURE",d.dex or "",510,30,-355),
        inputAt("dist_int","INT — DISTINGUISHING FEATURE",d.int or "",510,590,-355),
        inputAt("dist_pow","POW — DISTINGUISHING FEATURE",d.pow or "",510,30,-465),
        inputAt("dist_cha","CHA — DISTINGUISHING FEATURE",d.cha or "",510,590,-465)
    )
end

local function buildPersonnelStats()
    local a = state.agent

    return string.format([[
    <VerticalScrollView id="scroll_personnel_stats"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_personnel_stats"
          width="1160" height="760"
          rectAlignment="UpperCenter">

        %s
        %s
        %s
        %s

        <Text text="STATISTICS"
            rectAlignment="UpperLeft"
            width="300" height="38"
            offsetXY="30 -82"
            fontSize="22"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"/>

        <HorizontalLayout
            rectAlignment="UpperLeft"
            width="1120" height="132"
            offsetXY="20 -130"
            spacing="12"
            childForceExpandWidth="false"
            childForceExpandHeight="false"
            childControlWidth="true"
            childControlHeight="true">
          %s
          %s
          %s
          %s
          %s
          %s
        </HorizontalLayout>

        <Text text="DERIVED VALUES"
            rectAlignment="UpperLeft"
            width="300" height="38"
            offsetXY="30 -286"
            fontSize="22"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"/>

        <HorizontalLayout
            rectAlignment="UpperLeft"
            width="1120" height="112"
            offsetXY="20 -334"
            spacing="18"
            childForceExpandWidth="false"
            childForceExpandHeight="false"
            childControlWidth="true"
            childControlHeight="true">
          %s
          %s
          %s
          %s
        </HorizontalLayout>

        <Text text="STR/CON determine HP Max; POW determines WP Max. Breaking Point is managed automatically from SAN and POW."
            rectAlignment="UpperLeft"
            width="1080" height="54"
            offsetXY="30 -480"
            fontSize="14"
            color="#A9B8AD"
            alignment="MiddleLeft"
            horizontalOverflow="Wrap"/>

      </Panel>
    </VerticalScrollView>
    ]],
        personnelTabButton("profile","PROFILE",false,35),
        personnelTabButton("stats","STATS",true,255),
        personnelTabButton("portrait","PORTRAIT",false,475),
        personnelTabButton("notes","NOTES",false,695),

        statBox("str","STR",a.str),
        statBox("con","CON",a.con),
        statBox("dex","DEX",a.dex),
        statBox("int","INT",a.int),
        statBox("pow","POW",a.pow),
        statBox("cha","CHA",a.cha),

        resourceBox("hp","HIT POINTS",a.hp,a.hpMax,true),
        resourceBox("wp","WILLPOWER",a.wp,a.wpMax,true),
        resourceBox("san","SANITY",a.san,a.sanMax,false),
        breakingPointBox(a.breakingPoint)
    )
end

local function buildPersonnelPortrait()
    local a = state.agent
    local portraitUrl = tostring(a.portraitUrl or "")
    local portraitContent

    if portraitUrl ~= "" then
        portraitContent = string.format([[
          <Image image="%s"
              rectAlignment="UpperCenter"
              width="430" height="500"
              offsetXY="0 -26"
              preserveAspect="true"/>
        ]], esc(portraitUrl))
    else
        portraitContent = [[
          <Panel rectAlignment="UpperCenter"
              width="430" height="500"
              offsetXY="0 -26"
              color="#111A15CC">

            <Text text="NO PORTRAIT SET"
                rectAlignment="MiddleCenter"
                width="390" height="50"
                fontSize="24"
                fontStyle="Bold"
                color="#829287"
                alignment="MiddleCenter"/>

            <Text text="Paste a direct HTTPS image URL below."
                rectAlignment="MiddleCenter"
                width="390" height="42"
                offsetXY="0 -54"
                fontSize="14"
                color="#A9B8AD"
                alignment="MiddleCenter"/>
          </Panel>
        ]]
    end

    return string.format([[
    <VerticalScrollView id="scroll_personnel_portrait"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_personnel_portrait"
          width="1160" height="760"
          rectAlignment="UpperCenter">

        %s
        %s
        %s
        %s

        <Panel rectAlignment="UpperLeft"
            width="520" height="565"
            offsetXY="70 -76"
            color="#101712">
          %s
        </Panel>

        <Panel rectAlignment="UpperLeft"
            width="500" height="565"
            offsetXY="620 -76"
            color="#111A15CC">

          <Text text="CHARACTER PORTRAIT"
              rectAlignment="UpperLeft"
              width="455" height="36"
              offsetXY="22 -22"
              fontSize="21"
              fontStyle="Bold"
              color="#D2E5D6"
              alignment="MiddleLeft"/>

          <Text text="Use a direct HTTPS image URL (PNG, JPG, or JPEG). The link must open the image itself, not a webpage."
              rectAlignment="UpperLeft"
              width="455" height="62"
              offsetXY="22 -66"
              fontSize="14"
              color="#A9B8AD"
              alignment="UpperLeft"
              horizontalOverflow="Wrap"/>

          <Text text="IMAGE URL"
              rectAlignment="UpperLeft"
              width="455" height="26"
              offsetXY="22 -148"
              fontSize="15"
              fontStyle="Bold"
              color="#D2E5D6"
              alignment="MiddleLeft"/>

          <InputField id="portraitUrl"
              text="%s"
              onEndEdit="editField"
              rectAlignment="UpperLeft"
              width="455" height="92"
              offsetXY="22 -180"
              fontSize="14"
              textColor="#F1F7F2"
              color="#17201B"
              lineType="MultiLineNewLine"
              horizontalOverflow="Wrap"/>

          <Button id="clear_portrait"
              onClick="clearPortrait"
              text="CLEAR PORTRAIT"
              rectAlignment="UpperLeft"
              width="210" height="42"
              offsetXY="22 -300"
              fontSize="14"
              color="#33443A"
              textColor="#FFFFFF"/>

        </Panel>

      </Panel>
    </VerticalScrollView>
    ]],
        personnelTabButton("profile","PROFILE",false,35),
        personnelTabButton("stats","STATS",false,255),
        personnelTabButton("portrait","PORTRAIT",true,475),
        personnelTabButton("notes","NOTES",false,695),
        portraitContent,
        esc(portraitUrl)
    )
end

local function buildPersonnelNotes()
    local a = state.agent

    return string.format([[
    <VerticalScrollView id="scroll_personnel_notes"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_personnel_notes"
          width="1160" height="850"
          rectAlignment="UpperCenter">

        %s
        %s
        %s
        %s

        %s
        %s
        %s

      </Panel>
    </VerticalScrollView>
    ]],
        personnelTabButton("profile","PROFILE",false,35),
        personnelTabButton("stats","STATS",false,255),
        personnelTabButton("portrait","PORTRAIT",false,475),
        personnelTabButton("notes","NOTES",true,695),

        multilineAt("physicalDescription","PHYSICAL DESCRIPTION",a.physicalDescription,540,220,30,-76),
        multilineAt("motivation","PERSONAL DETAILS",a.motivation,540,220,590,-76),
        multilineAt("wounds","WOUNDS / INJURIES / CONDITIONS",a.wounds,1100,330,30,-344)
    )
end


local function buildPersonnel()
    local tab = state.personnelSubtab or "profile"

    if tab == "stats" then
        return buildPersonnelStats()
    elseif tab == "portrait" then
        return buildPersonnelPortrait()
    elseif tab == "notes" then
        return buildPersonnelNotes()
    end

    return buildPersonnelProfile()
end


local ensureStructuredImportState

local function markedSkillNames()
    ensureStructuredImportState()

    local names = {}

    for name, marked in pairs(state.skillImprovementMarked or {}) do
        if marked == true and name ~= "Unnatural" then
            table.insert(names, name)
        end
    end

    table.sort(names)
    return names
end

local function buildHomeTimePanel()
    local marked = markedSkillNames()
    local lines = {}

    for _, name in ipairs(marked) do
        table.insert(lines, string.format("%s  %d%%", name, tonumber(state.skills[name]) or 0))
    end

    local summary = #lines > 0 and table.concat(lines, "\n") or "No skills are marked for improvement."
    local panelHeight = math.max(250, 150 + (#marked * 26))

    return string.format([[
      <Panel id="home_time_panel"
          rectAlignment="UpperLeft"
          width="1060" height="%d"
          offsetXY="48 -82"
          color="#111A15F2">

        <Text text="END SESSION — FAILED SKILL IMPROVEMENT"
            rectAlignment="UpperLeft"
            width="650" height="34"
            offsetXY="22 -16"
            fontSize="20"
            fontStyle="Bold"
            color="#D7E7DA"
            alignment="MiddleLeft"/>

        <Text text="Failed skill rolls are marked automatically. At session end, every marked skill gains 1D4%% (maximum 99%%), then its mark is cleared."
            rectAlignment="UpperLeft"
            width="1000" height="54"
            offsetXY="22 -50"
            fontSize="14"
            color="#A9B8AD"
            alignment="UpperLeft"
            horizontalOverflow="Wrap"/>

        <Text text="%s"
            rectAlignment="UpperLeft"
            width="650" height="%d"
            offsetXY="22 -110"
            fontSize="15"
            color="#E4EFE7"
            alignment="UpperLeft"
            horizontalOverflow="Wrap"
            verticalOverflow="Overflow"/>

        <Button id="home_time_apply"
            onClick="applyMarkedSkillImprovements"
            text="IMPROVE ALL MARKED SKILLS"
            interactable="%s"
            rectAlignment="UpperRight"
            width="330" height="48"
            offsetXY="-24 -112"
            fontSize="16"
            fontStyle="Bold"
            color="#426A52"
            textColor="#FFFFFF"/>

        <Button id="home_time_close"
            onClick="toggleHomeTime"
            text="CLOSE"
            rectAlignment="UpperRight"
            width="150" height="40"
            offsetXY="-24 -172"
            fontSize="15"
            color="#293A31"
            textColor="#FFFFFF"/>

      </Panel>
    ]],
        panelHeight,
        esc(summary),
        math.max(90, #marked * 26),
        #marked > 0 and "true" or "false"
    )
end

local genericRollOptionsXml

local findNamedDieGuid

local function buildSkills()
    ensureStructuredImportState()

    local names = {}

    for n,_ in pairs(state.skills) do
        if not state.skillsActiveOnly or state.skillEnabled[n] ~= false then
            table.insert(names,n)
        end
    end

    table.sort(names)

    local split = math.ceil(#names / 2)
    local rowStep = 48
    local leftX = 28
    local rightX = 590
    local startY = state.homeTimeOpen and -390 or -92
    local rowsXml = ""

    for i,n in ipairs(names) do
        local colIndex
        local x

        if i <= split then
            colIndex = i - 1
            x = leftX
        else
            colIndex = i - split - 1
            x = rightX
        end

        local y = startY - (colIndex * rowStep)
        rowsXml = rowsXml .. skillRowAt(n, state.skills[n], x, y)
    end

    local maxRows = math.max(split, #names - split)
    local extraTop = state.homeTimeOpen and 300 or 0
    local contentHeight = math.max(700, 125 + extraTop + (maxRows * rowStep))

    local filterText =
        state.skillsActiveOnly and
        "SHOW INACTIVE SKILLS" or
        "HIDE INACTIVE SKILLS"
    local filterColor = state.skillsActiveOnly and "#293A31" or "#3B644D"
    local homeText = state.homeTimeOpen and "END SESSION: OPEN" or "END SESSION"

    return string.format([[
    <VerticalScrollView id="scroll_skills"
        width="1180" preferredWidth="1180"
        height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="38"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_skills"
          width="1160"
          height="%d"
          rectAlignment="UpperCenter">

        <Text text="SKILLS"
            rectAlignment="UpperLeft"
            width="150" height="46"
            offsetXY="28 -18"
            fontSize="21"
            fontStyle="Bold"
            color="#BFD2C4"
            alignment="MiddleLeft"/>

        <Text text="★ = MARKED FOR IMPROVEMENT"
            rectAlignment="UpperLeft"
            width="270" height="38"
            offsetXY="160 -21"
            fontSize="12"
            color="#B88955"
            alignment="MiddleLeft"/>

        <Button id="skills_filter"
            onClick="toggleSkillsActiveOnly"
            text="%s"
            rectAlignment="UpperLeft"
            width="260" height="42"
            offsetXY="470 -18"
            fontSize="14"
            color="%s"
            textColor="#FFFFFF"/>

        <Button id="home_time"
            onClick="toggleHomeTime"
            text="%s"
            rectAlignment="UpperLeft"
            width="190" height="42"
            offsetXY="742 -18"
            fontSize="15"
            fontStyle="Bold"
            color="#57492E"
            textColor="#FFFFFF"/>

        <Dropdown id="generic_roll_dropdown"
            onValueChanged="selectGenericRoll"
            rectAlignment="UpperLeft"
            width="120" height="42"
            offsetXY="910 -18"
            fontSize="14"
            color="#1D2B24"
            textColor="#FFFFFF"
            itemBackgroundColors="#1B2922|#294034|#355244|#15201A"
            itemTextColor="#FFFFFF"
            dropdownBackgroundColor="#121B16"
            checkColor="#8FC79D"
            arrowColor="#FFFFFF"
            itemHeight="34"
            dropdownHeight="260">
            %s
        </Dropdown>

        <Button id="generic_roll_button"
            onClick="rollGenericSelected"
            text="ROLL"
            rectAlignment="UpperLeft"
            width="82" height="42"
            offsetXY="1038 -18"
            fontSize="16"
            fontStyle="Bold"
            color="#32483B"
            textColor="#FFFFFF"/>

        %s
        %s

      </Panel>
    </VerticalScrollView>]],
      contentHeight,
      filterText,
      filterColor,
      homeText,
      genericRollOptionsXml(),
      state.homeTimeOpen and buildHomeTimePanel() or "",
      rowsXml)
end


local function simpleOptionList(values, selected)
    local out = {}
    for _, value in ipairs(values) do
        local text = tostring(value)
        if text == tostring(selected) then
            table.insert(out, '<Option selected="true">' .. esc(text) .. '</Option>')
        else
            table.insert(out, '<Option>' .. esc(text) .. '</Option>')
        end
    end
    return table.concat(out, "")
end

local function buildDicePoolPanel()
    local diceChoices = {}
    local allowedForPool = {
        d4=true, d6=true, d8=true, d10=true, d12=true, d20=true,
        ["Hit Location"]=true
    }

    for _, name in ipairs(state.availableDice or {
        "GUMSHOE","Hit Location","d4","d6","d8","d10","d10s","d12","d20"
    }) do
        if allowedForPool[name] then
            table.insert(diceChoices, name)
        end
    end

    if #diceChoices == 0 then
        diceChoices = {"d4","d6","d8","d10","d12","d20","Hit Location"}
    end

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1050" height="500" offsetXY="0 0" color="#111A15CC">
        <Text text="MULTI-DIE ROLLER" rectAlignment="UpperLeft" width="420" height="38"
            offsetXY="24 -18" fontSize="22" fontStyle="Bold" color="#D2E5D6" alignment="MiddleLeft"/>

        <Text text="Build up to four dice groups. The fourth slot can also use the Hit Location die."
            rectAlignment="UpperLeft" width="990" height="44" offsetXY="24 -58"
            fontSize="14" color="#A9B8AD" alignment="UpperLeft" horizontalOverflow="Wrap"/>

        <Text text="QTY" rectAlignment="UpperLeft" width="80" height="26" offsetXY="40 -118"
            fontSize="13" fontStyle="Bold" color="#A7C8B0" alignment="MiddleCenter"/>
        <Text text="DIE" rectAlignment="UpperLeft" width="170" height="26" offsetXY="135 -118"
            fontSize="13" fontStyle="Bold" color="#A7C8B0" alignment="MiddleCenter"/>

        <Dropdown id="multi_qty_1" onValueChanged="selectMultiQty" rectAlignment="UpperLeft"
            width="80" height="40" offsetXY="40 -148" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="260" itemHeight="32">%s</Dropdown>
        <Dropdown id="multi_die_1" onValueChanged="selectMultiDie" rectAlignment="UpperLeft"
            width="170" height="40" offsetXY="135 -148" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="360" itemHeight="34">%s</Dropdown>

        <Dropdown id="multi_qty_2" onValueChanged="selectMultiQty" rectAlignment="UpperLeft"
            width="80" height="40" offsetXY="40 -202" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="260" itemHeight="32">%s</Dropdown>
        <Dropdown id="multi_die_2" onValueChanged="selectMultiDie" rectAlignment="UpperLeft"
            width="170" height="40" offsetXY="135 -202" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="360" itemHeight="34">%s</Dropdown>

        <Dropdown id="multi_qty_3" onValueChanged="selectMultiQty" rectAlignment="UpperLeft"
            width="80" height="40" offsetXY="40 -256" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="260" itemHeight="32">%s</Dropdown>
        <Dropdown id="multi_die_3" onValueChanged="selectMultiDie" rectAlignment="UpperLeft"
            width="170" height="40" offsetXY="135 -256" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="360" itemHeight="34">%s</Dropdown>

        <Dropdown id="multi_qty_4" onValueChanged="selectMultiQty" rectAlignment="UpperLeft"
            width="80" height="40" offsetXY="40 -310" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="260" itemHeight="32">%s</Dropdown>
        <Dropdown id="multi_die_4" onValueChanged="selectMultiDie" rectAlignment="UpperLeft"
            width="170" height="40" offsetXY="135 -310" fontSize="14" color="#1D2B24"
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="360" itemHeight="34">%s</Dropdown>

        <Text text="MODIFIER" rectAlignment="UpperLeft" width="150" height="28" offsetXY="360 -118"
            fontSize="13" fontStyle="Bold" color="#A7C8B0" alignment="MiddleLeft"/>
        <InputField id="multiModifier" text="%s" onEndEdit="editField" rectAlignment="UpperLeft"
            width="170" height="42" offsetXY="360 -148" fontSize="17" textColor="#F1F7F2" color="#17201B"/>

        <Button id="multi_roll" onClick="rollMultiDice" text="ROLL DICE POOL"
            rectAlignment="UpperLeft" width="270" height="54" offsetXY="360 -214"
            fontSize="17" fontStyle="Bold" color="#355943" textColor="#FFFFFF"/>

        <Text text="Hit Location reports the body part separately and is not added to the numeric total."
            rectAlignment="UpperLeft" width="620" height="50" offsetXY="360 -286"
            fontSize="13" color="#BBC8BE" alignment="UpperLeft" horizontalOverflow="Wrap"/>
      </Panel>
    ]],
        simpleOptionList({"0","1","2","3","4","5","6"}, state.multiQty1 or 1),
        simpleOptionList(diceChoices, state.multiDie1 or "d6"),
        simpleOptionList({"0","1","2","3","4","5","6"}, state.multiQty2 or 0),
        simpleOptionList(diceChoices, state.multiDie2 or "d4"),
        simpleOptionList({"0","1","2","3","4","5","6"}, state.multiQty3 or 0),
        simpleOptionList(diceChoices, state.multiDie3 or "d8"),
        simpleOptionList({"0","1","2","3","4","5","6"}, state.multiQty4 or 0),
        simpleOptionList(diceChoices, state.multiDie4 or "Hit Location"),
        esc(tostring(state.multiModifier or "0"))
    )
end

local function equipmentTabButton(id, label, active, x)
    return string.format([[
      <Button id="equipment_tab_%s"
          onClick="switchEquipmentSubtab"
          text="%s"
          rectAlignment="UpperLeft"
          width="220" height="44"
          offsetXY="%d %d"
          fontSize="17"
          color="%s"
          textColor="#FFFFFF"/>
    ]],
        id,
        esc(label),
        x,
        active and "#426A52" or "#223229"
    )
end

local splitLinesToItems

local function buildWeaponRows()
    ensureStructuredImportState()

    if #state.importedWeapons == 0 then
        return [[
          <Text text="No weapons imported."
              rectAlignment="UpperLeft"
              width="1050" height="40"
              offsetXY="0 0"
              fontSize="17"
              color="#829287"
              alignment="MiddleLeft"/>
        ]]
    end

    local xml = ""
    local y = 0

    for i, w in ipairs(state.importedWeapons) do
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1050" height="82"
              offsetXY="0 %d"
              color="#111A15CC">

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="360" height="30"
                offsetXY="14 -9"
                fontSize="18"
                fontStyle="Bold"
                color="#E3EEE6"
                alignment="MiddleLeft"/>

            <Text text="SKILL: %s"
                rectAlignment="UpperLeft"
                width="240" height="26"
                offsetXY="390 -10"
                fontSize="14"
                color="#A7B7AB"
                alignment="MiddleLeft"/>

            <Text text="DAMAGE: %s"
                rectAlignment="UpperLeft"
                width="220" height="26"
                offsetXY="650 -10"
                fontSize="14"
                color="#D6BC7A"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="1020" height="34"
                offsetXY="14 -43"
                fontSize="13"
                color="#BBC8BE"
                alignment="MiddleLeft"
                horizontalOverflow="Wrap"/>

          </Panel>
        ]],
            -y,
            esc(w.name),
            esc(w.skill),
            esc(w.damage),
            esc(w.notes)
        )
        y = y + 90
    end

    return xml
end

local function buildArmorRows()
    ensureStructuredImportState()

    if #state.importedArmor == 0 then
        return [[
          <Text text="No armor imported."
              rectAlignment="UpperLeft"
              width="1050" height="40"
              offsetXY="0 0"
              fontSize="17"
              color="#829287"
              alignment="MiddleLeft"/>
        ]]
    end

    local xml = ""
    local y = 0

    for _, a in ipairs(state.importedArmor) do
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1050" height="76"
              offsetXY="0 %d"
              color="#111A15CC">

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="470" height="30"
                offsetXY="14 -8"
                fontSize="18"
                fontStyle="Bold"
                color="#E3EEE6"
                alignment="MiddleLeft"/>

            <Text text="ARMOR: %s"
                rectAlignment="UpperLeft"
                width="220" height="28"
                offsetXY="500 -9"
                fontSize="14"
                color="#D6BC7A"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="1020" height="30"
                offsetXY="14 -40"
                fontSize="13"
                color="#BBC8BE"
                alignment="MiddleLeft"
                horizontalOverflow="Wrap"/>

          </Panel>
        ]],
            -y,
            esc(a.name),
            esc(a.armor),
            esc(a.notes)
        )
        y = y + 84
    end

    return xml
end

local function buildGearRows()
    ensureStructuredImportState()

    if #state.importedGear == 0 then
        return [[
          <Text text="No gear imported."
              rectAlignment="UpperLeft"
              width="1050" height="40"
              offsetXY="0 0"
              fontSize="17"
              color="#829287"
              alignment="MiddleLeft"/>
        ]]
    end

    local xml = ""
    local y = 0

    for i, item in ipairs(state.importedGear) do
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1050" height="48"
              offsetXY="0 %d"
              color="#111A15AA">

            <Text text="%d."
                rectAlignment="UpperLeft"
                width="45" height="32"
                offsetXY="12 -8"
                fontSize="14"
                color="#86A88F"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="970" height="32"
                offsetXY="55 -8"
                fontSize="16"
                color="#E3EEE6"
                alignment="MiddleLeft"/>

          </Panel>
        ]],
            -y,
            i,
            esc(item)
        )
        y = y + 56
    end

    return xml
end

-------------------------------------------------
-- CORE DISORDERS
-------------------------------------------------

local DISORDER_DEFS = {
    ["PTSD"] = {
        sources={"Violence"},
        summary="Trauma reminders can trigger violent reactions or a depressive episode.",
        auto="Contextual; Handler chooses the acute response."
    },
    ["Depression"] = {
        sources={"Violence","Helplessness","Unnatural"},
        summary="Acute despair makes every skill or stat test cost 1D4 WP.",
        auto="AUTO: skill rolls cost 1D4 WP while acute.",
        wpCost=true
    },
    ["Addiction"] = {
        sources={"Violence","Helplessness"},
        summary="Dependence on a harmful substance or compulsive habit; withdrawal can cost WP and prevent recovery.",
        auto="Contextual withdrawal/indulgence effects."
    },
    ["Sleep Disorder"] = {
        sources={"Violence","Unnatural"},
        summary="Sleep may require a SAN test; failure prevents true rest and WP recovery for 24 hours.",
        auto="Contextual sleep/recovery effect."
    },
    ["Paranoia"] = {
        sources={"Violence","Unnatural"},
        summary="During an episode the Agent cannot reliably trust others and reads ordinary events as threats.",
        auto="Roleplay/contextual effect."
    },
    ["Intermittent Explosive Disorder"] = {
        sources={"Violence"},
        summary="Acute episodes erupt into sudden, disproportionate, uncontrollable rage.",
        auto="Roleplay/contextual effect."
    },
    ["Ligyrophobia"] = {
        sources={"Violence"},
        summary="Fear of loud noises; exposure can provoke a phobic episode and impair SAN tests.",
        auto="SAN-test penalty is shown; SAN rolls are not automated on this sheet.",
        sanPenalty=-20
    },
    ["Totemic Compulsion"] = {
        sources={"Violence"},
        summary="The Agent depends on a protective totem; separation causes a -10% penalty to tests until it is recovered or replaced.",
        auto="AUTO: -10% to skill rolls while acute.",
        skillPenalty=-10,
        statPenalty=-10,
        sanPenalty=-10
    },
    ["Obsessive/Compulsive Disorder"] = {
        sources={"Helplessness"},
        summary="An acute episode imposes -20% to tests until the Agent restores the required order or ritual.",
        auto="AUTO: -20% to skill rolls while acute.",
        skillPenalty=-20,
        statPenalty=-20,
        sanPenalty=-20
    },
    ["Anxiety Disorder"] = {
        sources={"Helplessness"},
        summary="An acute episode imposes -20% to skill, stat, and SAN tests.",
        auto="AUTO: -20% to skill rolls while acute.",
        skillPenalty=-20,
        statPenalty=-20,
        sanPenalty=-20
    },
    ["Obsession"] = {
        sources={"Helplessness"},
        summary="During an episode, long-term actions and skill uses are impaired because attention stays fixed on the obsession.",
        auto="Contextual: long-term actions only."
    },
    ["Enclosure-Related Phobia"] = {
        sources={"Helplessness"},
        summary="Agoraphobia or claustrophobia; the feared environment can provoke an acute episode and impair SAN tests.",
        auto="SAN-test penalty is shown; SAN rolls are not automated on this sheet.",
        sanPenalty=-20
    },
    ["Conversion Disorder"] = {
        sources={"Helplessness"},
        summary="Acute stress manifests as blindness, deafness, or paralysis until the stress subsides.",
        auto="Contextual physical disability."
    },
    ["Dissociative Identity Disorder"] = {
        sources={"Helplessness","Unnatural"},
        summary="An alternate identity with its own personality and memories can take control during an acute episode.",
        auto="Roleplay/contextual; Handler control."
    },
    ["Depersonalization Disorder"] = {
        sources={"Unnatural"},
        summary="Acute detachment from body, thoughts, and emotions imposes -20% to skill and stat tests.",
        auto="AUTO: -20% to skill rolls while acute.",
        skillPenalty=-20,
        statPenalty=-20
    },
    ["Amnesia"] = {
        sources={"Unnatural"},
        summary="An acute episode erases memory of the triggering event until those memories are recovered.",
        auto="Roleplay/contextual memory effect."
    },
    ["Fugues"] = {
        sources={"Unnatural"},
        summary="Extreme stress causes catatonia or disconnected wandering.",
        auto="Roleplay/contextual effect."
    },
    ["Megalomania"] = {
        sources={"Unnatural"},
        summary="During an episode, attempts to seek help or make a favorable impression automatically fail.",
        auto="Contextual automatic failure for specific social/help tests."
    }
}

local DISORDER_POOLS = {
    Violence = {
        "PTSD","Depression","Addiction","Sleep Disorder",
        "Paranoia","Intermittent Explosive Disorder",
        "Ligyrophobia","Totemic Compulsion"
    },
    Helplessness = {
        "Depression","Obsessive/Compulsive Disorder","Anxiety Disorder",
        "Addiction","Obsession","Enclosure-Related Phobia",
        "Conversion Disorder","Dissociative Identity Disorder"
    },
    Unnatural = {
        "Depersonalization Disorder","Depression","Sleep Disorder","Amnesia",
        "Fugues","Paranoia","Megalomania","Dissociative Identity Disorder"
    }
}

local function ensureDisorderState()
    local p = state.psychology

    if p.disorderList == nil then
        p.disorderList = {}
    end

    if p.pendingDisorders == nil then
        p.pendingDisorders = 0
    end

    if p.pendingSource == nil then
        p.pendingSource = "Violence"
    end

    if p.disorderPickIndex == nil then
        p.disorderPickIndex = 1
    end

    -- Preserve old freeform notes from earlier builds.
    if p.legacyDisorderNotes == nil and p.disorders and p.disorders ~= "" then
        p.legacyDisorderNotes = p.disorders
    end
end

local function currentDisorderCandidate()
    ensureDisorderState()

    local source = state.psychology.pendingSource or "Violence"
    local pool = DISORDER_POOLS[source] or DISORDER_POOLS.Violence
    local i = tonumber(state.psychology.disorderPickIndex) or 1

    if i < 1 then i = #pool end
    if i > #pool then i = 1 end

    state.psychology.disorderPickIndex = i
    return pool[i]
end

local function hasCuredDisorder()
    ensureDisorderState()
    for _, d in ipairs(state.psychology.disorderList) do
        if d.cured == true then
            return true
        end
    end
    return false
end

local function activeDisorderSkillPenalty()
    ensureDisorderState()
    local total = 0

    for _, d in ipairs(state.psychology.disorderList) do
        if not d.cured and d.acute then
            local def = DISORDER_DEFS[d.name]
            if def and def.skillPenalty then
                total = total + def.skillPenalty
            end
        end
    end

    return total
end

local function activeDisorderStatPenalty()
    ensureDisorderState()
    local total = 0

    for _, d in ipairs(state.psychology.disorderList) do
        if not d.cured and d.acute then
            local def = DISORDER_DEFS[d.name]
            if def and def.statPenalty then
                total = total + def.statPenalty
            end
        end
    end

    return total
end

local function activeDisorderSanPenalty()
    ensureDisorderState()
    local total = 0

    for _, d in ipairs(state.psychology.disorderList) do
        if not d.cured and d.acute then
            local def = DISORDER_DEFS[d.name]
            if def and def.sanPenalty then
                total = total + def.sanPenalty
            end
        end
    end

    return total
end

local function activeDepressionCount()
    ensureDisorderState()
    local count = 0

    for _, d in ipairs(state.psychology.disorderList) do
        if not d.cured and d.acute and d.name == "Depression" then
            count = count + 1
        end
    end

    return count
end

local function disorderEffectsSummary()
    local parts = {}
    local sp = activeDisorderSkillPenalty()
    local st = activeDisorderStatPenalty()
    local san = activeDisorderSanPenalty()

    if sp ~= 0 then table.insert(parts, string.format("Skill tests %d%%", sp)) end
    if st ~= 0 then table.insert(parts, string.format("Stat tests %d%%", st)) end
    if san ~= 0 then table.insert(parts, string.format("SAN tests %d%%", san)) end
    if activeDepressionCount() > 0 then table.insert(parts, "Skill/stat tests cost 1D4 WP") end

    if #parts == 0 then
        return "No automatic numeric disorder effects active."
    end

    return table.concat(parts, "  |  ")
end

local function buildDisorderRows()
    ensureDisorderState()

    local rows = ""
    local y = 0

    if #state.psychology.disorderList == 0 then
        return [[
          <Text text="No disorders assigned."
              rectAlignment="UpperLeft"
              width="1110" height="35"
              offsetXY="0 0"
              fontSize="17"
              color="#829287"
              alignment="MiddleLeft"/>
        ]]
    end

    for i, d in ipairs(state.psychology.disorderList) do
        local def = DISORDER_DEFS[d.name] or {
            summary="Unknown/custom disorder.",
            auto="No automatic effect."
        }

        local statusText
        local statusColor

        if d.cured then
            statusText = "CURED / REMISSION"
            statusColor = "#55705D"
        elseif d.acute then
            statusText = "ACUTE"
            statusColor = "#7A3434"
        else
            statusText = "DORMANT"
            statusColor = "#35463B"
        end

        local source = d.source or "Unknown"
        local cureText = d.cured and "RELAPSE" or "CURE"
        local acuteText = d.acute and "ACUTE: ON" or "ACUTE: OFF"
        local acuteInteract = d.cured and "false" or "true"

        rows = rows .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1110" height="112"
              offsetXY="0 %d"
              color="#111A15CC">

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="430" height="28"
                offsetXY="12 -7"
                fontSize="19"
                fontStyle="Bold"
                color="#E4EFE7"
                alignment="MiddleLeft"/>

            <Text text="%s • %s"
                rectAlignment="UpperLeft"
                width="310" height="26"
                offsetXY="445 -8"
                fontSize="14"
                color="#9DB0A2"
                alignment="MiddleLeft"/>

            <Button id="disorder_%d_acute"
                onClick="toggleDisorderAcute"
                text="%s"
                interactable="%s"
                rectAlignment="UpperLeft"
                width="125" height="34"
                offsetXY="760 -5"
                fontSize="14"
                color="%s"
                textColor="#FFFFFF"/>

            <Button id="disorder_%d_cure"
                onClick="toggleDisorderCured"
                text="%s"
                rectAlignment="UpperLeft"
                width="105" height="34"
                offsetXY="892 -5"
                fontSize="14"
                color="#33493C"
                textColor="#FFFFFF"/>

            <Button id="disorder_%d_remove"
                onClick="removeDisorder"
                text="REMOVE"
                rectAlignment="UpperLeft"
                width="96" height="34"
                offsetXY="1004 -5"
                fontSize="13"
                color="#4B2929"
                textColor="#FFFFFF"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="1075" height="36"
                offsetXY="12 -44"
                fontSize="14"
                color="#D3DED6"
                alignment="UpperLeft"
                horizontalOverflow="Wrap"
                verticalOverflow="Overflow"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="1075" height="25"
                offsetXY="12 -82"
                fontSize="13"
                color="#87A990"
                alignment="MiddleLeft"/>

          </Panel>
        ]],
            -y,
            esc(d.name),
            esc(source), esc(statusText),
            i, acuteText, acuteInteract, statusColor,
            i, cureText,
            i,
            esc(def.summary),
            esc(def.auto)
        )

        y = y + 120
    end

    return rows
end




-------------------------------------------------
-- BUILT-IN EQUIPMENT / WEAPON STAT CATALOG
-- Used when imported JSON contains only an item name.
-- Structured JSON data always takes priority over these defaults.
-------------------------------------------------

local EQUIPMENT_CATALOG = {}

-- GitHub is the only equipment catalog source.
-- The sheet loads directly from N3rdmade/DELTA-GREEN-STATS.
local EQUIPMENT_CATALOG_GITHUB_URL =
    "https://raw.githubusercontent.com/N3rdmade/DELTA-GREEN-STATS/main/equipment-data.js"

local FIREARM_EXPANSION_GITHUB_URL =
    "https://raw.githubusercontent.com/N3rdmade/DELTA-GREEN-STATS/main/firearms-expansion.js"

local equipmentCatalogSource = "GitHub only — not loaded yet"
local equipmentCatalogCount = 0
local equipmentCatalogRefreshRunning = false
local sortedCatalogNamesForCategory

local function officialCatalogCategory(rawCategory)
    rawCategory = tostring(rawCategory or "")
    if rawCategory == "Firearms" then return "Firearms" end
    if rawCategory == "Melee Weapons" then return "Melee Weapons" end
    if rawCategory == "Heavy Weapons" or rawCategory == "Artillery" or rawCategory == "Demolitions" then
        return "Heavy Weapons"
    end
    if rawCategory == "Less-Lethal" then return "Less-Lethal Weapons" end
    if rawCategory == "Armor" then return "Body Armor" end
    return "Other Gear"
end

local function officialOtherGearSubcategory(rawCategory, name)
    rawCategory = tostring(rawCategory or "")
    name = string.lower(tostring(name or ""))

    if rawCategory == "Surveillance" then return "Surveillance" end
    if rawCategory == "Comms & Tech" then return "Communications and Computers" end
    if rawCategory == "Optics & Vision" then return "Lighting and Vision" end
    if rawCategory == "Entry Tools" then return "Breaking and Entering" end
    if rawCategory == "Restraints" then return "Restraints" end
    if rawCategory == "Survival & Medical" then return "Emergency and Survival Gear" end

    if rawCategory == "Weapon Accessories" then
        if name:find("sight",1,true) or name:find("optic",1,true) or
           name:find("laser",1,true) or name:find("light",1,true)
        then
            return "Lighting and Vision"
        end
        -- Suppressors, slings and bipods are still Other Gear in the rules,
        -- but are left un-foldered rather than inventing a new rules category.
        return ""
    end

    return ""
end

local function officialCatalogSubcategory(rawCategory, rawSubcategory, name)
    rawCategory = tostring(rawCategory or "")
    if rawCategory == "Firearms" then return tostring(rawSubcategory or "") end
    if rawCategory == "Artillery" then return "Artillery" end
    if rawCategory == "Demolitions" then return "Demolitions" end
    if rawCategory == "Heavy Weapons" then return "" end
    if rawCategory == "Less-Lethal" or rawCategory == "Armor" or rawCategory == "Melee Weapons" then
        return ""
    end
    return officialOtherGearSubcategory(rawCategory, name)
end

local function equipmentUiCategoryFromSource(sourceCategory)
    local map = {
        ["Firearms"] = "firearms",
        ["Melee Weapons"] = "melee",
        ["Heavy Weapons"] = "heavy",
        ["Less-Lethal Weapons"] = "lesslethal",
        ["Body Armor"] = "armor"
    }
    return map[tostring(sourceCategory or "")] or "gear"
end

local function equipmentCatalogConsumable(category, name, ammo)
    category = tostring(category or "")
    name = string.lower(tostring(name or ""))
    ammo = tostring(ammo or "")

    if category == "Demolitions" then return true end

    -- Reusable launchers must keep ammo/reserve even though their names contain
    -- "grenade". Only the projectile/disposable item itself uses quantity.
    if name:find("grenade launcher",1,true) or
       name:find("grenade machine gun",1,true) or
       name:find("rpg%-7",1,false) or
       name:find("rocket%-propelled grenade launcher",1,false) or
       name:find("40mm sponge round launcher",1,true)
    then
        return false
    end

    if name:find("m72 law",1,true) or name:find("at4 launcher",1,true) then
        return true
    end

    if name:find("hand grenade",1,true) or
       name:find("fragmentation grenade",1,true) or
       name:find("incendiary grenade",1,true) or
       name:find("flash%-bang grenade",1,false) or
       name:find("stun grenade",1,true) or
       name:find("smoke grenade",1,true) or
       name:find("tear gas grenade",1,true) or
       name:find("molotov",1,true) or
       name:find("mine",1,true) or
       name:find("bomb",1,true) or
       name:find("missile",1,true) or
       name:find("ied",1,true) or
       name:find("demolition charge",1,true) or
       name:find("blasting charge",1,true) or
       name:find("satchel charge",1,true) or
       name:find("beanbag shotgun rounds",1,true)
    then
        return true
    end

    return false
end

local function parseGithubEquipmentCatalog(text)
    text = tostring(text or "")
    if text == "" then return nil, "GitHub returned an empty catalog." end

    local parsed = {}
    local displayNames = {}
    local current = nil

    for line in text:gmatch("[^\r\n]+") do
        local category, name, itemType = line:match(
            "category:%s*'([^']+)'%s*,%s*name:%s*'([^']+)'%s*,%s*type:%s*'([^']+)'"
        )

        if category and name and itemType then
            local rawSubcategory = line:match("subcategory:%s*'([^']+)'") or ""
            local officialCategory = officialCatalogCategory(category)
            current = {
                sourceCategory = officialCategory,
                originalCategory = category,
                category = equipmentUiCategoryFromSource(officialCategory),
                kind = itemType == "weapon" and "weapon" or
                       (itemType == "armor" and "armor" or "gear"),
                type = officialCategory,
                name = name,
                subcategory = officialCatalogSubcategory(category, rawSubcategory, name),
                caliber = line:match("caliber:%s*'([^']+)'") or "",
                variantSpec = line:match("variants:%s*'([^']+)'") or ""
            }

            local key = string.lower(name)
            parsed[key] = current
            displayNames[key] = name

        elseif current and line:find("system:", 1, true) then
            local function textField(field)
                return line:match(field .. ":%s*'([^']*)'") or ""
            end

            local function numberField(field)
                return tonumber(line:match(field .. ":%s*(-?%d+%.?%d*)"))
            end

            if current.kind == "weapon" then
                current.skill = textField("skill")
                current.accessoryMod = numberField("skillModifier") or 0
                current.range = textField("range")
                if current.range == "" and current.originalCategory == "Demolitions" then
                    current.range = "N/A"
                end
                current.damage = textField("damage")
                current.ap = tostring(numberField("armorPiercing") or 0)

                local lethality = numberField("lethality") or 0
                current.lethality =
                    lethality > 0 and (tostring(lethality) .. "%") or ""

                current.killRadius = textField("killRadius")
                current.capacity = textField("ammo")
                current.expense = textField("expense")
                current.consumable = equipmentCatalogConsumable(
                    current.originalCategory,
                    current.name,
                    current.capacity
                )

            elseif current.kind == "armor" then
                current.armor = tostring(numberField("protection") or 0)
                current.expense = textField("expense")
                current.description = textField("description")

            else
                current.expense = textField("expense")
                current.description = textField("description")
            end

            current = nil
        end
    end

    local count = 0
    for _ in pairs(parsed) do count = count + 1 end

    if count < 100 then
        return nil,
            "Only " .. tostring(count) ..
            " catalog items were parsed; keeping embedded fallback."
    end

    return {
        catalog = parsed,
        displayNames = displayNames,
        count = count
    }, nil
end

local function firearmProfileDefaults(profile)
    profile = tostring(profile or "")

    local map = {
        ["light-pistol"] = {
            skill="firearms", accessoryMod=0, range="10M",
            damage="1D8", ap="0", lethality="", expense="Standard"
        },
        ["medium-pistol"] = {
            skill="firearms", accessoryMod=0, range="15M",
            damage="1D10", ap="0", lethality="", expense="Standard"
        },
        ["carbine"] = {
            skill="firearms", accessoryMod=0, range="100M",
            damage="1D12", ap="3", lethality="10%", expense="Unusual"
        },
        ["assault-rifle"] = {
            skill="firearms", accessoryMod=0, range="100M",
            damage="1D12", ap="3", lethality="10%", expense="Unusual"
        },
        ["battle-rifle"] = {
            skill="firearms", accessoryMod=0, range="150M",
            damage="1D12+2", ap="5", lethality="10%", expense="Unusual"
        },
        ["marksman-rifle"] = {
            skill="firearms", accessoryMod=0, range="150M",
            damage="1D12+2", ap="5", lethality="10%", expense="Unusual"
        },
        ["heavy-sniper"] = {
            skill="firearms", accessoryMod=0, range="250M",
            damage="", ap="5", lethality="20%", expense="Major"
        },
        ["smg"] = {
            skill="firearms", accessoryMod=0, range="50M",
            damage="1D10", ap="0", lethality="10%", expense="Unusual"
        },
        ["shotgun"] = {
            skill="firearms", accessoryMod=20, range="75M",
            damage="2D8", ap="0", lethality="", expense="Standard"
        },
        ["pcc"] = {
            skill="firearms", accessoryMod=0, range="50M",
            damage="1D12", ap="0", lethality="10%", expense="Standard"
        }
    }

    return map[profile] or map["carbine"]
end

local function parseFirearmExpansionCatalog(text)
    local parsed = {}
    local displayNames = {}

    for line in tostring(text or ""):gmatch("[^\r\n]+") do
        local name = line:match("name:'([^']+)'")
        local subcategory = line:match("subcategory:'([^']+)'")
        local caliber = line:match("caliber:'([^']+)'")
        local capacity = line:match("capacity:'([^']+)'")
        local profile = line:match("profile:'([^']+)'")

        if name and subcategory and caliber and capacity and profile then
            local defaults = firearmProfileDefaults(profile)
            local key = string.lower(name)

            parsed[key] = {
                sourceCategory = "Firearms",
                category = "firearms",
                kind = "weapon",
                type = "Firearms",
                name = name,
                subcategory = subcategory,
                caliber = caliber,
                capacity = capacity,
                variantSpec = line:match("variants:'([^']+)'") or "",
                skill = defaults.skill,
                accessoryMod = defaults.accessoryMod,
                range = defaults.range,
                damage = defaults.damage,
                ap = defaults.ap,
                lethality = defaults.lethality,
                killRadius = "N/A",
                expense = defaults.expense,
                consumable = false
            }

            displayNames[key] = name
        end
    end

    return {
        catalog = parsed,
        displayNames = displayNames
    }
end

local function mergeEquipmentCatalogData(base, extra)
    base = base or {catalog={}, displayNames={}, count=0}
    extra = extra or {catalog={}, displayNames={}}

    for key, item in pairs(extra.catalog or {}) do
        base.catalog[key] = item
        base.displayNames[key] =
            (extra.displayNames and extra.displayNames[key]) or
            tostring(item.name or key)
    end

    local count = 0
    for _ in pairs(base.catalog or {}) do count = count + 1 end
    base.count = count

    return base
end

function refreshEquipmentCatalogFromGithub(player, value, id)
    if equipmentCatalogRefreshRunning then return end

    equipmentCatalogRefreshRunning = true
    equipmentCatalogSource = "Refreshing from GitHub..."

    if state.currentTab == "equipment" and
       state.equipmentSubtab == "add" and
       getCachedHelper("equipment")
    then
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
    end

    WebRequest.get(EQUIPMENT_CATALOG_GITHUB_URL, function(request)
        if request.is_error or not request.text or request.text == "" then
            equipmentCatalogRefreshRunning = false
            EQUIPMENT_CATALOG = {}
            EQUIPMENT_CATALOG_DISPLAY_NAMES = {}
            equipmentCatalogCount = 0
            equipmentCatalogSource = "GitHub unavailable"

            broadcastToAll(
                "[DG] Equipment catalog could not be loaded from GitHub.",
                {1.0,0.55,0.30}
            )
            return
        end

        local parsed, err = parseGithubEquipmentCatalog(request.text)

        if not parsed then
            equipmentCatalogRefreshRunning = false
            EQUIPMENT_CATALOG = {}
            EQUIPMENT_CATALOG_DISPLAY_NAMES = {}
            equipmentCatalogCount = 0
            equipmentCatalogSource =
                "GitHub parse failed — " .. tostring(err or "unknown error")

            broadcastToAll(
                "[DG] " .. tostring(err or "Could not parse GitHub equipment catalog."),
                {1.0,0.55,0.30}
            )
            return
        end

        WebRequest.get(FIREARM_EXPANSION_GITHUB_URL, function(extraRequest)
            if not extraRequest.is_error and
               extraRequest.text and
               extraRequest.text ~= ""
            then
                local extra = parseFirearmExpansionCatalog(extraRequest.text)
                parsed = mergeEquipmentCatalogData(parsed, extra)
            end

            equipmentCatalogRefreshRunning = false
            EQUIPMENT_CATALOG = parsed.catalog
            EQUIPMENT_CATALOG_DISPLAY_NAMES = parsed.displayNames
            equipmentCatalogCount = parsed.count
            equipmentCatalogSource =
                "GitHub N3rdmade/DELTA-GREEN-STATS — " ..
                tostring(parsed.count) .. " items"

            local names =
                sortedCatalogNamesForCategory(state.addItemCategory)

            local selected =
                string.lower(tostring(state.addItemName or ""))

            local valid = false
            for _, key in ipairs(names) do
                if key == selected then
                    valid = true
                    break
                end
            end

            if not valid then
                state.addItemName = ""
                state.addSelectedCaliber = ""
                state.addSelectedCapacity = ""
            end

            cachedPageDirty["equipment"] = true

            if state.currentTab == "equipment" and
               state.equipmentSubtab == "add" and
               getCachedHelper("equipment")
            then
                rebuildCachedPage("equipment")
                activateCachedPage("equipment")
            end
        end)
    end)
end

local function catalogEntryForItem(name)
    local key = string.lower(tostring(name or ""))
    return EQUIPMENT_CATALOG[key]
end


local EQUIPMENT_CATALOG_DISPLAY_NAMES = {}

local EQUIPMENT_ADD_CATEGORY_ORDER = {
    "Firearms",
    "Melee Weapons",
    "Heavy Weapons",
    "Less-Lethal Weapons",
    "Body Armor",
    "Other Gear"
}

sortedCatalogNamesForCategory = function(category)
    local names = {}

    for key, item in pairs(EQUIPMENT_CATALOG) do
        if tostring(item.sourceCategory or "") == tostring(category or "") then
            table.insert(names, key)
        end
    end

    table.sort(names, function(a,b)
        return string.lower(a) < string.lower(b)
    end)

    return names
end

local function titleCatalogName(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item then return tostring(key or "") end

    -- Recover capitalization from known user-facing forms.
    local sourceName = item.displayName
    if sourceName and sourceName ~= "" then return sourceName end

    local s = tostring(key or "")
    return (s:gsub("(%a)([%w'%-]*)", function(a,b)
        return string.upper(a) .. b
    end))
end

local function catalogDisplayName(key)
    key = tostring(key or "")
    return EQUIPMENT_CATALOG_DISPLAY_NAMES[key] or titleCatalogName(key)
end

local function cloneCatalogItemByName(name)
    local key = string.lower(tostring(name or ""))
    local catalog = EQUIPMENT_CATALOG[key]
    if not catalog then return nil end

    local copy = { name = catalogDisplayName(key) }

    -- Preserve exact requested name capitalization if supplied.
    if tostring(name or "") ~= "" then
        copy.name = tostring(name)
    end

    for k,v in pairs(catalog) do
        copy[k] = v
    end

    return copy
end

local function firstCatalogKeyForCategory(category)
    local names = sortedCatalogNamesForCategory(category)
    return names[1]
end

local function catalogDropdownOptions(names, selectedKey)
    local xml = ""
    selectedKey = tostring(selectedKey or "")

    for _, key in ipairs(names or {}) do
        local selected = tostring(key) == selectedKey and ' selected="true"' or ""
        xml = xml .. string.format(
            '<Option value="%s"%s>%s</Option>',
            esc(key), selected, esc(catalogDisplayName(key))
        )
    end

    return xml
end

local function addCatalogItemToInventory(name, selectedCaliber, selectedCapacity)
    ensureStructuredImportState()

    local key = string.lower(tostring(name or ""))
    local c = EQUIPMENT_CATALOG[key]
    if not c then return false, "Catalog item not found.", nil end

    local displayName = catalogDisplayName(key)

    if c.kind == "weapon" then
        local chosenCaliber = tostring(selectedCaliber or "")
        if chosenCaliber == "" then chosenCaliber = tostring(c.caliber or "") end

        local chosenCapacity = tonumber(selectedCapacity)
        if not chosenCapacity then
            chosenCapacity = tonumber(tostring(c.capacity or ""):match("(%d+)"))
        end

        -- Same model with a different chambering or magazine configuration is
        -- a distinct carried weapon. Exact matching variants may stack.
        for _, w in ipairs(state.importedWeapons) do
            if string.lower(tostring(w.name or "")) == key and
               tostring(w.caliber or "") == chosenCaliber and
               tonumber(tostring(w.capacity or ""):match("(%d+)")) == chosenCapacity
            then
                w.quantity = math.max(1, tonumber(w.quantity) or 1) + 1
                return true, displayName .. " quantity increased.", w
            end
        end

        local weapon = {
            name = displayName,
            skill = tostring(c.skill or ""),
            range = tostring(c.range or ""),
            damage = tostring(c.damage or ""),
            lethality = tostring(c.lethality or ""),
            capacity = chosenCapacity and tostring(chosenCapacity) or tostring(c.capacity or ""),
            caliber = chosenCaliber,
            ammoCurrent = chosenCapacity,
            ammoReserve = 0,
            quantity = 1,
            fireMode = "SINGLE",
            accessoryMod = tonumber(c.accessoryMod) or 0,
            ap = tostring(c.ap or ""),
            killRadius = tostring(c.killRadius or ""),
            expense = tostring(c.expense or ""),
            consumable = c.consumable == true,
            sourceCategory = tostring(c.sourceCategory or ""),
            notes = tostring(c.notes or "")
        }
        table.insert(state.importedWeapons, weapon)

        return true, displayName .. " added.", weapon

    elseif c.kind == "armor" then
        for _, a in ipairs(state.importedArmor) do
            if string.lower(tostring(a.name or "")) == key then
                state.itemQuantities[key] =
                    math.max(1, tonumber(state.itemQuantities[key]) or 1) + 1
                return true, displayName .. " quantity increased.", a
            end
        end

        local armor = {
            name = displayName,
            armor = tostring(c.armor or ""),
            expense = tostring(c.expense or ""),
            notes = tostring(c.notes or "")
        }
        table.insert(state.importedArmor, armor)

        state.itemQuantities[key] = math.max(1, tonumber(state.itemQuantities[key]) or 1)
        return true, displayName .. " added.", armor
    end

    local found = false
    for _, g in ipairs(state.importedGear) do
        if string.lower(tostring(g or "")) == key then
            found = true
            break
        end
    end

    if not found then table.insert(state.importedGear, displayName) end

    state.itemQuantities[key] =
        math.max(0, tonumber(state.itemQuantities[key]) or (found and 1 or 0)) + 1

    return true, displayName .. " added.", nil
end



local function mergeCatalogIntoItem(item)
    local catalog = catalogEntryForItem(item.name)

    if not catalog then
        return item
    end

    -- Imported JSON remains authoritative for weapon stats.
    -- GitHub is only enrichment/reference: it classifies recognized names and
    -- fills fields that the character export left blank. It never overwrites a
    -- populated imported range/damage/lethality/ammo/AP/etc. value.
    if catalog.kind ~= nil then
        item.kind = catalog.kind
    end

    if catalog.category ~= nil then
        item.category = catalog.category
    end

    if catalog.sourceCategory ~= nil and
       (item.sourceCategory == nil or tostring(item.sourceCategory) == "")
    then
        item.sourceCategory = catalog.sourceCategory
    end

    if catalog.consumable == true then
        item.consumable = true
    end

    for key, value in pairs(catalog) do
        if key ~= "kind" and key ~= "category" then
            if item[key] == nil or tostring(item[key]) == "" then
                item[key] = value
            end
        end
    end

    return item
end

local function equipmentCategoryForName(name, explicitSkill)
    local n = string.lower(tostring(name or ""))
    local skill = string.lower(tostring(explicitSkill or ""))

    -- Explicit weapon-skill hints first.
    if skill:find("firearm", 1, true) then
        return "firearms"
    end

    if skill:find("heavy weapon", 1, true) or
       skill:find("artillery", 1, true) or
       skill:find("demolition", 1, true)
    then
        return "heavy"
    end

    if skill:find("melee", 1, true) or
       skill:find("unarmed", 1, true)
    then
        return "melee"
    end

    -- Firearms / ranged weapons.
    local firearmWords = {
        "pistol","revolver","rifle","carbine","shotgun","smg",
        "submachine","machine gun","firearm","gun","sniper"
    }

    for _, word in ipairs(firearmWords) do
        if n:find(word, 1, true) then
            return "firearms"
        end
    end

    -- Less-lethal / restraint / compliance gear.
    local lessLethalWords = {
        "shock baton","stun","taser","pepper","mace","beanbag",
        "bean bag","rubber bullet","handcuff","restraint",
        "less lethal","less-lethal","tear gas"
    }

    for _, word in ipairs(lessLethalWords) do
        if n:find(word, 1, true) then
            return "lesslethal"
        end
    end

    -- Melee weapons.
    local meleeWords = {
        "axe","ax ","knife","machete","sword","club","baton",
        "crowbar","hammer","spear","unarmed","punch","melee"
    }

    for _, word in ipairs(meleeWords) do
        if n:find(word, 1, true) then
            return "melee"
        end
    end

    return "gear"
end

local function collectEquipmentItems()
    ensureStructuredImportState()

    -- Migration for sheets saved before catalog equipment was structured.
    -- Recognized weapons/armor living in importedGear are promoted once.
    local migratedGear = {}

    for _, g in ipairs(state.importedGear or {}) do
        local name = tostring(g or "")
        local key = string.lower(name)
        local c = EQUIPMENT_CATALOG[key]

        if c and c.kind == "weapon" then
            local existing = nil

            for _, w in ipairs(state.importedWeapons or {}) do
                if string.lower(tostring(w.name or "")) == key then
                    existing = w
                    break
                end
            end

            if existing then
                existing.quantity = math.max(1, tonumber(existing.quantity) or 1) + 1
            else
                local cap = tonumber(tostring(c.capacity or ""):match("(%d+)"))
                table.insert(state.importedWeapons, {
                    name = catalogDisplayName(key),
                    skill = tostring(c.skill or ""),
                    range = tostring(c.range or ""),
                    damage = tostring(c.damage or ""),
                    lethality = tostring(c.lethality or ""),
                    capacity = tostring(c.capacity or ""),
                    ammoCurrent = cap,
                    quantity = 1,
                    fireMode = "SINGLE",
                    accessoryMod = tonumber(c.accessoryMod) or 0,
                    ap = tostring(c.ap or ""),
                    killRadius = tostring(c.killRadius or ""),
                    expense = tostring(c.expense or ""),
                    consumable = c.consumable == true,
                    sourceCategory = tostring(c.sourceCategory or ""),
                    notes = tostring(c.notes or "")
                })
            end

        elseif c and c.kind == "armor" then
            local exists = false
            for _, a in ipairs(state.importedArmor or {}) do
                if string.lower(tostring(a.name or "")) == key then
                    exists = true
                    break
                end
            end

            if not exists then
                table.insert(state.importedArmor, {
                    name = catalogDisplayName(key),
                    armor = tostring(c.armor or ""),
                    expense = tostring(c.expense or ""),
                    notes = tostring(c.notes or "")
                })
            end

            state.itemQuantities[key] =
                math.max(1, tonumber(state.itemQuantities[key]) or 1)

        else
            table.insert(migratedGear, name)
        end
    end

    state.importedGear = migratedGear

    local result = {
        all = {},
        firearms = {},
        melee = {},
        heavy = {},
        lesslethal = {},
        armor = {},
        gear = {}
    }

    local function add(category, row)
        category = category or "gear"

        if result[category] == nil then
            category = "gear"
        end

        row.category = category

        table.insert(result.all, row)
        table.insert(result[category], row)
    end

    for weaponIndex, w in ipairs(state.importedWeapons or {}) do
        local row = {
            weaponIndex = weaponIndex,
            kind = "weapon",
            name = tostring(w.name or "Weapon"),
            skill = tostring(w.skill or ""),
            range = tostring(w.range or ""),
            damage = tostring(w.damage or ""),
            lethality = tostring(w.lethality or ""),
            capacity = tostring(w.capacity or w.ammo or ""),
            ammoCurrent = w.ammoCurrent,
            caliber = tostring(w.caliber or ""),
            quantity = math.max(0, tonumber(w.quantity) or 1),
            consumable = w.consumable == true,
            sourceCategory = tostring(w.sourceCategory or ""),
            killRadius = tostring(w.killRadius or ""),
            fireMode = tostring(w.fireMode or "SINGLE"),
            accessoryMod = tonumber(w.accessoryMod) or 0,
            ap = tostring(w.ap or w.armorPiercing or ""),
            expense = tostring(w.expense or ""),
            notes = tostring(w.notes or "")
        }

        mergeCatalogIntoItem(row)

        local category = row.category or
            equipmentCategoryForName(row.name, row.skill)

        if row.sourceCategory == "Heavy Weapons" or
           row.sourceCategory == "Artillery" or
           row.sourceCategory == "Demolitions"
        then
            category = "heavy"
        end

        add(category, row)
    end

    for armorIndex, a in ipairs(state.importedArmor or {}) do
        local row = {
            armorIndex = armorIndex,
            kind = "armor",
            category = "armor",
            name = tostring(a.name or "Armor"),
            armor = tostring(a.armor or ""),
            expense = tostring(a.expense or ""),
            notes = tostring(a.notes or ""),
            quantity = math.max(
                1,
                tonumber(state.itemQuantities[string.lower(tostring(a.name or ""))]) or 1
            )
        }

        mergeCatalogIntoItem(row)
        add("armor", row)
    end

    local seenGear = {}

    for _, g in ipairs(state.importedGear or {}) do
        local name = tostring(g or "")
        local key = string.lower(name)

        if not seenGear[key] then
            seenGear[key] = true

            local row = {
                name = name,
                gearKey = key
            }

            mergeCatalogIntoItem(row)

            if row.kind == nil or row.kind == "" then
                row.kind = "gear"
            end

            row.quantity = math.max(
                0,
                tonumber(state.itemQuantities[key]) or 1
            )

            local category = row.category or
                equipmentCategoryForName(row.name, row.skill or "")

            if category ~= "firearms" and
               category ~= "melee" and
               category ~= "heavy" and
               category ~= "lesslethal" and
               category ~= "armor"
            then
                category = "gear"
            end

            add(category, row)
        end
    end

    return result
end

local function equipmentCategoryLabel(category)
    local labels = {
        firearms = "FIREARMS",
        melee = "MELEE",
        heavy = "HEAVY / EXPLOSIVES",
        lesslethal = "LESS-LETHAL",
        armor = "ARMOR",
        gear = "GEAR"
    }

    return labels[category] or string.upper(tostring(category or "ITEM"))
end

local equipmentRollTargets = {}

local function equipmentCategoryColor(category)
    -- Keep equipment category labels inside the active sheet theme instead of
    -- introducing unrelated blue/red/purple category colors.
    local accentName = tostring(state.uiAccentColor or "Green")
    local accent = UI_ACCENT_COLORS[accentName] or UI_ACCENT_COLORS["Green"]
    return accent.title or "#A7C8B0"
end



local function weaponIsThrowableOrConsumable(info)
    if not info then return false end
    if info.consumable ~= nil then return info.consumable == true end

    local name = string.lower(tostring(info.name or ""))

    if name:find("launcher",1,true) or name:find("machine gun",1,true) then
        return false
    end

    local words = {
        "hand grenade", "fragmentation grenade", "stun grenade",
        "smoke grenade", "tear gas grenade", "flashbang", "flash-bang",
        "ied", "pipe bomb", "car bomb", "bomb", "mine", "molotov",
        "demolition charge", "blasting charge", "satchel charge"
    }

    for _, word in ipairs(words) do
        if name:find(word, 1, true) then return true end
    end
    return false
end

local function weaponSupportsSelectiveFire(info)
    if not info then return false end

    local cap = tonumber(tostring(info.capacity or ""):match("(%d+)"))
    local lethality = tonumber(tostring(info.lethality or ""):match("(%d+)")) or 0

    if not cap or lethality <= 0 then
        return false
    end

    local source = tostring(info.sourceCategory or "")
    local name = string.lower(tostring(info.name or ""))

    -- Automatic-capable firearms from the normal Firearms catalog.
    if source == "Firearms" then
        return true
    end

    -- Heavy Weapons that are actually automatic guns, rather than launchers,
    -- flamethrowers, rockets, grenades, etc.
    local autoWords = {
        "machine gun",
        "minigun",
        "autocannon",
        "m249",
        "rpk",
        "m240",
        "pkm",
        "m60",
        "m2hb"
    }

    for _, word in ipairs(autoWords) do
        if name:find(word, 1, true) then
            return true
        end
    end

    return false
end

local function selectedFireModeForWeapon(info)
    if not weaponSupportsSelectiveFire(info) then
        return "SINGLE"
    end

    local mode = tostring(info.fireMode or "SINGLE")
    if mode ~= "SINGLE" and mode ~= "BURST" and mode ~= "AUTO" then
        mode = "SINGLE"
    end
    return mode
end

local function ammoCostForFireMode(mode)
    mode = tostring(mode or "SINGLE")

    -- DG abstraction used by the sheet:
    -- SINGLE = ordinary attack
    -- BURST  = short burst (3 rounds)
    -- AUTO   = short spray (10 rounds)
    if mode == "BURST" then return 3 end
    if mode == "AUTO" then return 10 end
    return 1
end

-- Decide whether a successful attack resolves with normal damage or Lethality.
-- This keeps the player from having to choose between two rule paths manually.
local function weaponUsesLethalityForMode(info, fireMode)
    if not info then return false end

    local rating = tonumber(tostring(info.lethality or ""):match("(%d+)")) or 0
    if rating <= 0 then return false end

    local damage = tostring(info.damage or "")
    local hasOrdinaryDamage = damage ~= "" and damage ~= "—"

    -- Weapons with only a Lethality rating always use Lethality after a hit.
    if not hasOrdinaryDamage then
        return true
    end

    -- Grenades, explosives, mines, bombs, etc. use their Lethality rating
    -- when one is provided, even if the catalog also carries auxiliary damage data.
    if weaponIsThrowableOrConsumable(info) then
        return true
    end

    -- Selective-fire guns use ordinary damage on SINGLE and Lethality on BURST/AUTO.
    local mode = tostring(fireMode or selectedFireModeForWeapon(info))
    if mode ~= "SINGLE" and weaponSupportsSelectiveFire(info) then
        return true
    end

    return false
end

local weaponAmmoKey
local weaponAmmoLabel
local getSharedAmmoReserve
local setSharedAmmoReserve
local addSharedAmmoReserve
local migrateLegacyWeaponReservesToPools

local function buildCategorizedEquipmentRows(items)
    if #items == 0 then
        return [[
          <Text text="No items in this category."
              rectAlignment="UpperLeft"
              width="1050" height="40"
              offsetXY="0 0"
              fontSize="17"
              color="#829287"
              alignment="MiddleLeft"/>
        ]]
    end

    local xml = ""
    local y = 0

    equipmentRollTargets = {}

    for itemIndex, item in ipairs(items) do
        local statLine = ""
        local noteLine = tostring(item.notes or "")

        if item.kind == "weapon" then
            local parts = {}

            local function addPart(label, value)
                value = tostring(value or "")
                if value ~= "" and value ~= "—" then
                    table.insert(parts, label .. ": " .. value)
                end
            end

            addPart("SKILL", item.skill)
            addPart("RANGE", item.range)
            addPart("DAMAGE", item.damage)
            addPart("LETHALITY", item.lethality)

            addPart("AP", item.ap)
            addPart("BLAST", item.killRadius)
            addPart("EXPENSE", item.expense)

            statLine = table.concat(parts, "   |   ")

        elseif item.kind == "armor" then
            local parts = {}

            if tostring(item.armor or "") ~= "" then
                table.insert(parts, "ARMOR: " .. tostring(item.armor))
            end

            if tostring(item.expense or "") ~= "" then
                table.insert(parts, "EXPENSE: " .. tostring(item.expense))
            end

            statLine = table.concat(parts, "   |   ")

        else
            local parts = {}

            if tostring(item.type or "") ~= "" then
                table.insert(parts, "TYPE: " .. tostring(item.type))
            end

            if tostring(item.expense or "") ~= "" then
                table.insert(parts, "EXPENSE: " .. tostring(item.expense))
            end

            statLine = table.concat(parts, "   |   ")
        end

        if statLine == "" then
            statLine = "No additional stat data available."
        end

        local weaponRollButton = ""

        if item.kind == "weapon" then
            local attackId = "equipment_attack_" .. tostring(itemIndex)
            local damageId = "equipment_damage_" .. tostring(itemIndex)
            local lethalityId = "equipment_lethality_" .. tostring(itemIndex)

            local info = {
                name = tostring(item.name or "Weapon"),
                skill = tostring(item.skill or ""),
                damage = tostring(item.damage or ""),
                lethality = tostring(item.lethality or ""),
                weaponIndex = item.weaponIndex,
                capacity = tostring(item.capacity or ""),
                ammoCurrent = item.ammoCurrent,
                caliber = tostring(item.caliber or ""),
                quantity = tonumber(item.quantity) or 1,
                consumable = item.consumable == true,
                killRadius = tostring(item.killRadius or ""),
                sourceCategory = tostring(item.sourceCategory or ""),
                fireMode = tostring(item.fireMode or "SINGLE"),
                accessoryMod = tonumber(item.accessoryMod) or 0,
                ap = tostring(item.ap or ""),
                range = tostring(item.range or "")
            }

            equipmentRollTargets[attackId] = info
            equipmentRollTargets[damageId] = info
            equipmentRollTargets[lethalityId] = info

            local attackButton = ""
            local damageButton = ""
            local lethalityButton = ""

            if info.skill ~= "" then
                local pending = state.pendingWeaponRoll
                local pendingMatches = false

                if pending then
                    local pendingIndex = tonumber(pending.weaponIndex)
                    local infoIndex = tonumber(info.weaponIndex)

                    pendingMatches =
                        (pendingIndex and infoIndex and pendingIndex == infoIndex) or
                        (not pendingIndex and tostring(pending.weaponName or "") == tostring(info.name or ""))
                end

                local buttonText = "ATTACK D%"
                local buttonColor = "#355943"
                local buttonWidth = 220

                if pendingMatches then
                    if pending.phase == "damage" then
                        buttonText = "ROLL DAMAGE " .. tostring(info.damage or "")
                        buttonColor = "#355845"
                    elseif pending.phase == "lethality" then
                        buttonText = "ROLL LETHALITY " .. tostring(pending.rating or info.lethality or "") .. "%"
                        buttonColor = "#355845"
                    elseif pending.phase == "rolling" then
                        buttonText = "ROLLING..."
                        buttonColor = "#293A31"
                    end
                end

                attackButton = string.format([[
                  <Button id="%s"
                      onClick="rollEquipmentWeapon"
                      text="%s"
                      rectAlignment="UpperRight"
                      width="%d" height="30"
                      offsetXY="-18 -8"
                      fontSize="12"
                      fontStyle="Bold"
                      color="%s"
                      textColor="#FFFFFF"/>
                ]], esc(attackId), esc(buttonText), buttonWidth, buttonColor)
            end

            local trackerButtons = ""

            if tonumber(info.weaponIndex) then
                local wi = tonumber(info.weaponIndex)
                local cap = tonumber(tostring(info.capacity or ""):match("(%d+)"))
                local currentAmmo = tonumber(info.ammoCurrent)
                if cap and currentAmmo == nil then currentAmmo = cap end

                local modeButton = ""

                if weaponSupportsSelectiveFire(info) then
                    modeButton = string.format([[
                      <Button id="equipment_mode_%d"
                          onClick="cycleWeaponFireMode"
                          text="%s"
                          rectAlignment="UpperRight"
                          width="92" height="28"
                          offsetXY="-334 -35"
                          fontSize="10"
                          color="#355845"
                          textColor="#FFFFFF"/>
                    ]], wi, esc(tostring(info.fireMode or "SINGLE")))
                end

                local ammoControls = ""
                if cap and not weaponIsThrowableOrConsumable(info) then
                    ammoControls = string.format([[
                      <Text text="MAG"
                          rectAlignment="UpperRight"
                          width="40" height="24"
                          offsetXY="-234 -47"
                          fontSize="11" color="#A9B8AD"
                          alignment="MiddleCenter"/>
                      <Button id="equipment_ammo_minus_%d" onClick="adjustWeaponAmmo"
                          text="-" rectAlignment="UpperRight"
                          width="30" height="28" offsetXY="-188 -46"
                          fontSize="16" color="#293A31" textColor="#FFFFFF"/>
                      <Text id="equipment_ammo_count_%d" text="%d/%d"
                          rectAlignment="UpperRight"
                          width="58" height="28" offsetXY="-132 -46"
                          fontSize="13" fontStyle="Bold" color="#DCE8DF"
                          alignment="MiddleCenter"/>
                      <Button id="equipment_ammo_plus_%d" onClick="adjustWeaponAmmo"
                          text="+" rectAlignment="UpperRight"
                          width="30" height="28" offsetXY="-82 -46"
                          fontSize="16" color="#355845" textColor="#FFFFFF"/>
                      <Button id="equipment_reload_%d" onClick="reloadWeapon"
                          text="RELOAD" rectAlignment="UpperRight"
                          width="62" height="28" offsetXY="-12 -46"
                          fontSize="10" color="#355845" textColor="#FFFFFF"/>
                    ]], wi, wi, currentAmmo or 0, cap, wi, wi)
                end

                local reserveControls = ""

                if cap and not weaponIsThrowableOrConsumable(info) then
                    local reserveWeapon =
                        state.importedWeapons[wi] or info
                    local reserve = getSharedAmmoReserve(reserveWeapon)
                    local reserveLabel = weaponAmmoLabel(reserveWeapon)

                    reserveControls = string.format([[
                      <Text id="equipment_reserve_label_%d" text="%s RESERVE"
                          rectAlignment="UpperRight"
                          width="124" height="28"
                          offsetXY="-302 -82"
                          fontSize="9" color="#A9B8AD"
                          alignment="MiddleCenter"/>
                      <Button id="equipment_reserve_minus_%d" onClick="adjustWeaponReserve"
                          text="-10"
                          rectAlignment="UpperRight"
                          width="42" height="28"
                          offsetXY="-176 -82"
                          fontSize="11"
                          color="#293A31"
                          textColor="#FFFFFF"/>
                      <Text id="equipment_reserve_count_%d" text="%d"
                          rectAlignment="UpperRight"
                          width="54" height="28"
                          offsetXY="-120 -82"
                          fontSize="13"
                          fontStyle="Bold"
                          color="#DCE8DF"
                          alignment="MiddleCenter"/>
                      <Button id="equipment_reserve_plus_%d" onClick="adjustWeaponReserve"
                          text="+10"
                          rectAlignment="UpperRight"
                          width="42" height="28"
                          offsetXY="-64 -82"
                          fontSize="11"
                          color="#355845"
                          textColor="#FFFFFF"/>
                    ]], wi, esc(reserveLabel), wi, wi, reserve, wi)
                end

                local qtyControls = ""

                if weaponIsThrowableOrConsumable(info) then
                    local qty = math.max(0, tonumber(info.quantity) or 1)

                    qtyControls = string.format([[
                      <Text text="QTY"
                          rectAlignment="UpperRight"
                          width="40" height="24"
                          offsetXY="-234 -82"
                          fontSize="11" color="#A9B8AD"
                          alignment="MiddleCenter"/>
                      <Button id="equipment_qty_minus_%d" onClick="adjustWeaponQuantity"
                          text="-" rectAlignment="UpperRight"
                          width="30" height="28" offsetXY="-188 -82"
                          fontSize="16" color="#293A31" textColor="#FFFFFF"/>
                      <Text id="equipment_qty_count_%d" text="%d"
                          rectAlignment="UpperRight"
                          width="48" height="28" offsetXY="-132 -82"
                          fontSize="13" fontStyle="Bold" color="#DCE8DF"
                          alignment="MiddleCenter"/>
                      <Button id="equipment_qty_plus_%d" onClick="adjustWeaponQuantity"
                          text="+" rectAlignment="UpperRight"
                          width="30" height="28" offsetXY="-84 -82"
                          fontSize="16" color="#355845" textColor="#FFFFFF"/>
                    ]], wi, wi, qty, wi)
                end

                trackerButtons = modeButton .. ammoControls .. reserveControls .. qtyControls
            end

            weaponRollButton =
                attackButton .. damageButton .. lethalityButton ..
                trackerButtons

        elseif item.kind == "armor" and tonumber(item.armorIndex) then
            local active = tonumber(state.activeArmorIndex) == tonumber(item.armorIndex)

            weaponRollButton = string.format([[
              <Button id="armor_select_%d"
                  onClick="selectActiveArmor"
                  text="%s"
                  rectAlignment="UpperRight"
                  width="115" height="30"
                  offsetXY="-18 -6"
                  fontSize="12"
                  color="%s"
                  textColor="#FFFFFF"/>
            ]],
                tonumber(item.armorIndex),
                active and "EQUIPPED" or "EQUIP",
                active and "#355845" or "#293A31"
            )

        end

        local equipmentManageButtons = ""
        if item.kind == "weapon" and tonumber(item.weaponIndex) then
            equipmentManageButtons = string.format([[
              <Button id="equipment_remove_weapon_%d" onClick="removeEquipmentItem"
                  text="REMOVE" rectAlignment="UpperLeft" width="64" height="26"
                  offsetXY="10 -7" fontSize="9" color="#5B3030" textColor="#FFFFFF"/>
              <Button id="equipment_replace_weapon_%d" onClick="beginReplaceEquipmentItem"
                  text="REPLACE" rectAlignment="UpperLeft" width="72" height="26"
                  offsetXY="78 -7" fontSize="9" color="#355845" textColor="#FFFFFF"/>
            ]], tonumber(item.weaponIndex), tonumber(item.weaponIndex))
        elseif item.kind == "armor" and tonumber(item.armorIndex) then
            equipmentManageButtons = string.format([[
              <Button id="equipment_remove_armor_%d" onClick="removeEquipmentItem"
                  text="REMOVE" rectAlignment="UpperLeft" width="64" height="26"
                  offsetXY="10 -7" fontSize="9" color="#5B3030" textColor="#FFFFFF"/>
              <Button id="equipment_replace_armor_%d" onClick="beginReplaceEquipmentItem"
                  text="REPLACE" rectAlignment="UpperLeft" width="72" height="26"
                  offsetXY="78 -7" fontSize="9" color="#355845" textColor="#FFFFFF"/>
            ]], tonumber(item.armorIndex), tonumber(item.armorIndex))
        elseif item.kind == "gear" and tostring(item.gearKey or "") ~= "" then
            local safeGear = tostring(item.gearKey):gsub("[^%w]","_")
            equipmentManageButtons = string.format([[
              <Button id="equipment_remove_gear_%s" onClick="removeEquipmentItem"
                  text="REMOVE" rectAlignment="UpperLeft" width="64" height="26"
                  offsetXY="10 -7" fontSize="9" color="#5B3030" textColor="#FFFFFF"/>
              <Button id="equipment_replace_gear_%s" onClick="beginReplaceEquipmentItem"
                  text="REPLACE" rectAlignment="UpperLeft" width="72" height="26"
                  offsetXY="78 -7" fontSize="9" color="#355845" textColor="#FFFFFF"/>
            ]], esc(safeGear), esc(safeGear))
        end

        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1050" height="142"
              offsetXY="0 %d"
              color="#111A15CC">

            %s

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="135" height="24"
                offsetXY="158 -7"
                fontSize="13"
                fontStyle="Bold"
                color="%s"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="405" height="28"
                offsetXY="300 -5"
                fontSize="18"
                fontStyle="Bold"
                color="#E3EEE6"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="675" height="44"
                offsetXY="20 -55"
                fontSize="13"
                color="#D5E1D8"
                alignment="MiddleLeft"
                horizontalOverflow="Wrap"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="675" height="30"
                offsetXY="20 -101"
                fontSize="12"
                color="#95A59A"
                alignment="MiddleLeft"
                horizontalOverflow="Wrap"/>

            %s

          </Panel>
        ]],
            -y,
            equipmentManageButtons,
            esc(equipmentCategoryLabel(item.category)),
            equipmentCategoryColor(item.category),
            esc(item.name),
            esc(statLine),
            esc(noteLine),
            weaponRollButton
        )

        y = y + 150
    end

    return xml
end


local function equipmentTabButtonCompact(id, label, active, x, width, y)
    y = tonumber(y) or -16
    local baseColor = equipmentCategoryColor(id)
    if id == "all" then baseColor = "#355845" end
    if id == "notes" then baseColor = "#563C6B" end
    if id == "dice" then baseColor = "#2D625E" end
    if id == "add" then baseColor = "#355845" end
    if id == "funds" then baseColor = "#6A552B" end

    return string.format([[
      <Button id="equipment_tab_%s"
          onClick="switchEquipmentSubtab"
          text="%s"
          rectAlignment="UpperLeft"
          width="%d" height="40"
          offsetXY="%d %d"
          fontSize="14"
          color="%s"
          textColor="#FFFFFF"/>
    ]],
        id,
        esc(label),
        width,
        x,
        y,
        active and baseColor or "#223229"
    )
end


local function activeArmorInfo()
    ensureStructuredImportState()
    local i = tonumber(state.activeArmorIndex) or 1
    local a = state.importedArmor[i]

    if not a then
        return nil, 0
    end

    local value = tonumber(tostring(a.armor or ""):match("(%d+)")) or 0
    return a, value
end

local function buildArmorAutomationPanel()
    local armor, armorValue = activeArmorInfo()
    local armorName = armor and tostring(armor.name or "Armor") or "NONE"

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1050" height="112"
          offsetXY="0 0" color="#111A15CC">
        <Text text="ACTIVE ARMOR: %s (%d)"
            rectAlignment="UpperLeft" width="430" height="32"
            offsetXY="14 -8" fontSize="17" fontStyle="Bold"
            color="#DCE2E4" alignment="MiddleLeft"/>
        <Text text="INCOMING DAMAGE"
            rectAlignment="UpperLeft" width="150" height="24"
            offsetXY="14 -48" fontSize="12" color="#A9B8AD"/>
        <InputField id="incomingDamage" text="%s"
            onEndEdit="editField" characterValidation="Integer"
            rectAlignment="UpperLeft" width="90" height="36"
            offsetXY="155 -44" fontSize="16"
            textColor="#FFFFFF" color="#17201B"/>
        <Text text="AP"
            rectAlignment="UpperLeft" width="40" height="24"
            offsetXY="265 -48" fontSize="12" color="#A9B8AD"/>
        <InputField id="incomingAP" text="%s"
            onEndEdit="editField" characterValidation="Integer"
            rectAlignment="UpperLeft" width="70" height="36"
            offsetXY="300 -44" fontSize="16"
            textColor="#FFFFFF" color="#17201B"/>
        <Button id="apply_incoming_damage" onClick="applyIncomingDamage"
            text="APPLY DAMAGE"
            rectAlignment="UpperLeft" width="190" height="38"
            offsetXY="390 -43" fontSize="14" fontStyle="Bold"
            color="#6B3535" textColor="#FFFFFF"/>
        <Text text="Effective armor = Armor − AP (minimum 0). Final damage is applied to HP and synced to Handler."
            rectAlignment="UpperLeft" width="430" height="62"
            offsetXY="600 -37" fontSize="13" color="#A9B8AD"
            alignment="MiddleLeft" horizontalOverflow="Wrap"/>
      </Panel>
    ]], esc(armorName), armorValue,
        esc(tostring(state.incomingDamage or "0")),
        esc(tostring(state.incomingAP or "0")))
end




local function catalogItemExpense(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item then return "—" end

    local expense = tostring(item.expense or "")
    if expense == "" then expense = "—" end
    return expense
end

local function catalogItemDetailsText(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item then return "Select an item." end

    local pieces = {
        "TYPE: " .. string.upper(tostring(item.kind or "gear"))
    }

    if tostring(item.subcategory or "") ~= "" then
        table.insert(pieces, "CLASS: " .. tostring(item.subcategory))
    end

    if tostring(item.variantSpec or "") ~= "" then
        table.insert(pieces, "CONFIGURABLE CALIBER / MAGAZINE")
    elseif tostring(item.caliber or "") ~= "" and
           tostring(item.caliber or "") ~= "various"
    then
        table.insert(pieces, "CALIBER: " .. tostring(item.caliber))
    end

    if item.kind == "weapon" then
        table.insert(pieces, "SKILL: " .. tostring(item.skill or "—"))
        table.insert(pieces, "RANGE: " .. tostring(item.range or "—"))

        if tostring(item.damage or "") ~= "" then
            table.insert(pieces, "DAMAGE: " .. tostring(item.damage))
        end

        local lethality =
            tonumber(tostring(item.lethality or ""):match("(%d+)"))

        if lethality and lethality > 0 then
            table.insert(pieces, "LETHALITY: " .. tostring(item.lethality))
        end

        if tostring(item.ap or "") ~= "" then
            table.insert(pieces, "AP: " .. tostring(item.ap))
        end

        if tostring(item.killRadius or "") ~= "" and
           tostring(item.killRadius or "") ~= "N/A"
        then
            table.insert(pieces, "BLAST: " .. tostring(item.killRadius))
        end

        if tostring(item.variantSpec or "") == "" and
           tostring(item.capacity or "") ~= ""
        then
            table.insert(pieces, "MAG/CAPACITY: " .. tostring(item.capacity))
        end

    elseif item.kind == "armor" then
        table.insert(pieces, "ARMOR: " .. tostring(item.armor or "—"))
    end

    return table.concat(pieces, "\n")
end

local function cleanCatalogDescription(text)
    text = tostring(text or "")
    text = text:gsub("<br%s*/?>", " ")
    text = text:gsub("</p>", " ")
    text = text:gsub("<[^>]+>", "")
    text = text:gsub("&amp;", "&")
    text = text:gsub("&quot;", '"')
    text = text:gsub("&#39;", "'")
    text = text:gsub("%s+", " ")
    return text
end

local function displayCatalogSkill(skill)
    local map = {
        firearms="Firearms", heavy_weapons="Heavy Weapons",
        melee_weapons="Melee Weapons", unarmed_combat="Unarmed Combat",
        demolitions="Demolitions", artillery="Artillery",
        athletics="Athletics", dex="DEX×5", throw="Athletics"
    }
    return map[string.lower(tostring(skill or ""))] or tostring(skill or "")
end

local function catalogItemSubcategory(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item then return "Other" end

    local sub = tostring(item.subcategory or "")
    local source = tostring(item.sourceCategory or "")

    if source == "Firearms" then
        if sub == "Pistols" then
            local name = string.lower(tostring(item.name or ""))
            local caliber = string.lower(tostring(item.caliber or ""))

            if name == "light pistol" or
               caliber == ".22 lr" or caliber == ".22 short" or
               caliber == ".25 acp" or caliber == ".32 acp" or
               caliber == ".32 h&r magnum" or caliber == ".380 acp" or
               caliber == ".38 special"
            then
                return "Light Pistols"

            elseif name == "heavy pistol" or
                   caliber == ".357 magnum" or caliber == ".44 magnum" or
                   caliber == ".41 magnum" or caliber == "10mm auto" or
                   caliber == ".50 ae" or caliber == ".454 casull" or
                   caliber == ".500 s&w magnum"
            then
                return "Heavy Pistols"
            end

            return "Medium Pistols"
        elseif sub == "Carbines" or sub == "Pistol-Caliber Carbines" or sub == "Assault Rifles" then
            return "Light Rifles / Carbines"
        elseif sub == "Battle Rifles" or sub == "Marksman Rifles" then
            return "Heavy Rifles"
        elseif sub == "Heavy Snipers" then
            return "Very Heavy Rifles"
        elseif sub == "SMGs" then
            return "SMGs"
        elseif sub == "Shotguns" then
            return "Shotguns"
        end
    end

    return sub
end

local function catalogItemDetailsXml(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item then return "", 0 end

    local rows = {}
    local function add(label, value, allowBlank)
        value = tostring(value or "")
        if value ~= "" or allowBlank then
            if value == "" then value = "N/A" end
            table.insert(rows, {label=label, value=value})
        end
    end

    if item.kind == "weapon" then
        add("TYPE", "Weapon")
        local cls = catalogItemSubcategory(key)
        if cls == "" then cls = tostring(item.sourceCategory or "Weapon") end
        add("WEAPON CLASS", cls)
        if tostring(item.caliber or "") ~= "" and string.lower(tostring(item.caliber)) ~= "various" then
            add("CALIBER", item.caliber)
        end
        add("SKILL", displayCatalogSkill(item.skill), true)
        add("RANGE", item.range, true)
        if tostring(item.damage or "") ~= "" then add("DAMAGE", item.damage) end
        if tostring(item.lethality or "") ~= "" then add("LETHALITY", item.lethality) end
        local apValue = tonumber(tostring(item.ap or ""):match("(%d+)")) or 0
        if apValue > 0 then add("ARMOR PIERCING", tostring(apValue)) end
        if tostring(item.killRadius or "") ~= "" and tostring(item.killRadius) ~= "N/A" then
            add("BLAST RADIUS", item.killRadius)
        end
        if tostring(item.capacity or "") ~= "" then
            add("MAG / CAPACITY", item.capacity)
        end

    elseif item.kind == "armor" then
        add("TYPE", "Body Armor")
        add("ARMOR RATING", item.armor, true)
        local d = cleanCatalogDescription(item.description)
        if d ~= "" then add("NOTES", d) end

    else
        add("TYPE", "Gear")
        local sub = catalogItemSubcategory(key)
        add("GEAR CATEGORY", sub ~= "" and sub or "Other Gear")
        local d = cleanCatalogDescription(item.description)
        if d ~= "" then add("DETAILS", d) end
    end

    local xml = ""
    local y = 0
    for _, row in ipairs(rows) do
        local h = (row.label == "DETAILS" or row.label == "NOTES") and 34 or 17
        xml = xml .. string.format([[
          <Text text="%s: %s" rectAlignment="UpperLeft"
              width="250" height="%d" offsetXY="18 %d"
              fontSize="10" color="#D5E1D8" alignment="UpperLeft"
              horizontalOverflow="Wrap"/>
        ]], esc(row.label), esc(row.value), h, -y)
        y = y + h
    end
    return xml, y
end


local function catalogItemMagazineCapacity(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item or item.kind ~= "weapon" then return nil end

    return tonumber(tostring(item.capacity or ""):match("(%d+)"))
end

local function parseCatalogVariants(item)
    local result = {}
    local spec = tostring(item and item.variantSpec or "")

    if spec ~= "" then
        for group in spec:gmatch("[^;]+") do
            local caliber, caps = group:match("^%s*(.-)%s*=%s*(.-)%s*$")
            if caliber and caliber ~= "" then
                local capacities = {}
                for cap in tostring(caps or ""):gmatch("[^/]+") do
                    local n = tonumber(tostring(cap):match("(%d+)"))
                    if n then table.insert(capacities, n) end
                end
                table.insert(result, {
                    caliber = caliber,
                    capacities = capacities
                })
            end
        end
    end

    if #result == 0 and item then
        local caliber = tostring(item.caliber or "")
        local cap = tonumber(tostring(item.capacity or ""):match("(%d+)"))
        if caliber ~= "" and string.lower(caliber) ~= "various" then
            table.insert(result, {
                caliber = caliber,
                capacities = cap and {cap} or {}
            })
        end
    end

    return result
end

local function catalogCaliberOptions(key)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    local result = {}
    for _, variant in ipairs(parseCatalogVariants(item)) do
        table.insert(result, tostring(variant.caliber or ""))
    end
    return result
end

local function catalogCapacityOptions(key, caliber)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    local wanted = tostring(caliber or "")
    for _, variant in ipairs(parseCatalogVariants(item)) do
        if wanted == "" or tostring(variant.caliber or "") == wanted then
            local result = {}
            for _, cap in ipairs(variant.capacities or {}) do
                table.insert(result, tostring(cap))
            end
            return result
        end
    end
    local cap = catalogItemMagazineCapacity(key)
    return cap and {tostring(cap)} or {}
end

local function catalogItemMatchesCaliberFilter(key, filter)
    filter = tostring(filter or "ALL")
    if filter == "" or filter == "ALL" then return true end

    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    if not item or tostring(item.sourceCategory or "") ~= "Firearms" then
        return false
    end

    for _, caliber in ipairs(catalogCaliberOptions(key)) do
        if caliber == filter then return true end
    end

    return tostring(item.caliber or "") == filter
end

local function catalogAvailableCalibers(category, subcategory)
    if tostring(category or "") ~= "Firearms" then return {"ALL"} end

    local found = {}
    for _, key in ipairs(sortedCatalogNamesForCategory("Firearms")) do
        local item = EQUIPMENT_CATALOG[key]
        if (not subcategory or subcategory == "" or
            tostring(item and item.subcategory or "") == tostring(subcategory))
        then
            for _, caliber in ipairs(catalogCaliberOptions(key)) do
                if caliber ~= "" and string.lower(caliber) ~= "various" then
                    found[caliber] = true
                end
            end
        end
    end

    local values = {}
    for caliber in pairs(found) do table.insert(values, caliber) end
    table.sort(values)

    local result = {"ALL"}
    for _, caliber in ipairs(values) do table.insert(result, caliber) end
    return result
end

local function plainDropdownOptions(values, selected)
    local xml = ""
    selected = tostring(selected or "")
    for _, value in ipairs(values or {}) do
        value = tostring(value)
        xml = xml .. string.format(
            '<Option value="%s"%s>%s</Option>',
            esc(value),
            value == selected and ' selected="true"' or "",
            esc(value)
        )
    end
    return xml
end

local function selectedCatalogCaliber(key)
    key = tostring(key or "")
    local options = catalogCaliberOptions(key)
    local selected = tostring(state.addSelectedCaliber or "")

    for _, value in ipairs(options) do
        if value == selected then return selected end
    end

    local item = EQUIPMENT_CATALOG[key]
    local fallback = tostring(item and item.caliber or "")
    if #options > 0 then fallback = options[1] end
    state.addSelectedCaliber = fallback
    return fallback
end

local function selectedCatalogCapacity(key)
    key = tostring(key or "")
    local caliber = selectedCatalogCaliber(key)
    local options = catalogCapacityOptions(key, caliber)
    local selected = tostring(state.addSelectedCapacity or "")

    for _, value in ipairs(options) do
        if value == selected then return tonumber(selected) end
    end

    if #options > 0 then
        state.addSelectedCapacity = tostring(options[1])
        return tonumber(options[1])
    end

    state.addSelectedCapacity = ""
    return catalogItemMagazineCapacity(key)
end

local function catalogVariantCapacityDropdownsXml(key, chosenCaliber, chosenCapacity)
    local item = EQUIPMENT_CATALOG[tostring(key or "")]
    local variants = parseCatalogVariants(item)
    local xml = ""

    for index, variant in ipairs(variants) do
        local values = {}
        for _, cap in ipairs(variant.capacities or {}) do
            table.insert(values, tostring(cap))
        end

        local selected = ""
        if tostring(variant.caliber or "") == tostring(chosenCaliber or "") then
            selected = tostring(chosenCapacity or "")
        elseif #values > 0 then
            selected = tostring(values[1])
        end

        xml = xml .. string.format([[
            <Dropdown id="equipment_variant_capacity_%d"
                active="%s"
                onValueChanged="selectCatalogVariantCapacity"
                rectAlignment="UpperLeft" width="105" height="32" offsetXY="132 -28"
                fontSize="11" color="#1D2B24" textColor="#F1F7F2"
                itemTextColor="#F1F7F2"
                itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
                dropdownBackgroundColor="#0F1210"
                checkColor="#9BC3A4" arrowColor="#FFFFFF"
                dropdownHeight="260" itemHeight="30">%s</Dropdown>
        ]],
            index,
            tostring(variant.caliber or "") == tostring(chosenCaliber or "") and "true" or "false",
            plainDropdownOptions(values, selected)
        )
    end

    return xml
end


local function resetSelectedCatalogVariant(key)
    state.addSelectedCaliber = ""
    state.addSelectedCapacity = ""
    if tostring(key or "") ~= "" then
        selectedCatalogCapacity(key)
    end
end



local function normalizeAmmoKey(caliber)
    local raw = tostring(caliber or "")
    local lower = string.lower(raw)

    if lower == "" or lower == "various" or lower == "—" or lower == "n/a" then
        return nil
    end

    lower = lower:gsub("%s+", "")
    lower = lower:gsub("×", "x")
    lower = lower:gsub("mmnato", "mm")
    lower = lower:gsub("parabellum", "")
    lower = lower:gsub("luger", "")
    lower = lower:gsub("%.0", "")
    return lower
end

weaponAmmoKey = function(weapon)
    if not weapon then return nil end

    local caliber = tostring(weapon.caliber or "")
    if caliber == "" then
        local catalog = catalogEntryForItem(weapon.name)
        if catalog then
            caliber = tostring(catalog.caliber or "")
        end
    end

    local key = normalizeAmmoKey(caliber)
    if key then return key end

    -- Unknown/generic calibers must not accidentally share ammunition.
    return "weapon:" .. string.lower(tostring(weapon.name or "unknown"))
end

weaponAmmoLabel = function(weapon)
    if not weapon then return "AMMO" end

    local caliber = tostring(weapon.caliber or "")
    if caliber == "" then
        local catalog = catalogEntryForItem(weapon.name)
        if catalog then caliber = tostring(catalog.caliber or "") end
    end

    if caliber == "" or string.lower(caliber) == "various" then
        return "AMMO"
    end

    return caliber
end

getSharedAmmoReserve = function(weapon)
    state.ammoPools = state.ammoPools or {}
    local key = weaponAmmoKey(weapon)
    if not key then return 0 end
    return math.max(0, math.floor(tonumber(state.ammoPools[key]) or 0))
end

setSharedAmmoReserve = function(weapon, amount)
    state.ammoPools = state.ammoPools or {}
    local key = weaponAmmoKey(weapon)
    if not key then return end
    state.ammoPools[key] = math.max(0, math.floor(tonumber(amount) or 0))
end

addSharedAmmoReserve = function(weapon, amount)
    local current = getSharedAmmoReserve(weapon)
    setSharedAmmoReserve(weapon, current + math.floor(tonumber(amount) or 0))
end

migrateLegacyWeaponReservesToPools = function()
    state.ammoPools = state.ammoPools or {}

    for _, w in ipairs(state.importedWeapons or {}) do
        local legacy = math.max(0, math.floor(tonumber(w.ammoReserve) or 0))
        if legacy > 0 then
            addSharedAmmoReserve(w, legacy)
            w.ammoReserve = 0
        end
    end
end

local function selectedCatalogUsesQuantity()
    local key = string.lower(tostring(state.addItemName or ""))
    local item = EQUIPMENT_CATALOG[key]
    if not item or item.kind ~= "weapon" then return false end

    local info = {
        name = catalogDisplayName(key),
        sourceCategory = tostring(item.sourceCategory or ""),
        consumable = item.consumable == true
    }

    return weaponIsThrowableOrConsumable(info)
end

local function selectedCatalogHasReserveAmmo()
    local key = string.lower(tostring(state.addItemName or ""))
    local item = EQUIPMENT_CATALOG[key]
    if not item or item.kind ~= "weapon" then return false end

    local cap = catalogItemMagazineCapacity(key)
    if not cap then return false end

    local info = {
        name = catalogDisplayName(key),
        sourceCategory = tostring(item.sourceCategory or ""),
        consumable = item.consumable == true
    }

    return not weaponIsThrowableOrConsumable(info)
end


-- Generic versions used by the Handler dashboard remote-add API.
local function catalogKeyUsesQuantity(key)
    key = string.lower(tostring(key or ""))
    local item = EQUIPMENT_CATALOG[key]
    if not item or item.kind ~= "weapon" then return false end

    local info = {
        name = catalogDisplayName(key),
        sourceCategory = tostring(item.sourceCategory or ""),
        consumable = item.consumable == true
    }

    return weaponIsThrowableOrConsumable(info)
end

local function catalogKeyHasReserveAmmo(key)
    key = string.lower(tostring(key or ""))
    local item = EQUIPMENT_CATALOG[key]
    if not item or item.kind ~= "weapon" then return false end

    if not catalogItemMagazineCapacity(key) then return false end

    local info = {
        name = catalogDisplayName(key),
        sourceCategory = tostring(item.sourceCategory or ""),
        consumable = item.consumable == true
    }

    return not weaponIsThrowableOrConsumable(info)
end

local function updateAddItemSelectionUi(previousKey, newKey)
    local helper = getCachedHelper("equipment")
    if not helper then return end

    newKey = tostring(newKey or "")

    pcall(function()
        if newKey == "" then
            helper.UI.hide("equipment_add_selected_panel")
            return
        end

        helper.UI.show("equipment_add_selected_panel")

        helper.UI.setAttribute(
            "equipment_add_selected_name",
            "text",
            catalogDisplayName(newKey)
        )

        helper.UI.setAttribute(
            "equipment_add_selected_expense",
            "text",
            catalogItemExpense(newKey)
        )

        helper.UI.setAttribute(
            "equipment_add_selected_details",
            "text",
            catalogItemDetailsText(newKey)
        )

        local cap = catalogItemMagazineCapacity(newKey)

        if selectedCatalogHasReserveAmmo() and cap then
            helper.UI.show("equipment_add_ammo_options")
            helper.UI.hide("equipment_add_quantity_options")
            local mags = math.max(0, math.floor(tonumber(state.addReserveMags) or 0))
            helper.UI.setAttribute(
                "equipment_add_mag_hint",
                "text",
                string.format(
                    "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
                    cap, mags, cap * mags
                )
            )
        elseif selectedCatalogUsesQuantity() then
            helper.UI.hide("equipment_add_ammo_options")
            helper.UI.show("equipment_add_quantity_options")
            helper.UI.setAttribute(
                "add_item_qty_count",
                "text",
                tostring(math.max(1, math.floor(tonumber(state.addItemQuantity) or 1)))
            )
        else
            helper.UI.hide("equipment_add_ammo_options")
            helper.UI.hide("equipment_add_quantity_options")
        end
    end)
end


local EQUIPMENT_SUBCATEGORY_ORDER = {
    ["Firearms"] = {
        "All",
        "Light Pistols",
        "Medium Pistols",
        "Heavy Pistols",
        "Light Rifles / Carbines",
        "Heavy Rifles",
        "Very Heavy Rifles",
        "SMGs",
        "Shotguns"
    },
    ["Heavy Weapons"] = {
        "All",
        "Demolitions",
        "Artillery"
    },
    ["Other Gear"] = {
        "All",
        "Restraints",
        "Communications and Computers",
        "Surveillance",
        "Lighting and Vision",
        "Breaking and Entering",
        "Emergency and Survival Gear"
    }
}

local function itemMatchesSubcategory(key, subcategory)
    if tostring(subcategory or "All") == "All" then
        return true
    end
    return catalogItemSubcategory(key) == tostring(subcategory)
end

local function subcategoryHasFilteredItems(category, subcategory)
    local filter = tostring(state.addCaliberFilter or "ALL")

    for _, key in ipairs(sortedCatalogNamesForCategory(category)) do
        if itemMatchesSubcategory(key, subcategory) and
           (category ~= "Firearms" or
            catalogItemMatchesCaliberFilter(key, filter))
        then
            return true
        end
    end

    return false
end

local function firstCatalogKeyForCategoryAndSubcategory(category, subcategory)
    local names = sortedCatalogNamesForCategory(category)

    local hasSubcategories = EQUIPMENT_SUBCATEGORY_ORDER[category] ~= nil

    for _, key in ipairs(names) do
        if (not hasSubcategories or itemMatchesSubcategory(key, subcategory)) and
           (tostring(category or "") ~= "Firearms" or
            catalogItemMatchesCaliberFilter(key, state.addCaliberFilter))
        then
            return key
        end
    end

    return ""
end


local function categoryHasSubcategories(category)
    return EQUIPMENT_SUBCATEGORY_ORDER[tostring(category or "")] ~= nil
end

local function browseTitle()
    local level = tostring(state.addItemBrowseLevel or "root")
    if level == "root" then return "ALL EQUIPMENT" end
    if level == "category" then
        return tostring(state.addItemCategory or "CATEGORY")
    end
    if level == "subcategory" then
        return tostring(state.addItemSubcategory or "SUBCATEGORY")
    end
    return "ALL EQUIPMENT"
end

local function buildBreadcrumbXml()
    local level = tostring(state.addItemBrowseLevel or "root")
    local xml = ""
    local x = 20

    local function chip(id, text, active)
        local width = math.max(100, math.min(250, 32 + (#tostring(text) * 9)))
        local bg = active and "#426A52" or "#223229"

        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="%d" height="32"
              offsetXY="%d -84">
            <Panel rectAlignment="MiddleCenter"
                width="%d" height="32"
                color="%s"/>
            <Text text="%s"
                rectAlignment="MiddleCenter"
                width="%d" height="28"
                fontSize="12"
                fontStyle="Bold"
                color="#FFFFFF"
                alignment="MiddleCenter"/>
            <Button id="equipment_crumb_%s"
                onClick="equipmentBreadcrumbClick"
                text=""
                rectAlignment="MiddleCenter"
                width="%d" height="32"
                color="#00000000"/>
          </Panel>
        ]],
            width, x,
            width, bg,
            esc(text), width - 12,
            esc(id), width
        )

        x = x + width + 10
    end

    chip("root", "ALL EQUIPMENT", level == "root")

    if level == "category" or level == "subcategory" then
        chip("category", tostring(state.addItemCategory or "CATEGORY"),
            level == "category")
    end

    if level == "subcategory" then
        chip("subcategory", tostring(state.addItemSubcategory or "SUBCATEGORY"),
            true)
    end

    return xml
end

local function buildBrowseLevelRows()
    local level = tostring(state.addItemBrowseLevel or "root")
    local rows = ""
    local y = 0

    local function addRow(id, text, kind)
        local safe = tostring(id or ""):gsub("[^%w]","_")
        rows = rows .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="690" height="40"
              offsetXY="0 %d">
            <Panel rectAlignment="MiddleCenter"
                width="690" height="40"
                color="#1B2821"/>
            <Text text="%s"
                rectAlignment="MiddleLeft"
                width="610" height="34"
                offsetXY="18 0"
                fontSize="14"
                fontStyle="Bold"
                color="#FFFFFF"
                alignment="MiddleLeft"/>
            <Text text="%s"
                rectAlignment="MiddleRight"
                width="50" height="34"
                offsetXY="-18 0"
                fontSize="18"
                color="#A9B8AD"
                alignment="MiddleCenter"/>
            <Button id="equipment_browse_%s_%s"
                onClick="equipmentBrowseRowClick"
                text=""
                rectAlignment="MiddleCenter"
                width="690" height="40"
                color="#00000000"/>
          </Panel>
        ]],
            -y,
            esc(text),
            kind == "item" and "" or "›",
            esc(kind), esc(safe)
        )
        y = y + 46
    end

    if level == "root" then
        for _, cat in ipairs(EQUIPMENT_ADD_CATEGORY_ORDER) do
            addRow(cat, cat, "category")
        end

    elseif level == "category" then
        local category = tostring(state.addItemCategory or "")
        local order = EQUIPMENT_SUBCATEGORY_ORDER[category]

        if order then
            for _, sub in ipairs(order) do
                if sub ~= "All" and
                   subcategoryHasFilteredItems(category, sub)
                then
                    addRow(sub, sub, "subcategory")
                end
            end

            -- Items with no rules-defined subsection stay directly in their
            -- official top-level category instead of being forced into a made-up folder.
            for _, key in ipairs(sortedCatalogNamesForCategory(category)) do
                if catalogItemSubcategory(key) == "" and
                   (category ~= "Firearms" or catalogItemMatchesCaliberFilter(key, state.addCaliberFilter))
                then
                    addRow(key, catalogDisplayName(key), "item")
                end
            end
        else
            for _, key in ipairs(sortedCatalogNamesForCategory(category)) do
                if category ~= "Firearms" or
                   catalogItemMatchesCaliberFilter(key, state.addCaliberFilter)
                then
                    addRow(key, catalogDisplayName(key), "item")
                end
            end
        end

    elseif level == "subcategory" then
        local category = tostring(state.addItemCategory or "")
        local sub = tostring(state.addItemSubcategory or "")

        for _, key in ipairs(sortedCatalogNamesForCategory(category)) do
            if itemMatchesSubcategory(key, sub) and
               (category ~= "Firearms" or
                catalogItemMatchesCaliberFilter(key, state.addCaliberFilter))
            then
                addRow(key, catalogDisplayName(key), "item")
            end
        end
    end

    if rows == "" then
        rows = [[
          <Text text="No items found at this level."
              rectAlignment="UpperLeft"
              width="650" height="40"
              offsetXY="10 0"
              fontSize="14"
              color="#A9B8AD"
              alignment="MiddleLeft"/>
        ]]
        y = 46
    end

    return rows, math.max(380, y + 12)
end

local function firstVisibleBrowseItem()
    local level = tostring(state.addItemBrowseLevel or "root")

    if level == "category" and
       not categoryHasSubcategories(state.addItemCategory)
    then
        local keys = sortedCatalogNamesForCategory(state.addItemCategory)
        return keys[1] or ""
    end

    if level == "subcategory" then
        return firstCatalogKeyForCategoryAndSubcategory(
            state.addItemCategory,
            state.addItemSubcategory
        )
    end

    return ""
end

local function buildAddItemPanel()
    ensureStructuredImportState()

    local browseRows, browseHeight = buildBrowseLevelRows()
    local selected = string.lower(tostring(state.addItemName or ""))

    if selected ~= "" and not EQUIPMENT_CATALOG[selected] then
        selected = ""
        state.addItemName = ""
    end

    local detailsXml, detailsHeight = catalogItemDetailsXml(selected)
    local expense = catalogItemExpense(selected)
    local cap = selected ~= "" and selectedCatalogCapacity(selected) or nil
    local replacing = state.equipmentReplace ~= nil
    local showAmmoOptions = (not replacing) and selected ~= "" and selectedCatalogHasReserveAmmo()
    local showQuantity = (not replacing) and selected ~= "" and selectedCatalogUsesQuantity()
    local mags = math.max(0, math.floor(tonumber(state.addReserveMags) or 0))
    local magHint = ""

    if cap then
        magHint = string.format(
            "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
            cap, mags, cap * mags
        )
    end

    local filterXml = ""
    if tostring(state.addItemCategory or "") == "Firearms" and
       tostring(state.addItemBrowseLevel or "") ~= "root"
    then
        local filterValues = catalogAvailableCalibers(
            "Firearms",
            tostring(state.addItemBrowseLevel or "") == "subcategory" and
                tostring(state.addItemSubcategory or "") or nil
        )

        local selectedFilter = tostring(state.addCaliberFilter or "ALL")
        local valid = false
        for _, value in ipairs(filterValues) do
            if value == selectedFilter then valid = true break end
        end
        if not valid then
            selectedFilter = "ALL"
            state.addCaliberFilter = "ALL"
        end

        filterXml = string.format([[
          <Text text="CALIBER" rectAlignment="UpperLeft" width="80" height="28"
              offsetXY="430 -124" fontSize="11" fontStyle="Bold" color="#A9B8AD"/>
          <Dropdown id="equipment_caliber_filter" onValueChanged="selectEquipmentCaliberFilter"
              rectAlignment="UpperLeft" width="195" height="34" offsetXY="505 -120"
              fontSize="12" color="#1D2B24" textColor="#F1F7F2"
              itemTextColor="#F1F7F2"
              itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
              dropdownBackgroundColor="#0F1210"
              checkColor="#9BC3A4" arrowColor="#FFFFFF"
              dropdownHeight="360" itemHeight="32">%s</Dropdown>
        ]], plainDropdownOptions(filterValues, selectedFilter))
    end

    local variantPanel = ""
    local item = EQUIPMENT_CATALOG[selected]
    local hasVariants = item and tostring(item.variantSpec or "") ~= ""

    if hasVariants then
        local calibers = catalogCaliberOptions(selected)
        local chosenCaliber = selectedCatalogCaliber(selected)
        local capacities = catalogCapacityOptions(selected, chosenCaliber)
        local chosenCapacity = tostring(selectedCatalogCapacity(selected) or "")

        variantPanel = string.format([[
          <Panel id="equipment_variant_options" rectAlignment="UpperLeft"
              width="250" height="82" offsetXY="18 -286" color="#101712CC">
            <Text text="CALIBER" rectAlignment="UpperLeft" width="110" height="20"
                offsetXY="8 -6" fontSize="10" fontStyle="Bold" color="#A9B8AD"/>
            <Dropdown id="equipment_variant_caliber" onValueChanged="selectCatalogVariantCaliber"
                rectAlignment="UpperLeft" width="112" height="32" offsetXY="8 -28"
                fontSize="11" color="#1D2B24" textColor="#F1F7F2"
                itemTextColor="#F1F7F2" itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
                dropdownBackgroundColor="#0F1210" checkColor="#9BC3A4" arrowColor="#FFFFFF"
                dropdownHeight="300" itemHeight="30">%s</Dropdown>
            <Text text="MAG" rectAlignment="UpperLeft" width="105" height="20"
                offsetXY="132 -6" fontSize="10" fontStyle="Bold" color="#A9B8AD"/>
            %s
          </Panel>
        ]],
            plainDropdownOptions(calibers, chosenCaliber),
            catalogVariantCapacityDropdownsXml(selected, chosenCaliber, chosenCapacity)
        )
    end

    local optionsY = hasVariants and -374 or -300

    local ammoPanel = ""
    if showAmmoOptions then
        ammoPanel = string.format([[
          <Panel id="equipment_add_ammo_options"
              rectAlignment="UpperLeft" width="250" height="116"
              offsetXY="18 %d" color="#101712CC">
            <Text text="RESERVE AMMO" rectAlignment="UpperLeft" width="220" height="20"
                offsetXY="10 -6" fontSize="11" fontStyle="Bold" color="#D2E5D6"/>
            <Text text="ROUNDS" rectAlignment="UpperLeft" width="70" height="18"
                offsetXY="10 -30" fontSize="10" color="#A9B8AD"/>
            <InputField id="addReserveRounds" text="%d" onEndEdit="editField"
                characterValidation="Integer" rectAlignment="UpperLeft"
                width="76" height="30" offsetXY="10 -48" fontSize="14"
                textColor="#FFFFFF" color="#17201B"/>
            <Text text="MAGS" rectAlignment="UpperLeft" width="70" height="18"
                offsetXY="105 -30" fontSize="10" color="#A9B8AD"/>
            <Button id="add_reserve_mags_minus" onClick="adjustAddReserveMags" text="-"
                rectAlignment="UpperLeft" width="30" height="30" offsetXY="105 -48"
                fontSize="16" color="#5B3030" textColor="#FFFFFF"/>
            <Text id="add_reserve_mags_count" text="%d" rectAlignment="UpperLeft"
                width="44" height="30" offsetXY="138 -48" fontSize="14"
                fontStyle="Bold" color="#FFFFFF" alignment="MiddleCenter"/>
            <Button id="add_reserve_mags_plus" onClick="adjustAddReserveMags" text="+"
                rectAlignment="UpperLeft" width="30" height="30" offsetXY="185 -48"
                fontSize="16" color="#355845" textColor="#FFFFFF"/>
            <Text id="equipment_add_mag_hint" text="%s" rectAlignment="UpperLeft"
                width="225" height="28" offsetXY="10 -82" fontSize="9"
                color="#A9B8AD" alignment="UpperLeft" horizontalOverflow="Wrap"/>
          </Panel>
        ]], optionsY,
            math.max(0, math.floor(tonumber(state.addReserveRounds) or 0)),
            mags, esc(magHint))
    end

    local qtyPanel = ""
    if showQuantity then
        qtyPanel = string.format([[
          <Panel id="equipment_add_quantity_options" rectAlignment="UpperLeft"
              width="250" height="90" offsetXY="18 %d" color="#101712CC">
            <Text text="QUANTITY" rectAlignment="UpperLeft" width="220" height="24"
                offsetXY="10 -8" fontSize="13" fontStyle="Bold" color="#D2E5D6"/>
            <Button id="add_item_qty_minus" onClick="adjustAddItemQuantity" text="-"
                rectAlignment="UpperLeft" width="38" height="36" offsetXY="40 -42"
                fontSize="18" color="#5B3030" textColor="#FFFFFF"/>
            <Text id="add_item_qty_count" text="%d" rectAlignment="UpperLeft"
                width="70" height="36" offsetXY="88 -42" fontSize="17"
                fontStyle="Bold" color="#FFFFFF" alignment="MiddleCenter"/>
            <Button id="add_item_qty_plus" onClick="adjustAddItemQuantity" text="+"
                rectAlignment="UpperLeft" width="38" height="36" offsetXY="166 -42"
                fontSize="18" color="#355845" textColor="#FFFFFF"/>
          </Panel>
        ]], optionsY, math.max(1, math.floor(tonumber(state.addItemQuantity) or 1)))
    end

    local actionLabel = replacing and "REPLACE ITEM" or "ADD TO AGENT"
    local panelTitle = replacing and ("REPLACE " .. tostring(state.equipmentReplace.name or "ITEM")) or "ADD EQUIPMENT"
    local cancelReplace = replacing and [[
        <Button id="equipment_cancel_replace" onClick="cancelEquipmentReplace"
            text="CANCEL REPLACE" rectAlignment="UpperRight" width="160" height="32"
            offsetXY="-214 -48" fontSize="10" color="#5B3030" textColor="#FFFFFF"/>
    ]] or ""

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1050" height="720" offsetXY="0 0" color="#111A15CC">
        <Text text="%s" rectAlignment="UpperLeft" width="420" height="38"
            offsetXY="20 -16" fontSize="21" fontStyle="Bold" color="#D2E5D6" alignment="MiddleLeft"/>
        <Text text="SOURCE: %s" rectAlignment="UpperLeft" width="650" height="30"
            offsetXY="20 -51" fontSize="12" color="#A9B8AD"/>
        <Button id="equipment_refresh_github" onClick="refreshEquipmentCatalogFromGithub"
            text="REFRESH GITHUB" rectAlignment="UpperRight" width="185" height="32"
            offsetXY="-20 -48" fontSize="11" color="#2D625E" textColor="#FFFFFF"/>
        %s

        %s

        <Text text="%s" rectAlignment="UpperLeft" width="390" height="30"
            offsetXY="20 -126" fontSize="16" fontStyle="Bold"
            color="#D2E5D6" alignment="MiddleLeft"/>
        %s

        <VerticalScrollView id="equipment_browse_scroll" width="710" height="490"
            rectAlignment="UpperLeft" offsetXY="20 -162" scrollSensitivity="32"
            color="#0D151100" verticalScrollbarVisibility="AutoHide"
            scrollbarBackgroundColor="#101712"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A">
          <Panel width="690" height="%d" rectAlignment="UpperLeft">%s</Panel>
        </VerticalScrollView>

        <Panel id="equipment_add_selected_panel" active="%s"
            rectAlignment="UpperRight" width="290" height="520"
            offsetXY="-20 -162" color="#17201BCC">
          <Text text="SELECTED" rectAlignment="UpperLeft" width="250" height="24"
              offsetXY="18 -12" fontSize="12" fontStyle="Bold" color="#A9B8AD"/>
          <Text id="equipment_add_selected_name" text="%s"
              rectAlignment="UpperLeft" width="250" height="58" offsetXY="18 -38"
              fontSize="18" fontStyle="Bold" color="#FFFFFF"
              alignment="UpperLeft" horizontalOverflow="Wrap"/>

          <Text text="EXPENSE LEVEL" rectAlignment="UpperLeft" width="250" height="20"
              offsetXY="18 -101" fontSize="11" fontStyle="Bold" color="#A9B8AD"/>
          <Text id="equipment_add_selected_expense" text="%s"
              rectAlignment="UpperLeft" width="250" height="26" offsetXY="18 -122"
              fontSize="14" fontStyle="Bold" color="#D9C07A"/>

          <Panel id="equipment_add_selected_details"
              rectAlignment="UpperLeft" width="250" height="140" offsetXY="0 -154">
            %s
          </Panel>

          %s
          %s
          %s

          <Button id="equipment_add_selected" onClick="addSelectedCatalogItem"
              text="%s" interactable="%s"
              rectAlignment="LowerLeft" width="250" height="42" offsetXY="18 14"
              fontSize="15" fontStyle="Bold" color="%s" textColor="#FFFFFF"/>
        </Panel>
      </Panel>
    ]],
        esc(panelTitle),
        esc(tostring(equipmentCatalogSource) .. " (" .. tostring(equipmentCatalogCount) .. " items)"),
        cancelReplace,
        buildBreadcrumbXml(),
        esc(browseTitle()), filterXml,
        browseHeight, browseRows,
        selected ~= "" and "true" or "false",
        esc(selected ~= "" and catalogDisplayName(selected) or ""),
        esc(expense), detailsXml,
        variantPanel, ammoPanel, qtyPanel,
        esc(actionLabel),
        selected ~= "" and "true" or "false",
        selected ~= "" and "#355845" or "#252B27"
    )
end



local function buildFundsPanel()
    ensureStructuredImportState()

    local balanceRows, balanceHeight = buildCurrencyBalanceRows()
    local pending = state.equipment.currencyAssignPending == true
    local draft = tostring(state.equipment.currencyDraft or "")
    local legacyCash = tostring(state.equipment.cash or "")

    if pending then
        return string.format([[
          <Panel rectAlignment="UpperLeft" width="1050" height="760"
              offsetXY="0 0" color="#111A15CC">

            <Text text="CHOOSE CURRENCY / METAL"
                rectAlignment="UpperLeft" width="520" height="38"
                offsetXY="20 -16" fontSize="21" fontStyle="Bold"
                color="#D2E5D6"/>

            <Text text="ADD AMOUNT: %s"
                rectAlignment="UpperLeft" width="350" height="32"
                offsetXY="20 -54" fontSize="15" fontStyle="Bold"
                color="#FFFFFF"/>

            <Button id="currency_cancel"
                onClick="cancelCurrencyFunds"
                text="‹ BACK"
                rectAlignment="UpperRight" width="130" height="34"
                offsetXY="-20 -20" fontSize="12" fontStyle="Bold"
                color="#4A3030" textColor="#FFFFFF"/>

            %s
          </Panel>
        ]],
            esc(draft),
            buildCurrencyChoiceButtons()
        )
    end

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1050" height="%d"
          offsetXY="0 0" color="#111A15CC">

        <Text text="FUNDS / CASH / VALUABLES"
            rectAlignment="UpperLeft" width="500" height="38"
            offsetXY="20 -16" fontSize="21" fontStyle="Bold"
            color="#D2E5D6"/>

        <Text text="ADD AMOUNT"
            rectAlignment="UpperLeft" width="260" height="26"
            offsetXY="20 -70" fontSize="13" fontStyle="Bold"
            color="#A9B8AD"/>

        <InputField id="currencyAmountInput"
            text="%s"
            onEndEdit="captureCurrencyAmount"
            lineType="SingleLine"
            contentType="DecimalNumber"
            rectAlignment="UpperLeft" width="320" height="42"
            offsetXY="20 -100" fontSize="17"
            textColor="#FFFFFF" color="#17201B"/>

        <Button id="currency_add_funds"
            onClick="beginCurrencyFunds"
            text="ADD FUNDS"
            rectAlignment="UpperLeft" width="165" height="42"
            offsetXY="352 -100" fontSize="13" fontStyle="Bold"
            color="#355845" textColor="#FFFFFF"/>

        <Text text="CURRENCY BALANCES"
            rectAlignment="UpperLeft" width="300" height="28"
            offsetXY="20 -166" fontSize="14" fontStyle="Bold"
            color="#A9B8AD"/>

        <Panel rectAlignment="UpperLeft" width="1000" height="%d"
            offsetXY="20 -202">%s</Panel>

        <Text text="VALUABLES / ASSETS"
            rectAlignment="UpperLeft" width="300" height="26"
            offsetXY="20 -%d" fontSize="13" fontStyle="Bold"
            color="#A9B8AD"/>

        <InputField id="valuables" text="%s"
            onEndEdit="editField"
            lineType="MultiLineNewline"
            rectAlignment="UpperLeft" width="990" height="160"
            offsetXY="20 -%d" fontSize="15"
            textColor="#FFFFFF" color="#17201B"
            horizontalOverflow="Wrap"/>

        <Text text="%s"
            rectAlignment="UpperLeft" width="990" height="34"
            offsetXY="20 -%d" fontSize="11"
            color="#7E8C83" horizontalOverflow="Wrap"/>

      </Panel>
    ]],
        math.max(620, 390 + balanceHeight),
        esc(draft),
        math.max(80, balanceHeight),
        balanceRows,
        222 + balanceHeight,
        esc(tostring(state.equipment.valuables or "")),
        252 + balanceHeight,
        legacyCash ~= "" and ("Legacy cash note preserved: " .. legacyCash) or "",
        424 + balanceHeight
    )
end

local function buildEquipment()
    ensureStructuredImportState()

    local tab = state.equipmentSubtab or "all"
    local grouped = collectEquipmentItems()
    local content = ""
    local contentHeight = 620

    if tab == "add" then
        content = buildAddItemPanel()
        contentHeight = 760
    elseif tab == "funds" then
        content = buildFundsPanel()
        contentHeight = 820
    elseif tab == "notes" then
        content = multilineAt(
            "equipmentNotes",
            "EQUIPMENT NOTES",
            state.equipment.notes or "",
            1050,
            420,
            0,
            0
        )
        contentHeight = 560
    elseif tab == "dice" then
        content = buildDicePoolPanel()
        contentHeight = 560
    else
        local items = grouped[tab] or grouped.all
        local rows = buildCategorizedEquipmentRows(items)

        if tab == "armor" then
            content =
                buildArmorAutomationPanel() ..
                string.format([[
                  <Panel rectAlignment="UpperLeft" width="1050" height="%d"
                      offsetXY="0 -126">%s</Panel>
                ]], math.max(500,#items*134+30), rows)

            contentHeight = math.max(740, #items * 134 + 170)
        else
            content = rows
            contentHeight = math.max(620, #items * 134 + 30)
        end
    end

    local pageHeight = contentHeight + 190

    return string.format([[
    <VerticalScrollView id="scroll_equipment"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_equipment"
          width="1160" height="%d"
          rectAlignment="UpperCenter">

        %s
        %s
        %s
        %s
        %s
        %s
        %s
        %s
        %s
        %s
        %s

        <Text text="ATTACK D%% = skill check. On a hit the same button changes to the correct follow-up: SINGLE usually rolls DAMAGE; BURST/AUTO and Lethality explosives roll LETHALITY. MAG is loaded ammo; RESERVE is carried stockpile. RELOAD transfers reserve rounds into MAG. BURST uses 3; AUTO uses 10. QTY is for throwable/single-use weapons."
            rectAlignment="UpperLeft"
            width="1040" height="42"
            offsetXY="58 -101"
            fontSize="12"
            color="#A9B8AD"
            alignment="MiddleLeft"/>

        <Panel rectAlignment="UpperLeft"
            width="1050" height="%d"
            offsetXY="55 -150">%s</Panel>

      </Panel>
    </VerticalScrollView>]],
        pageHeight,
        equipmentTabButtonCompact("all","ALL",tab=="all",28,105,-16),
        equipmentTabButtonCompact("firearms","FIREARMS",tab=="firearms",141,145,-16),
        equipmentTabButtonCompact("melee","MELEE",tab=="melee",294,120,-16),
        equipmentTabButtonCompact("heavy","HEAVY",tab=="heavy",422,120,-16),
        equipmentTabButtonCompact("lesslethal","LESS-LETHAL",tab=="lesslethal",550,165,-16),
        equipmentTabButtonCompact("armor","ARMOR",tab=="armor",723,115,-16),
        equipmentTabButtonCompact("gear","GEAR",tab=="gear",846,110,-16),

        equipmentTabButtonCompact("add","ADD ITEM",tab=="add",240,150,-60),
        equipmentTabButtonCompact("funds","FUNDS",tab=="funds",398,125,-60),
        equipmentTabButtonCompact("notes","NOTES",tab=="notes",531,125,-60),
        equipmentTabButtonCompact("dice","DICE",tab=="dice",664,105,-60),

        contentHeight,
        content
    )
end



local function notifyHandlerAction(text)
    local msg = "[DG ACTION] " .. tostring(text or "")

    pcall(function()
        broadcastToColor(msg, "Black", {1.0,0.68,0.25})
    end)

    queueDashboardSnapshot(SHEET_COLOR, "home", msg)
end

local function refreshPsychologyPage()
    if rebuildCachedPage and getCachedHelper("psychology") then
        rebuildCachedPage("psychology")
        activateCachedPage("psychology")
    elseif rebuildUI then
        rebuildUI()
    end
end

local function currentRollModifier()
    local manual = math.floor(tonumber(state.rollModifier) or 0)
    local wp = tonumber(state.agent.wp) or 0
    local lowWp = 0

    if wp <= 0 then
        lowWp = -100
    elseif wp <= 2 then
        lowWp = -20
    end

    return manual + lowWp, manual, lowWp
end

local function selectedBond()
    ensureStructuredImportState()
    local i = tonumber(state.psychology.selectedBondIndex) or 1

    if i < 1 then i = 1 end
    if i > #state.importedBonds then i = #state.importedBonds end

    state.psychology.selectedBondIndex = math.max(1, i)

    return state.importedBonds[i], i
end

local function adjustBondScore(index, delta, markDamaged)
    ensureStructuredImportState()

    local bond = state.importedBonds[tonumber(index) or 0]
    if not bond then return 0 end

    local old = tonumber(bond.score) or 0
    local cap = math.max(0, tonumber(state.agent.cha) or 0)
    local newValue = math.max(0, math.min(cap, old + (tonumber(delta) or 0)))

    bond.score = newValue

    if markDamaged == true and newValue < old then
        bond.damaged = true
        state.psychology.sessionBondDamage =
            (tonumber(state.psychology.sessionBondDamage) or 0) +
            (old - newValue)
    end

    -- If the Bonds page is currently visible, update it immediately so
    -- the player never has to refresh or change tabs to see the new score.
    if state.currentTab == "psychology" and
       tostring(state.psychologySubtab or "") == "bonds"
    then
        Wait.frames(function()
            refreshPsychologyPage()
        end, 1)
    else
        cachedPageDirty["psychology"] = true
    end

    return old - newValue
end

local function countIncidentBoxes(boxes)
    local count = 0
    if type(boxes) == "table" then
        for i=1,3 do
            if boxes[i] == true then count = count + 1 end
        end
    end
    return count
end

local function markNextIncidentBox(source)
    local key = source == "Violence" and "violenceBoxes" or "helplessnessBoxes"
    local countKey = source == "Violence" and "violenceIncidents" or "helplessnessIncidents"

    state.psychology[key] = state.psychology[key] or {false,false,false}

    for i=1,3 do
        if state.psychology[key][i] ~= true then
            state.psychology[key][i] = true
            break
        end
    end

    state.psychology[countKey] = countIncidentBoxes(state.psychology[key])
end

local function clearIncidentBoxes(source)
    if source == "Violence" then
        state.psychology.violenceBoxes = {false,false,false}
        state.psychology.violenceIncidents = 0
    elseif source == "Helplessness" then
        state.psychology.helplessnessBoxes = {false,false,false}
        state.psychology.helplessnessIncidents = 0
    end
end

local function resetIncidentTrack(source)
    if source == "Violence" and not state.psychology.adaptedViolence then
        clearIncidentBoxes("Violence")
    elseif source == "Helplessness" and not state.psychology.adaptedHelplessness then
        clearIncidentBoxes("Helplessness")
    end
end

local function resetBothIncidentTracks()
    if not state.psychology.adaptedViolence then
        clearIncidentBoxes("Violence")
    end
    if not state.psychology.adaptedHelplessness then
        clearIncidentBoxes("Helplessness")
    end
end

local function triggerAdaptation(source)
    if source == "Violence" then
        if state.psychology.adaptedViolence then return end
        state.psychology.adaptedViolence = true
        state.psychology.violenceBoxes = {true,true,true}
        state.psychology.violenceIncidents = 3

        broadcastToAll(
            "[DG] " .. tostring(state.agent.name or "Agent") ..
            " is now ADAPTED TO VIOLENCE. Rolling 1D6 CHA/Bond consequence.",
            {0.95,0.68,0.30}
        )

        notifyHandlerAction(
            tostring(state.agent.name or "Agent") ..
            " became adapted to Violence. 1D6 CHA and each Bond will be reduced automatically."
        )

        startDiceExpressionRoll(
            "ADAPTATION — VIOLENCE",
            "1d6",
            "adaptationCost",
            { source = "Violence" }
        )

    elseif source == "Helplessness" then
        if state.psychology.adaptedHelplessness then return end
        state.psychology.adaptedHelplessness = true
        state.psychology.helplessnessBoxes = {true,true,true}
        state.psychology.helplessnessIncidents = 3

        broadcastToAll(
            "[DG] " .. tostring(state.agent.name or "Agent") ..
            " is now ADAPTED TO HELPLESSNESS. Rolling 1D6 POW consequence.",
            {0.95,0.68,0.30}
        )

        notifyHandlerAction(
            tostring(state.agent.name or "Agent") ..
            " became adapted to Helplessness. 1D6 POW will be reduced automatically."
        )

        startDiceExpressionRoll(
            "ADAPTATION — HELPLESSNESS",
            "1d6",
            "adaptationCost",
            { source = "Helplessness" }
        )
    end
end

local function recordSanIncident(source, actualLoss, temporaryInsanity, crossedBP)
    if actualLoss <= 0 then return end

    if crossedBP then
        resetBothIncidentTracks()
        return
    end

    if temporaryInsanity then
        resetIncidentTrack(source)
        return
    end

    if source == "Violence" and not state.psychology.adaptedViolence then
        markNextIncidentBox("Violence")

        if state.psychology.violenceIncidents >= 3 then
            Wait.frames(function() triggerAdaptation("Violence") end, 2)
        end

    elseif source == "Helplessness" and not state.psychology.adaptedHelplessness then
        markNextIncidentBox("Helplessness")

        if state.psychology.helplessnessIncidents >= 3 then
            Wait.frames(function() triggerAdaptation("Helplessness") end, 2)
        end
    end
end

local function applyResolvedSanLoss(amount, source, reason)
    ensureStructuredImportState()

    amount = math.max(0, math.floor(tonumber(amount) or 0))
    source = tostring(source or state.psychology.pendingSanSource or
        state.psychology.sanSource or "Unnatural")

    local oldSan = tonumber(state.agent.san) or 0
    local oldBP = tonumber(state.agent.breakingPoint) or 0
    local newSan = clampResourceValue("san", oldSan - amount)
    local actualLoss = math.max(0, oldSan - newSan)

    state.agent.san = newSan
    state.psychology.sessionSanLost =
        (tonumber(state.psychology.sessionSanLost) or 0) + actualLoss

    local crossedBP = oldSan > oldBP and newSan <= oldBP
    local temporaryInsanity = actualLoss >= 5

    handleSanChange(oldSan, newSan)

    if crossedBP then
        state.psychology.sessionBreakingPoints =
            (tonumber(state.psychology.sessionBreakingPoints) or 0) + 1

        notifyHandlerAction(
            string.format(
                "%s crossed a Breaking Point (%d SAN). Assign/resolve the new disorder.",
                tostring(state.agent.name or "Agent"),
                newSan
            )
        )
    end

    if temporaryInsanity then
        state.psychology.temporaryInsanityPending = true

        notifyHandlerAction(
            string.format(
                "%s lost %d SAN at once from %s. Temporary insanity is triggered; Handler chooses the reaction unless repressed.",
                tostring(state.agent.name or "Agent"),
                actualLoss,
                source
            )
        )
    end

    recordSanIncident(source, actualLoss, temporaryInsanity, crossedBP)

    state.psychology.pendingSanLoss = nil
    state.psychology.pendingSanSource = nil

    local message = string.format(
        "%s - SAN LOSS %d (%s) | SAN %d -> %d%s",
        tostring(state.agent.name or "Agent"),
        actualLoss,
        source,
        oldSan,
        newSan,
        reason and (" | " .. tostring(reason)) or ""
    )

    broadcastToAll(message, {0.88,0.72,0.45})
    queueDashboardSnapshot(SHEET_COLOR, "roll", message)

    if newSan <= 0 then
        notifyHandlerAction(
            tostring(state.agent.name or "Agent") ..
            " reached 0 SAN. Permanent insanity requires Handler resolution."
        )
    end

    refreshPsychologyPage()
    return actualLoss
end

local function motivationLines()
    local result = {}
    for line in tostring(state.psychology.motivations or ""):gmatch("[^\r\n]+") do
        local clean = line:gsub("^%s+",""):gsub("%s+$","")
        if clean ~= "" then table.insert(result, clean) end
        if #result >= 5 then break end
    end
    return result
end


local function buildBondCards()
    ensureStructuredImportState()

    if #state.importedBonds == 0 then
        return [[
          <Text text="No bonds imported."
              rectAlignment="UpperLeft"
              width="1080" height="40"
              offsetXY="0 0"
              fontSize="17"
              color="#829287"
              alignment="MiddleLeft"/>
        ]]
    end

    local xml = ""
    local y = 0
    local selected = tonumber(state.psychology.selectedBondIndex) or 1

    for i, bond in ipairs(state.importedBonds) do
        local selectedColor = (i == selected) and "#355845" or "#223229"
        local damagedText = bond.damaged and "DAMAGED" or "HEALTHY"
        local damagedColor = bond.damaged and "#743A3A" or "#315E3A"

        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1080" height="158"
              offsetXY="0 %d"
              color="#111A15CC">

            <Text text="BOND %d"
                rectAlignment="UpperLeft"
                width="105" height="28"
                offsetXY="12 -8"
                fontSize="15"
                fontStyle="Bold"
                color="#86A88F"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="390" height="32"
                offsetXY="118 -6"
                fontSize="19"
                fontStyle="Bold"
                color="#E4EFE7"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="480" height="28"
                offsetXY="118 -39"
                fontSize="14"
                color="#A9B8AD"
                alignment="MiddleLeft"/>

            <Text id="bond_score_%d" text="SCORE %d"
                rectAlignment="UpperLeft"
                width="135" height="30"
                offsetXY="610 -8"
                fontSize="16"
                fontStyle="Bold"
                color="#D9C07A"
                alignment="MiddleRight"/>

            <Button id="bond_damage_%d"
                onClick="toggleBondDamaged"
                text="%s"
                rectAlignment="UpperRight"
                width="154" height="32"
                offsetXY="-10 -6"
                fontSize="11"
                fontStyle="Bold"
                color="%s"
                textColor="#FFFFFF"/>

            <Button id="bond_minus_%d"
                onClick="bondAdjust"
                text="-1"
                rectAlignment="UpperLeft"
                width="48" height="32"
                offsetXY="625 -46"
                fontSize="15"
                color="#6B3535"
                textColor="#FFFFFF"/>

            <Button id="bond_plus_%d"
                onClick="bondAdjust"
                text="+1"
                rectAlignment="UpperLeft"
                width="48" height="32"
                offsetXY="681 -46"
                fontSize="15"
                color="#355845"
                textColor="#FFFFFF"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="1038" height="70"
                offsetXY="20 -82"
                fontSize="14"
                color="#CDD8D0"
                alignment="UpperLeft"
                horizontalOverflow="Wrap"
                verticalOverflow="Overflow"/>

          </Panel>
        ]],
            -y,
            i,
            esc(bond.name),
            esc(bond.relationship),
            i,
            tonumber(bond.score) or 0,
            i,
            damagedText,
            damagedColor,
            i,
            i,
            esc(bond.description)
        )

        y = y + 168
    end

    return xml
end


local function psychologyTabButton(id, label, active, x)
    return string.format([[
      <Button id="psychology_tab_%s"
          onClick="switchPsychologySubtab"
          text="%s"
          rectAlignment="UpperLeft"
          width="205" height="44"
          offsetXY="%d -16"
          fontSize="15"
          color="%s"
          textColor="#FFFFFF"/>
    ]],
        id,
        esc(label),
        x,
        active and "#426A52" or "#223229"
    )
end

local function incidentBoxes(boxesOrCount, adapted)
    local boxes

    if type(boxesOrCount) == "table" then
        boxes = {
            boxesOrCount[1] == true,
            boxesOrCount[2] == true,
            boxesOrCount[3] == true
        }
    else
        boxes = {false,false,false}
        local count = math.max(0, math.min(3, tonumber(boxesOrCount) or 0))
        for i=1,count do boxes[i] = true end
    end

    local parts = {}
    for i=1,3 do
        table.insert(parts, boxes[i] and "[■]" or "[□]")
    end

    if adapted then
        table.insert(parts, "  ADAPTED")
    end

    return table.concat(parts, "   ")
end


local function buildSanAutomationPanel()
    local p = state.psychology
    local source = tostring(p.sanSource or "Unnatural")
    local pending = tonumber(p.pendingSanLoss)
    local selected, selectedIndex = selectedBond()
    local selectedBondText = selected and
        string.format("%s (%d)", tostring(selected.name or "Bond"), tonumber(selected.score) or 0) or
        "NO BOND SELECTED"

    local sanBondButtons = ""
    local bx = 145
    local by = -282

    for i, bond in ipairs(state.importedBonds or {}) do
        if i > 6 then break end

        local row = math.floor((i - 1) / 3)
        local col = (i - 1) % 3
        local active = i == selectedIndex
        local label = string.format(
            "%s%s",
            active and "✓ " or "",
            tostring(bond.name or ("Bond " .. i))
        )

        sanBondButtons = sanBondButtons .. string.format([[
          <Button id="bond_select_%d"
              onClick="selectBond"
              text="%s"
              rectAlignment="UpperLeft"
              width="245" height="34"
              offsetXY="%d %d"
              fontSize="11"
              color="%s"
              textColor="#FFFFFF"/>
        ]],
            i,
            esc(label),
            bx + (col * 255),
            by - (row * 40),
            active and "#426A52" or "#223229"
        )
    end

    local pendingXml = ""
    if pending ~= nil then
        pendingXml = string.format([[
        <Panel rectAlignment="UpperLeft" width="1085" height="120"
            offsetXY="18 -365" color="#241C12EE">
          <Text text="PENDING SAN LOSS: %d — %s"
              rectAlignment="UpperLeft" width="470" height="34"
              offsetXY="14 -10" fontSize="18" fontStyle="Bold"
              color="#E0BA75" alignment="MiddleLeft"/>
          <Text text="Bond used for Projection/Repression: %s"
              rectAlignment="UpperLeft" width="470" height="30"
              offsetXY="14 -48" fontSize="14"
              color="#D5E1D8" alignment="MiddleLeft"/>
          <Button id="san_apply_pending" onClick="applyPendingSanLoss"
              text="APPLY SAN LOSS"
              rectAlignment="UpperRight" width="190" height="42"
              offsetXY="-220 -18" fontSize="14" fontStyle="Bold"
              color="#6B3535" textColor="#FFFFFF"/>
          <Button id="san_project_pending" onClick="projectPendingSanLoss"
              text="PROJECT ONTO BOND"
              rectAlignment="UpperRight" width="205" height="42"
              offsetXY="-10 -18" fontSize="13" fontStyle="Bold"
              color="#57492E" textColor="#FFFFFF"/>
        </Panel>
        ]], pending, esc(tostring(p.pendingSanSource or source)), esc(selectedBondText))
    end

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1122" height="485"
          offsetXY="18 -112" color="#111A15CC">

        <Text text="SANITY AUTOMATION"
            rectAlignment="UpperLeft" width="420" height="32"
            offsetXY="18 -12" fontSize="19" fontStyle="Bold"
            color="#D2E5D6" alignment="MiddleLeft"/>

        <Text text="SOURCE"
            rectAlignment="UpperLeft" width="90" height="30"
            offsetXY="18 -52" fontSize="14" fontStyle="Bold"
            color="#A9B8AD" alignment="MiddleLeft"/>

        <Button id="san_source_violence" onClick="selectSanSource"
            text="VIOLENCE"
            rectAlignment="UpperLeft" width="150" height="38"
            offsetXY="105 -48" fontSize="14"
            color="%s" textColor="#FFFFFF"/>

        <Button id="san_source_helplessness" onClick="selectSanSource"
            text="HELPLESSNESS"
            rectAlignment="UpperLeft" width="175" height="38"
            offsetXY="263 -48" fontSize="14"
            color="%s" textColor="#FFFFFF"/>

        <Button id="san_source_unnatural" onClick="selectSanSource"
            text="UNNATURAL"
            rectAlignment="UpperLeft" width="150" height="38"
            offsetXY="446 -48" fontSize="14"
            color="%s" textColor="#FFFFFF"/>

        <Text text="LOSS (success/failure)"
            rectAlignment="UpperLeft" width="210" height="28"
            offsetXY="18 -103" fontSize="13"
            color="#A9B8AD" alignment="MiddleLeft"/>

        <InputField id="sanLossFormula" text="%s"
            onEndEdit="editField" rectAlignment="UpperLeft"
            width="245" height="42" offsetXY="18 -132"
            fontSize="17" textColor="#F1F7F2" color="#17201B"/>

        <Button id="san_loss_roll" onClick="rollSanLoss"
            text="ROLL SAN"
            rectAlignment="UpperLeft" width="190" height="42"
            offsetXY="275 -132" fontSize="15" fontStyle="Bold"
            color="#355943" textColor="#FFFFFF"/>

        <Button id="san_repress" onClick="repressInsanity"
            text="REPRESS INSANITY"
            rectAlignment="UpperLeft" width="210" height="42"
            offsetXY="475 -132" fontSize="14" fontStyle="Bold"
            color="#563C6B" textColor="#FFFFFF"/>

        <Text text="VIOLENCE: %s"
            rectAlignment="UpperLeft" width="510" height="44"
            offsetXY="18 -190" fontSize="22" fontStyle="Bold"
            color="#D5E1D8" alignment="MiddleLeft"/>

        <Text text="HELPLESSNESS: %s"
            rectAlignment="UpperLeft" width="555" height="44"
            offsetXY="550 -190" fontSize="22" fontStyle="Bold"
            color="#D5E1D8" alignment="MiddleLeft"/>

        <Text text="ROLL MODIFIER"
            rectAlignment="UpperLeft" width="150" height="28"
            offsetXY="18 -240" fontSize="13"
            color="#A9B8AD" alignment="MiddleLeft"/>

        <InputField id="rollModifier" text="%d"
            onEndEdit="editField" characterValidation="Integer"
            rectAlignment="UpperLeft" width="95" height="38"
            offsetXY="150 -236" fontSize="16"
            textColor="#FFFFFF" color="#17201B"/>

        <Text text="Manual modifier combines with disorder and low-WP penalties. WP 1–2: -20%%. WP 0: automatic failure."
            rectAlignment="UpperLeft" width="760" height="44"
            offsetXY="260 -235" fontSize="13"
            color="#A9B8AD" alignment="MiddleLeft" horizontalOverflow="Wrap"/>

        <Text text="BOND FOR SAN"
            rectAlignment="UpperLeft" width="120" height="30"
            offsetXY="18 -284" fontSize="12" fontStyle="Bold"
            color="#A9B8AD" alignment="MiddleLeft"/>

        %s

        %s

      </Panel>
    ]],
        source=="Violence" and "#6B3535" or "#293A31",
        source=="Helplessness" and "#6A552B" or "#293A31",
        source=="Unnatural" and "#563C6B" or "#293A31",
        esc(tostring(state.sanLossFormula or "0/1d4")),
        esc(incidentBoxes(p.violenceBoxes or p.violenceIncidents, p.adaptedViolence)),
        esc(incidentBoxes(p.helplessnessBoxes or p.helplessnessIncidents, p.adaptedHelplessness)),
        math.floor(tonumber(state.rollModifier) or 0),
        sanBondButtons,
        pendingXml
    )
end

local function buildMotivationsPanel()
    local lines = motivationLines()
    local xml = ""
    local y = 0

    if #lines == 0 then
        xml = [[
        <Text text="No motivations added yet."
            rectAlignment="UpperLeft" width="1040" height="36"
            offsetXY="0 0" fontSize="14" color="#829287" alignment="MiddleLeft"/>
        ]]
        y = 42
    else
        for i, motivationText in ipairs(lines) do
            if i > 5 then break end

            local used = state.psychology.motivationUsed[i] == true

            xml = xml .. string.format([[
            <Panel rectAlignment="UpperLeft" width="1080" height="58"
                offsetXY="0 %d" color="#111A15CC">

              <Text text="%d. %s"
                  rectAlignment="UpperLeft" width="650" height="40"
                  offsetXY="14 -9" fontSize="15" color="#E4EFE7"
                  alignment="MiddleLeft" horizontalOverflow="Wrap"/>

              <Button id="motivation_use_%d" onClick="useMotivation"
                  text="%s"
                  interactable="%s"
                  rectAlignment="UpperRight" width="205" height="34"
                  offsetXY="-112 -12" fontSize="12" fontStyle="Bold"
                  color="%s" textColor="#FFFFFF"/>

              <Button id="motivation_remove_%d" onClick="removeMotivation"
                  text="REMOVE"
                  rectAlignment="UpperRight" width="92" height="34"
                  offsetXY="-10 -12" fontSize="11" fontStyle="Bold"
                  color="#5B3030" textColor="#FFFFFF"/>

            </Panel>
            ]],
                -y,
                i,
                esc(motivationText),
                i,
                used and "USED THIS SESSION" or "ENGAGE: +1 WP",
                used and "false" or "true",
                used and "#252B27" or "#355845",
                i
            )

            y = y + 66
        end
    end

    local count = math.min(#lines, 5)
    local canAdd = count < 5

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1080" height="%d"
          offsetXY="40 -112">

        <Text text="MOTIVATIONS — up to five. Each may restore 1 WP once per session."
            rectAlignment="UpperLeft" width="1030" height="34"
            offsetXY="0 0" fontSize="15" color="#D2E5D6" alignment="MiddleLeft"/>

        <InputField id="newMotivationInput"
            text="%s"
            onEndEdit="captureNewMotivation"
            lineType="SingleLine"
            interactable="%s"
            rectAlignment="UpperLeft" width="850" height="42"
            offsetXY="0 -42" fontSize="16"
            textColor="#F1F7F2" color="#17201B"
            selectionColor="#355845"/>

        <Button id="motivation_add"
            onClick="addNewMotivation"
            text="%s"
            interactable="%s"
            rectAlignment="UpperRight" width="210" height="42"
            offsetXY="0 -42" fontSize="13" fontStyle="Bold"
            color="%s" textColor="#FFFFFF"/>

        <Panel rectAlignment="UpperLeft" width="1080" height="%d"
            offsetXY="0 -100">%s</Panel>

      </Panel>
    ]],
        math.max(500, 125 + y),
        esc(tostring(state.psychology.newMotivationDraft or "")),
        canAdd and "true" or "false",
        canAdd and "ADD MOTIVATION" or "5 / 5 FULL",
        canAdd and "true" or "false",
        canAdd and "#355845" or "#252B27",
        math.max(300, y + 20),
        xml
    )
end

local function buildSessionPanel()
    local marked = currentMarkedSkillsForDashboard()
    local markedText = #marked > 0 and table.concat(marked, ", ") or "None"
    local p = state.psychology

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1080" height="590"
          offsetXY="40 -112" color="#111A15CC">

        <Text text="SESSION AUTOMATION SUMMARY"
            rectAlignment="UpperLeft" width="500" height="36"
            offsetXY="18 -14" fontSize="20" fontStyle="Bold"
            color="#D2E5D6" alignment="MiddleLeft"/>

        <Text text="SAN LOST THIS SESSION: %d"
            rectAlignment="UpperLeft" width="360" height="34"
            offsetXY="18 -70" fontSize="17" color="#E0BA75" alignment="MiddleLeft"/>

        <Text text="BREAKING POINTS CROSSED: %d"
            rectAlignment="UpperLeft" width="360" height="34"
            offsetXY="18 -110" fontSize="17" color="#E0BA75" alignment="MiddleLeft"/>

        <Text text="BOND DAMAGE THIS SESSION: %d"
            rectAlignment="UpperLeft" width="360" height="34"
            offsetXY="18 -150" fontSize="17" color="#E0BA75" alignment="MiddleLeft"/>

        <Text text="WP STATUS: %d / %d%s"
            rectAlignment="UpperLeft" width="520" height="34"
            offsetXY="18 -205" fontSize="17" fontStyle="Bold"
            color="%s" alignment="MiddleLeft"/>

        <Text text="VIOLENCE TRACK: %s"
            rectAlignment="UpperLeft" width="500" height="34"
            offsetXY="18 -255" fontSize="19" fontStyle="Bold" color="#D5E1D8" alignment="MiddleLeft"/>

        <Text text="HELPLESSNESS TRACK: %s"
            rectAlignment="UpperLeft" width="550" height="34"
            offsetXY="18 -295" fontSize="19" fontStyle="Bold" color="#D5E1D8" alignment="MiddleLeft"/>

        <Text text="MARKED SKILLS: %s"
            rectAlignment="UpperLeft" width="1030" height="90"
            offsetXY="18 -350" fontSize="15" color="#D5E1D8"
            alignment="UpperLeft" horizontalOverflow="Wrap"/>

        <Button id="session_reset" onClick="resetSessionAutomation"
            text="END / RESET SESSION TRACKING"
            rectAlignment="UpperLeft" width="330" height="44"
            offsetXY="18 -475" fontSize="14" fontStyle="Bold"
            color="#57492E" textColor="#FFFFFF"/>

        <Text text="Reset clears motivation-use flags, damaged-Bond session markers, and session counters. Character values remain."
            rectAlignment="UpperLeft" width="690" height="54"
            offsetXY="370 -471" fontSize="13" color="#A9B8AD"
            alignment="MiddleLeft" horizontalOverflow="Wrap"/>

      </Panel>
    ]],
        tonumber(p.sessionSanLost) or 0,
        tonumber(p.sessionBreakingPoints) or 0,
        tonumber(p.sessionBondDamage) or 0,
        tonumber(state.agent.wp) or 0,
        tonumber(state.agent.wpMax) or 0,
        (tonumber(state.agent.wp) or 0) <= 0 and " — AUTOMATIC FAILURES" or
            ((tonumber(state.agent.wp) or 0) <= 2 and " — -20% TO TESTS" or ""),
        (tonumber(state.agent.wp) or 0) <= 2 and "#D98A66" or "#D2E5D6",
        esc(incidentBoxes(p.violenceIncidents,p.adaptedViolence)),
        esc(incidentBoxes(p.helplessnessIncidents,p.adaptedHelplessness)),
        esc(markedText)
    )
end

local function buildPsychology()
    ensureDisorderState()
    ensureStructuredImportState()

    if state.addCaliberFilter == nil then state.addCaliberFilter = "ALL" end
    if state.addSelectedCaliber == nil then state.addSelectedCaliber = "" end
    if state.addSelectedCapacity == nil then state.addSelectedCapacity = "" end

    local tab = state.psychologySubtab or "sanity"
    if tab == "psychology" then tab = "sanity" end

    local tabs =
        psychologyTabButton("sanity","SANITY",tab=="sanity",40) ..
        psychologyTabButton("bonds","BONDS",tab=="bonds",255) ..
        psychologyTabButton("motivations","MOTIVATIONS",tab=="motivations",470) ..
        psychologyTabButton("session","SESSION",tab=="session",685)

    local content = ""
    local pageHeight = 900

    if tab == "bonds" then
        local bondHeight = math.max(620, #state.importedBonds * 168 + 30)
        content = string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1080" height="%d"
              offsetXY="40 -112">%s</Panel>
        ]], bondHeight, buildBondCards())
        pageHeight = bondHeight + 115

    elseif tab == "motivations" then
        content = buildMotivationsPanel()
        pageHeight = 900

    elseif tab == "session" then
        content = buildSessionPanel()
        pageHeight = 780

    else
        content =
            buildSanAutomationPanel() ..
            multilineAt("psychNotes","PSYCHOLOGY NOTES",
                state.psychology.notes or "",1122,250,18,-505)
        pageHeight = 865
    end

    return string.format([[
    <VerticalScrollView id="scroll_psychology"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_psychology"
          width="1160" height="%d"
          rectAlignment="UpperCenter">

        %s

        <Text text="Choose BOND FOR SAN on the SANITY tab for Project onto Bond or Repress Insanity."
            rectAlignment="UpperLeft"
            width="1040" height="34"
            offsetXY="40 -58"
            fontSize="13"
            color="#A9B8AD"
            alignment="MiddleLeft"/>

        %s

      </Panel>
    </VerticalScrollView>
    ]], pageHeight, tabs, content)
end


local function buildDisorders()
    ensureDisorderState()
    local p = state.psychology

    local candidate = currentDisorderCandidate()
    local candidateDef = DISORDER_DEFS[candidate]
    local pendingText = string.format(
        "PENDING DISORDERS: %d",
        tonumber(p.pendingDisorders) or 0
    )

    local curedReminder = ""
    if hasCuredDisorder() and (tonumber(p.pendingDisorders) or 0) > 0 then
        curedReminder =
            "REMINDER: A previously cured disorder may relapse when a new disorder is gained; resolve the appropriate SAN test with the Handler."
    end

    return [[
    <VerticalScrollView id="scroll_disorders"
        width="1180" preferredWidth="1180" height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_disorders"
          width="1160" height="1180"
          rectAlignment="UpperCenter">

        <Panel rectAlignment="UpperLeft"
            width="1122" height="190"
            offsetXY="18 -18"
            color="#111A15CC">

          <Text text="DISORDER CONTROL"
              rectAlignment="UpperLeft"
              width="280" height="30"
              offsetXY="12 -8"
              fontSize="19"
              fontStyle="Bold"
              color="#D2E5D6"
              alignment="MiddleLeft"/>

          <Text text="]]..esc(pendingText)..[["
              rectAlignment="UpperLeft"
              width="250" height="30"
              offsetXY="300 -8"
              fontSize="17"
              fontStyle="Bold"
              color="#E0BA75"
              alignment="MiddleLeft"/>

          <Button id="source_violence"
              onClick="selectDisorderSource"
              text="VIOLENCE"
              rectAlignment="UpperLeft"
              width="155" height="38"
              offsetXY="12 -48"
              fontSize="15"
              color="]]..(p.pendingSource=="Violence" and "#4F6D58" or "#293A30")..[["
              textColor="#FFFFFF"/>

          <Button id="source_helplessness"
              onClick="selectDisorderSource"
              text="HELPLESSNESS"
              rectAlignment="UpperLeft"
              width="175" height="38"
              offsetXY="175 -48"
              fontSize="15"
              color="]]..(p.pendingSource=="Helplessness" and "#4F6D58" or "#293A30")..[["
              textColor="#FFFFFF"/>

          <Button id="source_unnatural"
              onClick="selectDisorderSource"
              text="UNNATURAL"
              rectAlignment="UpperLeft"
              width="155" height="38"
              offsetXY="358 -48"
              fontSize="15"
              color="]]..(p.pendingSource=="Unnatural" and "#4F6D58" or "#293A30")..[["
              textColor="#FFFFFF"/>

          <Button id="disorder_prev"
              onClick="cycleDisorderCandidate"
              text="&lt;"
              rectAlignment="UpperLeft"
              width="42" height="38"
              offsetXY="530 -48"
              fontSize="20"
              color="#293A30"
              textColor="#FFFFFF"/>

          <Text text="]]..esc(candidate)..[["
              rectAlignment="UpperLeft"
              width="300" height="38"
              offsetXY="580 -48"
              fontSize="17"
              fontStyle="Bold"
              color="#E7EEE9"
              alignment="MiddleCenter"/>

          <Button id="disorder_next"
              onClick="cycleDisorderCandidate"
              text="&gt;"
              rectAlignment="UpperLeft"
              width="42" height="38"
              offsetXY="888 -48"
              fontSize="20"
              color="#293A30"
              textColor="#FFFFFF"/>

          <Button id="assign_disorder"
              onClick="assignDisorderCandidate"
              text="ASSIGN"
              rectAlignment="UpperLeft"
              width="155" height="38"
              offsetXY="942 -48"
              fontSize="15"
              fontStyle="Bold"
              color="#365C49"
              textColor="#FFFFFF"/>

          <Text text="]]..esc(candidateDef.summary)..[["
              rectAlignment="UpperLeft"
              width="1085" height="38"
              offsetXY="12 -96"
              fontSize="14"
              color="#C5D2C8"
              alignment="UpperLeft"
              horizontalOverflow="Wrap"
              verticalOverflow="Overflow"/>

          <Text text="ACTIVE EFFECTS: ]]..esc(disorderEffectsSummary())..[["
              rectAlignment="UpperLeft"
              width="1085" height="26"
              offsetXY="12 -142"
              fontSize="14"
              fontStyle="Bold"
              color="#86B092"
              alignment="MiddleLeft"/>

          <Text text="]]..esc(curedReminder)..[["
              rectAlignment="UpperLeft"
              width="1085" height="28"
              offsetXY="12 -164"
              fontSize="12"
              color="#D9A56D"
              alignment="MiddleLeft"/>

        </Panel>

        <Text text="GAINED DISORDERS"
            rectAlignment="UpperLeft"
            width="350" height="32"
            offsetXY="18 -226"
            fontSize="20"
            fontStyle="Bold"
            color="#D2E5D6"
            alignment="MiddleLeft"/>

        <Panel rectAlignment="UpperLeft"
            width="1122" height="900"
            offsetXY="18 -265">]]..
              buildDisorderRows()..
        [[</Panel>

      </Panel>
    </VerticalScrollView>]]
end



ensureStructuredImportState = function()
    if state.importedBonds == nil then
        state.importedBonds = {}
    end

    if state.importedWeapons == nil then
        state.importedWeapons = {}
    end

    if state.importedArmor == nil then
        state.importedArmor = {}
    end

    if state.importedGear == nil then
        state.importedGear = {}
    end

    if state.equipmentSubtab == nil then
        state.equipmentSubtab = "all"
    end

    if state.psychologySubtab == nil or state.psychologySubtab == "psychology" then
        state.psychologySubtab = "sanity"
    end

    if state.personnelSubtab == nil or state.personnelSubtab == "details" then
        state.personnelSubtab = "profile"
    end

    if state.skillImprovementMarked == nil then
        state.skillImprovementMarked = {}
    end

    if state.homeTimeOpen == nil then
        state.homeTimeOpen = false
    end

    if state.genericRollChoice == nil or state.genericRollChoice == "" then
        state.genericRollChoice = "GUMSHOE"
    end

    if state.multiQty1 == nil then state.multiQty1 = 1 end
    if state.multiDie1 == nil then state.multiDie1 = "d6" end
    if state.multiQty2 == nil then state.multiQty2 = 0 end
    if state.multiDie2 == nil then state.multiDie2 = "d4" end
    if state.multiQty3 == nil then state.multiQty3 = 0 end
    if state.multiDie3 == nil then state.multiDie3 = "d8" end
    if state.multiQty4 == nil then state.multiQty4 = 0 end
    if state.multiDie4 == nil then state.multiDie4 = "Hit Location" end
    if state.multiModifier == nil then state.multiModifier = "0" end
    if state.sanLossFormula == nil or state.sanLossFormula == "" then
        state.sanLossFormula = "0/1d4"
    state.rollModifier = 0
    state.incomingDamage = "0"
    state.incomingAP = "0"
    state.activeArmorIndex = 1
    end

    if state.rollModifier == nil then state.rollModifier = 0 end
    if state.incomingDamage == nil then state.incomingDamage = "0" end
    if state.incomingAP == nil then state.incomingAP = "0" end
    if state.activeArmorIndex == nil then state.activeArmorIndex = 1 end
    state.itemQuantities = state.itemQuantities or {}
    state.ammoPools = state.ammoPools or {}
    state.addItemQuantity = math.max(1, math.floor(tonumber(state.addItemQuantity) or 1))
    state.addItemBrowseLevel = tostring(state.addItemBrowseLevel or "root")
    state.addItemCategory = tostring(state.addItemCategory or "")
    state.addItemSubcategory = tostring(state.addItemSubcategory or "")
    state.addItemName = tostring(state.addItemName or "")
    state.addReserveRounds = math.max(0, math.floor(tonumber(state.addReserveRounds) or 0))
    state.addReserveMags = math.max(0, math.floor(tonumber(state.addReserveMags) or 0))
    state.equipment.spendable = tonumber(state.equipment.spendable) or 0
    state.equipment.valuables = tostring(state.equipment.valuables or "")
    state.equipment.currencyBalances = state.equipment.currencyBalances or {}
    state.equipment.currencyDraft = tostring(state.equipment.currencyDraft or "")
    state.equipment.currencyAssignPending = state.equipment.currencyAssignPending == true

    migrateLegacyWeaponReservesToPools()

    state.agent.sex = tostring(state.agent.sex or "")
    state.agent.distinguishing = state.agent.distinguishing or {}
    for _, key in ipairs({"str","con","dex","int","pow","cha"}) do
        if state.agent.distinguishing[key] == nil then
            state.agent.distinguishing[key] = ""
        end
    end

    state.psychology.violenceIncidents =
        math.max(0, math.min(3, tonumber(state.psychology.violenceIncidents) or
        (state.psychology.adaptedViolence and 3 or 0)))

    state.psychology.helplessnessIncidents =
        math.max(0, math.min(3, tonumber(state.psychology.helplessnessIncidents) or
        (state.psychology.adaptedHelplessness and 3 or 0)))

    local function ensureBoxes(existing, count, adapted)
        if type(existing) == "table" then
            return {
                existing[1] == true,
                existing[2] == true,
                existing[3] == true
            }
        end

        local boxes = {false,false,false}
        local n = adapted and 3 or math.max(0, math.min(3, tonumber(count) or 0))
        for i=1,n do boxes[i] = true end
        return boxes
    end

    state.psychology.violenceBoxes =
        ensureBoxes(
            state.psychology.violenceBoxes,
            state.psychology.violenceIncidents,
            state.psychology.adaptedViolence
        )

    state.psychology.helplessnessBoxes =
        ensureBoxes(
            state.psychology.helplessnessBoxes,
            state.psychology.helplessnessIncidents,
            state.psychology.adaptedHelplessness
        )

    state.psychology.sanSource = tostring(state.psychology.sanSource or "Unnatural")
    state.psychology.selectedBondIndex = tonumber(state.psychology.selectedBondIndex) or 1
    state.psychology.motivationUsed = state.psychology.motivationUsed or {}
    state.psychology.sessionSanLost = tonumber(state.psychology.sessionSanLost) or 0
    state.psychology.sessionBreakingPoints = tonumber(state.psychology.sessionBreakingPoints) or 0
    state.psychology.sessionBondDamage = tonumber(state.psychology.sessionBondDamage) or 0
    state.psychology.temporaryInsanityPending = state.psychology.temporaryInsanityPending == true

    for _, bond in ipairs(state.importedBonds or {}) do
        if bond.damaged == nil then bond.damaged = false end
    end

    for _, w in ipairs(state.importedWeapons or {}) do
        if w.quantity == nil then w.quantity = 1 end
        if w.fireMode == nil or w.fireMode == "" then w.fireMode = "SINGLE" end
        if w.accessoryMod == nil then w.accessoryMod = 0 end
        if w.ammoReserve == nil then w.ammoReserve = 0 end
        if w.ammoCurrent == nil then
            local cap = tonumber(tostring(w.capacity or w.ammo or ""):match("(%d+)"))
            if cap then w.ammoCurrent = cap end
        end
    end
end

splitLinesToItems = function(text)
    local items = {}

    if text == nil then
        return items
    end

    for line in tostring(text):gmatch("[^\r\n]+") do
        local clean = line:gsub("^%s+", ""):gsub("%s+$", "")
        if clean ~= "" then
            table.insert(items, clean)
        end
    end

    return items
end

-------------------------------------------------
-- PIGEON LABS / DELTA GREEN STATS JSON IMPORT
-------------------------------------------------

local PIGEON_SKILL_MAP = {
    accounting = "Accounting",
    alertness = "Alertness",
    anthropology = "Anthropology",
    archeology = "Archeology",
    art = "Art",
    artillery = "Artillery",
    athletics = "Athletics",
    bureaucracy = "Bureaucracy",
    computer_science = "Computer Science",
    criminology = "Criminology",
    demolitions = "Demolitions",
    disguise = "Disguise",
    dodge = "Dodge",
    drive = "Drive",
    firearms = "Firearms",
    first_aid = "First Aid",
    forensics = "Forensics",
    heavy_machiner = "Heavy Machinery",
    heavy_machinery = "Heavy Machinery",
    heavy_weapons = "Heavy Weapons",
    history = "History",
    humint = "HUMINT",
    law = "Law",
    medicine = "Medicine",
    melee_weapons = "Melee Weapons",
    military_science = "Military Science",
    navigate = "Navigate",
    occult = "Occult",
    persuade = "Persuade",
    pharmacy = "Pharmacy",
    psychotherapy = "Psychotherapy",
    ride = "Ride",
    search = "Search",
    sigint = "SIGINT",
    stealth = "Stealth",
    surgery = "Surgery",
    survival = "Survival",
    swim = "Swim",
    unarmed_combat = "Unarmed Combat",
    unnatural = "Unnatural"
}

local function titleCaseSlug(value)
    local s = tostring(value or "")
    s = s:gsub("_", " ")

    s = s:gsub("(%a)([%w']*)", function(first, rest)
        return string.upper(first) .. string.lower(rest)
    end)

    return s
end

local function importStructuredBonds(bonds)
    ensureStructuredImportState()

    state.importedBonds = {}

    if type(bonds) ~= "table" then
        return
    end

    for _, bond in ipairs(bonds) do
        if type(bond) == "table" then
            table.insert(state.importedBonds, {
                id = tostring(bond.id or ""),
                name = tostring(bond.name or "Unnamed Bond"),
                relationship = tostring(bond.relationship or ""),
                description = tostring(bond.description or ""),
                score = math.floor(tonumber(bond.score) or 0),
                damaged = bond.damaged == true
            })
        end
    end
end

local function joinImportedEquipment(items, extraGear)
    local lines = {}

    if type(items) == "table" then
        for _, item in ipairs(items) do
            if item ~= nil and tostring(item) ~= "" then
                table.insert(lines, tostring(item))
            end
        end
    end

    if extraGear and tostring(extraGear) ~= "" then
        if #lines > 0 then
            table.insert(lines, "")
        end

        table.insert(lines, tostring(extraGear))
    end

    return table.concat(lines, "\n")
end

local function importStructuredEquipment(data, lpNotes)
    ensureStructuredImportState()

    state.importedGear = {}
    state.importedArmor = {}
    state.importedWeapons = {}

    state.itemQuantities = {}
    state.ammoPools = {}

    if type(data.equipment) == "table" then
        for _, item in ipairs(data.equipment) do
            if item ~= nil and tostring(item) ~= "" then
                local itemName = tostring(item)
                local key = string.lower(itemName)
                local c = EQUIPMENT_CATALOG[key]

                if c and c.kind == "weapon" then
                    local existing = nil

                    for _, w in ipairs(state.importedWeapons) do
                        if string.lower(tostring(w.name or "")) == key then
                            existing = w
                            break
                        end
                    end

                    if existing then
                        existing.quantity = (tonumber(existing.quantity) or 1) + 1
                    else
                        local cap = tonumber(tostring(c.capacity or ""):match("(%d+)"))

                        table.insert(state.importedWeapons, {
                            name = catalogDisplayName(key),
                            skill = tostring(c.skill or ""),
                            range = tostring(c.range or ""),
                            damage = tostring(c.damage or ""),
                            lethality = tostring(c.lethality or ""),
                            capacity = tostring(c.capacity or ""),
                            caliber = tostring(c.caliber or ""),
                            ammoCurrent = cap,
                            ammoReserve = 0,
                            quantity = 1,
                            fireMode = "SINGLE",
                            accessoryMod = tonumber(c.accessoryMod) or 0,
                            ap = tostring(c.ap or ""),
                            killRadius = tostring(c.killRadius or ""),
                            expense = tostring(c.expense or ""),
                            consumable = c.consumable == true,
                            sourceCategory = tostring(c.sourceCategory or ""),
                            notes = tostring(c.notes or "")
                        })
                    end

                elseif c and c.kind == "armor" then
                    table.insert(state.importedArmor, {
                        name = catalogDisplayName(key),
                        armor = tostring(c.armor or ""),
                        expense = tostring(c.expense or ""),
                        notes = tostring(c.notes or "")
                    })
                    state.itemQuantities[key] =
                        (tonumber(state.itemQuantities[key]) or 0) + 1

                else
                    local already = false
                    for _, g in ipairs(state.importedGear) do
                        if string.lower(tostring(g or "")) == key then
                            already = true
                            break
                        end
                    end

                    if not already then
                        table.insert(state.importedGear, itemName)
                    end

                    state.itemQuantities[key] =
                        (tonumber(state.itemQuantities[key]) or 0) + 1
                end
            end
        end
    end

    if lpNotes and lpNotes.gear and tostring(lpNotes.gear) ~= "" then
        for _, line in ipairs(splitLinesToItems(lpNotes.gear)) do
            table.insert(state.importedGear, line)
        end
    end

    if type(data.lpWeapons) == "table" then
        for _, w in ipairs(data.lpWeapons) do
            if type(w) == "table" then
                table.insert(state.importedWeapons, {
                    name = tostring(w.name or w.label or "Weapon"),
                    skill = tostring(w.skill or ""),
                    range = tostring(w.range or w.baseRange or ""),
                    damage = tostring(w.damage or ""),
                    lethality = tostring(w.lethality or ""),
                    capacity = tostring(w.capacity or w.ammo or ""),
                    caliber = tostring(w.caliber or ""),
                    ammoCurrent = tonumber(w.ammoCurrent or w.currentAmmo),
                    ammoReserve = tonumber(w.ammoReserve or w.reserveAmmo) or 0,
                    quantity = tonumber(w.quantity) or 1,
                    fireMode = tostring(w.fireMode or "SINGLE"),
                    accessoryMod = tonumber(w.accessoryMod or w.attackModifier) or 0,
                    ap = tostring(w.ap or w.armorPiercing or ""),
                    expense = tostring(w.expense or w.cost or ""),
                    notes = tostring(w.notes or w.description or "")
                })
            elseif w ~= nil and tostring(w) ~= "" then
                table.insert(state.importedWeapons, {
                    name = tostring(w),
                    skill = "",
                    damage = "",
                    notes = ""
                })
            end
        end
    end

    if data.itemsJson and tostring(data.itemsJson) ~= "" then
        local okItems, decodedItems = pcall(
            JSON.decode,
            tostring(data.itemsJson)
        )

        if okItems and type(decodedItems) == "table" then
            for _, item in ipairs(decodedItems) do
                if type(item) == "table" then
                    local sys = item.system or {}

                    if item.type == "weapon" then
                        table.insert(state.importedWeapons, {
                            name = tostring(item.name or "Weapon"),
                            skill = PIGEON_SKILL_MAP[sys.skill] or titleCaseSlug(sys.skill or ""),
                            range = tostring(sys.range or sys.baseRange or ""),
                            damage = tostring(sys.damage or ""),
                            lethality = tostring(sys.lethality or ""),
                            capacity = tostring(sys.capacity or sys.ammo or sys.ammoCapacity or ""),
                            caliber = tostring(sys.caliber or ""),
                            ammoCurrent = tonumber(sys.ammoCurrent or sys.currentAmmo),
                            ammoReserve = tonumber(sys.ammoReserve or sys.reserveAmmo) or 0,
                            quantity = tonumber(sys.quantity) or 1,
                            fireMode = tostring(sys.fireMode or "SINGLE"),
                            accessoryMod = tonumber(sys.accessoryMod or sys.attackModifier) or 0,
                            ap = tostring(sys.ap or sys.armorPiercing or ""),
                            expense = tostring(sys.expense or sys.cost or ""),
                            notes = tostring(sys.notes or sys.description or "")
                        })

                    elseif item.type == "armor" then
                        table.insert(state.importedArmor, {
                            name = tostring(item.name or "Armor"),
                            armor = tostring(sys.armor or sys.protection or ""),
                            notes = tostring(sys.notes or sys.description or "")
                        })
                    end
                end
            end
        end
    end

    -- Preserve existing freeform armor lines as structured armor entries.
    if state.equipment.armor and tostring(state.equipment.armor) ~= "" then
        for _, line in ipairs(splitLinesToItems(state.equipment.armor)) do
            table.insert(state.importedArmor, {
                name = line,
                armor = "",
                notes = ""
            })
        end
    end
end

local function adaptedFromBoxes(boxes)
    if type(boxes) ~= "table" then
        return false
    end

    local checked = 0

    for _, value in ipairs(boxes) do
        if value == true then
            checked = checked + 1
        end
    end

    return checked >= 3
end

local function syncImportedCharacterToObjects()
    pushAgentNameToDisplay()




end


local function applyImportedSkills(skills, specialtyInstances)
    if type(skills) ~= "table" then
        return 0, 0
    end

    if state.skillEnabled == nil then
        state.skillEnabled = {}
    end

    if state.pageHelperGuids == nil then
        state.pageHelperGuids = {}
    end

    -- Imported sheet is authoritative for the exported skill list.
    -- First mark every existing skill inactive; the imported values below
    -- explicitly reactivate skills that have a positive value.
    for name, _ in pairs(state.skills) do
        state.skillEnabled[name] = false
    end

    local importedCount = 0
    local activeCount = 0

    for externalKey, rawValue in pairs(skills) do
        local key = tostring(externalKey or "")
        local internalName = PIGEON_SKILL_MAP[key]

        if not internalName then
            internalName = titleCaseSlug(key)
        end

        if internalName ~= "" then
            local amount = math.floor(tonumber(rawValue) or 0)

            if amount < 0 then amount = 0 end
            if amount > 99 then amount = 99 end

            state.skills[internalName] = amount
            state.skillEnabled[internalName] = amount > 0

            importedCount = importedCount + 1
            if amount > 0 then
                activeCount = activeCount + 1
            end
        end
    end

    -- Import site specialties as their own editable skills.
    if type(specialtyInstances) == "table" then
        for _, spec in ipairs(specialtyInstances) do
            if type(spec) == "table" then
                local specialty = tostring(spec.specialty or "")
                local baseKey = tostring(spec.key or "")

                if specialty ~= "" then
                    local baseName = PIGEON_SKILL_MAP[baseKey] or titleCaseSlug(baseKey)
                    local name

                    if baseName ~= "" then
                        name = baseName .. " (" .. specialty .. ")"
                    else
                        name = specialty
                    end

                    local amount = math.floor(tonumber(spec.value) or 0)
                    if amount < 0 then amount = 0 end
                    if amount > 99 then amount = 99 end

                    state.skills[name] = amount
                    state.skillEnabled[name] = amount > 0

                    importedCount = importedCount + 1
                    if amount > 0 then
                        activeCount = activeCount + 1
                    end
                end
            end
        end
    end

    return importedCount, activeCount
end

local function applyPigeonCharacter(data)
    if type(data) ~= "table" then
        return false, "JSON root is not an object."
    end

    if type(data.stats) ~= "table" and
       type(data.csStats) ~= "table"
    then
        return false, "This does not look like a Delta Green Stats character export."
    end

    local stats = data.csStats or data.stats or {}
    local derived = data.derived or {}
    local bio = data.bio or {}
    local skills = data.skills or {}
    local lpNotes = data.lpNotes or {}
    local sanity = data.sanity or {}

    -------------------------------------------------
    -- CORE STATS
    -------------------------------------------------
    state.agent.str = clampBaseStat(stats.STR or stats.str or state.agent.str)
    state.agent.dex = clampBaseStat(stats.DEX or stats.dex or state.agent.dex)
    state.agent.con = clampBaseStat(stats.CON or stats.con or state.agent.con)
    state.agent.int = clampBaseStat(stats.INT or stats.int or state.agent.int)
    state.agent.pow = clampBaseStat(stats.POW or stats.pow or state.agent.pow)
    state.agent.cha = clampBaseStat(stats.CHA or stats.cha or state.agent.cha)

    state.agent.hpMax = deriveHPMax()
    state.agent.wpMax = deriveWPMax()

    state.agent.hp = clamp(
        math.floor(tonumber(derived.hp) or state.agent.hpMax),
        0,
        state.agent.hpMax
    )

    state.agent.wp = clamp(
        math.floor(tonumber(derived.wp) or state.agent.wpMax),
        0,
        state.agent.wpMax
    )

    local importedSan = math.floor(
        tonumber(derived.san) or
        (state.agent.pow * 5)
    )

    if importedSan < 0 then importedSan = 0 end
    if importedSan > 99 then importedSan = 99 end

    state.agent.san = importedSan

    -- The external creator exports the current/starting SAN rather than
    -- a separate SAN ceiling, so preserve the existing sheet convention
    -- and make the imported SAN the initial displayed maximum.
    state.agent.sanMax = importedSan

    state.agent.breakingPoint = math.floor(
        tonumber(derived.bp) or
        math.max(0, importedSan - state.agent.pow)
    )

    if state.agent.breakingPoint < 0 then
        state.agent.breakingPoint = 0
    end

    -------------------------------------------------
    -- BIOGRAPHY
    -------------------------------------------------
    state.agent.name = tostring(bio.name or state.agent.name)

    if bio.profession and tostring(bio.profession) ~= "" then
        state.agent.profession = titleCaseSlug(bio.profession)
    end

    state.agent.employer = tostring(bio.employer or state.agent.employer)
    state.agent.nationality = tostring(bio.nationality or state.agent.nationality)
    state.agent.sex = tostring(bio.sex or state.agent.sex or "")
    state.agent.age = tostring(bio.age or state.agent.age)
    state.agent.education = tostring(bio.education or state.agent.education)

    if bio.physicalDesc ~= nil then
        state.agent.physicalDescription = tostring(bio.physicalDesc)
    end

    if bio.motivations ~= nil then
        state.psychology.motivations = tostring(bio.motivations)
    end

    local importedDist =
        data.distinguishingFeatures or
        bio.distinguishingFeatures or
        data.statFeatures or
        {}

    if type(importedDist) == "table" then
        state.agent.distinguishing = state.agent.distinguishing or {}
        for _, key in ipairs({"str","con","dex","int","pow","cha"}) do
            local v =
                importedDist[key] or
                importedDist[string.upper(key)]
            if v ~= nil then
                state.agent.distinguishing[key] = tostring(v)
            end
        end
    end

    -------------------------------------------------
    -- SKILLS
    -------------------------------------------------
    local importedSkillCount, importedActiveSkillCount = applyImportedSkills(skills, data.specialtyInstances)

    -------------------------------------------------
    -- BONDS / PSYCHOLOGY
    -------------------------------------------------
    if type(data.bonds) == "table" then
        importStructuredBonds(data.bonds)
    end

    if type(sanity.violence) == "table" then
        state.psychology.violenceBoxes = {
            sanity.violence[1] == true,
            sanity.violence[2] == true,
            sanity.violence[3] == true
        }

        local count = 0
        for i=1,3 do
            if state.psychology.violenceBoxes[i] then count = count + 1 end
        end

        state.psychology.violenceIncidents = count
        state.psychology.adaptedViolence = count >= 3
    end

    if type(sanity.helplessness) == "table" then
        state.psychology.helplessnessBoxes = {
            sanity.helplessness[1] == true,
            sanity.helplessness[2] == true,
            sanity.helplessness[3] == true
        }

        local count = 0
        for i=1,3 do
            if state.psychology.helplessnessBoxes[i] then count = count + 1 end
        end

        state.psychology.helplessnessIncidents = count
        state.psychology.adaptedHelplessness = count >= 3
    end

    if bio.personalDetails ~= nil then
        state.agent.motivation = tostring(bio.personalDetails)
    end

    -------------------------------------------------
    -- EQUIPMENT / NOTES
    -------------------------------------------------
    importStructuredEquipment(data, lpNotes)

    state.equipment.gear = table.concat(state.importedGear, "\n")

    if lpNotes.remarks ~= nil then
        state.equipment.notes = tostring(lpNotes.remarks)
    end

    if lpNotes.wounds ~= nil then
        state.agent.wounds = tostring(lpNotes.wounds)
    end


    -------------------------------------------------
    -- IMPORT STATE
    -------------------------------------------------
    state.skillsActiveOnly = true
    state.skillImprovementMarked = {}
    state.homeTimeOpen = false
    state.equipmentSubtab = "all"
    state.psychologySubtab = "sanity"

    -- A fresh import should be immediately editable. The user can
    -- re-enable Lock Text afterward from the context menu.
    state.textLocked = false

    state.importBuffer = ""
    state.importStatus = string.format(
        "Import successful: %s — %d skills imported, %d active. Alertness=%s, Firearms=%s, HUMINT=%s, Unarmed=%s",
        state.agent.name,
        importedSkillCount or 0,
        importedActiveSkillCount or 0,
        tostring(state.skills["Alertness"]),
        tostring(state.skills["Firearms"]),
        tostring(state.skills["HUMINT"]),
        tostring(state.skills["Unarmed Combat"])
    )

    syncImportedCharacterToObjects()
    queueDashboardSnapshot(state.ownerColor, "status", "Character imported")

    return true, state.importStatus
end

local function buildImportPage()
    local buffer = state.importBuffer or ""
    local importStatus = state.importStatus or
        "Paste the Live Character Sheet JSON export below."

    return [[
    <VerticalScrollView id="scroll_import"
        width="1180" preferredWidth="1180"
        height="700" preferredHeight="700"
        rectAlignment="UpperCenter"
        scrollSensitivity="35"
        color="#0D151100"
        verticalScrollbarVisibility="AutoHide"
        scrollbarBackgroundColor="#101712"
        scrollbarColors="#55705D|#66836D|#78937E|#33443A">

      <Panel id="page_import"
          width="1160" height="840"
          rectAlignment="UpperCenter">

        <Text
            text="IMPORT DELTA GREEN STATS JSON"
            rectAlignment="UpperLeft"
            width="700" height="38"
            offsetXY="26 -22"
            fontSize="22"
            fontStyle="Bold"
            color="#BFD2C4"
            alignment="MiddleLeft"/>

        <Text
            text="From pigeon-labs-stack.github.io/DELTA-GREEN-STATS/ → Live Character Sheet JSON export. Paste the entire JSON object here."
            rectAlignment="UpperLeft"
            width="1090" height="52"
            offsetXY="26 -66"
            fontSize="15"
            color="#9EB1A3"
            alignment="UpperLeft"
            horizontalOverflow="Wrap"
            verticalOverflow="Overflow"/>

        <InputField
            id="character_import_json"
            text="]]..esc(buffer)..[["
            onValueChanged="captureImportJson"
            onEndEdit="captureImportJson"
            lineType="MultiLineNewline"
            rectAlignment="UpperLeft"
            width="1090" height="500"
            offsetXY="26 -128"
            fontSize="15"
            textColor="#F1F7F2"
            color="#101813"
            selectionColor="#355845"/>

        <Text
            text="]]..esc(importStatus)..[["
            rectAlignment="UpperLeft"
            width="1090" height="42"
            offsetXY="26 -646"
            fontSize="15"
            color="#C6D6CA"
            alignment="MiddleLeft"/>

        <Button
            id="import_character_confirm"
            onClick="importCharacterJson"
            text="IMPORT CHARACTER"
            rectAlignment="UpperLeft"
            width="260" height="48"
            offsetXY="26 -706"
            fontSize="18"
            fontStyle="Bold"
            color="#365C49"
            textColor="#FFFFFF"/>

        <Button
            id="import_character_clear"
            onClick="clearCharacterImport"
            text="CLEAR"
            rectAlignment="UpperLeft"
            width="150" height="48"
            offsetXY="300 -706"
            fontSize="17"
            color="#343E38"
            textColor="#FFFFFF"/>

        <Button
            id="import_character_cancel"
            onClick="cancelCharacterImport"
            text="CANCEL"
            rectAlignment="UpperLeft"
            width="150" height="48"
            offsetXY="465 -706"
            fontSize="17"
            color="#4A3030"
            textColor="#FFFFFF"/>

      </Panel>
    </VerticalScrollView>]]
end



local lastPortraitAssetUrl = nil

local function refreshPortraitAsset()
    -- Portraits now render directly from the URL in the <Image> element.
    -- Keep this function as a compatibility no-op because older lifecycle
    -- code still calls it.
    if state.agent then
        lastPortraitAssetUrl = tostring(state.agent.portraitUrl or "")
    else
        lastPortraitAssetUrl = ""
    end
end

local function findHandlerDashboardObject()
    if HANDLER_DASHBOARD_GUID and HANDLER_DASHBOARD_GUID ~= "" then
        local direct = getObjectFromGUID(HANDLER_DASHBOARD_GUID)
        if direct then
            return direct
        end
    end

    local ok, guid = pcall(function()
        return Global.getVar("DG_HANDLER_DASHBOARD_GUID")
    end)

    if ok and guid and guid ~= "" then
        return getObjectFromGUID(guid)
    end

    return nil
end

local function clearHandlerDashboardAgent()
    local dashboard = findHandlerDashboardObject()

    if not dashboard then
        return false
    end

    local ok = pcall(function()
        dashboard.call("clearAgent", {
            color = SHEET_COLOR,
            sheetGuid = self.getGUID()
        })
    end)

    return ok
end

local function resetCharacterData()
    -- True character-data wipe. Sheet theme/layout/helper infrastructure remains.
    physicalRoll = nil
    genericPhysicalRoll = nil
    diceBatchRoll = nil
    physicalRollMonitorRunning = false
    genericPhysicalRollMonitorRunning = false
    diceBatchMonitorRunning = false

    state.agent = {
        name = "",
        profession = "",
        employer = "",
        nationality = "",
        sex = "",
        age = "",
        education = "",
        distinguishing = { str="", con="", dex="", int="", pow="", cha="" },
        str = 0, con = 0, dex = 0, int = 0, pow = 0, cha = 0,
        hp = 0, hpMax = 0,
        wp = 0, wpMax = 0,
        san = 0, sanMax = 0,
        breakingPoint = 0,
        physicalDescription = "",
        motivation = "",
        wounds = "",
        portraitUrl = ""
    }

    state.skills = {
        ["Accounting"] = 0,
        ["Alertness"] = 0,
        ["Anthropology"] = 0,
        ["Archeology"] = 0,
        ["Art"] = 0,
        ["Athletics"] = 0,
        ["Bureaucracy"] = 0,
        ["Computer Science"] = 0,
        ["Criminology"] = 0,
        ["Disguise"] = 0,
        ["Dodge"] = 0,
        ["Drive"] = 0,
        ["Firearms"] = 0,
        ["First Aid"] = 0,
        ["Forensics"] = 0,
        ["Heavy Machinery"] = 0,
        ["Heavy Weapons"] = 0,
        ["History"] = 0,
        ["HUMINT"] = 0,
        ["Law"] = 0,
        ["Medicine"] = 0,
        ["Melee Weapons"] = 0,
        ["Military Science"] = 0,
        ["Navigate"] = 0,
        ["Occult"] = 0,
        ["Persuade"] = 0,
        ["Pharmacy"] = 0,
        ["Psychotherapy"] = 0,
        ["Ride"] = 0,
        ["Search"] = 0,
        ["SIGINT"] = 0,
        ["Stealth"] = 0,
        ["Surgery"] = 0,
        ["Survival"] = 0,
        ["Swim"] = 0,
        ["Unarmed Combat"] = 0,
        ["Unnatural"] = 0,
    }

    state.skillEnabled = {
        ["Accounting"] = false,
        ["Alertness"] = false,
        ["Anthropology"] = false,
        ["Archeology"] = false,
        ["Art"] = false,
        ["Athletics"] = false,
        ["Bureaucracy"] = false,
        ["Computer Science"] = false,
        ["Criminology"] = false,
        ["Disguise"] = false,
        ["Dodge"] = false,
        ["Drive"] = false,
        ["Firearms"] = false,
        ["First Aid"] = false,
        ["Forensics"] = false,
        ["Heavy Machinery"] = false,
        ["Heavy Weapons"] = false,
        ["History"] = false,
        ["HUMINT"] = false,
        ["Law"] = false,
        ["Medicine"] = false,
        ["Melee Weapons"] = false,
        ["Military Science"] = false,
        ["Navigate"] = false,
        ["Occult"] = false,
        ["Persuade"] = false,
        ["Pharmacy"] = false,
        ["Psychotherapy"] = false,
        ["Ride"] = false,
        ["Search"] = false,
        ["SIGINT"] = false,
        ["Stealth"] = false,
        ["Surgery"] = false,
        ["Survival"] = false,
        ["Swim"] = false,
        ["Unarmed Combat"] = false,
        ["Unnatural"] = false,
    }

    state.skillImprovementMarked = {}
    state.skillsActiveOnly = true
    state.homeTimeOpen = false

    state.genericRollChoice = "GUMSHOE"
    state.multiQty1 = 1
    state.multiDie1 = "d6"
    state.multiQty2 = 0
    state.multiDie2 = "d4"
    state.multiQty3 = 0
    state.multiDie3 = "d8"
    state.multiQty4 = 0
    state.multiDie4 = "Hit Location"
    -- Keep the checked dice list. It changes only when the Handler explicitly
    -- requests CHECK FOR NEW DICE.
    state.availableDice = state.availableDice
    state.multiModifier = "0"
    state.sanLossFormula = "0/1d4"
    state.rollModifier = 0
    state.incomingDamage = "0"
    state.incomingAP = "0"
    state.activeArmorIndex = 1

    state.equipment = {
        weapons = "",
        armor = "",
        gear = "",
        cash = "",
        spendable = 0,
        valuables = "",
        notes = "",
        currencyBalances = {},
        currencyDraft = "",
        currencyAssignPending = false
    }

    state.importedWeapons = {}
    state.importedArmor = {}
    state.importedGear = {}
    state.itemQuantities = {}
    state.ammoPools = {}
    state.addItemQuantity = 1
    state.addItemBrowseLevel = "root"
    state.addItemCategory = ""
    state.addItemSubcategory = ""
    state.addItemName = ""
    state.addReserveRounds = 0
    state.addReserveMags = 0

    state.psychology = {
        bonds = "",
        disorders = "",
        adaptedViolence = false,
        adaptedHelplessness = false,
        violenceIncidents = 0,
        helplessnessIncidents = 0,
        violenceBoxes = {false,false,false},
        helplessnessBoxes = {false,false,false},
        sanSource = "Unnatural",
        pendingSanLoss = nil,
        pendingSanSource = nil,
        selectedBondIndex = 1,
        temporaryInsanityPending = false,
        motivationUsed = {},
        sessionSanLost = 0,
        sessionBreakingPoints = 0,
        sessionBondDamage = 0,
        motivations = "",
        notes = "",
        disorderList = {},
        pendingDisorders = 0,
        pendingSource = "Violence",
        disorderPickIndex = 1
    }

    state.importedBonds = {}

    state.importBuffer = ""
    state.importStatus = nil
    state.clearConfirm = false
    state.textLocked = false

    state.currentTab = "personnel"
    state.personnelSubtab = "profile"
    state.equipmentSubtab = "all"
    state.psychologySubtab = "sanity"

    lastPortraitAssetUrl = nil
    pushAgentNameToDisplay()
    clearHandlerDashboardAgent()
    refreshPortraitAsset()

    markAllCachedPagesDirty()

    self.UI.setXml(applyUiTheme(buildXml()))
    uiReady = true

    if pageCacheInitialized then
        themeRebuildRunning = true
        rebuildCachedPagesSequentially(1)
    else
        rebuildUI()
    end

    Wait.frames(function()
        activateCachedPage("personnel")
        dgSyncActiveCachedHelperTransform(true)
    end, 3)

    broadcastToAll(
        "[DG] Character sheet cleared completely.",
        {0.65,0.85,0.70}
    )
end

local function buildClearButtonXml()
    if state.clearConfirm == true then
        return [[
          <Button id="clear_sheet_confirm"
              onClick="clearSheetButton"
              text="CONFIRM CLEAR"
              fontSize="12"
              fontStyle="Bold"
              color="#7A3434"
              textColor="#FFFFFF"
              preferredWidth="125"
              preferredHeight="42"/>
        ]]
    end

    return [[
      <Button id="clear_sheet"
          onClick="clearSheetButton"
          text="CLEAR SHEET"
          fontSize="12"
          color="#26352C"
          textColor="#FFFFFF"
          preferredWidth="125"
          preferredHeight="42"/>
    ]]
end


local function colorDropdownOptions(order, selected)
    local options = {}

    for _, name in ipairs(order) do
        if name == selected then
            table.insert(options, '<Option selected="true">' .. esc(name) .. '</Option>')
        else
            table.insert(options, '<Option>' .. esc(name) .. '</Option>')
        end
    end

    return table.concat(options, "")
end

local function buildThemeControlsXml()
    local baseSelected = tostring(state.uiBaseColor or "Forest")
    local accentSelected = tostring(state.uiAccentColor or "Green")

    return string.format([[
      <HorizontalLayout preferredWidth="330" preferredHeight="44" spacing="6"
          childForceExpandHeight="false" childControlHeight="true">

        <VerticalLayout preferredWidth="155" spacing="0" childForceExpandHeight="false">
          <Text text="BASE" preferredHeight="13" fontSize="9"
              color="#A7C8B0" alignment="MiddleCenter"/>
          <Dropdown id="ui_base_color"
              onValueChanged="selectUiBaseColor"
              preferredWidth="155" preferredHeight="29"
              fontSize="12"
              color="#1D2B24"
              textColor="#FFFFFF"
              itemBackgroundColors="#1B2922|#294034|#355244|#15201A"
              itemTextColor="#FFFFFF"
              dropdownBackgroundColor="#121B16"
              checkColor="#8FC79D"
              arrowColor="#FFFFFF"
              itemHeight="30"
              dropdownHeight="300">
              %s
          </Dropdown>
        </VerticalLayout>

        <VerticalLayout preferredWidth="155" spacing="0" childForceExpandHeight="false">
          <Text text="ACCENT" preferredHeight="13" fontSize="9"
              color="#A7C8B0" alignment="MiddleCenter"/>
          <Dropdown id="ui_accent_color"
              onValueChanged="selectUiAccentColor"
              preferredWidth="155" preferredHeight="29"
              fontSize="12"
              color="#1D2B24"
              textColor="#FFFFFF"
              itemBackgroundColors="#1B2922|#294034|#355244|#15201A"
              itemTextColor="#FFFFFF"
              dropdownBackgroundColor="#121B16"
              checkColor="#8FC79D"
              arrowColor="#FFFFFF"
              itemHeight="30"
              dropdownHeight="360">
              %s
          </Dropdown>
        </VerticalLayout>

      </HorizontalLayout>
    ]],
        colorDropdownOptions(UI_BASE_COLOR_ORDER, baseSelected),
        colorDropdownOptions(UI_ACCENT_COLOR_ORDER, accentSelected)
    )
end


local function buildPageContentFor(tabName)
    if tabName == "personnel" then
        return buildPersonnel()
    elseif tabName == "skills" then
        local oldActiveOnly = state.skillsActiveOnly
        state.skillsActiveOnly = false
        local page = buildSkills()
        state.skillsActiveOnly = oldActiveOnly
        return page
    elseif tabName == "skills_active" then
        local oldActiveOnly = state.skillsActiveOnly
        state.skillsActiveOnly = true
        local page = buildSkills()
        state.skillsActiveOnly = oldActiveOnly
        return page
    elseif tabName == "equipment" then
        return buildEquipment()
    elseif tabName == "psychology" then
        return buildPsychology()
    elseif tabName == "disorders" then
        return buildDisorders()
    elseif tabName == "import" then
        return buildImportPage()
    end

    return buildPersonnel()
end

local function resolvedCachedPageName()
    local current = tostring(state.currentTab or "personnel")

    if current == "skills" and state.skillsActiveOnly == true then
        return "skills_active"
    end

    return current
end

local function buildCachedPageXml(tabName)
    local page = buildPageContentFor(tabName)

    -- The header is 50 high and the main tab row is 46 high.
    -- Put the cached page explicitly below them instead of using
    -- invisible spacer layouts, which drift on ScriptingTrigger UIs.
    local pageWidth = DG_MASTER_UI_WIDTH - 8

    local transform = dgComputeTransform(true)

    -- Cached page helpers must obey the same visibility rule as the
    -- physical Agent sheet. Black (Handler) can always see assigned sheets.
    local helperVisibility = ""
    local owner = tostring(state.ownerColor or "")

    if owner ~= "" and owner ~= "Public" then
        helperVisibility = owner .. "|Black"
    end

    local xml = string.format([[
<Panel id="dg_root"
    width="%d" height="%d"
    position="%s"
    rotation="%s"
    scale="%s"
    visibility="%s"
    color="#00000000"
    rectAlignment="MiddleCenter"
    raycastTarget="false">

  <Panel id="dg_cached_page"
      width="%d"
      preferredWidth="%d"
      height="700"
      preferredHeight="700"
      rectAlignment="UpperCenter"
      offsetXY="0 %d"
      color="#0D1511EE"
      raycastTarget="true">

    %s

  </Panel>

</Panel>
]],
        DG_MASTER_UI_WIDTH, DG_MASTER_UI_HEIGHT,
        transform.position, transform.rotation, transform.scale,
        helperVisibility,
        pageWidth,
        pageWidth,
        tonumber(state.cachedPageYOffset) or -111,
        page
    )

    return retargetHelperCallbacks(applyUiTheme(xml))
end


-- PERFORMANCE: cached pages are created only when first opened.
-- Once created they stay cached, preserving fast repeat tab switches.
local function ensureCachedPage(tabName, callback)
    tabName = tostring(tabName or "personnel")

    local existing = getCachedHelper(tabName)
    if existing then
        if cachedPageDirty[tabName] or not pageHelpersReady[tabName] then
            existing.UI.setXml(buildCachedPageXml(tabName))
            cachedPageDirty[tabName] = nil
            pageHelpersReady[tabName] = true
        end

        if callback then callback(existing) end
        return existing
    end

    spawnPageHelper(tabName, function(helper)
        helper.UI.setXml(buildCachedPageXml(tabName))
        cachedPageDirty[tabName] = nil
        pageHelpersReady[tabName] = true

        -- Apply current ownership visibility immediately to the new helper.
        local owner = state.ownerColor
        if owner == nil or owner == "" or owner == "Public" then
            pcall(function() helper.setInvisibleTo({}) end)
        else
            local hidden = {}
            for _, c in ipairs({"White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink","Grey","Black"}) do
                if c ~= owner and c ~= "Black" then
                    table.insert(hidden, c)
                end
            end
            pcall(function() helper.setInvisibleTo(hidden) end)
        end

        placeHelper(
            tabName,
            tostring(resolvedCachedPageName()) == tabName
        )

        if callback then callback(helper) end
    end)

    return nil
end


buildXml = function()
    -- Permanent lightweight shell: title, theme controls, Clear Sheet and tabs.
    local transform = dgComputeTransform(false)

    return string.format([[
<Panel id="dg_root"
    width="%d" height="%d"
    position="%s"
    rotation="%s"
    scale="%s"
    color="#00000000"
    rectAlignment="MiddleCenter"
    raycastTarget="false">

  <VerticalLayout spacing="0"
      padding="0 0 0 0"
      childForceExpandHeight="false"
      childControlHeight="true"
      raycastTarget="false">

    <HorizontalLayout preferredHeight="50"
        spacing="8"
        color="#101A14"
        childForceExpandHeight="false"
        raycastTarget="true">

      <VerticalLayout flexibleWidth="1"
          padding="8 4 0 4"
          childForceExpandHeight="false">

        <Text text="DELTA GREEN"
            fontSize="23"
            fontStyle="Bold"
            color="#A7C8B0"
            alignment="MiddleLeft"/>

        <Text text="PHYSICAL AGENT SHEET"
            fontSize="10"
            color="#667D6D"
            alignment="UpperLeft"/>

      </VerticalLayout>

      %s
      %s

    </HorizontalLayout>

    <Panel preferredHeight="46"
        height="46"
        color="#0D1511"
        raycastTarget="true">

      %s
      %s
      %s
      %s
      %s

    </Panel>

  </VerticalLayout>
</Panel>
]],
        DG_MASTER_UI_WIDTH, DG_MASTER_UI_HEIGHT,
        transform.position, transform.rotation, transform.scale,
        buildThemeControlsXml(),
        buildClearButtonXml(),
        navButton("personnel","PERSONNEL",state.currentTab=="personnel",0,-4),
        navButton("skills","SKILLS",state.currentTab=="skills",241,-4),
        navButton("equipment","EQUIPMENT",state.currentTab=="equipment",482,-4),
        navButton("psychology","PSYCHOLOGY",state.currentTab=="psychology",723,-4),
        navButton("disorders","DISORDERS",state.currentTab=="disorders",964,-4)
    )
end

rebuildCachedPage = function(tabName)
    local helper = getCachedHelper(tabName)
    if not helper then return false end

    helper.UI.setXml(buildCachedPageXml(tabName))
    pageHelpersReady[tabName] = true
    cachedPageDirty[tabName] = nil

    if tostring(state.currentTab or "personnel") == tabName then
        activateCachedPage(tabName)
    end

    return true
end

local themeRebuildRunning = false

markAllCachedPagesDirty = function()
    for _, tabName in ipairs(PAGE_HELPER_TABS) do
        cachedPageDirty[tabName] = true
    end
end

local function refreshCachedPageIfDirty(tabName)
    if cachedPageDirty[tabName] and getCachedHelper(tabName) then
        rebuildCachedPage(tabName)
        return true
    end
    return false
end


rebuildCachedPagesSequentially = function(index)
    index = tonumber(index) or 1

    if index > #PAGE_HELPER_TABS then
        themeRebuildRunning = false
        activateCachedPage(resolvedCachedPageName())
        return
    end

    local tabName = PAGE_HELPER_TABS[index]
    rebuildCachedPage(tabName)

    local helper = getCachedHelper(tabName)

    local function continueWhenReady()
        if helper and helper.UI.loading then
            Wait.frames(continueWhenReady, 1)
            return
        end

        Wait.frames(function()
            rebuildCachedPagesSequentially(index + 1)
        end, 5)
    end

    Wait.frames(continueWhenReady, 1)
end

local function rebuildAllCachedPages()
    if themeRebuildRunning then return end
    themeRebuildRunning = true
    rebuildCachedPagesSequentially(1)
end

local function initializePageCache()
    if pageHelpersBuilding then return end

    pageHelpersBuilding = true
    pageCacheInitialized = false

    local current = resolvedCachedPageName()

    -- PERFORMANCE / MIGRATION:
    -- r47 and earlier saved all seven helper GUIDs. Destroy this sheet's
    -- inactive legacy helpers on load so upgrading an existing table actually
    -- reduces active UI trees immediately. They will be recreated on demand.
    state.pageHelperGuids = state.pageHelperGuids or {}

    for _, tabName in ipairs(PAGE_HELPER_TABS) do
        if tabName ~= current then
            local guid = tostring(state.pageHelperGuids[tabName] or "")

            if guid ~= "" then
                local obj = getObjectFromGUID(guid)

                if obj and helperBelongsToThisSheet(obj, tabName) then
                    pcall(function()
                        destroyObject(obj)
                    end)
                end
            end

            state.pageHelperGuids[tabName] = nil
            pageHelpers[tabName] = nil
            pageHelpersReady[tabName] = nil
        end
    end

    -- Rebuild the one retained/current page once against the r48 code.
    cachedPageDirty[current] = true

    ensureCachedPage(current, function(helper)
        pageHelpersBuilding = false
        pageCacheInitialized = true
        activateCachedPage(current)

        Wait.frames(function()
            pcall(function()
                dgSyncActiveCachedHelperTransform(true)
            end)
        end, 1)
    end)
end



local ALL_PLAYER_COLORS = {
    "White","Brown","Red","Orange","Yellow","Green",
    "Teal","Blue","Purple","Pink","Grey","Black"
}

local function applyTextLock()
    if not uiReady then return end

    local locked = state.textLocked == true
    local readonly = locked and "true" or "false"
    local interactable = locked and "false" or "true"

    local ids = {
        "name","profession","employer","nationality","age","education",
        "str","con","dex","int","pow","cha",
        "hp","wp","san","sanMax",
        "physicalDescription","motivation","wounds","portraitUrl",
        "weapons","armor","gear","cash","equipmentNotes",
        "bonds","psychMotivations","psychNotes"
    }

    for _, id in ipairs(ids) do
        dgUISetAttributes(id, {
            readOnly = readonly,
            interactable = interactable
        })
    end

    for name, _ in pairs(state.skills) do
        local id = skillId(name)
        local skillOn = state.skillEnabled[name] ~= false

        dgUISetAttribute(
            id,
            "readOnly",
            (locked or not skillOn) and "true" or "false"
        )

        dgUISetAttribute(
            id.."_roll",
            "interactable",
            skillOn and "true" or "false"
        )
    end
end

local function applyViewerColor()
    local owner = state.ownerColor

    if owner == nil or owner == "" or owner == "Public" then
        self.setInvisibleTo({})

        for _, tabName in ipairs(PAGE_HELPER_TABS) do
            local helper = getCachedHelper(tabName)
            if helper then
                pcall(function()
                    helper.setInvisibleTo({})
                end)
            end
        end

        if uiReady then
            dgUISetAttribute("dg_root", "visibility", "")
        end
        return
    end

    local hidden = {}

    for _, c in ipairs(ALL_PLAYER_COLORS) do
        if c ~= owner and c ~= "Black" then
            table.insert(hidden, c)
        end
    end

    self.setInvisibleTo(hidden)

    for _, tabName in ipairs(PAGE_HELPER_TABS) do
        local helper = getCachedHelper(tabName)
        if helper then
            pcall(function()
                helper.setInvisibleTo(hidden)
            end)
        end
    end

    if uiReady then
        dgUISetAttribute(
            "dg_root",
            "visibility",
            owner .. "|Black"
        )
    end
end

local function buildColorContextMenu()
    self.clearContextMenu()

    self.addContextMenuItem("Public / Everyone", function()
        state.ownerColor = nil
        applyViewerColor()
        buildMainContextMenu()
    end)

    local colors = {"Red","Green","Pink","Purple","Blue","Orange"}

    for _, colorName in ipairs(colors) do
        self.addContextMenuItem(colorName, function()
            state.ownerColor = colorName
            applyViewerColor()
            queueDashboardSnapshot(colorName, "status", "Sheet assigned")
            buildMainContextMenu()
        end)
    end

    self.addContextMenuItem("< Back", function()
        buildMainContextMenu()
    end)
end


function buildMainContextMenu()
    self.clearContextMenu()


    self.addContextMenuItem(
        state.textLocked and "Unlock Text" or "Lock Text",
        function()
            state.textLocked = not state.textLocked
            applyTextLock()
            buildMainContextMenu()
        end
    )

    self.addContextMenuItem(
        "Import Character JSON",
        function()
            state.importBuffer = ""
            state.importStatus =
                "Paste the Live Character Sheet JSON export below."
            state.currentTab = "import"
            rebuildUI()
            Wait.frames(function()
                activateCachedPage("import")
            end, 2)
        end
    )

    self.addContextMenuItem(
        "Sync Agent Name",
        function()
            pushAgentNameToDisplay()
        end
    )
self.addContextMenuItem(
        "Reset Starting SAN / BP",
        function()
            initializeStartingSanityAndBreakingPoint()
            rebuildUI()
        end
    )

    self.addContextMenuItem(
        self.getLock() and "Unlock Object" or "Lock Object",
        function()
            self.setLock(not self.getLock())
            pcall(function()
                dgSyncActiveCachedHelperTransform(true)
                applyScaleCompensation(true)
            end)
            buildMainContextMenu()
        end
    )

    self.addContextMenuItem(
        "Rebuild Sheet UI",
        function()
            rebuildUI()
        end
    )
end



local function getNameDisplayObject()
    if not NAME_DISPLAY_GUID or NAME_DISPLAY_GUID == "" then
        return nil
    end

    return getObjectFromGUID(NAME_DISPLAY_GUID)
end

local function readNameDisplayValue()
    local obj = getNameDisplayObject()

    if not obj then
        return nil
    end

    local ok, data = pcall(function()
        return obj.getTable("ref_buttonData")
    end)

    if not ok or not data or
       not data.textbox or
       not data.textbox[1]
    then
        return nil
    end

    return tostring(data.textbox[1].value or "")
end

local function writeNameDisplayValue(newName)
    local obj = getNameDisplayObject()

    if not obj then
        return false
    end

    local ok, data = pcall(function()
        return obj.getTable("ref_buttonData")
    end)

    if not ok or not data then
        return false
    end

    if not data.textbox then
        data.textbox = {}
    end

    if not data.textbox[1] then
        data.textbox[1] = {
            pos = {0.0, 1.6, 0},
            rows = 1,
            width = 3880,
            font_size = 370,
            label = "Click me to edit!",
            value = "",
            alignment = 3
        }
    end

    newName = tostring(newName or "")

    if tostring(data.textbox[1].value or "") == newName then
        return true
    end

    data.textbox[1].value = newName

    local setOk = pcall(function()
        obj.setTable("ref_buttonData", data)
    end)

    if not setOk then
        return false
    end

    -- Refresh the existing text input directly.
    pcall(function()
        obj.editInput({
            index = 0,
            value = newName
        })
    end)

    -- Persist with the name object's own save function.
    pcall(function()
        obj.call("updateSave")
    end)

    return true
end

pushAgentNameToDisplay = function()
    return writeNameDisplayValue(state.agent.name)
end

local function pullAgentNameFromDisplay()
    local displayedName = readNameDisplayValue()

    if displayedName == nil then
        return false
    end

    displayedName = tostring(displayedName)

    if tostring(state.agent.name or "") ~= displayedName then
        state.agent.name = displayedName

        if uiReady then
            dgUISetValue("name", displayedName)
        end

        return true
    end

    return false
end

local function setBreakingPoint(newValue)
    newValue = math.floor(tonumber(newValue) or 0)

    -- Breaking Point can never be negative.
    if newValue < 0 then
        newValue = 0
    end

    if newValue > 999 then
        newValue = 999
    end

    state.agent.breakingPoint = newValue

    if uiReady then
        dgUISetValue("breakingPointDisplay", tostring(newValue))
    end

end


local function addPendingDisorder(oldBP, newBP, sanValue)
    ensureDisorderState()

    local p = state.psychology
    p.pendingDisorders = (tonumber(p.pendingDisorders) or 0) + 1
    p.lastBreakingPoint = {
        oldBP = tonumber(oldBP) or 0,
        newBP = tonumber(newBP) or 0,
        san = tonumber(sanValue) or 0
    }

    if uiReady then
        rebuildUI()
    end
end


local function safeBroadcastToColor(message, color, rgb)
    if not color or
       color == "" or
       color == "Public" or
       color == "Black"
    then
        return false
    end

    local seated = getSeatedPlayers() or {}
    local valid = false

    for _, seatedColor in ipairs(seated) do
        if seatedColor == color then
            valid = true
            break
        end
    end

    if not valid then
        return false
    end

    broadcastToColor(message, color, rgb)
    return true
end

local function announceBreakingPoint(newValue)
    local msg = string.format(
        "[DG] BREAKING POINT REACHED — choose the trauma source and assign an appropriate disorder on the DISORDERS tab. New Breaking Point: %d",
        newValue
    )

    local delivered = safeBroadcastToColor(
        msg,
        state.ownerColor,
        {1.0, 0.55, 0.35}
    )

    if not delivered then
        broadcastToAll(msg, {1.0, 0.55, 0.35})
    end
end

handleSanChange = function(oldSan, newSan)
    oldSan = tonumber(oldSan) or 0
    newSan = tonumber(newSan) or 0

    local bp = tonumber(state.agent.breakingPoint)

    if bp == nil then
        setBreakingPoint(
            math.max(
                0,
                newSan - (tonumber(state.agent.pow) or 0)
            )
        )
        return
    end

    -- Breaking Point remains fixed while SAN changes.
    -- Only when SAN reaches/crosses it do we calculate the NEXT BP.
    if oldSan > bp and newSan <= bp then
        local oldBP = bp

        local newBP = math.max(
            0,
            newSan - (tonumber(state.agent.pow) or 0)
        )

        -- SAN 0 is permanent insanity; otherwise record the newly gained disorder.
        if newSan > 0 then
            addPendingDisorder(oldBP, newBP, newSan)
        end

        setBreakingPoint(newBP)
        announceBreakingPoint(newBP)
    end
end

local function handlePowChange(oldPow, newPow)
    -- Intentionally does nothing to an existing Breaking Point.
    -- BP stays fixed until SAN reaches/crosses it.
    --
    -- If this is an old/incomplete save with no BP at all, initialize one.
    state.agent.str = clampBaseStat(state.agent.str)
    state.agent.con = clampBaseStat(state.agent.con)
    state.agent.dex = clampBaseStat(state.agent.dex)
    state.agent.int = clampBaseStat(state.agent.int)
    state.agent.pow = clampBaseStat(state.agent.pow)
    state.agent.cha = clampBaseStat(state.agent.cha)

    state.agent.hpMax = deriveHPMax()
    state.agent.wpMax = deriveWPMax()

    state.agent.sanMax = math.floor(tonumber(state.agent.sanMax) or 0)
    if state.agent.sanMax < 0 then state.agent.sanMax = 0 end
    if state.agent.sanMax > 999 then state.agent.sanMax = 999 end

    state.agent.hp = clampResourceValue("hp", state.agent.hp)
    state.agent.wp = clampResourceValue("wp", state.agent.wp)
    state.agent.san = clampResourceValue("san", state.agent.san)

    if state.agent.breakingPoint ~= nil then
        state.agent.breakingPoint = math.max(
            0,
            math.floor(tonumber(state.agent.breakingPoint) or 0)
        )
    end

    if state.agent.breakingPoint == nil then
        setBreakingPoint(
            math.max(
                0,
                (tonumber(state.agent.san) or 0) -
                (tonumber(newPow) or 0)
            )
        )
    end
end




local function syncSkillFieldsToUI()
    if not uiReady then return end

    -- Skill values and editability are authored directly in buildSkills().
    -- Do not rewrite the InputField after XML load; TTS can lose/blank
    -- InputField content when its attributes are mutated immediately after creation.
end

rebuildUI = function()
    refreshPortraitAsset()

    -- The Purple card itself owns only the lightweight shell.
    self.UI.setXml(applyUiTheme(buildXml()))
    uiReady = true

    if not pageCacheInitialized then
        initializePageCache()
    else
        local current = resolvedCachedPageName()
        local helper = getCachedHelper(current)

        if helper then
            rebuildCachedPage(current)
            activateCachedPage(current)
        else
            ensureCachedPage(current, function()
                activateCachedPage(current)
                Wait.frames(function()
                    pcall(function()
                        dgSyncActiveCachedHelperTransform(true)
                    end)
                end, 1)
            end)
        end
    end

    local function finishUiBuild()
        if self.UI.loading then
            Wait.frames(finishUiBuild, 1)
            return
        end

        applyScaleCompensation(true)
        applyViewerColor()
        applyTextLock()
        buildMainContextMenu()
    end

    Wait.frames(finishUiBuild, 1)
end



local function dgUiWidthPercent()
    local n = tonumber(state.uiWidthPercent) or 100
    if n < 70 then n = 70 end
    if n > 120 then n = 120 end
    return n
end

local function dgUiHeightPercent()
    local n = tonumber(state.uiHeightPercent) or 100
    if n < 70 then n = 70 end
    if n > 120 then n = 120 end
    return n
end

local function dgUiScaleMultipliers()
    return dgUiWidthPercent() / 100, dgUiHeightPercent() / 100
end

-- SINGLE SOURCE OF TRUTH for the card's UI transform.
-- Every place that used to independently format its own position/rotation/
-- scale strings (the shell, every cached page helper, and the periodic
-- rescale) now calls this instead. That is what guarantees the shell and
-- every tab share identical x/y/z offsets off the card object: they can no
-- longer drift apart from separately-edited copies of the same formula.

local function dgEnsureFineTuneState()
    state.uiFineTune = state.uiFineTune or {}

    local function ensurePart(name)
        state.uiFineTune[name] = state.uiFineTune[name] or {}
        local t = state.uiFineTune[name]

        local defaults
        if name == "bottom" then
            defaults = {
                x = 0, y = 2, z = 0,
                scaleX = 1.075, scaleY = 1.075
            }
        else
            defaults = {
                x = 0, y = 2, z = 0,
                scaleX = 1.025, scaleY = 1.025
            }
        end

        if t.x == nil then t.x = defaults.x end
        if t.y == nil then t.y = defaults.y end
        if t.z == nil then t.z = defaults.z end
        if t.scaleX == nil then t.scaleX = defaults.scaleX end
        if t.scaleY == nil then t.scaleY = defaults.scaleY end

        return t
    end

    ensurePart("top")
    ensurePart("bottom")
end

local function dgFineTunePart(forHelper)
    dgEnsureFineTuneState()

    if forHelper then
        return state.uiFineTune.bottom
    end

    return state.uiFineTune.top
end

local function dgFineTuneSummary(partName)
    dgEnsureFineTuneState()

    local t = state.uiFineTune[partName]

    return string.format(
        "%s: X %.1f | Y %.1f | Z %.1f | W %.3f | H %.3f",
        string.upper(partName),
        tonumber(t.x) or 0,
        tonumber(t.y) or 0,
        tonumber(t.z) or 0,
        tonumber(t.scaleX) or 1,
        tonumber(t.scaleY) or 1
    )
end

local function dgApplyFineTuneCommand(partName, action)
    dgEnsureFineTuneState()

    local t = state.uiFineTune[partName]
    if not t then return false end

    -- Deliberately small increments for visual fine tuning.
    local MOVE_STEP = 1.0
    local DEPTH_STEP = 1.0
    local SCALE_STEP = 0.005

    if action == "left" then
        t.x = (tonumber(t.x) or 0) - MOVE_STEP
    elseif action == "right" then
        t.x = (tonumber(t.x) or 0) + MOVE_STEP
    elseif action == "up" then
        t.y = (tonumber(t.y) or 0) + MOVE_STEP
    elseif action == "down" then
        t.y = (tonumber(t.y) or 0) - MOVE_STEP

    elseif action == "raise" or action == "out" then
        t.z = (tonumber(t.z) or 0) + DEPTH_STEP
    elseif action == "lower" or action == "in" then
        t.z = (tonumber(t.z) or 0) - DEPTH_STEP

    elseif action == "wider" then
        t.scaleX = (tonumber(t.scaleX) or 1) + SCALE_STEP
    elseif action == "narrower" then
        t.scaleX = math.max(0.10, (tonumber(t.scaleX) or 1) - SCALE_STEP)
    elseif action == "taller" then
        t.scaleY = (tonumber(t.scaleY) or 1) + SCALE_STEP
    elseif action == "shorter" then
        t.scaleY = math.max(0.10, (tonumber(t.scaleY) or 1) - SCALE_STEP)

    elseif action == "bigger" then
        t.scaleX = (tonumber(t.scaleX) or 1) + SCALE_STEP
        t.scaleY = (tonumber(t.scaleY) or 1) + SCALE_STEP
    elseif action == "smaller" then
        t.scaleX = math.max(0.10, (tonumber(t.scaleX) or 1) - SCALE_STEP)
        t.scaleY = math.max(0.10, (tonumber(t.scaleY) or 1) - SCALE_STEP)

    elseif action == "reset" then
        t.x = 0
        t.y = 2
        t.z = 0

        if partName == "bottom" then
            t.scaleX = 1.075
            t.scaleY = 1.075
        else
            t.scaleX = 1.025
            t.scaleY = 1.025
        end
    else
        return false
    end

    applyScaleCompensation(true)
    return true
end

dgComputeTransform = function(forHelper)
    if not originalObjectScale then
        originalObjectScale = self.getScale()
    end

    local current = self.getScale()

    local baseW = math.abs(getComponent(originalObjectScale, RESIZE_WIDTH_AXIS) or 1)
    local baseH = math.abs(getComponent(originalObjectScale, RESIZE_HEIGHT_AXIS) or 1)
    local nowW  = math.abs(getComponent(current, RESIZE_WIDTH_AXIS) or 1)
    local nowH  = math.abs(getComponent(current, RESIZE_HEIGHT_AXIS) or 1)

    if baseW < 0.0001 then baseW = 1 end
    if baseH < 0.0001 then baseH = 1 end

    -- Follow the physical Custom Card resize DIRECTLY.
    -- Wider card = wider UI. Taller card = taller UI.
    local ratioX = nowW / baseW
    local ratioY = nowH / baseH

    local widthMult, heightMult = dgUiScaleMultipliers()

    local sx = CARD_UI_SCALE_X * CARD_FILL_X * ratioX * widthMult
    local sy = CARD_UI_SCALE_Y * CARD_FILL_Y * ratioY * heightMult

    -- Independent manual fine tuning for the permanent top shell and
    -- the cached bottom/page helper.
    local fine = dgFineTunePart(forHelper)

    sx = sx * (tonumber(fine.scaleX) or 1)
    sy = sy * (tonumber(fine.scaleY) or 1)

    -- Cached page helpers are ScriptingTrigger objects, not the Custom Card
    -- itself, and TTS renders their attached UI horizontally compressed
    -- even at an identical transform. This is the ONLY place that
    -- difference is allowed to exist; every helper page goes through here
    -- with forHelper=true so they all get exactly the same correction.
    if forHelper then
        sx = sx * PAGE_HELPER_UI_X_COMPENSATION
    end

    lastScale = {x = current.x, y = current.y, z = current.z}

    return {
        scale = string.format("%.5f %.5f 1", sx, sy),
        position = string.format(
            "%.3f %.3f %.3f",
            tonumber(fine.x) or 0,
            tonumber(fine.y) or 0,
            UI_SURFACE_Z + (tonumber(fine.z) or 0)
        ),
        rotation = UI_ROTATION
    }
end

function applyScaleCompensation(force)
    if not originalObjectScale then
        originalObjectScale = self.getScale()
    end

    local current = self.getScale()
    if not force and not scaleChanged(current, lastScale) then return end

    if uiReady then
        -- Shell keeps the exact original Purple-card transform.
        local shellTransform = dgComputeTransform(false)

        self.UI.setAttributes("dg_root", {
            scale = shellTransform.scale,
            position = shellTransform.position,
            rotation = shellTransform.rotation
        })

        -- Cached page helpers use the SAME computation (plus the helper-only
        -- X correction), so every tab always matches the shell exactly.
        for _, tabName in ipairs(PAGE_HELPER_TABS) do
            local helper = getCachedHelper(tabName)

            if helper then
                local helperTransform = dgComputeTransform(true)

                helper.UI.setAttributes("dg_root", {
                    scale = helperTransform.scale,
                    position = helperTransform.position,
                    rotation = helperTransform.rotation
                })
            end
        end
    end

    if pageCacheInitialized then
        activateCachedPage(resolvedCachedPageName())
    end
end

status = function(msg)
    -- Status footer removed in v1.1 to maximize usable sheet space.
end

local function normalizedSkillLookupKey(name)
    return tostring(name or ""):lower():gsub("[^%w]", "")
end

local function resolveSkillNameAndValue(requestedName)
    local requested = tostring(requestedName or "")
    local wanted = normalizedSkillLookupKey(requested)
    local bestName = nil
    local bestValue = nil
    local bestExact = false

    for name, rawValue in pairs(state.skills or {}) do
        if normalizedSkillLookupKey(name) == wanted then
            local n = tonumber(rawValue) or 0
            local isExact = tostring(name) == requested

            if bestName == nil or
               (bestValue == 0 and n ~= 0) or
               (bestValue == n and isExact and not bestExact)
            then
                bestName = name
                bestValue = n
                bestExact = isExact
            end
        end
    end

    if bestName then
        return bestName, bestValue or 0
    end

    return requested, 0
end

local function liveSkillValue(skillName)
    local canonicalName, storedValue = resolveSkillNameAndValue(skillName)
    local fieldId = skillId(canonicalName)

    -- The cached Skills helper can still contain the newest typed value even
    -- before TTS fires onEndEdit. Read it immediately when a roll starts.
    local helperNames = { "skills", "skills_active" }
    for _, helperName in ipairs(helperNames) do
        local helper = getCachedHelper(helperName)
        if helper then
            local ok, raw = pcall(function()
                return helper.UI.getValue(fieldId)
            end)

            if (not ok) or raw == nil or tostring(raw) == "" then
                ok, raw = pcall(function()
                    return helper.UI.getAttribute(fieldId, "text")
                end)
            end

            if ok and raw ~= nil and tostring(raw) ~= "" then
                local n = tonumber(raw)
                if n ~= nil then
                    n = math.floor(clamp(n, 0, 99))
                    state.skills[canonicalName] = n
                    return canonicalName, n
                end
            end
        end
    end

    return canonicalName, tonumber(storedValue) or 0
end

local function skillNameFromId(id)
    if id == nil then return nil end

    local target = tostring(id):gsub("_roll$","")

    for name,_ in pairs(state.skills) do
        if skillId(name) == target then
            return name
        end
    end

    return nil
end

-----------------------------
-- TTS EVENTS
-----------------------------

function onLoad(saved_data)
    lastScale = nil

    pageHelpers = {}
    pageHelpersReady = {}
    pageHelpersBuilding = false
    pageCacheInitialized = false
    themeRebuildRunning = false
    cachedPageDirty = {}

    if saved_data and saved_data ~= "" then
        local ok, decoded = pcall(JSON.decode,saved_data)
        if ok and decoded then
            if decoded.state then state = decoded.state end
        end
    end

    -- This script is permanently Purple, even if this object was cloned
    -- from an older sheet with a different saved ownerColor.
    state.ownerColor = SHEET_COLOR
    if UI_BASE_COLORS[state.uiBaseColor] == nil then
        state.uiBaseColor = "Forest"
    end

    if UI_ACCENT_COLORS[state.uiAccentColor] == nil then
        state.uiAccentColor = "Green"
    end

    if state.baseObjectScale then
        originalObjectScale = Vector(
            state.baseObjectScale.x,
            state.baseObjectScale.y,
            state.baseObjectScale.z
        )
    else
        originalObjectScale = self.getScale()
        state.baseObjectScale = {
            x = originalObjectScale.x,
            y = originalObjectScale.y,
            z = originalObjectScale.z
        }
    end

    if state.agent.breakingPoint == nil then
        state.agent.breakingPoint = math.max(
            0,
            (tonumber(state.agent.san) or 0) -
            (tonumber(state.agent.pow) or 0)
        )
    end

    if state.skillEnabled == nil then
        state.skillEnabled = {}
    end

    if state.skillsActiveOnly == nil then
        state.skillsActiveOnly = false
    end

    if state.uiWidthPercent == nil then state.uiWidthPercent = 100 end
    if state.uiHeightPercent == nil then state.uiHeightPercent = 100 end
    dgEnsureFineTuneState()
    if state.cachedPageYOffset == nil then state.cachedPageYOffset = -111 end

    ensureDisorderState()
    ensureStructuredImportState()

    if state.importBuffer == nil then
        state.importBuffer = ""
    end

    if state.importStatus == nil then
        state.importStatus = nil
    end

    for name,_ in pairs(state.skills) do
        if state.skillEnabled[name] == nil then
            state.skillEnabled[name] = true
        end
    end

    lastScale = nil

    Wait.frames(function()
        rebuildUI()
    end, 1)
    Wait.frames(function()
        queueDashboardSnapshot(state.ownerColor, "status", "Sheet loaded")
    end, 10)

    if type(state.availableDice) ~= "table" or #state.availableDice == 0 then
        Wait.frames(function()
            if refreshAvailableDiceFromStorage then
                refreshAvailableDiceFromStorage({initial=true})
            end
        end, 20)
    end

end

function onSave()
    return JSON.encode({ state = state })
end


dgLastFollowPosition = nil
dgLastFollowRotation = nil
local dgFollowFrame = 0

local function dgTransformChanged(a, b, epsilon)
    if not a or not b then return true end
    epsilon = epsilon or 0.01

    return
        math.abs((a.x or 0) - (b.x or 0)) > epsilon or
        math.abs((a.y or 0) - (b.y or 0)) > epsilon or
        math.abs((a.z or 0) - (b.z or 0)) > epsilon
end

dgSyncActiveCachedHelperTransform = function(force)
    if not pageCacheInitialized then return end
    if not getCachedHelper then return end

    local current =
        resolvedCachedPageName and
        resolvedCachedPageName() or
        tostring(state.currentTab or "personnel")

    local helper = getCachedHelper(current)
    if not helper then return end

    local p = self.getPosition()
    local r = self.getRotation()

    local changed =
        force == true or
        dgTransformChanged(p, dgLastFollowPosition, 0.001) or
        dgTransformChanged(r, dgLastFollowRotation, 0.01)

    if not changed then return end

    pcall(function()
        -- HARD LOCK to the card. No interpolation/spring movement.
        helper.setPosition({x=p.x, y=p.y, z=p.z})
        helper.setRotation({x=r.x, y=r.y, z=r.z})
        helper.setLock(true)
    end)

    dgLastFollowPosition = {x=p.x, y=p.y, z=p.z}
    dgLastFollowRotation = {x=r.x, y=r.y, z=r.z}
end

function onUpdate()
    -- PERFORMANCE: locked character sheets are stationary during normal play.
    -- Tab changes force-sync the active helper, so there is no reason for each
    -- sheet to poll its transform every rendered frame while locked.
    if self.getLock() then
        return
    end

    -- While unlocked/moving, follow at a modest rate rather than every frame.
    dgFollowFrame = dgFollowFrame + 1
    if dgFollowFrame >= 3 then
        dgFollowFrame = 0
        pcall(function()
            dgSyncActiveCachedHelperTransform(false)
        end)
    end

    frameCounter = frameCounter + 1
    if frameCounter >= SCALE_CHECK_FRAMES then
        frameCounter = 0
        pcall(function()
            applyScaleCompensation(false)
        end)
    end
end


-------------------------------------------------
-- HANDLER DASHBOARD SYNC
-- Event-driven only: no polling loop.
-------------------------------------------------

local dashboardSyncPending = false
local dashboardSyncColorHint = nil

local function dashboardPlayerColor(colorHint)
    return SHEET_COLOR
end

currentMarkedSkillsForDashboard = function()
    ensureStructuredImportState()

    local result = {}

    for name, marked in pairs(state.skillImprovementMarked or {}) do
        if marked == true and name ~= "Unnatural" then
            table.insert(result, name)
        end
    end

    table.sort(result)
    return result
end

local function pushDashboardSnapshot(colorHint, eventType, eventText)
    local dashboard = nil

    if HANDLER_DASHBOARD_GUID and HANDLER_DASHBOARD_GUID ~= "" then
        dashboard = getObjectFromGUID(HANDLER_DASHBOARD_GUID)
    end

    if not dashboard then
        local ok, guid = pcall(function()
            return Global.getVar("DG_HANDLER_DASHBOARD_GUID")
        end)

        if ok and guid and guid ~= "" then
            dashboard = getObjectFromGUID(guid)
        end
    end

    if not dashboard then
        return false
    end

    local playerColor = dashboardPlayerColor(colorHint)

    if playerColor == "" then
        return false
    end

    local a = state.agent or {}

    local payload = {
        color = playerColor,
        sheetGuid = self.getGUID(),
        name = tostring(a.name or "Agent"),

        hp = tonumber(a.hp) or 0,
        hpMax = tonumber(a.hpMax) or 0,

        wp = tonumber(a.wp) or 0,
        wpMax = tonumber(a.wpMax) or 0,

        san = tonumber(a.san) or 0,
        sanMax = tonumber(a.sanMax) or 0,

        breakingPoint = tonumber(a.breakingPoint) or 0,

        markedSkills = currentMarkedSkillsForDashboard(),
        markedCount = #currentMarkedSkillsForDashboard(),

        adaptedViolence = state.psychology.adaptedViolence == true,
        adaptedHelplessness = state.psychology.adaptedHelplessness == true,
        violenceIncidents = tonumber(state.psychology.violenceIncidents) or 0,
        helplessnessIncidents = tonumber(state.psychology.helplessnessIncidents) or 0,
        pendingSanLoss = tonumber(state.psychology.pendingSanLoss),
        temporaryInsanityPending = state.psychology.temporaryInsanityPending == true,
        sessionSanLost = tonumber(state.psychology.sessionSanLost) or 0,

        inventory = handlerGetInventorySnapshot({}),

        eventType = tostring(eventType or ""),
        eventText = tostring(eventText or "")
    }

    local ok = pcall(function()
        dashboard.call("receiveAgentUpdate", payload)
    end)

    return ok
end

queueDashboardSnapshot = function(colorHint, eventType, eventText)
    dashboardSyncColorHint = colorHint or dashboardSyncColorHint

    if dashboardSyncPending then
        return
    end

    dashboardSyncPending = true

    -- One short deferred push coalesces multiple edits/rebuilds into one update.
    Wait.frames(function()
        dashboardSyncPending = false
        pushDashboardSnapshot(
            dashboardSyncColorHint,
            eventType,
            eventText
        )
        dashboardSyncColorHint = nil
    end, 2)
end

-----------------------------

function requestDashboardSync(params)
    local colorHint = SHEET_COLOR

    if type(params) == "table" and params.color then
        colorHint = params.color
    elseif type(params) == "string" and params ~= "" then
        colorHint = params
    end

    return pushDashboardSnapshot(
        colorHint,
        "status",
        "Dashboard sync"
    )
end

-- UI EVENTS
-----------------------------


function captureImportJson(player, value, id)
    state.importBuffer = tostring(value or "")
end

function clearCharacterImport(player, value, id)
    state.importBuffer = ""
    state.importStatus = "Import box cleared."
    rebuildUI()
end

function cancelCharacterImport(player, value, id)
    state.importBuffer = ""
    state.importStatus = nil
    state.currentTab = "personnel"
    rebuildUI()
end

function importCharacterJson(player, value, id)
    local raw = tostring(state.importBuffer or "")

    if raw == "" then
        state.importStatus = "ERROR: Paste the exported JSON first."
        rebuildUI()
        return
    end

    local okDecode, decoded = pcall(JSON.decode, raw)

    if not okDecode or type(decoded) ~= "table" then
        state.importStatus =
            "ERROR: Invalid JSON. Copy the complete Live Character Sheet export."
        rebuildUI()
        return
    end

    local okApply, success, message = pcall(
        applyPigeonCharacter,
        decoded
    )

    if not okApply then
        state.importStatus =
            "ERROR while importing: " .. tostring(success)
        rebuildUI()
        return
    end

    if not success then
        state.importStatus =
            "ERROR: " .. tostring(message or "Import failed.")
        rebuildUI()
        return
    end

    state.currentTab = "personnel"
    rebuildUI()

    Wait.frames(function()
        syncSkillFieldsToUI()
    end, 3)

    broadcastToAll(
        "[DG] Imported character: " .. tostring(state.agent.name),
        {0.55,0.9,0.65}
    )
end



function switchPersonnelSubtab(player, value, id)
    local sub = tostring(id or ""):match("^personnel_tab_(.+)$")

    if sub == "profile" or sub == "stats" or
       sub == "portrait" or sub == "notes"
    then
        state.personnelSubtab = sub
        state.clearConfirm = false

        if rebuildCachedPage and getCachedHelper("personnel") then
            rebuildCachedPage("personnel")
            activateCachedPage("personnel")
        else
            rebuildUI()
        end
    end
end

function clearPortrait(player, value, id)
    state.agent.portraitUrl = ""
    lastPortraitAssetUrl = nil
    refreshPortraitAsset()
    rebuildUI()
end

function clearSheetButton(player, value, id)
    if state.clearConfirm == true then
        resetCharacterData()
        return
    end

    state.clearConfirm = true
    rebuildUI()
end

function switchEquipmentSubtab(player, value, id)
    ensureStructuredImportState()

    local sub = id:match("^equipment_tab_(.+)$")

    if sub == "all" or
       sub == "firearms" or
       sub == "melee" or
       sub == "heavy" or
       sub == "lesslethal" or
       sub == "armor" or
       sub == "gear" or
       sub == "add" or
       sub == "funds" or
       sub == "notes" or
       sub == "dice"
    then
        state.equipmentSubtab = sub

        -- PERFORMANCE: the remote equipment catalog is only needed by
        -- ADD ITEM. Avoid one identical GitHub request per sheet at startup.
        if sub == "add" and
           equipmentCatalogCount == 0 and
           not equipmentCatalogRefreshRunning
        then
            refreshEquipmentCatalogFromGithub(nil, nil, nil)
        end

        rebuildUI()
    end
end

function switchPsychologySubtab(player, value, id)
    ensureStructuredImportState()

    local sub = id:match("^psychology_tab_(.+)$")

    if sub == "sanity" or sub == "bonds" or
       sub == "motivations" or sub == "session"
    then
        state.psychologySubtab = sub
        if getCachedHelper("psychology") then
            rebuildCachedPage("psychology")
            activateCachedPage("psychology")
        else
            rebuildUI()
        end
    end
end

function switchTab(player, value, id)
    local nextTab = tostring(id or ""):gsub("^tab_","")

    local valid = {
        personnel=true,
        skills=true,
        equipment=true,
        psychology=true,
        disorders=true
    }

    if not valid[nextTab] then return end
    if state.currentTab == nextTab then return end

    local previous = tostring(state.currentTab or "personnel")
    state.currentTab = nextTab

    local baseName = tostring(state.uiBaseColor or "Forest")
    local accentName = tostring(state.uiAccentColor or "Green")

    local base = UI_BASE_COLORS[baseName] or UI_BASE_COLORS["Forest"]
    local accent = UI_ACCENT_COLORS[accentName] or UI_ACCENT_COLORS["Green"]

    -- Only two controls on the tiny shell are mutated.
    pcall(function()
        self.UI.setAttribute("tab_" .. previous, "color", base.dark2)
        self.UI.setAttribute("tab_" .. nextTab, "color", accent.accent)
    end)

    local targetPage = resolvedCachedPageName()
    local helper = getCachedHelper(targetPage)

    if helper then
        refreshCachedPageIfDirty(targetPage)
        activateCachedPage(targetPage)
        Wait.frames(function()
            dgSyncActiveCachedHelperTransform(true)
        end, 1)
    else
        ensureCachedPage(targetPage, function()
            activateCachedPage(targetPage)
            Wait.frames(function()
                dgSyncActiveCachedHelperTransform(true)
            end, 1)
        end)
    end
end

function editField(player, value, id)
    if state.textLocked then return end

    local a = state.agent
    local e = state.equipment
    local p = state.psychology

    local baseStats = {
        str=true, con=true, dex=true,
        int=true, pow=true, cha=true
    }

    local currentResources = {
        hp=true, wp=true, san=true
    }

    if baseStats[id] then
        local oldValue = tonumber(a[id]) or 0
        a[id] = clampBaseStat(value)

        if id == "pow" then
            handlePowChange(oldValue, a[id])
        end

        a.hpMax = deriveHPMax()
        a.wpMax = deriveWPMax()

        local oldHP = tonumber(a.hp) or 0
        local oldWP = tonumber(a.wp) or 0

        a.hp = clampResourceValue("hp", a.hp)
        a.wp = clampResourceValue("wp", a.wp)

        if oldHP ~= a.hp then

        end

        if oldWP ~= a.wp then

        end

        rebuildUI()
        return
    end

    if currentResources[id] then
        local oldValue = tonumber(a[id]) or 0
        a[id] = clampResourceValue(id, value)

        if id == "san" then

            handleSanChange(oldValue, a.san)
        else

        end

        dgUISetValue(id, tostring(a[id]))
        return
    end

    if id == "sanMax" then
        local newMax = math.floor(tonumber(value) or 0)
        if newMax < 0 then newMax = 0 end
        if newMax > 999 then newMax = 999 end

        a.sanMax = newMax

        local oldSan = tonumber(a.san) or 0
        a.san = clampResourceValue("san", a.san)

        if oldSan ~= a.san then
            handleSanChange(oldSan, a.san)
        end

        rebuildUI()
        return
    end

    if a[id] ~= nil then
        a[id] = value

        if id == "name" then
            pushAgentNameToDisplay()
        elseif id == "portraitUrl" then
            lastPortraitAssetUrl = nil
            refreshPortraitAsset()
            rebuildUI()
        end

    elseif id == "weapons" then
        e.weapons = value

    elseif id == "armor" then
        e.armor = value

    elseif id == "gear" then
        e.gear = value

    elseif id == "cash" then
        e.cash = value

    elseif id == "equipmentNotes" then
        e.notes = value

    elseif id == "bonds" then
        p.bonds = value

    elseif id == "disorders" then
        p.disorders = value

    elseif id == "psychMotivations" then
        p.motivations = value

    elseif id == "psychNotes" then
        p.notes = value
    elseif id == "multiModifier" then
        state.multiModifier = tostring(value or "0")
    elseif id == "sanLossFormula" then
        state.sanLossFormula = tostring(value or "0/1d4")
    elseif id == "sex" then
        a.sex = tostring(value or "")
    elseif id == "rollModifier" then
        state.rollModifier = math.max(-80, math.min(80, math.floor(tonumber(value) or 0)))
    elseif id == "incomingDamage" then
        state.incomingDamage = tostring(value or "0")
    elseif id == "incomingAP" then
        state.incomingAP = tostring(value or "0")
    elseif id == "valuables" then
        e.valuables = tostring(value or "")
    elseif id == "addReserveRounds" then
        state.addReserveRounds =
            math.max(0, math.floor(tonumber(value) or 0))
    elseif tostring(id):match("^dist_") then
        local key = tostring(id):gsub("^dist_","")
        a.distinguishing = a.distinguishing or {}
        if a.distinguishing[key] ~= nil then
            a.distinguishing[key] = tostring(value or "")
        end
    end

    status("Updated "..tostring(id)..".")
end

local startPhysicalPercentileRoll

local startGenericPhysicalDieRoll
local parseDiceExpression



function selectMultiQty(player, value, id)
    local index = tonumber(tostring(id or ""):match("^multi_qty_(%d)$"))
    if index and (index < 1 or index > 4) then return end
    if not index then return end

    local qty = math.floor(tonumber(value) or 0)
    if qty < 0 then qty = 0 end
    if qty > 6 then qty = 6 end

    state["multiQty" .. tostring(index)] = qty
end

function selectMultiDie(player, value, id)
    local index = tonumber(tostring(id or ""):match("^multi_die_(%d)$"))
    if not index or index < 1 or index > 4 then return end

    local raw = tostring(value or "")
    local lower = raw:lower()
    local allowed = {d4=true,d6=true,d8=true,d10=true,d12=true,d20=true}

    if lower == "hit location" then
        state["multiDie" .. tostring(index)] = "Hit Location"
    elseif allowed[lower] then
        state["multiDie" .. tostring(index)] = lower
    end
end

function rollMultiDice(player, value, id)
    local parts = {}

    for i = 1, 4 do
        local qty = math.floor(tonumber(state["multiQty" .. tostring(i)]) or 0)
        local dieName = tostring(state["multiDie" .. tostring(i)] or "d6")

        if qty > 0 then
            if dieName == "Hit Location" then
                table.insert(parts, "hitlocation")
            else
                table.insert(parts, tostring(qty) .. dieName)
            end
        end
    end

    local modifier = math.floor(tonumber(state.multiModifier) or 0)

    if modifier ~= 0 then
        if modifier > 0 then
            table.insert(parts, "+" .. tostring(modifier))
        else
            table.insert(parts, tostring(modifier))
        end
    end

    if #parts == 0 then
        broadcastToAll("[DG] Dice pool is empty.", {1,0.45,0.35})
        return
    end

    startDiceExpressionRoll(
        "DICE POOL",
        table.concat(parts, "+"):gsub("%+%-", "-"),
        "multi"
    )
end


local function updateWeaponAmmoUi(weaponIndex)
    local i = tonumber(weaponIndex)
    local w = i and state.importedWeapons[i]
    if not w then return end

    local cap = tonumber(tostring(w.capacity or ""):match("(%d+)"))
    if not cap then return end

    local current = tonumber(w.ammoCurrent)
    if current == nil then current = cap end
    local reserve = getSharedAmmoReserve(w)

    local helper = getCachedHelper("equipment")
    if not helper then return end

    pcall(function()
        helper.UI.setAttribute(
            "equipment_ammo_count_" .. tostring(i),
            "text",
            tostring(current) .. "/" .. tostring(cap)
        )

        helper.UI.setAttribute(
            "equipment_reserve_count_" .. tostring(i),
            "text",
            tostring(reserve)
        )

        helper.UI.setAttribute(
            "equipment_reserve_label_" .. tostring(i),
            "text",
            weaponAmmoLabel(w)
        )
    end)
end

local function refreshSharedAmmoPoolUi(weapon)
    local key = weaponAmmoKey(weapon)
    if not key then return end

    for i, other in ipairs(state.importedWeapons or {}) do
        if weaponAmmoKey(other) == key then
            updateWeaponAmmoUi(i)
        end
    end
end

local function refreshWeaponInventoryUi(weaponIndex)
    updateWeaponAmmoUi(weaponIndex)
    cachedPageDirty["equipment"] = true
end

function rollEquipmentDamage(player, value, id)
    local info = equipmentRollTargets[tostring(id or "")]
    if not info then return end

    local damage = tostring(info.damage or "")
    if damage == "" or damage == "—" then
        broadcastToAll(
            "[DG] " .. tostring(info.name or "Weapon") ..
            " has no rollable damage expression.",
            {1,0.55,0.30}
        )
        return
    end

    if not damage:lower():find("d%d") then
        broadcastToAll(
            "[DG] " .. tostring(info.name or "Weapon") ..
            " damage is '" .. damage .. "'; resolve it using the weapon rules.",
            {1,0.65,0.25}
        )
        return
    end

    startDiceExpressionRoll(
        tostring(info.name or "Weapon") .. " DAMAGE",
        damage,
        "weaponDamage"
    )
end

function rollEquipmentLethality(player, value, id)
    local info = equipmentRollTargets[tostring(id or "")]
    if not info then return end

    local rating = tonumber(tostring(info.lethality or ""):match("(%d+)"))
    if not rating or rating <= 0 then
        broadcastToAll(
            "[DG] No Lethality rating is set for " ..
            tostring(info.name or "this weapon") .. ".",
            {1,0.55,0.30}
        )
        return
    end

    startPhysicalPercentileRoll(
        SHEET_COLOR,
        tostring(info.name or "Weapon") .. " LETHALITY",
        math.min(99, rating),
        "",
        nil,
        {
            kind = "lethality",
            rating = math.min(99, rating),
            weaponName = tostring(info.name or "Weapon")
        }
    )
end


function selectSanSource(player, value, id)
    local source =
        id == "san_source_violence" and "Violence" or
        id == "san_source_helplessness" and "Helplessness" or
        "Unnatural"

    state.psychology.sanSource = source
    refreshPsychologyPage()
end

function selectBond(player, value, id)
    local i = tonumber(tostring(id or ""):match("bond_select_(%d+)"))
    if not i or not state.importedBonds[i] then return end
    state.psychology.selectedBondIndex = i
    refreshPsychologyPage()
end

function bondAdjust(player, value, id)
    local i = tonumber(tostring(id or ""):match("bond_[%a]+_(%d+)"))
    if not i then return end

    local delta = tostring(id):find("_plus_",1,true) and 1 or -1
    adjustBondScore(i, delta, delta < 0)

    local bond = state.importedBonds[i]
    local helper = getCachedHelper("psychology")
    if helper and bond then
        pcall(function()
            helper.UI.setAttribute(
                "bond_score_" .. tostring(i),
                "text",
                "SCORE " .. tostring(tonumber(bond.score) or 0)
            )
        end)
    end

    cachedPageDirty["psychology"] = true
    queueDashboardSnapshot(SHEET_COLOR, "status", "Bond adjusted")
end

function toggleBondDamaged(player, value, id)
    local i = tonumber(tostring(id or ""):match("bond_damage_(%d+)"))
    local bond = i and state.importedBonds[i]
    if not bond then return end
    bond.damaged = not bond.damaged

    local helper = getCachedHelper("psychology")
    if helper then
        pcall(function()
            helper.UI.setAttributes(
                "bond_damage_" .. tostring(i),
                {
                    text = bond.damaged and "DAMAGED" or "HEALTHY",
                    color = bond.damaged and "#743A3A" or "#315E3A"
                }
            )
        end)
    end

    cachedPageDirty["psychology"] = true
end


function applyPendingSanLoss(player, value, id)
    local amount = tonumber(state.psychology.pendingSanLoss)
    if amount == nil then return end

    applyResolvedSanLoss(
        amount,
        state.psychology.pendingSanSource,
        "Applied directly"
    )
end

function projectPendingSanLoss(player, value, id)
    local amount = tonumber(state.psychology.pendingSanLoss)
    if amount == nil then
        broadcastToAll("[DG] There is no pending SAN loss to project.", {1,0.55,0.30})
        return
    end

    local bond, bondIndex = selectedBond()
    if not bond then
        broadcastToAll("[DG] Select a Bond before projecting SAN loss.", {1,0.55,0.30})
        return
    end

    startDiceExpressionRoll(
        "PROJECT ONTO BOND",
        "1d4",
        "bondProjection",
        {
            bondIndex = bondIndex,
            pendingLoss = amount,
            source = tostring(state.psychology.pendingSanSource or "Unnatural")
        }
    )
end

function repressInsanity(player, value, id)
    local bond, bondIndex = selectedBond()
    if not bond then
        broadcastToAll("[DG] Select a Bond before repressing insanity.", {1,0.55,0.30})
        return
    end

    startDiceExpressionRoll(
        "REPRESS INSANITY",
        "1d4",
        "repressCost",
        { bondIndex = bondIndex }
    )
end

function captureNewMotivation(player, value, id)
    state.psychology.newMotivationDraft =
        tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
end

function addNewMotivation(player, value, id)
    local lines = motivationLines()

    if #lines >= 5 then
        status("Maximum of five motivations.")
        return
    end

    local helper = getCachedHelper("psychology")
    local draft = nil

    if helper then
        pcall(function()
            draft = helper.UI.getValue("newMotivationInput")
        end)
    end

    if draft == nil then
        draft = state.psychology.newMotivationDraft
    end

    draft = tostring(draft or ""):gsub("^%s+",""):gsub("%s+$","")

    if draft == "" then
        status("Enter a motivation first.")
        return
    end

    table.insert(lines, draft)
    state.psychology.motivations = table.concat(lines, "\n")
    state.psychology.newMotivationDraft = ""

    status("Motivation added.")
    queueDashboardSnapshot(SHEET_COLOR, "status", "Motivation added")
    refreshPsychologyPage()
end

function removeMotivation(player, value, id)
    local i = tonumber(tostring(id or ""):match("motivation_remove_(%d+)"))
    if not i then return end

    local lines = motivationLines()
    if not lines[i] then return end

    table.remove(lines, i)
    state.psychology.motivations = table.concat(lines, "\n")

    local oldUsed = state.psychology.motivationUsed or {}
    local newUsed = {}

    for oldIndex = 1, 5 do
        if oldIndex < i then
            newUsed[oldIndex] = oldUsed[oldIndex]
        elseif oldIndex > i then
            newUsed[oldIndex - 1] = oldUsed[oldIndex]
        end
    end

    state.psychology.motivationUsed = newUsed

    status("Motivation removed.")
    queueDashboardSnapshot(SHEET_COLOR, "status", "Motivation removed")
    refreshPsychologyPage()
end

function useMotivation(player, value, id)
    local i = tonumber(tostring(id or ""):match("motivation_use_(%d+)"))
    if not i then return end

    if state.psychology.motivationUsed[i] then return end

    state.psychology.motivationUsed[i] = true
    local old = tonumber(state.agent.wp) or 0
    state.agent.wp = math.min(tonumber(state.agent.wpMax) or old, old + 1)

    local lines = motivationLines()
    local text = tostring(lines[i] or ("Motivation "..i))

    local msg = string.format(
        "%s engages motivation \"%s\" — WP %d -> %d.",
        tostring(state.agent.name or "Agent"),
        text,
        old,
        state.agent.wp
    )

    broadcastToAll(msg, {0.55,0.85,0.65})
    queueDashboardSnapshot(SHEET_COLOR, "home", msg)
    local helper = getCachedHelper("psychology")
    if helper then
        pcall(function()
            helper.UI.setAttributes(
                "motivation_use_" .. tostring(i),
                {
                    text = "USED THIS SESSION",
                    interactable = "false",
                    color = "#252B27"
                }
            )
        end)
    end

    dgUISetValue("wp", tostring(state.agent.wp))
    cachedPageDirty["psychology"] = true
end

function resetSessionAutomation(player, value, id)
    state.psychology.motivationUsed = {}
    state.psychology.sessionSanLost = 0
    state.psychology.sessionBreakingPoints = 0
    state.psychology.sessionBondDamage = 0
    state.psychology.temporaryInsanityPending = false

    for _, bond in ipairs(state.importedBonds or {}) do
        bond.damaged = false
    end

    broadcastToAll(
        "[DG] Session tracking reset. Character values and adaptation progress were preserved.",
        {0.55,0.85,0.65}
    )

    queueDashboardSnapshot(SHEET_COLOR, "home", "Session tracking reset")
    refreshPsychologyPage()
end



function equipmentBreadcrumbClick(player, value, id)
    local target = tostring(id or ""):gsub("^equipment_crumb_", "")

    if state.equipmentReplace then
        -- Replace mode is intentionally locked to the original item's class.
        -- Backing out of that class cancels replacement instead of allowing
        -- the player to browse into unrelated equipment categories.
        if target == "root" or target == "category" then
            cancelEquipmentReplace(player, value, id)
        end
        return
    end

    if target == "root" then
        state.addItemBrowseLevel = "root"
        state.addItemCategory = ""
        state.addItemSubcategory = ""
        state.addItemName = ""
        state.addCaliberFilter = "ALL"
        resetSelectedCatalogVariant("")

    elseif target == "category" then
        if tostring(state.addItemCategory or "") == "" then return end
        state.addItemBrowseLevel = "category"
        state.addItemSubcategory = ""
        state.addItemName = firstVisibleBrowseItem()

    elseif target == "subcategory" then
        if tostring(state.addItemSubcategory or "") == "" then return end
        state.addItemBrowseLevel = "subcategory"
        state.addItemName = firstVisibleBrowseItem()

    else
        return
    end

    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function equipmentBrowseRowClick(player, value, id)
    local kind, safe =
        tostring(id or ""):match("^equipment_browse_([%a]+)_(.+)$")

    if not kind or not safe then return end

    if kind == "category" then
        local selected = nil
        for _, cat in ipairs(EQUIPMENT_ADD_CATEGORY_ORDER) do
            if cat:gsub("[^%w]","_") == safe then
                selected = cat
                break
            end
        end
        if not selected then return end

        state.addItemCategory = selected
        state.addItemSubcategory = ""
        state.addItemBrowseLevel = "category"
        state.addCaliberFilter = "ALL"
        state.addItemName = firstVisibleBrowseItem()
        resetSelectedCatalogVariant(state.addItemName)

    elseif kind == "subcategory" then
        local order =
            EQUIPMENT_SUBCATEGORY_ORDER[
                tostring(state.addItemCategory or "")
            ]
        if not order then return end

        local selected = nil
        for _, sub in ipairs(order) do
            if sub ~= "All" and
               sub:gsub("[^%w]","_") == safe
            then
                selected = sub
                break
            end
        end
        if not selected then return end

        state.addItemSubcategory = selected
        state.addItemBrowseLevel = "subcategory"
        state.addItemName = firstVisibleBrowseItem()
        resetSelectedCatalogVariant(state.addItemName)

    elseif kind == "item" then
        local selected = nil
        for _, key in ipairs(
            sortedCatalogNamesForCategory(state.addItemCategory)
        ) do
            if key:gsub("[^%w]","_") == safe then
                selected = key
                break
            end
        end
        if not selected then return end

        local previous =
            string.lower(tostring(state.addItemName or ""))

        state.addItemName = selected
        resetSelectedCatalogVariant(selected)

        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
        return
    else
        return
    end

    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end


function selectEquipmentCaliberFilter(player, value, id)
    state.addCaliberFilter = tostring(value or "ALL")
    state.addItemName = firstVisibleBrowseItem()
    resetSelectedCatalogVariant(state.addItemName)
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function selectCatalogVariantCaliber(player, value, id)
    local selectedKey = string.lower(tostring(state.addItemName or ""))
    local item = EQUIPMENT_CATALOG[selectedKey]
    if not item then return end

    state.addSelectedCaliber = tostring(value or "")
    state.addSelectedCapacity = ""

    local cap = selectedCatalogCapacity(selectedKey)
    local helper = getCachedHelper("equipment")

    if helper then
        local variants = parseCatalogVariants(item)

        pcall(function()
            for index, variant in ipairs(variants) do
                helper.UI.setAttribute(
                    "equipment_variant_capacity_" .. tostring(index),
                    "active",
                    tostring(variant.caliber or "") == state.addSelectedCaliber and
                        "true" or "false"
                )
            end

            local mags = math.max(
                0,
                math.floor(tonumber(state.addReserveMags) or 0)
            )

            if cap then
                helper.UI.setAttribute(
                    "equipment_add_mag_hint",
                    "text",
                    string.format(
                        "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
                        cap, mags, cap * mags
                    )
                )
            end
        end)
    end
end

function selectCatalogVariantCapacity(player, value, id)
    state.addSelectedCapacity = tostring(value or "")

    local helper = getCachedHelper("equipment")
    if helper then
        local cap = tonumber(state.addSelectedCapacity)
        local mags = math.max(
            0,
            math.floor(tonumber(state.addReserveMags) or 0)
        )

        if cap then
            pcall(function()
                helper.UI.setAttribute(
                    "equipment_add_mag_hint",
                    "text",
                    string.format(
                        "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
                        cap, mags, cap * mags
                    )
                )
            end)
        end
    end
end

function adjustAddItemQuantity(player, value, id)
    local qty = math.max(1, math.floor(tonumber(state.addItemQuantity) or 1))

    if id == "add_item_qty_minus" then
        qty = math.max(1, qty - 1)
    elseif id == "add_item_qty_plus" then
        qty = qty + 1
    else
        return
    end

    state.addItemQuantity = qty

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute(
                "add_item_qty_count",
                "text",
                tostring(qty)
            )
        end)
    end
end

function adjustAddReserveMags(player, value, id)
    local amount = math.max(
        0,
        math.floor(tonumber(state.addReserveMags) or 0)
    )

    if id == "add_reserve_mags_minus" then
        amount = math.max(0, amount - 1)
    elseif id == "add_reserve_mags_plus" then
        amount = amount + 1
    else
        return
    end

    state.addReserveMags = amount

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute(
                "add_reserve_mags_count",
                "text",
                tostring(amount)
            )

            local cap = selectedCatalogCapacity(
                string.lower(tostring(state.addItemName or ""))
            )

            if cap then
                helper.UI.setAttribute(
                    "equipment_add_mag_hint",
                    "text",
                    string.format(
                        "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
                        cap,
                        amount,
                        cap * amount
                    )
                )
            end
        end)
    end
end



function addSelectedCatalogItem(player, value, id)
    local selectedKey = string.lower(tostring(state.addItemName or ""))
    local catalog = EQUIPMENT_CATALOG[selectedKey]
    if not catalog then return end

    if state.equipmentReplace then
        local chosenCaliber = selectedCatalogCaliber(selectedKey)
        local chosenCapacity = selectedCatalogCapacity(selectedKey)
        local replacement = state.equipmentReplace
        local displayName = catalogDisplayName(selectedKey)
        local ok = false
        local message = ""

        if replacement.kind == "weapon" and catalog.kind == "weapon" then
            local i = tonumber(replacement.index)
            local old = i and state.importedWeapons[i] or nil
            if old then
                local cap = tonumber(chosenCapacity) or tonumber(tostring(catalog.capacity or ""):match("(%d+)"))
                state.importedWeapons[i] = {
                    name = displayName, skill = tostring(catalog.skill or ""),
                    range = tostring(catalog.range or ""), damage = tostring(catalog.damage or ""),
                    lethality = tostring(catalog.lethality or ""),
                    capacity = cap and tostring(cap) or tostring(catalog.capacity or ""),
                    caliber = tostring(chosenCaliber or catalog.caliber or ""),
                    ammoCurrent = cap, ammoReserve = 0, quantity = 1, fireMode = "SINGLE",
                    accessoryMod = tonumber(catalog.accessoryMod) or 0,
                    ap = tostring(catalog.ap or ""), killRadius = tostring(catalog.killRadius or ""),
                    expense = tostring(catalog.expense or ""), consumable = catalog.consumable == true,
                    sourceCategory = tostring(catalog.sourceCategory or ""), notes = tostring(catalog.notes or "")
                }
                ok = true
                message = tostring(old.name or "Weapon") .. " replaced with " .. displayName .. ". Shared reserve ammo was preserved."
            end
        elseif replacement.kind == "armor" and catalog.kind == "armor" then
            local i = tonumber(replacement.index)
            local old = i and state.importedArmor[i] or nil
            if old then
                state.importedArmor[i] = {
                    name = displayName, armor = tostring(catalog.armor or ""),
                    expense = tostring(catalog.expense or ""), notes = tostring(catalog.notes or "")
                }
                ok = true
                message = tostring(old.name or "Armor") .. " replaced with " .. displayName .. "."
            end
        elseif replacement.kind == "gear" and catalog.kind == "gear" then
            local safe = tostring(replacement.key or "")
            for i, g in ipairs(state.importedGear or {}) do
                local oldName = tostring(g or "")
                if string.lower(oldName):gsub("[^%w]","_") == safe then
                    state.itemQuantities[string.lower(oldName)] = nil
                    state.importedGear[i] = displayName
                    state.itemQuantities[string.lower(displayName)] = 1
                    ok = true
                    message = oldName .. " replaced with " .. displayName .. "."
                    break
                end
            end
        end

        if not ok then
            broadcastToAll("[DG] Choose an item from the same replacement class.", {1.0,0.45,0.35})
            return
        end

        state.equipmentReplace = nil
        state.equipmentSubtab = "all"
        state.addReserveRounds = 0
        state.addReserveMags = 0
        state.addItemQuantity = 1
        state.pendingWeaponRoll = nil
        cachedPageDirty["equipment"] = true
        broadcastToAll("[DG] " .. message, {0.55,0.85,0.65})
        queueDashboardSnapshot(SHEET_COLOR, "inventory", message)
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
        return
    end

    local requestedQty =
        math.max(1, math.floor(tonumber(state.addItemQuantity) or 1))

    local chosenCaliber = selectedCatalogCaliber(selectedKey)
    local chosenCapacity = selectedCatalogCapacity(selectedKey)

    local ok, msg, addedWeapon =
        addCatalogItemToInventory(selectedKey, chosenCaliber, chosenCapacity)
    if not ok then
        broadcastToAll(
            "[DG] " .. tostring(msg or "Could not add item."),
            {1.0,0.45,0.35}
        )
        return
    end

    local reserveAdded = 0

    if catalog.kind == "weapon" then
        if selectedCatalogUsesQuantity() and addedWeapon then
            -- addCatalogItemToInventory already added/incremented one.
            addedWeapon.quantity =
                math.max(1, tonumber(addedWeapon.quantity) or 1) +
                math.max(0, requestedQty - 1)

            msg = catalogDisplayName(selectedKey) ..
                " quantity set/increased by " .. tostring(requestedQty) .. "."

        elseif selectedCatalogHasReserveAmmo() and addedWeapon then
            local cap = selectedCatalogCapacity(selectedKey)
            local rounds =
                math.max(0, math.floor(tonumber(state.addReserveRounds) or 0))
            local mags =
                math.max(0, math.floor(tonumber(state.addReserveMags) or 0))

            reserveAdded = rounds + ((cap or 0) * mags)

            if reserveAdded > 0 then
                addSharedAmmoReserve(addedWeapon, reserveAdded)
                msg = tostring(msg or "Item added.") ..
                    " Added " .. tostring(reserveAdded) ..
                    " shared " .. weaponAmmoLabel(addedWeapon) .. "."
            end
        end
    end

    broadcastToAll(
        "[DG] " .. tostring(msg or "Item added."),
        {0.55,0.85,0.65}
    )

    state.addReserveRounds = 0
    state.addReserveMags = 0
    state.addItemQuantity = 1
    resetSelectedCatalogVariant(selectedKey)

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setValue("addReserveRounds", "0")
            helper.UI.setAttribute("add_reserve_mags_count", "text", "0")
            helper.UI.setAttribute("add_item_qty_count", "text", "1")
        end)
    end

    cachedPageDirty["equipment"] = true
end



-------------------------------------------------
-- HANDLER LIVE INVENTORY API
-- Gives the Handler a lightweight snapshot of this Agent's actual funds and
-- carried equipment, and allows the Handler to top up existing ammo/quantities.
-------------------------------------------------

function handlerGetInventorySnapshot(params)
    ensureStructuredImportState()

    pcall(function()
        migrateLegacyWeaponReservesToPools()
    end)

    local snapshot = {
        cash = tostring((state.equipment and state.equipment.cash) or ""),
        spendable = math.max(0, math.floor(tonumber(state.equipment and state.equipment.spendable) or 0)),
        valuables = tostring((state.equipment and state.equipment.valuables) or ""),
        currencyBalances = state.equipment and state.equipment.currencyBalances or {},
        weapons = {},
        armor = {},
        gear = {}
    }

    for i, w in ipairs(state.importedWeapons or {}) do
        local cap = tonumber(tostring(w.capacity or ""):match("(%d+)"))
        local current = tonumber(w.ammoCurrent)
        if current == nil and cap then current = cap end

        local qty = tonumber(w.quantity)

        -- For Handler display, magazine capacity is authoritative. If an
        -- imported/catalog weapon has a capacity, it is ammo-fed even if an
        -- older quantity field happens to exist. Quantity controls are only
        -- for weapons/items with no magazine capacity.
        local usesQuantity = cap == nil and qty ~= nil
        local hasReserveAmmo = cap ~= nil

        local reserve = 0
        if hasReserveAmmo then
            pcall(function()
                reserve = math.max(0, math.floor(tonumber(getSharedAmmoReserve(w)) or 0))
            end)
        end

        local handlerCategory =
            equipmentUiCategoryFromSource(w.sourceCategory)

        if handlerCategory == "gear" then
            local skill = string.lower(tostring(w.skill or ""))
            local name = string.lower(tostring(w.name or ""))

            if skill:find("heavy", 1, true) then
                handlerCategory = "heavy"
            elseif skill:find("melee", 1, true) or
                   skill:find("unarmed", 1, true)
            then
                handlerCategory = "melee"
            elseif skill:find("firearm", 1, true) then
                handlerCategory = "firearms"
            elseif name:find("taser", 1, true) or
                   name:find("pepper", 1, true) or
                   name:find("beanbag", 1, true) or
                   name:find("rubber bullet", 1, true)
            then
                handlerCategory = "lesslethal"
            end
        end

        table.insert(snapshot.weapons, {
            index = i,
            name = tostring(w.name or ("Weapon " .. i)),
            skill = tostring(w.skill or ""),
            damage = tostring(w.damage or ""),
            category = handlerCategory,
            sourceCategory = tostring(w.sourceCategory or ""),
            capacity = cap,
            ammoCurrent = current,
            reserve = reserve,
            ammoLabel = tostring((weaponAmmoLabel and weaponAmmoLabel(w)) or ""),
            quantity = qty,
            usesQuantity = usesQuantity,
            hasReserveAmmo = hasReserveAmmo
        })
    end

    for i, a in ipairs(state.importedArmor or {}) do
        table.insert(snapshot.armor, {
            index = i,
            name = tostring(a.name or ("Armor " .. i)),
            armor = tostring(a.armor or ""),
            notes = tostring(a.notes or "")
        })
    end

    for i, item in ipairs(state.importedGear or {}) do
        local name = tostring(item or "")
        local key = string.lower(name)
        local qty = tonumber((state.itemQuantities or {})[key])

        table.insert(snapshot.gear, {
            index = i,
            key = key,
            name = name,
            quantity = qty
        })
    end

    return snapshot
end

function handlerAdjustExistingInventory(params)
    if type(params) ~= "table" then
        return {ok=false, message="Invalid inventory request."}
    end

    ensureStructuredImportState()

    local kind = tostring(params.kind or "weapon")
    local action = tostring(params.action or "")
    local amount = math.max(1, math.floor(tonumber(params.amount) or 1))
    local message = ""

    if kind == "currency" then
        local code = tostring(params.code or "")
        local def = currencyDefinition(code)
        if not def then
            return {ok=false, message="Unknown currency type."}
        end

        local delta = tonumber(params.amount) or 0
        state.equipment.currencyBalances = state.equipment.currencyBalances or {}

        local current = tonumber(state.equipment.currencyBalances[code]) or 0
        local nextValue = math.max(0, current + delta)
        state.equipment.currencyBalances[code] = nextValue

        message = string.format(
            "%s / %s: %s",
            code,
            def.label,
            currencyDisplayAmount(nextValue)
        )

    elseif kind == "funds" then
        local delta = math.floor(tonumber(params.amount) or 0)
        state.equipment = state.equipment or {}
        state.equipment.spendable = math.max(
            0,
            math.floor(tonumber(state.equipment.spendable) or 0) + delta
        )
        message = string.format(
            "Spendable Funds %s%d. New total: %d.",
            delta >= 0 and "+" or "",
            delta,
            state.equipment.spendable
        )

    elseif kind == "weapon" then
        local i = math.floor(tonumber(params.index) or 0)
        local w = state.importedWeapons and state.importedWeapons[i] or nil
        if not w then
            return {ok=false, message="Weapon is no longer on that Agent sheet."}
        end

        local cap = tonumber(tostring(w.capacity or ""):match("(%d+)"))

        if action == "reserve" then
            if not cap then
                return {ok=false, message="That item does not use reserve ammunition."}
            end

            local reserve = math.max(0, math.floor(tonumber(getSharedAmmoReserve(w)) or 0))
            reserve = reserve + amount
            setSharedAmmoReserve(w, reserve)
            message = string.format("Added %d reserve rounds to %s.", amount, tostring(w.name or "weapon"))

        elseif action == "mag" then
            if not cap then
                return {ok=false, message="That item does not use magazines."}
            end

            local reserve = math.max(0, math.floor(tonumber(getSharedAmmoReserve(w)) or 0))
            reserve = reserve + (cap * amount)
            setSharedAmmoReserve(w, reserve)
            message = string.format(
                "Added %d spare %s to %s (%d rounds into reserve).",
                amount,
                amount == 1 and "magazine" or "magazines",
                tostring(w.name or "weapon"),
                cap * amount
            )

        elseif action == "loaded" then
            if not cap then
                return {ok=false, message="That item does not have a magazine."}
            end

            local current = tonumber(w.ammoCurrent)
            if current == nil then current = cap end
            local add = math.min(amount, math.max(0, cap - current))
            w.ammoCurrent = current + add
            message = string.format(
                "Added %d loaded round%s to %s (%d/%d loaded).",
                add, add == 1 and "" or "s",
                tostring(w.name or "weapon"),
                w.ammoCurrent, cap
            )

        elseif action == "fill" then
            if not cap then
                return {ok=false, message="That item does not have a magazine."}
            end

            local current = tonumber(w.ammoCurrent)
            if current == nil then current = cap end
            local needed = math.max(0, cap - current)
            local reserve = math.max(0, math.floor(tonumber(getSharedAmmoReserve(w)) or 0))
            local moved = math.min(needed, reserve)
            w.ammoCurrent = current + moved
            setSharedAmmoReserve(w, reserve - moved)
            message = string.format(
                "Reloaded %s: %d/%d loaded, %d reserve remaining.",
                tostring(w.name or "weapon"),
                w.ammoCurrent, cap, reserve - moved
            )

        elseif action == "quantity" then
            local qty = math.max(0, math.floor(tonumber(w.quantity) or 0))
            w.quantity = qty + amount
            message = string.format(
                "Added %d to %s quantity.",
                amount,
                tostring(w.name or "item")
            )

        else
            return {ok=false, message="Unknown weapon inventory action."}
        end

    elseif kind == "gear" then
        local key = string.lower(tostring(params.key or ""))
        if key == "" then
            return {ok=false, message="Gear item key missing."}
        end

        state.itemQuantities = state.itemQuantities or {}
        local qty = math.max(0, math.floor(tonumber(state.itemQuantities[key]) or 1))
        state.itemQuantities[key] = qty + amount
        message = string.format("Added %d to %s quantity.", amount, tostring(params.name or key))

    else
        return {ok=false, message="Unknown inventory item type."}
    end

    cachedPageDirty["equipment"] = true

    if state.currentTab == "equipment" and getCachedHelper("equipment") then
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
    end

    queueDashboardSnapshot(
        SHEET_COLOR,
        "status",
        "Handler inventory update: " .. message
    )

    return {
        ok = true,
        message = message,
        inventory = handlerGetInventorySnapshot({})
    }
end

-------------------------------------------------
-- HANDLER EQUIPMENT REMOTE-ADD API
-- Called by the Handler dashboard. Uses this sheet's own equipment catalog
-- and inventory functions so the Handler and Agent always add items identically.
-------------------------------------------------

function handlerGetEquipmentCatalog(params)
    params = type(params) == "table" and params or {}

    -- Handler requests must be self-sufficient. The Agent's own Add Item tab
    -- is lazy-loaded for performance, but the Handler should never depend on
    -- that tab having been opened first.
    if (tonumber(equipmentCatalogCount) or 0) == 0 and
       not equipmentCatalogRefreshRunning
    then
        refreshEquipmentCatalogFromGithub(nil, nil, nil)
    end

    local category = tostring(params.category or state.addItemCategory or "Firearms")
    local validCategory = false
    for _, c in ipairs(EQUIPMENT_ADD_CATEGORY_ORDER) do
        if c == category then
            validCategory = true
            break
        end
    end
    if not validCategory then
        category = EQUIPMENT_ADD_CATEGORY_ORDER[1] or "Firearms"
    end

    local categories = {}
    for _, c in ipairs(EQUIPMENT_ADD_CATEGORY_ORDER) do
        table.insert(categories, c)
    end

    local items = {}
    for _, key in ipairs(sortedCatalogNamesForCategory(category)) do
        local c = EQUIPMENT_CATALOG[key] or {}
        table.insert(items, {
            key = key,
            name = catalogDisplayName(key),
            kind = tostring(c.kind or "gear"),
            sourceCategory = tostring(c.sourceCategory or category),
            subcategory = catalogItemSubcategory(key),
            capacity = tostring(c.capacity or ""),
            caliber = tostring(c.caliber or ""),
            variantSpec = tostring(c.variantSpec or ""),
            skill = tostring(c.skill or ""),
            range = tostring(c.range or ""),
            damage = tostring(c.damage or ""),
            lethality = tostring(c.lethality or ""),
            ap = tostring(c.ap or ""),
            killRadius = tostring(c.killRadius or ""),
            armor = tostring(c.armor or ""),
            expense = catalogItemExpense(key),
            details = catalogItemDetailsText(key),
            description = cleanCatalogDescription(c.description),
            usesQuantity = catalogKeyUsesQuantity(key),
            hasReserveAmmo = catalogKeyHasReserveAmmo(key)
        })
    end

    local subcategories = {}
    local subOrder = EQUIPMENT_SUBCATEGORY_ORDER[category]
    if subOrder then
        for _, sub in ipairs(subOrder) do
            if sub ~= "All" then
                table.insert(subcategories, sub)
            end
        end
    end

    return {
        category = category,
        categories = categories,
        subcategories = subcategories,
        items = items,
        source = tostring(equipmentCatalogSource or "Equipment catalog"),
        loading = equipmentCatalogRefreshRunning == true or
            (tonumber(equipmentCatalogCount) or 0) == 0
    }
end

function handlerAddEquipmentItem(params)
    if type(params) ~= "table" then
        return { ok = false, message = "Invalid Handler equipment request." }
    end

    local key = string.lower(tostring(params.itemKey or params.key or ""))
    local catalog = EQUIPMENT_CATALOG[key]
    if not catalog then
        return { ok = false, message = "Catalog item not found on Agent sheet." }
    end

    local requestedQty = math.max(1, math.floor(tonumber(params.quantity) or 1))
    local reserveRounds = math.max(0, math.floor(tonumber(params.reserveRounds) or 0))
    local reserveMags = math.max(0, math.floor(tonumber(params.reserveMags) or 0))
    local selectedCaliber = tostring(params.caliber or "")
    local selectedCapacity = tonumber(params.capacity)

    local ok, msg, addedWeapon =
        addCatalogItemToInventory(key, selectedCaliber, selectedCapacity)
    if not ok then
        return { ok = false, message = tostring(msg or "Could not add item.") }
    end

    local reserveAdded = 0

    if catalog.kind == "weapon" then
        if catalogKeyUsesQuantity(key) and addedWeapon then
            -- addCatalogItemToInventory already added/incremented one.
            addedWeapon.quantity =
                math.max(1, tonumber(addedWeapon.quantity) or 1) +
                math.max(0, requestedQty - 1)

            msg = catalogDisplayName(key) ..
                " quantity set/increased by " .. tostring(requestedQty) .. "."

        elseif catalogKeyHasReserveAmmo(key) and addedWeapon then
            local cap =
                tonumber(tostring(addedWeapon.capacity or ""):match("(%d+)")) or
                catalogItemMagazineCapacity(key) or 0
            reserveAdded = reserveRounds + (cap * reserveMags)

            if reserveAdded > 0 then
                addSharedAmmoReserve(addedWeapon, reserveAdded)
                msg = tostring(msg or "Item added.") ..
                    " Added " .. tostring(reserveAdded) ..
                    " shared " .. weaponAmmoLabel(addedWeapon) .. "."
            end
        end
    end

    cachedPageDirty["equipment"] = true

    if state.currentTab == "equipment" and getCachedHelper("equipment") then
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
    end

    queueDashboardSnapshot(
        SHEET_COLOR,
        "status",
        "Handler added " .. catalogDisplayName(key)
    )

    return {
        ok = true,
        message = tostring(msg or "Item added."),
        itemName = catalogDisplayName(key),
        reserveAdded = reserveAdded
    }
end

local function equipmentReplacementTarget(kind, token)
    ensureStructuredImportState()
    if kind == "weapon" then
        local i = tonumber(token)
        local w = i and state.importedWeapons[i] or nil
        if not w then return nil end
        local key = string.lower(tostring(w.name or ""))
        local catalog = EQUIPMENT_CATALOG[key]
        return {kind="weapon", index=i, name=tostring(w.name or "Weapon"),
            category=tostring((catalog and catalog.sourceCategory) or w.sourceCategory or "Firearms"),
            subcategory=catalog and catalogItemSubcategory(key) or ""}
    elseif kind == "armor" then
        local i = tonumber(token)
        local a = i and state.importedArmor[i] or nil
        if not a then return nil end
        return {kind="armor", index=i, name=tostring(a.name or "Armor"), category="Body Armor", subcategory=""}
    elseif kind == "gear" then
        local safe = tostring(token or "")
        for _, g in ipairs(state.importedGear or {}) do
            local name = tostring(g or "")
            if string.lower(name):gsub("[^%w]","_") == safe then
                local key = string.lower(name)
                local catalog = EQUIPMENT_CATALOG[key]
                return {kind="gear", key=safe, name=name,
                    category=tostring((catalog and catalog.sourceCategory) or "Other Gear"),
                    subcategory=catalog and catalogItemSubcategory(key) or ""}
            end
        end
    end
    return nil
end

function removeEquipmentItem(player, value, id)
    local kind, token = tostring(id or ""):match("^equipment_remove_([%a]+)_(.+)$")
    local target = equipmentReplacementTarget(kind, token)
    if not target then return end
    if kind == "weapon" then
        table.remove(state.importedWeapons, target.index)
        state.pendingWeaponRoll = nil
    elseif kind == "armor" then
        table.remove(state.importedArmor, target.index)
        if tonumber(state.activeArmorIndex) > #state.importedArmor then
            state.activeArmorIndex = math.max(1, #state.importedArmor)
        end
    elseif kind == "gear" then
        for i, g in ipairs(state.importedGear or {}) do
            if string.lower(tostring(g or "")):gsub("[^%w]","_") == target.key then
                state.itemQuantities[string.lower(tostring(g or ""))] = nil
                table.remove(state.importedGear, i)
                break
            end
        end
    end
    local msg = tostring(target.name or "Item") .. " removed."
    cachedPageDirty["equipment"] = true
    broadcastToAll("[DG] " .. msg, {0.80,0.60,0.45})
    queueDashboardSnapshot(SHEET_COLOR, "inventory", msg)
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function beginReplaceEquipmentItem(player, value, id)
    local kind, token = tostring(id or ""):match("^equipment_replace_([%a]+)_(.+)$")
    local target = equipmentReplacementTarget(kind, token)
    if not target then return end
    state.equipmentReplace = target
    state.equipmentSubtab = "add"
    state.addItemCategory = target.category
    state.addItemSubcategory = target.subcategory
    state.addCaliberFilter = "ALL"
    state.addItemName = ""
    if categoryHasSubcategories(target.category) and target.subcategory ~= "" then
        state.addItemBrowseLevel = "subcategory"
        state.addItemName = firstCatalogKeyForCategoryAndSubcategory(target.category, target.subcategory)
    else
        state.addItemBrowseLevel = "category"
        state.addItemName = firstCatalogKeyForCategory(target.category) or ""
    end
    resetSelectedCatalogVariant(state.addItemName)
    cachedPageDirty["equipment"] = true
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function cancelEquipmentReplace(player, value, id)
    state.equipmentReplace = nil
    state.equipmentSubtab = "all"
    cachedPageDirty["equipment"] = true
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function adjustWeaponAmmo(player, value, id)
    local action, i = tostring(id or ""):match("^equipment_ammo_([%a]+)_(%d+)$")
    if action ~= "minus" and action ~= "plus" then return end

    i = tonumber(i)
    local w = i and state.importedWeapons[i]
    if not w then return end

    local cap = tonumber(tostring(w.capacity or ""):match("(%d+)"))
    if not cap then return end

    local current = tonumber(w.ammoCurrent)
    if current == nil then current = cap end

    if action == "minus" then
        current = math.max(0, current - 1)
    else
        current = math.min(cap, current + 1)
    end

    w.ammoCurrent = current
    refreshWeaponInventoryUi(i)
end


function adjustWeaponReserve(player, value, id)
    local action, i =
        tostring(id or ""):match("^equipment_reserve_([%a]+)_(%d+)$")

    if action ~= "minus" and action ~= "plus" then return end

    i = tonumber(i)
    local w = i and state.importedWeapons[i]
    if not w then return end

    local reserve = getSharedAmmoReserve(w)

    if action == "minus" then
        reserve = math.max(0, reserve - 10)
    else
        reserve = reserve + 10
    end

    setSharedAmmoReserve(w, reserve)
    refreshSharedAmmoPoolUi(w)
end

function adjustWeaponQuantity(player, value, id)
    local action, i = tostring(id or ""):match("^equipment_qty_([%a]+)_(%d+)$")
    if action ~= "minus" and action ~= "plus" then return end

    i = tonumber(i)
    local w = i and state.importedWeapons[i]
    if not w then return end

    local qty = math.max(0, tonumber(w.quantity) or 1)

    if action == "minus" then
        qty = math.max(0, qty - 1)
    else
        qty = qty + 1
    end

    w.quantity = qty
    cachedPageDirty["equipment"] = true

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute(
                "equipment_qty_count_" .. tostring(i),
                "text",
                tostring(qty)
            )
        end)
    end
end

local function gearKeyFromSafeId(safeId)
    safeId = tostring(safeId or "")

    for key, _ in pairs(EQUIPMENT_CATALOG) do
        if key:gsub("[^%w]","_") == safeId then
            return key
        end
    end

    for _, g in ipairs(state.importedGear or {}) do
        local key = string.lower(tostring(g or ""))
        if key:gsub("[^%w]","_") == safeId then
            return key
        end
    end

    for _, a in ipairs(state.importedArmor or {}) do
        local key = string.lower(tostring(a.name or ""))
        if key:gsub("[^%w]","_") == safeId then
            return key
        end
    end

    return nil
end

function adjustGearQuantity(player, value, id)
    local action, safe = tostring(id or ""):match("^item_qty_([%a]+)_(.+)$")
    if action ~= "minus" and action ~= "plus" then return end

    local key = gearKeyFromSafeId(safe)
    if not key then return end

    local qty = math.max(0, tonumber(state.itemQuantities[key]) or 1)

    if action == "minus" then
        qty = math.max(0, qty - 1)
    else
        qty = qty + 1
    end

    state.itemQuantities[key] = qty
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function captureCurrencyAmount(player, value, id)
    local raw = tostring(value or "")
    local cleaned = raw:gsub("[^%d%.]", "")

    -- Keep only the first decimal point.
    local first = cleaned:find("%.", 1, false)
    if first then
        cleaned =
            cleaned:sub(1, first) ..
            cleaned:sub(first + 1):gsub("%.", "")
    end

    state.equipment.currencyDraft = cleaned

    local helper = getCachedHelper("equipment")
    if helper and cleaned ~= raw then
        pcall(function()
            helper.UI.setAttribute("currencyAmountInput", "text", cleaned)
        end)
    end
end

function beginCurrencyFunds(player, value, id)
    ensureStructuredImportState()

    local helper = getCachedHelper("equipment")
    local draft = nil

    if helper then
        pcall(function()
            draft = helper.UI.getValue("currencyAmountInput")
        end)
    end

    if draft == nil then
        draft = state.equipment.currencyDraft
    end

    draft = tostring(draft or ""):gsub("^%s+",""):gsub("%s+$","")
    local amount = tonumber(draft)

    if not amount or amount <= 0 then
        status("Enter a positive amount first.")
        return
    end

    state.equipment.currencyDraft = draft
    state.equipment.currencyAssignPending = true
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function cancelCurrencyFunds(player, value, id)
    state.equipment.currencyAssignPending = false
    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function chooseCurrencyForFunds(player, value, id)
    ensureStructuredImportState()

    local code = tostring(id or ""):match("^currency_pick_(.+)$")
    local def = currencyDefinition(code)
    if not def then return end

    local amount = tonumber(state.equipment.currencyDraft)
    if not amount or amount <= 0 then
        state.equipment.currencyAssignPending = false
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
        return
    end

    state.equipment.currencyBalances = state.equipment.currencyBalances or {}
    state.equipment.currencyBalances[code] =
        (tonumber(state.equipment.currencyBalances[code]) or 0) + amount

    state.equipment.currencyDraft = ""
    state.equipment.currencyAssignPending = false

    queueDashboardSnapshot(
        SHEET_COLOR,
        "status",
        string.format("Added %s %s", currencyDisplayAmount(amount), code)
    )

    rebuildCachedPage("equipment")
    activateCachedPage("equipment")
end

function adjustCurrencyBalance(player, value, id)
    ensureStructuredImportState()

    local code, action =
        tostring(id or ""):match("^currency_adjust_([^_]+)_(.+)$")

    if not code or not action or not currencyDefinition(code) then return end

    local deltaMap = {
        minus100 = -100,
        minus10 = -10,
        minus1 = -1,
        plus1 = 1,
        plus10 = 10,
        plus100 = 100
    }

    local delta = deltaMap[action]
    if not delta then return end

    state.equipment.currencyBalances = state.equipment.currencyBalances or {}
    local current = tonumber(state.equipment.currencyBalances[code]) or 0
    local nextValue = math.max(0, current + delta)
    state.equipment.currencyBalances[code] = nextValue

    cachedPageDirty["equipment"] = true

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute(
                "currency_balance_" .. tostring(code),
                "text",
                currencyDisplayWithSymbol(code, nextValue)
            )
        end)
    end

    queueDashboardSnapshot(
        SHEET_COLOR,
        "status",
        string.format("%s %s adjusted", code, currencyDisplayAmount(nextValue))
    )
end

function adjustFunds(player, value, id)
    ensureStructuredImportState()

    local delta = 0
    if id == "funds_minus100" then delta = -100
    elseif id == "funds_minus10" then delta = -10
    elseif id == "funds_minus1" then delta = -1
    elseif id == "funds_plus1" then delta = 1
    elseif id == "funds_plus10" then delta = 10
    elseif id == "funds_plus100" then delta = 100
    else return end

    state.equipment.spendable =
        math.max(0, math.floor(tonumber(state.equipment.spendable) or 0) + delta)

    cachedPageDirty["equipment"] = true

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute(
                "funds_spendable_count",
                "text",
                tostring(math.floor(tonumber(state.equipment.spendable) or 0))
            )
        end)
    end

    queueDashboardSnapshot(SHEET_COLOR, "status", "Spendable funds adjusted")
end

function selectActiveArmor(player, value, id)
    local i = tonumber(tostring(id or ""):match("armor_select_(%d+)"))
    if not i or not state.importedArmor[i] then return end

    local previous = tonumber(state.activeArmorIndex)
    state.activeArmorIndex = i
    cachedPageDirty["equipment"] = true

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            if previous and previous ~= i then
                helper.UI.setAttributes(
                    "armor_select_" .. tostring(previous),
                    {text="EQUIP", color="#293A31"}
                )
            end
            helper.UI.setAttributes(
                "armor_select_" .. tostring(i),
                {text="EQUIPPED", color="#355845"}
            )
        end)
    end
end

function applyIncomingDamage(player, value, id)
    local raw = math.max(0, math.floor(tonumber(state.incomingDamage) or 0))
    local ap = math.max(0, math.floor(tonumber(state.incomingAP) or 0))
    local armor, armorValue = activeArmorInfo()
    local effectiveArmor = math.max(0, armorValue - ap)
    local finalDamage = math.max(0, raw - effectiveArmor)

    local oldHP = tonumber(state.agent.hp) or 0
    state.agent.hp = clampResourceValue("hp", oldHP - finalDamage)

    local msg = string.format(
        "%s - DAMAGE %d | AP %d | %s armor %d -> effective %d | HP %d -> %d",
        tostring(state.agent.name or "Agent"),
        raw,
        ap,
        armor and tostring(armor.name or "Armor") or "No",
        armorValue,
        effectiveArmor,
        oldHP,
        state.agent.hp
    )

    broadcastToAll(msg, finalDamage > 0 and {0.95,0.45,0.35} or {0.55,0.85,0.65})
    queueDashboardSnapshot(SHEET_COLOR, "roll", msg)

    state.incomingDamage = "0"
    state.incomingAP = "0"

    cachedPageDirty["equipment"] = true
    dgUISetValue("hp", tostring(state.agent.hp))

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute("incomingDamage", "text", "0")
            helper.UI.setAttribute("incomingAP", "text", "0")
        end)
    end
end

function cycleWeaponFireMode(player, value, id)
    local i = tonumber(tostring(id or ""):match("equipment_mode_(%d+)"))
    local w = i and state.importedWeapons[i]
    if not w then return end

    local info = {
        name = tostring(w.name or ""),
        sourceCategory = tostring(w.sourceCategory or ""),
        capacity = tostring(w.capacity or ""),
        lethality = tostring(w.lethality or ""),
        fireMode = tostring(w.fireMode or "SINGLE")
    }

    local catalog = catalogEntryForItem(w.name)
    if catalog then
        if tostring(catalog.sourceCategory or "") ~= "" then
            info.sourceCategory = tostring(catalog.sourceCategory)
        end
        if tostring(catalog.capacity or "") ~= "" then
            info.capacity = tostring(catalog.capacity)
        end
        if tostring(catalog.lethality or "") ~= "" then
            info.lethality = tostring(catalog.lethality)
        end
    end

    if not weaponSupportsSelectiveFire(info) then
        return
    end

    local mode = tostring(w.fireMode or "SINGLE")

    if mode == "SINGLE" then
        mode = "BURST"
    elseif mode == "BURST" then
        mode = "AUTO"
    else
        mode = "SINGLE"
    end

    w.fireMode = mode

    cachedPageDirty["equipment"] = true

    local helper = getCachedHelper("equipment")
    if helper then
        pcall(function()
            helper.UI.setAttribute(
                "equipment_mode_" .. tostring(i),
                "text",
                tostring(mode)
            )
        end)
    end
end

function reloadWeapon(player, value, id)
    local i = tonumber(tostring(id or ""):match("equipment_reload_(%d+)"))
    local w = i and state.importedWeapons[i]
    if not w then return end

    local cap = tonumber(tostring(w.capacity or ""):match("(%d+)"))
    if not cap then return end

    local current = tonumber(w.ammoCurrent)
    if current == nil then current = cap end

    local reserve = getSharedAmmoReserve(w)
    local needed = math.max(0, cap - current)

    if needed <= 0 then
        broadcastToAll(
            "[DG] " .. tostring(w.name or "Weapon") ..
            " is already fully loaded.",
            {0.75,0.75,0.75}
        )
        return
    end

    if reserve <= 0 then
        broadcastToAll(
            "[DG] No " .. weaponAmmoLabel(w) ..
            " available for " .. tostring(w.name or "Weapon") .. ".",
            {1.0,0.55,0.30}
        )
        return
    end

    local loaded = math.min(needed, reserve)
    w.ammoCurrent = current + loaded
    setSharedAmmoReserve(w, reserve - loaded)

    local msg = string.format(
        "%s reloads %s: +%d rounds | MAG %d/%d | %s %d.",
        tostring(state.agent.name or "Agent"),
        tostring(w.name or "weapon"),
        loaded,
        tonumber(w.ammoCurrent) or 0,
        cap,
        weaponAmmoLabel(w),
        getSharedAmmoReserve(w)
    )

    broadcastToAll(msg, {0.55,0.85,0.65})
    refreshSharedAmmoPoolUi(w)
end

function rollSanLoss(player, value, id)
    local formula = tostring(state.sanLossFormula or "0/1d4")
    local successExpr, failureExpr = formula:match("^%s*([^/]+)%s*/%s*([^/]+)%s*$")

    if not successExpr or not failureExpr then
        broadcastToAll(
            "[DG] SAN loss must use success/failure format, for example 0/1d4.",
            {1,0.45,0.35}
        )
        return
    end

    local _, _, successErr = parseDiceExpression(successExpr)
    local _, _, failureErr = parseDiceExpression(failureExpr)

    if successErr or failureErr then
        broadcastToAll(
            "[DG] SAN loss formula is invalid: " ..
            tostring(successErr or failureErr),
            {1,0.45,0.35}
        )
        return
    end

    local source = tostring(state.psychology.sanSource or "Unnatural")
    local adapted =
        (source == "Violence" and state.psychology.adaptedViolence == true) or
        (source == "Helplessness" and state.psychology.adaptedHelplessness == true)

    if adapted then
        broadcastToAll(
            "[DG] Adapted to " .. source ..
            ": SAN test automatically succeeds. Rolling success-side loss.",
            {0.55,0.85,0.65}
        )

        return startDiceExpressionRoll(
            "SAN LOSS",
            successExpr,
            "sanLossPending",
            { source = source }
        )
    end

    if (tonumber(state.agent.wp) or 0) <= 0 then
        broadcastToAll(
            "[DG] 0 WP: SAN test automatically fails. Rolling failure-side loss.",
            {0.95,0.45,0.35}
        )

        return startDiceExpressionRoll(
            "SAN LOSS",
            failureExpr,
            "sanLossPending",
            { source = source }
        )
    end

    local totalMod = currentRollModifier()
    local sanTarget = clamp((tonumber(state.agent.san) or 0) + totalMod, 0, 99)

    startPhysicalPercentileRoll(
        SHEET_COLOR,
        "SAN Test — " .. source,
        sanTarget,
        totalMod ~= 0 and string.format("[Total modifier %+d%%]", totalMod) or "",
        nil,
        {
            kind = "sanLossTest",
            successExpr = successExpr,
            failureExpr = failureExpr,
            source = source
        }
    )
end


function selectUiBaseColor(player, value, id)
    local selected = tostring(value or "")
    if UI_BASE_COLORS[selected] == nil then return end

    state.uiBaseColor = selected

    self.UI.setXml(applyUiTheme(buildXml()))
    uiReady = true

    markAllCachedPagesDirty()

    local current = resolvedCachedPageName()
    Wait.frames(function()
        refreshCachedPageIfDirty(current)
        activateCachedPage(current)
        applyScaleCompensation(true)
    end, 1)
end

function selectUiAccentColor(player, value, id)
    local selected = tostring(value or "")
    if UI_ACCENT_COLORS[selected] == nil then return end

    state.uiAccentColor = selected

    self.UI.setXml(applyUiTheme(buildXml()))
    uiReady = true

    markAllCachedPagesDirty()

    local current = resolvedCachedPageName()
    Wait.frames(function()
        refreshCachedPageIfDirty(current)
        activateCachedPage(current)
        applyScaleCompensation(true)
    end, 1)
end

function selectGenericRoll(player, value, id)
    ensureStructuredImportState()

    local selected = tostring(value or "")
    if selected == "" then selected = "GUMSHOE" end

    state.genericRollChoice = selected
end

function rollGenericSelected(player, value, id)
    ensureStructuredImportState()

    local choice = tostring(state.genericRollChoice or "GUMSHOE")

    local allowed = {
        GUMSHOE = true,
        ["Hit Location"] = true,
        d4 = true,
        d6 = true,
        d8 = true,
        d10 = true,
        d10s = true,
        d12 = true,
        d20 = true
    }

    if not allowed[choice] then
        choice = "GUMSHOE"
        state.genericRollChoice = choice
    end

    if choice == "GUMSHOE" then
        startPhysicalPercentileRoll(
            player.color,
            "GUMSHOE",
            nil,
            ""
        )
        return
    end

    startGenericPhysicalDieRoll(
        player.color,
        choice,
        nil,
        nil,
        nil
    )
end

function toggleSkillImprovementMark(player, value, id)
    ensureStructuredImportState()

    local target = tostring(id or ""):gsub("_improve$", "")
    local matchedName = nil

    for name, _ in pairs(state.skills) do
        if skillId(name) == target then
            matchedName = name
            break
        end
    end

    if not matchedName or matchedName == "Unnatural" then
        return
    end

    state.skillImprovementMarked[matchedName] =
        not (state.skillImprovementMarked[matchedName] == true)

    rebuildUI()
    queueDashboardSnapshot(player.color, "home", "Improvement mark changed")
end

function toggleHomeTime(player, value, id)
    ensureStructuredImportState()
    state.homeTimeOpen = not state.homeTimeOpen
    rebuildUI()
end

function applyMarkedSkillImprovements(player, value, id)
    ensureStructuredImportState()

    local marked = markedSkillNames()

    if #marked == 0 then
        broadcastToAll("[DG] No skills are marked for improvement.", {0.75,0.75,0.75})
        return
    end

    if physicalRoll or genericPhysicalRoll then
        broadcastToAll("[DG] Finish the current physical roll first.", {1,0.65,0.25})
        return
    end

    local config = getPhysicalDiceConfig(SHEET_COLOR)
    local storage = config and config.storage ~= "" and getObjectFromGUID(config.storage) or nil

    if not storage or not findNamedDieGuid(storage, "d4", SHEET_COLOR) then
        broadcastToAll(
            "[DG] Home Time needs a die named d4 with description " ..
            SHEET_COLOR .. " in that player's dice container.",
            {1,0.45,0.35}
        )
        return
    end

    local agentName = tostring(state.agent.name or "Agent")
    if agentName == "" then agentName = "Agent" end

    local header = agentName .. " - END SESSION SKILL IMPROVEMENTS"
    broadcastToAll(header, {0.35,0.75,1.0})

    startGenericPhysicalDieRoll(
        player.color,
        "d4",
        marked[1],
        marked,
        1
    )
end


local function updateSkillEnabledUi(skillName)
    local id = skillId(skillName)
    local enabled = state.skillEnabled[skillName] ~= false

    local labelColor = enabled and "#DDE7DF" or "#68736B"
    local inputTextColor = enabled and "#F1F7F2" or "#6D756F"
    local inputColor = enabled and "#17201B" or "#202521"
    local rollColor = enabled and "#284C39" or "#252B27"
    local rollTextColor = enabled and "#FFFFFF" or "#646C66"

    local helper = getCachedHelper("skills")
    if helper then
        pcall(function()
            helper.UI.setAttribute(id .. "_toggle", "text", enabled and "X" or "")
            helper.UI.setAttribute(id, "readOnly", enabled and "false" or "true")
            helper.UI.setAttribute(id, "interactable", enabled and "true" or "false")
            helper.UI.setAttribute(id, "textColor", inputTextColor)
            helper.UI.setAttribute(id, "color", inputColor)
            helper.UI.setAttribute(id .. "_roll", "interactable", enabled and "true" or "false")
            helper.UI.setAttribute(id .. "_roll", "color", rollColor)
            helper.UI.setAttribute(id .. "_roll", "textColor", rollTextColor)
            helper.UI.setAttribute(id .. "_improve", "interactable",
                (enabled and skillName ~= "Unnatural") and "true" or "false")
            helper.UI.setAttribute(id .. "_label", "color", labelColor)
            helper.UI.setAttribute(id .. "_pct", "color", labelColor)
        end)
    end

    -- Compact active-only layout needs a reflow, but defer that work until
    -- the player actually opens that view.
    cachedPageDirty["skills_active"] = true
end

function toggleSkillEnabled(player, value, id)
    if state.skillEnabled == nil then
        state.skillEnabled = {}
    end

    local target = tostring(id or ""):gsub("_toggle$", "")
    local matchedName = nil

    for name, _ in pairs(state.skills) do
        if skillId(name) == target then
            matchedName = name
            break
        end
    end

    if not matchedName then
        status("Could not identify skill activation: "..tostring(id))
        return
    end

    -- Skills are only acquired here; this control never removes/unlearns one.
    if state.skillEnabled[matchedName] ~= false then
        return
    end

    state.skillEnabled[matchedName] = true

    -- Mark both cached skill views stale. Rebuild the currently-visible
    -- "show inactive" page so the ADD check disappears immediately.
    cachedPageDirty["skills"] = true
    cachedPageDirty["skills_active"] = true

    local targetPage = resolvedCachedPageName()
    if getCachedHelper(targetPage) then
        rebuildCachedPage(targetPage)
        activateCachedPage(targetPage)
    end

    queueDashboardSnapshot(SHEET_COLOR, "status",
        matchedName .. " added to active skills")
end

function toggleSkillsActiveOnly(player, value, id)
    state.skillsActiveOnly = not state.skillsActiveOnly

    local targetPage = resolvedCachedPageName()
    local helper = getCachedHelper(targetPage)

    if helper then
        refreshCachedPageIfDirty(targetPage)
        activateCachedPage(targetPage)
        Wait.frames(function()
            dgSyncActiveCachedHelperTransform(true)
        end, 1)
    else
        ensureCachedPage(targetPage, function()
            activateCachedPage(targetPage)
            Wait.frames(function()
                dgSyncActiveCachedHelperTransform(true)
            end, 1)
        end)
    end

    queueDashboardSnapshot(player.color, "status",
        state.skillsActiveOnly and "Inactive skills hidden" or "Inactive skills shown")
end

function editSkillLive(player, value, id)
    if state.textLocked == true then
        return
    end

    if state.skillEnabled == nil then
        state.skillEnabled = {}
    end

    local matchedName = nil

    for name, _ in pairs(state.skills) do
        if skillId(name) == id then
            matchedName = name
            break
        end
    end

    if not matchedName then
        return
    end

    if state.skillEnabled[matchedName] == false then
        return
    end

    -- TTS InputFields do not always keep their visible text in sync.
    -- Explicitly mirror the typed value back to the XML text attribute.
    dgUISetAttribute(id, "text", tostring(value or ""))

    local n = tonumber(value)

    if n ~= nil then
        n = math.floor(n)
        if n < 0 then n = 0 end
        if n > 99 then n = 99 end
        state.skills[matchedName] = n
    end
end

function editSkill(player, value, id)
    if state.textLocked == true then
        status("Text is locked. Right-click the sheet and choose Unlock Text.")
        return
    end

    if state.skillEnabled == nil then
        state.skillEnabled = {}
    end

    local matchedName = nil

    for name, _ in pairs(state.skills) do
        if skillId(name) == id then
            matchedName = name
            break
        end
    end

    if not matchedName then
        status("Could not identify skill field: "..tostring(id))
        return
    end

    if state.skillEnabled[matchedName] == false then
        status(matchedName.." is inactive. Enable it first.")
        return
    end

    local newValue = math.floor(tonumber(value) or 0)
    if newValue < 0 then newValue = 0 end
    if newValue > 99 then newValue = 99 end

    state.skills[matchedName] = newValue

    -- If an enabled skill is edited down to zero, keep it enabled until
    -- the user explicitly unchecks it. That makes manual editing predictable.
    if state.skillEnabled[matchedName] == nil then
        state.skillEnabled[matchedName] = true
    end

    status(matchedName.." set to "..newValue.."%.")
end

function resourceAdjust(player, value, id)
    local resource, direction =
        id:match("^(%a+)_(%a+)$")

    if not resource then
        return
    end

    if resource ~= "hp" and
       resource ~= "wp" and
       resource ~= "san"
    then
        return
    end

    local oldValue =
        tonumber(state.agent[resource]) or 0

    local delta =
        direction == "plus" and 1 or -1

    state.agent[resource] =
        clampResourceValue(
            resource,
            oldValue + delta
        )
    if resource == "san" then
        handleSanChange(
            oldValue,
            state.agent.san
        )
    end

    dgUISetValue(resource, tostring(state.agent[resource]))
    queueDashboardSnapshot(player.color, "status", "")
end


function selectDisorderSource(player, value, id)
    ensureDisorderState()

    if id == "source_violence" then
        state.psychology.pendingSource = "Violence"
    elseif id == "source_helplessness" then
        state.psychology.pendingSource = "Helplessness"
    elseif id == "source_unnatural" then
        state.psychology.pendingSource = "Unnatural"
    end

    state.psychology.disorderPickIndex = 1
    rebuildUI()
end

function cycleDisorderCandidate(player, value, id)
    ensureDisorderState()

    local source = state.psychology.pendingSource or "Violence"
    local pool = DISORDER_POOLS[source]
    local i = tonumber(state.psychology.disorderPickIndex) or 1

    if id == "disorder_prev" then
        i = i - 1
    else
        i = i + 1
    end

    if i < 1 then i = #pool end
    if i > #pool then i = 1 end

    state.psychology.disorderPickIndex = i
    rebuildUI()
end

function assignDisorderCandidate(player, value, id)
    ensureDisorderState()

    local name = currentDisorderCandidate()
    local source = state.psychology.pendingSource or "Violence"

    table.insert(state.psychology.disorderList, {
        name = name,
        source = source,
        acute = false,
        cured = false
    })

    if (tonumber(state.psychology.pendingDisorders) or 0) > 0 then
        state.psychology.pendingDisorders =
            state.psychology.pendingDisorders - 1
    end

    if hasCuredDisorder() then
        local msg =
            "[DG] New disorder gained while a cured disorder exists. Resolve the rules-required SAN test for possible relapse with the Handler."

        local delivered = safeBroadcastToColor(
            msg,
            state.ownerColor,
            {1.0,0.65,0.35}
        )

        if not delivered then
            broadcastToAll(msg, {1.0,0.65,0.35})
        end
    end

    rebuildUI()
end

local function disorderIndexFromButton(id)
    return tonumber(id:match("^disorder_(%d+)_"))
end

function toggleDisorderAcute(player, value, id)
    ensureDisorderState()

    local i = disorderIndexFromButton(id)
    local d = i and state.psychology.disorderList[i]

    if not d or d.cured then return end

    d.acute = not d.acute
    if rebuildCachedPage and getCachedHelper("disorders") then
        rebuildCachedPage("disorders")
        activateCachedPage("disorders")
    else
        rebuildUI()
    end
end

function toggleDisorderCured(player, value, id)
    ensureDisorderState()

    local i = disorderIndexFromButton(id)
    local d = i and state.psychology.disorderList[i]

    if not d then return end

    d.cured = not d.cured

    if d.cured then
        d.acute = false
    end

    if rebuildCachedPage and getCachedHelper("disorders") then
        rebuildCachedPage("disorders")
        activateCachedPage("disorders")
    else
        rebuildUI()
    end
end

function removeDisorder(player, value, id)
    ensureDisorderState()

    local i = disorderIndexFromButton(id)
    local list = state.psychology.disorderList or {}

    -- Cached UI can briefly contain a button for a row that was already
    -- removed. Never pass a stale/out-of-range index to table.remove().
    if not i or i < 1 or i > #list then
        if rebuildCachedPage and getCachedHelper("disorders") then
            rebuildCachedPage("disorders")
            activateCachedPage("disorders")
        end
        return
    end

    table.remove(list, i)

    if rebuildCachedPage and getCachedHelper("disorders") then
        rebuildCachedPage("disorders")
        activateCachedPage("disorders")
    else
        rebuildUI()
    end
end

function toggleAdaptation(player, value, id)
    if id == "adaptedViolence" then
        state.psychology.adaptedViolence = not state.psychology.adaptedViolence
    elseif id == "adaptedHelplessness" then
        state.psychology.adaptedHelplessness = not state.psychology.adaptedHelplessness
    end
    rebuildUI()
end



-------------------------------------------------
-- DICE CONTAINER LOOKUP
-------------------------------------------------

local SUPPORTED_GENERIC_DICE = {
    "GUMSHOE",
    "d4",
    "d6",
    "d8",
    "d10",
    "d10s",
    "d12",
    "d20"
}

local function normalizeDieName(name)
    return string.lower(tostring(name or "")):gsub("%s+", "")
end

local function sameColorDescription(description, playerColor)
    return string.lower(tostring(description or "")) ==
           string.lower(tostring(playerColor or ""))
end

local function bagEntryDisplayName(entry)
    if type(entry) ~= "table" then return "" end

    return tostring(
        entry.nickname or
        entry.name or
        entry.Nickname or
        entry.Name or
        ""
    )
end

local function bagEntryDescription(entry)
    if type(entry) ~= "table" then return "" end

    return tostring(
        entry.description or
        entry.Description or
        ""
    )
end

local function bagEntryGuid(entry)
    if type(entry) ~= "table" then return nil end

    return entry.guid or entry.GUID
end

findNamedDieGuid = function(storage, dieName, playerColor)
    if not storage then return nil end

    local target = normalizeDieName(dieName)
    local objects = storage.getObjects() or {}

    for _, entry in ipairs(objects) do
        local entryName = normalizeDieName(bagEntryDisplayName(entry))
        local entryDescription = bagEntryDescription(entry)

        if entryName == target and sameColorDescription(entryDescription, playerColor) then
            return bagEntryGuid(entry)
        end
    end

    return nil
end

local function findSharedNamedDieGuid(storage, dieName)
    if not storage then return nil end

    local target = normalizeDieName(dieName)

    for _, entry in ipairs(storage.getObjects() or {}) do
        if normalizeDieName(bagEntryDisplayName(entry)) == target then
            return bagEntryGuid(entry)
        end
    end

    return nil
end

local function scanAvailableDiceForColor(playerColor)
    local available = {"GUMSHOE"}
    local config = getPhysicalDiceConfig(playerColor)

    if not config or not config.storage or config.storage == "" then
        return available
    end

    local storage = getObjectFromGUID(config.storage)
    if not storage then return available end

    if findSharedNamedDieGuid(storage, "Hit Location") then
        table.insert(available, "Hit Location")
    end

    for _, dieName in ipairs({"d4","d6","d8","d10","d10s","d12","d20"}) do
        if findNamedDieGuid(storage, dieName, playerColor) then
            table.insert(available, dieName)
        end
    end

    return available
end

function refreshAvailableDiceFromStorage(params)
    state.availableDice = scanAvailableDiceForColor(SHEET_COLOR)

    local found = {}
    for _, name in ipairs(state.availableDice or {}) do found[name] = true end

    if not found[state.genericRollChoice or "GUMSHOE"] then
        state.genericRollChoice = "GUMSHOE"
    end

    -- Rebuild only the equipment page because its DICE subtab owns these
    -- dropdowns. This happens only on an explicit Handler CHECK FOR NEW DICE.
    cachedPageDirty["equipment"] = true
    if state.currentTab == "equipment" and
       state.equipmentSubtab == "dice" and
       getCachedHelper("equipment")
    then
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
    end

    return state.availableDice
end

genericRollOptionsXml = function()
    local available = state.availableDice

    -- Old saves get one initial scan. After that the list stays fixed until
    -- the Handler explicitly runs CHECK FOR NEW DICE.
    if type(available) ~= "table" or #available == 0 then
        available = scanAvailableDiceForColor(SHEET_COLOR)
        state.availableDice = available
    end

    local selected = tostring(state.genericRollChoice or "GUMSHOE")
    local foundSelected = false
    local options = {}

    for _, name in ipairs(available) do
        if name == selected then
            foundSelected = true
            table.insert(options,
                '<Option selected="true">' .. esc(name) .. '</Option>')
        else
            table.insert(options,
                '<Option>' .. esc(name) .. '</Option>')
        end
    end

    if not foundSelected then
        state.genericRollChoice = "GUMSHOE"
    end

    return table.concat(options, "")
end


local diceBatchRoll = nil
local startNextBatchDie
local randomSignedSpin
local applyRandomDiceSpin
local dieLooksSettled
local recoverPendingWeaponRollAfterTimeout

parseDiceExpression = function(expression)
    local clean = tostring(expression or ""):lower():gsub("%s+", "")
    if clean == "" then
        return nil, nil, "empty dice expression"
    end

    local dice = {}
    local modifier = 0
    local matched = false

    for sign, term in clean:gmatch("([+-]?)([^+-]+)") do
        matched = true
        local signValue = sign == "-" and -1 or 1
        local countText, sidesText = term:match("^(%d*)d(%d+)$")

        if term == "hitlocation" then
            if signValue < 0 then
                return nil, nil, "negative Hit Location dice are not supported"
            end
            table.insert(dice, "Hit Location")

        elseif sidesText then
            if signValue < 0 then
                return nil, nil, "negative dice groups are not supported"
            end

            local count = tonumber(countText)
            if count == nil then count = 1 end
            local sides = tonumber(sidesText)

            local allowed = {
                [4]=true,[6]=true,[8]=true,[10]=true,[12]=true,[20]=true
            }

            if not allowed[sides] then
                return nil, nil, "unsupported die d" .. tostring(sides)
            end

            if count < 0 or count > 20 then
                return nil, nil, "dice count must be 0-20"
            end

            for _ = 1, count do
                table.insert(dice, "d" .. tostring(sides))
            end
        else
            local number = tonumber(term)
            if number == nil then
                return nil, nil, "could not parse '" .. tostring(term) .. "'"
            end
            modifier = modifier + (signValue * number)
        end
    end

    if not matched then
        return nil, nil, "invalid dice expression"
    end

    return dice, modifier, nil
end

local function finalizeDiceBatch()
    if not diceBatchRoll then return end

    local batch = diceBatchRoll
    diceBatchRoll = nil

    local total = tonumber(batch.modifier) or 0
    local parts = {}

    for _, result in ipairs(batch.results or {}) do
        local n = tonumber(result.value) or 0

        if normalizeDieName(result.die) == normalizeDieName("Hit Location") then
            local location =
                (HIT_LOCATION_RESULTS and
                 HIT_LOCATION_RESULTS[math.floor(n)]) or
                "Unknown Location"
            table.insert(parts, "HIT LOCATION=" .. string.upper(location))
        else
            total = total + n
            table.insert(parts, tostring(result.die) .. "=" .. tostring(n))
        end
    end

    if (tonumber(batch.modifier) or 0) ~= 0 then
        table.insert(parts, string.format("mod=%+d", tonumber(batch.modifier) or 0))
    end

    local agentName = tostring(state.agent.name or "Agent")
    if agentName == "" then agentName = "Agent" end

    local detail = table.concat(parts, ", ")
    if detail == "" then detail = "no dice" end

    local message

    if batch.kind == "weaponDamage" then
        local weaponName = tostring(batch.label or "Weapon")
        weaponName = weaponName:gsub("%s+[Dd][Aa][Mm][Aa][Gg][Ee]%s*$", "")

        local multiplier = math.max(1, math.floor(tonumber((batch.context or {}).damageMultiplier) or 1))
        if multiplier > 1 then
            total = total * multiplier
        end

        message = string.format(
            "%s — %s: %d damage%s",
            agentName,
            weaponName,
            total,
            multiplier > 1 and " (critical x2)" or ""
        )

        state.pendingWeaponRoll = nil
        cachedPageDirty["equipment"] = true
        if state.currentTab == "equipment" and getCachedHelper("equipment") then
            rebuildCachedPage("equipment")
            activateCachedPage("equipment")
        end
    else
        message = string.format(
            "%s - {%s} %s = %d",
            agentName,
            tostring(batch.label or "DICE"),
            detail,
            total
        )
    end

    if batch.kind == "sanLoss" or batch.kind == "sanLossPending" then
        local source = tostring((batch.context or {}).source or
            state.psychology.sanSource or "Unnatural")

        state.psychology.pendingSanLoss = math.max(0, total)
        state.psychology.pendingSanSource = source

        message = message .. string.format(
            " | %d SAN pending (%s)",
            math.max(0,total),
            source
        )

        if math.max(0,total) <= 0 then
            applyResolvedSanLoss(0, source, "No SAN lost")
        else
            broadcastToAll(
                "[DG] SAN loss is pending. Open PSYCHOLOGY > SANITY to APPLY it or PROJECT ONTO BOND.",
                {0.95,0.68,0.30}
            )

            notifyHandlerAction(
                tostring(state.agent.name or "Agent") ..
                " has pending SAN loss. Player must Apply or Project it onto a Bond."
            )

            refreshPsychologyPage()
        end

    elseif batch.kind == "bondProjection" then
        local ctx = batch.context or {}
        local i = tonumber(ctx.bondIndex)
        local bond = i and state.importedBonds[i]
        local pending = math.max(0, tonumber(ctx.pendingLoss) or
            tonumber(state.psychology.pendingSanLoss) or 0)

        if bond then
            local cost = math.max(0,total)
            local oldWP = tonumber(state.agent.wp) or 0
            state.agent.wp = clampResourceValue("wp", oldWP - cost)

            if state.agent.wp >= 1 then
                local reduction = math.min(pending, cost)
                adjustBondScore(i, -cost, true)
                local remaining = math.max(0, pending - reduction)

                message = message .. string.format(
                    " | WP %d->%d | %s Bond -%d | SAN loss %d->%d",
                    oldWP, state.agent.wp, tostring(bond.name or "Bond"),
                    cost, pending, remaining
                )

                applyResolvedSanLoss(
                    remaining,
                    tostring(ctx.source or state.psychology.pendingSanSource or "Unnatural"),
                    "Projected " .. tostring(reduction) .. " onto " .. tostring(bond.name or "Bond")
                )
            else
                message = message .. string.format(
                    " | WP %d->%d; projection failed because WP did not remain above 0.",
                    oldWP, state.agent.wp
                )

                applyResolvedSanLoss(
                    pending,
                    tostring(ctx.source or state.psychology.pendingSanSource or "Unnatural"),
                    "Projection failed"
                )
            end
        end

    elseif batch.kind == "adaptationCost" then
        local source = tostring((batch.context or {}).source or "")
        local loss = math.max(1,total)

        if source == "Violence" then
            local oldCha = tonumber(state.agent.cha) or 3
            state.agent.cha = clampBaseStat(oldCha - loss)

            local actualChaLoss = oldCha - state.agent.cha

            for i, bond in ipairs(state.importedBonds or {}) do
                adjustBondScore(i, -actualChaLoss, true)
            end

            message = message .. string.format(
                " | CHA %d->%d; each Bond -%d",
                oldCha, state.agent.cha, actualChaLoss
            )

        elseif source == "Helplessness" then
            local oldPow = tonumber(state.agent.pow) or 3
            state.agent.pow = clampBaseStat(oldPow - loss)
            handlePowChange(oldPow, state.agent.pow)

            message = message .. string.format(
                " | POW %d->%d",
                oldPow, state.agent.pow
            )
        end

        notifyHandlerAction(message)
        refreshPsychologyPage()

    elseif batch.kind == "repressCost" then
        local ctx = batch.context or {}
        local i = tonumber(ctx.bondIndex)
        local bond = i and state.importedBonds[i]

        if bond then
            local cost = math.max(0,total)
            local oldWP = tonumber(state.agent.wp) or 0
            state.agent.wp = clampResourceValue("wp", oldWP - cost)

            if state.agent.wp >= 1 then
                adjustBondScore(i, -cost, true)

                message = message .. string.format(
                    " | WP %d->%d | %s Bond -%d | SAN test follows",
                    oldWP, state.agent.wp, tostring(bond.name or "Bond"), cost
                )

                Wait.frames(function()
                    startPhysicalPercentileRoll(
                        SHEET_COLOR,
                        "REPRESS INSANITY",
                        clamp(tonumber(state.agent.san) or 0,0,99),
                        "[Bond: " .. tostring(bond.name or "Bond") .. "]",
                        nil,
                        { kind = "repressTest", bondIndex = i }
                    )
                end, 2)
            else
                message = message .. string.format(
                    " | WP %d->%d. Repression fails because WP did not remain above 0.",
                    oldWP, state.agent.wp
                )

                notifyHandlerAction(message)
            end
        end
    end

    local batchChatColor =
        batch.kind == "weaponDamage" and {0.30, 0.90, 0.40} or
        {0.85,0.85,0.85}

    broadcastToAll(message, batchChatColor)

    queueDashboardSnapshot(SHEET_COLOR, "roll", message)
end


local diceBatchMonitorRunning = false

local HIT_LOCATION_RESULTS

local function batchDieDropPoint(config, index, totalDice)
    local tower = getObjectFromGUID(config.tower)
    if not tower then return nil end

    local i = math.max(1, math.floor(tonumber(index) or 1))
    local total = math.max(1, math.floor(tonumber(totalDice) or 1))

    -- Preserve the original GUMSHOE spacing exactly:
    -- two dice now sit at +0.025 and -0.025 = 0.05 apart.
    if total == 1 then
        return plainPosition(
            tower.positionToWorld({0.00, 3.25, 0.00})
        )
    elseif total == 2 then
        local xOffset = (i % 2 == 1) and 0.01875 or -0.01875
        return plainPosition(
            tower.positionToWorld({xOffset, 3.25, 0.00})
        )
    end

    -- For larger pools, keep that same ~0.10 neighbor spacing but arrange the
    -- entry points around a compact circumference instead of widening a line.
    -- Cap at six ring positions; larger pools reuse them as dice stream in.
    local slots = math.min(total, 6)
    local spacing = 0.0375
    local radius = spacing / (2 * math.sin(math.pi / slots))
    local slot = (i - 1) % slots
    local angle = (2 * math.pi * slot) / slots

    local xOffset = math.cos(angle) * radius
    local zOffset = math.sin(angle) * radius

    return plainPosition(
        tower.positionToWorld({xOffset, 3.25, zOffset})
    )
end

local function returnDiceBatchObjects(batch)
    if not batch then return end

    local config = batch.config
    local storage =
        config and config.storage and
        getObjectFromGUID(config.storage) or nil

    if not storage then return end

    for _, entry in ipairs(batch.objects or {}) do
        local obj = entry.obj
        if obj then
            if entry.isClone == true then
                pcall(function()
                    destroyObject(obj)
                end)
            else
                pcall(function()
                    storage.putObject(obj)
                end)
            end
        end
    end
end

function coroutine_monitorDiceBatch()
    if not diceBatchRoll then
        diceBatchMonitorRunning = false
        return 1
    end

    local stableFrames = 0
    local frames = 0

    -- Let the first dice get into the tower before testing rest state.
    for _ = 1, 20 do
        coroutine.yield(0)
    end

    while diceBatchRoll and frames < PHYSICAL_DICE_TIMEOUT_FRAMES do
        frames = frames + 1
        local batch = diceBatchRoll

        local expected = #(batch.dice or {})
        local spawned = #(batch.objects or {})
        local allSpawned = batch.spawnComplete == true and spawned >= expected
        local allResting = allSpawned and expected > 0

        if allResting then
            for _, entry in ipairs(batch.objects or {}) do
                if not entry.obj or not dieLooksSettled(entry.obj) then
                    allResting = false
                    break
                end
            end
        end

        if allResting then
            stableFrames = stableFrames + 1

            if stableFrames >= PHYSICAL_DICE_SETTLE_FRAMES then
                batch.results = {}

                table.sort(batch.objects, function(a,b)
                    return (tonumber(a.index) or 0) < (tonumber(b.index) or 0)
                end)

                for _, entry in ipairs(batch.objects) do
                    table.insert(batch.results, {
                        die = tostring(entry.die),
                        value = math.floor(tonumber(entry.obj.getValue()) or 0)
                    })
                end

                local finishedBatch = batch
                diceBatchMonitorRunning = false

                -- Announce immediately, then leave the dice visible briefly.
                finalizeDiceBatch()

                Wait.time(function()
                    returnDiceBatchObjects(finishedBatch)
                end, PHYSICAL_DICE_RETURN_DELAY)

                return 1
            end
        else
            stableFrames = 0
        end

        coroutine.yield(0)
    end

    local timedOutBatch = diceBatchRoll
    diceBatchRoll = nil
    diceBatchMonitorRunning = false

    broadcastToAll(
        "[DG] Dice pool roll timed out. Dice returned; roll can be retried.",
        {1,0.35,0.35}
    )

    if timedOutBatch and timedOutBatch.kind == "weaponDamage" then
        recoverPendingWeaponRollAfterTimeout("weaponDamage")
    end

    returnDiceBatchObjects(timedOutBatch)
    return 1
end

local function spawnNextDiceBatchObject()
    local batch = diceBatchRoll
    if not batch then return end

    local index = tonumber(batch.spawnIndex) or 1
    local dice = batch.dice or {}

    if index > #dice then
        batch.spawnComplete = true
        return
    end

    local dieName = tostring(dice[index])
    local config = batch.config
    local storage =
        config and config.storage and
        getObjectFromGUID(config.storage) or nil

    if not storage then
        local failedBatch = batch
        diceBatchRoll = nil
        diceBatchMonitorRunning = false
        broadcastToAll("[DG] Dice storage not found.", {1,0.35,0.35})
        returnDiceBatchObjects(failedBatch)
        return
    end

    local dropPos = batchDieDropPoint(config, index, #dice)
    if not dropPos then
        local failedBatch = batch
        diceBatchRoll = nil
        diceBatchMonitorRunning = false
        broadcastToAll("[DG] Dice tower not found.", {1,0.35,0.35})
        returnDiceBatchObjects(failedBatch)
        return
    end

    batch.spawnIndex = index + 1
    batch.originalsByName = batch.originalsByName or {}

    local original = batch.originalsByName[dieName]

    local function registerSpawnedDie(obj, isClone)
        if not obj then return end

        if not diceBatchRoll or diceBatchRoll ~= batch then
            if isClone then
                pcall(function() destroyObject(obj) end)
            else
                pcall(function() storage.putObject(obj) end)
            end
            return
        end

        if isClone ~= true then
            batch.originalsByName[dieName] = obj
        end

        obj.setLock(false)
        obj.setPosition(dropPos)
        obj.setRotation(randomDiceRotation())
        kickRandomDiceSpin(obj)

        table.insert(batch.objects, {
            index = index,
            die = dieName,
            obj = obj,
            isClone = isClone == true
        })

        if not diceBatchMonitorRunning then
            diceBatchMonitorRunning = true
            startLuaCoroutine(self, "coroutine_monitorDiceBatch")
        end
    end

    if original then
        -- The first die of each type is the real storage object. Every repeat
        -- is a temporary clone of that same original, so 5d4 needs only one
        -- actual d4 in the box.
        local clone = nil

        pcall(function()
            clone = original.clone({
                position = dropPos,
                rotation = randomDiceRotation(),
                snap_to_grid = false
            })
        end)

        if not clone then
            local failedBatch = batch
            diceBatchRoll = nil
            diceBatchMonitorRunning = false

            broadcastToAll(
                "[DG] Could not clone " .. dieName ..
                " for the multi-die roll.",
                {1,0.45,0.35}
            )

            returnDiceBatchObjects(failedBatch)
            return
        end

        registerSpawnedDie(clone, true)

    else
        -- Only the first die of this type is taken from storage.
        local guid

        if normalizeDieName(dieName) == normalizeDieName("Hit Location") then
            guid = findSharedNamedDieGuid(storage, "Hit Location")
        else
            guid = findNamedDieGuid(storage, dieName, SHEET_COLOR)
        end

        if not guid then
            local failedBatch = batch
            diceBatchRoll = nil
            diceBatchMonitorRunning = false

            broadcastToAll(
                "[DG] Could not find " .. dieName ..
                " with description " .. SHEET_COLOR ..
                " in the dice container.",
                {1,0.45,0.35}
            )

            returnDiceBatchObjects(failedBatch)
            return
        end

        storage.takeObject({
            guid = guid,
            position = dropPos,
            rotation = randomDiceRotation(),
            smooth = false,
            callback_function = function(obj)
                registerSpawnedDie(obj, false)
            end
        })
    end

    Wait.time(function()
        if diceBatchRoll == batch then
            spawnNextDiceBatchObject()
        end
    end, DICE_POOL_SPAWN_INTERVAL)
end

local function startPipelinedDiceBatch()
    local batch = diceBatchRoll
    if not batch then return false end

    local config = getPhysicalDiceConfig(SHEET_COLOR)

    if not config or
       not config.storage or config.storage == "" or
       not config.tower or config.tower == ""
    then
        broadcastToAll(
            "[DG] Dice storage/tower are not configured for " .. SHEET_COLOR .. ".",
            {1,0.45,0.35}
        )
        diceBatchRoll = nil
        return false
    end

    if not getObjectFromGUID(config.storage) then
        broadcastToAll("[DG] Dice storage not found.", {1,0.35,0.35})
        diceBatchRoll = nil
        return false
    end

    if not getObjectFromGUID(config.tower) then
        broadcastToAll("[DG] Dice tower not found.", {1,0.35,0.35})
        diceBatchRoll = nil
        return false
    end

    batch.config = config
    batch.objects = {}
    batch.results = {}
    batch.originalsByName = {}
    batch.spawnIndex = 1
    batch.spawnComplete = false

    spawnNextDiceBatchObject()
    return true
end

startNextBatchDie = function()
    if not diceBatchRoll then return end

    local index = tonumber(diceBatchRoll.index) or 1
    if index > #(diceBatchRoll.dice or {}) then
        finalizeDiceBatch()
        return
    end

    local dieName = diceBatchRoll.dice[index]
    local ok = startGenericPhysicalDieRoll(
        SHEET_COLOR,
        dieName,
        nil,
        nil,
        nil,
        true
    )

    if not ok then
        local label = tostring(diceBatchRoll.label or "dice")
        diceBatchRoll = nil
        broadcastToAll(
            "[DG] Could not continue " .. label .. " roll.",
            {1,0.35,0.35}
        )
    end
end

startDiceExpressionRoll = function(label, expression, kind, context)
    if diceBatchRoll or physicalRoll or genericPhysicalRoll then
        broadcastToAll(
            "[DG] A physical dice roll is already in progress.",
            {1,0.65,0.25}
        )
        return false
    end

    local dice, modifier, err = parseDiceExpression(expression)
    if err then
        broadcastToAll(
            "[DG] " .. tostring(label) .. ": " .. tostring(err) ..
            " (" .. tostring(expression) .. ")",
            {1,0.45,0.35}
        )
        return false
    end

    diceBatchRoll = {
        label = tostring(label or "DICE"),
        expression = tostring(expression or ""),
        kind = kind,
        context = context or {},
        dice = dice or {},
        modifier = tonumber(modifier) or 0,
        results = {},
        index = 1
    }

    if #diceBatchRoll.dice == 0 then
        finalizeDiceBatch()
        return true
    end

    return startPipelinedDiceBatch()
end


local function returnGenericPhysicalDie()
    if not genericPhysicalRoll then return end

    local storage = getObjectFromGUID(genericPhysicalRoll.config.storage)

    if storage and genericPhysicalRoll.dieObj then
        pcall(function()
            storage.putObject(genericPhysicalRoll.dieObj)
        end)
    end

    genericPhysicalRoll = nil
    genericPhysicalRollMonitorRunning = false
end

randomSignedSpin = function()
    local magnitude = math.random(DICE_SPIN_MIN, DICE_SPIN_MAX)
    if math.random(0,1) == 0 then
        magnitude = -magnitude
    end
    return magnitude
end

randomDiceRotation = function()
    return {
        x = math.random(0,359),
        y = math.random(0,359),
        z = math.random(0,359)
    }
end

applyRandomDiceSpin = function(obj)
    if not obj then return end

    pcall(function()
        obj.setLock(false)

        local spin = {
            x = randomSignedSpin(),
            y = randomSignedSpin(),
            z = randomSignedSpin()
        }

        -- TTS exposes both angular velocity and rotational torque. Use both:
        -- angular velocity establishes a random tumble immediately, while
        -- addTorque applies an actual Unity rotational impulse.
        obj.setAngularVelocity(spin)
        obj.addTorque({
            x = spin.x,
            y = spin.y,
            z = spin.z
        }, 4)
    end)
end

kickRandomDiceSpin = function(obj)
    if not obj then return end

    -- takeObject can overwrite rigidbody state on the spawn frame. Apply the
    -- real angular velocity only after the die exists in-world, then reinforce
    -- it twice while it is already falling.
    Wait.frames(function()
        if obj then applyRandomDiceSpin(obj) end
    end, 1)

    Wait.frames(function()
        if obj then applyRandomDiceSpin(obj) end
    end, 3)

    Wait.frames(function()
        if obj then applyRandomDiceSpin(obj) end
    end, 6)
end

-- TTS can leave a die's .resting flag false when it is visibly stationary
-- against a tower/collider. Treat very low linear + angular velocity as settled
-- so percentile/damage rolls do not hang forever on collider jitter.
dieLooksSettled = function(obj)
    if not obj then return false end
    if obj.resting == true then return true end

    local okV, v = pcall(function() return obj.getVelocity() end)
    local okA, a = pcall(function() return obj.getAngularVelocity() end)

    if not okV or not okA or not v or not a then
        return false
    end

    local vx = tonumber(v.x or v[1]) or 0
    local vy = tonumber(v.y or v[2]) or 0
    local vz = tonumber(v.z or v[3]) or 0
    local ax = tonumber(a.x or a[1]) or 0
    local ay = tonumber(a.y or a[2]) or 0
    local az = tonumber(a.z or a[3]) or 0

    local linearSq = vx*vx + vy*vy + vz*vz
    local angularSq = ax*ax + ay*ay + az*az

    return linearSq <= 0.0100 and angularSq <= 0.2500
end

recoverPendingWeaponRollAfterTimeout = function(kind)
    local pending = state and state.pendingWeaponRoll or nil
    if not pending or pending.phase ~= "rolling" then return end

    if kind == "lethality" then
        pending.phase = "lethality"
    elseif kind == "weaponDamage" then
        pending.phase = "damage"
    else
        -- A fresh attack has no legitimate follow-up yet. Clear any stale state.
        state.pendingWeaponRoll = nil
    end

    cachedPageDirty["equipment"] = true
    if state.currentTab == "equipment" and getCachedHelper("equipment") then
        rebuildCachedPage("equipment")
        activateCachedPage("equipment")
    end
end

local function genericDieDropPoint(config)
    local tower = getObjectFromGUID(config.tower)

    if not tower then
        return nil
    end

    -- Single physical dice drop dead-center between the percentile pair.
    -- No tower-side Lua is required.
    local world = tower.positionToWorld({0.00, 3.25, 0.00})

    return {
        x = tonumber(world.x or world[1]) or 0,
        y = tonumber(world.y or world[2]) or 0,
        z = tonumber(world.z or world[3]) or 0
    }
end


HIT_LOCATION_RESULTS = {
    [1]  = "Left Foot",
    [2]  = "Right Foot",
    [3]  = "Left Leg",
    [4]  = "Right Leg",
    [5]  = "Left Hand",
    [6]  = "Right Hand",
    [7]  = "Left Arm",
    [8]  = "Right Arm",
    [9]  = "Crotch",
    [10] = "Stomach",
    [11] = "Chest",
    [12] = "Head"
}

local function finishGenericPhysicalRoll()
    if not genericPhysicalRoll or not genericPhysicalRoll.dieObj then
        return
    end

    local value = genericPhysicalRoll.dieObj.getValue()
    local dieName = genericPhysicalRoll.dieName
    local agentName = tostring(state.agent.name or "Agent")
    if agentName == "" then agentName = "Agent" end

    local displayValue = value
    local message = nil

    if genericPhysicalRoll.isHitLocation == true then
        local locationNumber = math.floor(tonumber(value) or 0)
        local locationName =
            HIT_LOCATION_RESULTS[locationNumber] or
            ("Unknown Location")

        message = string.format(
            "%s - HIT LOCATION = %s",
            agentName,
            string.upper(locationName)
        )
    else
        -- Standalone d10s is a tens die:
        -- raw 1..9 => 10..90, raw 10/0 => 00.
        if normalizeDieName(dieName) == "d10s" then
            local n = tonumber(value) or 0

            if n == 0 or n == 10 then
                displayValue = "00"
            else
                displayValue = tostring(n * 10)
            end
        end

        message = string.format(
            "%s - {%s} = %s",
            agentName,
            string.upper(dieName),
            tostring(displayValue)
        )
    end

    broadcastToAll(message, {0.85,0.85,0.85})

    queueDashboardSnapshot(
        genericPhysicalRoll.playerColor,
        "roll",
        message
    )

    -- Home Time callback, if this d4 was rolled for advancement.
    if genericPhysicalRoll.homeTimeSkill then
        local skillName = genericPhysicalRoll.homeTimeSkill
        local oldValue = math.floor(tonumber(state.skills[skillName]) or 0)
        local gain = math.floor(tonumber(value) or 0)

        if gain < 1 then gain = 1 end
        if gain > 4 then gain = 4 end

        local newValue = math.min(99, oldValue + gain)
        local actualGain = newValue - oldValue

        state.skills[skillName] = newValue
        state.skillImprovementMarked[skillName] = false
        queueDashboardSnapshot(
            genericPhysicalRoll.playerColor,
            "home",
            string.format("%s %d%% -> %d%% (+%d)", skillName, oldValue, newValue, actualGain)
        )

        local improveMessage = string.format(
            "%s - END SESSION {%s} %d%% -> %d%% (+%d)",
            agentName,
            skillName,
            oldValue,
            newValue,
            actualGain
        )

        broadcastToAll(improveMessage, {0.55,0.90,0.60})

        local queue = genericPhysicalRoll.homeTimeQueue
        local nextIndex = (genericPhysicalRoll.homeTimeIndex or 1) + 1
        local playerColor = genericPhysicalRoll.playerColor

        Wait.time(function()
            returnGenericPhysicalDie()

            if queue and nextIndex <= #queue then
                Wait.time(function()
                    startGenericPhysicalDieRoll(
                        playerColor,
                        "d4",
                        queue[nextIndex],
                        queue,
                        nextIndex
                    )
                end, 0.5)
            else
                state.homeTimeOpen = false
                rebuildUI()
            end
        end, PHYSICAL_DICE_RETURN_DELAY)

        return
    end

    Wait.time(returnGenericPhysicalDie, PHYSICAL_DICE_RETURN_DELAY)
end

function coroutine_monitorGenericPhysicalRoll()
    if not genericPhysicalRoll then
        genericPhysicalRollMonitorRunning = false
        return 1
    end

    local settled = 0
    local frames = 0

    for _ = 1, 35 do
        coroutine.yield(0)
    end

    while genericPhysicalRoll and frames < PHYSICAL_DICE_TIMEOUT_FRAMES do
        frames = frames + 1

        local dieObj = genericPhysicalRoll.dieObj

        if dieObj and dieLooksSettled(dieObj) then
            settled = settled + 1

            if settled >= PHYSICAL_DICE_SETTLE_FRAMES then
                genericPhysicalRollMonitorRunning = false
                Wait.time(finishGenericPhysicalRoll, 0.30)
                return 1
            end
        else
            settled = 0
        end

        coroutine.yield(0)
    end

    genericPhysicalRollMonitorRunning = false
    broadcastToAll("[DG] Physical die roll timed out.", {1,0.35,0.35})
    returnGenericPhysicalDie()
    return 1
end

startGenericPhysicalDieRoll = function(playerColor, dieName, homeTimeSkill, homeTimeQueue, homeTimeIndex, batchMode)
    playerColor = SHEET_COLOR

    if physicalRoll or genericPhysicalRoll then
        broadcastToAll("[DG] A physical dice roll is already in progress.", {1,0.65,0.25})
        return false
    end

    local config = getPhysicalDiceConfig(playerColor)

    if not config or
       not config.storage or config.storage == "" or
       not config.tower or config.tower == ""
    then
        broadcastToAll(
            "[DG] Dice storage/tower are not configured for " .. tostring(playerColor) .. ".",
            {1,0.45,0.35}
        )
        return false
    end

    local storage = getObjectFromGUID(config.storage)
    if not storage then
        broadcastToAll("[DG] Dice storage not found.", {1,0.35,0.35})
        return false
    end

    local guid

    if normalizeDieName(dieName) == normalizeDieName("Hit Location") then
        guid = findSharedNamedDieGuid(storage, "Hit Location")
    else
        guid = findNamedDieGuid(storage, dieName, playerColor)
    end

    if not guid then
        local requirement

        if normalizeDieName(dieName) == normalizeDieName("Hit Location") then
            requirement = "shared die named Hit Location"
        else
            requirement =
                tostring(dieName) ..
                " with description " .. tostring(playerColor)
        end

        broadcastToAll(
            "[DG] Could not find " .. requirement .. " in the dice container.",
            {1,0.45,0.35}
        )
        return false
    end

    local dropPos = genericDieDropPoint(config)
    if not dropPos then
        broadcastToAll("[DG] Dice tower not found.", {1,0.35,0.35})
        return false
    end

    genericPhysicalRoll = {
        playerColor = playerColor,
        dieName = dieName,
        isHitLocation = (
            normalizeDieName(dieName) ==
            normalizeDieName("Hit Location")
        ),
        batchMode = batchMode == true,
        config = config,
        dieObj = nil,
        homeTimeSkill = homeTimeSkill,
        homeTimeQueue = homeTimeQueue,
        homeTimeIndex = homeTimeIndex
    }

    storage.takeObject({
        guid = guid,
        position = dropPos,
        rotation = randomDiceRotation(),
        smooth = false,
        callback_function = function(obj)
            if not genericPhysicalRoll then return end

            genericPhysicalRoll.dieObj = obj
            obj.setLock(false)
            obj.setPosition(dropPos)
            kickRandomDiceSpin(obj)

            if not genericPhysicalRollMonitorRunning then
                genericPhysicalRollMonitorRunning = true
                startLuaCoroutine(self, "coroutine_monitorGenericPhysicalRoll")
            end
        end
    })

    return true
end

-------------------------------------------------
-- PHYSICAL PERCENTILE ROLL ENGINE
-------------------------------------------------

local function normalizePercentileDieValue(value)
    local n = tonumber(value)

    if n == nil then
        return 10
    end

    -- Some physical/custom d10s report their zero face as 0,
    -- while the original roller expected that face to read as 10.
    -- Normalize both representations to the same internal value.
    if n == 0 then
        return 10
    end

    return n
end

local function percentileFromDice(tensValue, onesValue)
    local tens = normalizePercentileDieValue(tensValue)
    local ones = normalizePercentileDieValue(onesValue)

    -- Match the original table roller exactly:
    -- zero/zero (10/10 internally) = 100
    -- zero tens + ones = 01..09
    -- tens + zero ones = 10,20..90
    if tens == 10 and ones == 10 then
        return 100
    elseif tens == 10 then
        return ones
    elseif ones == 10 then
        return tens * 10
    else
        return tens * 10 + ones
    end
end

local function isDoublePercentile(total)
    return total == 11 or total == 22 or total == 33 or
           total == 44 or total == 55 or total == 66 or
           total == 77 or total == 88 or total == 99
end

local function evaluatePercentileUsingTableLogic(total, target)
    -- This intentionally matches the user's existing physical roller logic.
    if total <= target then
        if total == 1 or isDoublePercentile(total) then
            return "CRITICAL SUCCESS"
        end
        return "SUCCESS"
    else
        if total == 100 or isDoublePercentile(total) then
            return "FUMBLE"
        end
        return "FAILURE"
    end
end

plainPosition = function(v)
    if not v then return nil end

    return {
        x = tonumber(v.x or v[1]) or 0,
        y = tonumber(v.y or v[2]) or 0,
        z = tonumber(v.z or v[3]) or 0
    }
end



local function getDiceDropPoints(config)
    local tower = getObjectFromGUID(config.tower)

    if not tower then
        return nil, nil, "Dice tower " .. tostring(config.tower) .. " not found."
    end

    -- All player towers share the same geometry.
    -- Calculate drop points directly from the tower object so the towers
    -- themselves need NO Lua helper script.
    local tensWorld = tower.positionToWorld({ 0.00, 3.25, 0.00 })
    local onesWorld = tower.positionToWorld({ 0.00, 3.25, 0.00 })

    return plainPosition(tensWorld), plainPosition(onesWorld), nil
end

local function returnPhysicalDice()
    if not physicalRoll then return end

    local storage = getObjectFromGUID(physicalRoll.config.storage)

    if storage then
        if physicalRoll.tensObj then
            pcall(function() storage.putObject(physicalRoll.tensObj) end)
        end

        if physicalRoll.onesObj then
            pcall(function() storage.putObject(physicalRoll.onesObj) end)
        end
    end

    physicalRoll = nil
    physicalRollMonitorRunning = false
end

local function validPhysicalD10Value(v)
    local n = tonumber(v)
    if n == nil then return false end

    -- Custom d10s may expose their zero face as 0 or 10.
    return n >= 0 and n <= 10
end


local function announcePhysicalRollResult()
    if not physicalRoll then return end

    local tensObj = physicalRoll.tensObj
    local onesObj = physicalRoll.onesObj

    if not tensObj or not onesObj then
        broadcastToAll(
            "[DG] Physical dice roll failed: one or both dice are missing.",
            {1,0.35,0.35}
        )
        returnPhysicalDice()
        return
    end

    local tensValue = tensObj.getValue()
    local onesValue = onesObj.getValue()

    -- A die can briefly report an unusable value just as it comes to rest.
    -- If that happens, try again rather than producing a partial/missing result.
    if not validPhysicalD10Value(tensValue) or
       not validPhysicalD10Value(onesValue)
    then
        Wait.time(announcePhysicalRollResult, 0.20)
        return
    end

    local total = percentileFromDice(tensValue, onesValue)

    local normalizedTens = normalizePercentileDieValue(tensValue)
    local normalizedOnes = normalizePercentileDieValue(onesValue)

    local tensDisplay
    if normalizedTens == 10 then
        tensDisplay = "00"
    else
        tensDisplay = tostring(normalizedTens * 10)
    end

    local onesDisplay
    if normalizedOnes == 10 then
        onesDisplay = "0"
    else
        onesDisplay = tostring(normalizedOnes)
    end

    local agentName = tostring(state.agent.name or "Agent")
    if agentName == "" then agentName = "Agent" end

    local label = tostring(physicalRoll.label or "d100")
    if label == "" then label = "d100" end

    local target = tonumber(physicalRoll.target)
    local resultText = ""

    if target ~= nil then
        resultText = evaluatePercentileUsingTableLogic(total, target)

        if resultText == nil or resultText == "" then
            resultText = "RESULT"
        end
    end

    local skillWasMarked = false

    if physicalRoll.skillName and
       physicalRoll.skillName ~= "Unnatural" and
       (resultText == "FAILURE" or resultText == "FUMBLE")
    then
        ensureStructuredImportState()

        if state.skillImprovementMarked[physicalRoll.skillName] ~= true then
            state.skillImprovementMarked[physicalRoll.skillName] = true
            skillWasMarked = true
        end
    end

    local message
    local logMessage

    -- TTS chat treats square-bracket text as BBCode. A die result such as
    -- [40] can therefore be interpreted as a tag and truncate the visible
    -- message. Use full-width brackets in chat, while keeping normal ASCII
    -- brackets in the DM/history log.
    if target ~= nil then
        message = string.format(
            "%s - {%s} ［%s］ ［%s］ = %d *%s* (%d%%)",
            agentName,
            label,
            tensDisplay,
            onesDisplay,
            total,
            resultText,
            target
        )

        logMessage = string.format(
            "%s - {%s} [%s] [%s] = %d *%s* (%d%%)",
            agentName,
            label,
            tensDisplay,
            onesDisplay,
            total,
            resultText,
            target
        )
    else
        message = string.format(
            "%s - {%s} ［%s］ ［%s］ = %d",
            agentName,
            label,
            tensDisplay,
            onesDisplay,
            total
        )

        logMessage = string.format(
            "%s - {%s} [%s] [%s] = %d",
            agentName,
            label,
            tensDisplay,
            onesDisplay,
            total
        )
    end

    if physicalRoll.skillName and
       physicalRoll.skillName ~= "Unnatural" and
       (resultText == "FAILURE" or resultText == "FUMBLE")
    then
        message = message .. " ★"
        logMessage = logMessage .. " ★"
    end

    if physicalRoll.extra and physicalRoll.extra ~= "" then
        local extraText = tostring(physicalRoll.extra)
        message = message .. " " .. extraText
        logMessage = logMessage .. " " .. extraText
    end

    local chatColor = {1,1,1}

    if resultText == "SUCCESS" then
        chatColor = {0.30, 0.90, 0.40}
    elseif resultText == "FAILURE" then
        chatColor = {1.00, 0.55, 0.10}
    elseif resultText == "FUMBLE" then
        chatColor = {0.95, 0.25, 0.25}
    elseif resultText == "CRITICAL SUCCESS" then
        chatColor = {0.25, 0.60, 1.00}
    end

    -- Chat announcement.
    local chatOk = pcall(function()
        broadcastToAll(message, chatColor)
    end)

    -- Rare fallback in case broadcast fails for any reason.
    if not chatOk then
        pcall(function()
            printToAll(message, chatColor)
        end)
    end

    -- DM/history object. Logging failure must never stop chat or dice cleanup.

    queueDashboardSnapshot(
        physicalRoll.playerColor,
        "roll",
        logMessage
    )

    local automation = physicalRoll.automation

    if automation and automation.kind == "lethality" then
        local rating = tonumber(automation.rating) or 0
        local weaponName = tostring(automation.weaponName or label)
        local lethalityMessage
        local fallbackMultiplier = math.max(1, math.floor(tonumber(automation.damageMultiplier) or 1))

        -- Lethality checks are simple pass/fail against the Lethality rating;
        -- doubles on the Lethality roll itself are not criticals/fumbles.
        local lethalityColor

        if total <= rating then
            lethalityMessage = string.format(
                "%s - {%s} ATTACK HIT — LETHALITY SUCCESS — target is killed if susceptible.",
                agentName,
                weaponName
            )
            lethalityColor = {0.30, 0.90, 0.40}
        else
            local tensDamage = tonumber(normalizedTens) or 0
            local onesDamage = tonumber(normalizedOnes) or 0
            local baseFallbackDamage = tensDamage + onesDamage
            local fallbackDamage = baseFallbackDamage * fallbackMultiplier

            lethalityMessage = string.format(
                "%s - {%s} ATTACK HIT — LETHALITY FAILED — %d + %d = %d HP damage%s.",
                agentName,
                weaponName,
                tensDamage,
                onesDamage,
                fallbackDamage,
                fallbackMultiplier > 1 and " (critical x2)" or ""
            )
            lethalityColor = {1.00, 0.55, 0.10}
        end

        broadcastToAll(lethalityMessage, lethalityColor)
        queueDashboardSnapshot(
            physicalRoll.playerColor,
            "roll",
            lethalityMessage
        )

        state.pendingWeaponRoll = nil
        cachedPageDirty["equipment"] = true
        if state.currentTab == "equipment" and getCachedHelper("equipment") then
            rebuildCachedPage("equipment")
            activateCachedPage("equipment")
        end
    end

    status(
        target ~= nil and
        string.format("%s: %d vs %d — %s", label, total, target, resultText) or
        string.format("%s: %d", label, total)
    )

    if skillWasMarked then
        rebuildUI()
    end

    if automation and automation.kind == "repressTest" then
        local success =
            resultText == "SUCCESS" or
            resultText == "CRITICAL SUCCESS"

        if success then
            state.psychology.temporaryInsanityPending = false
        end

        local repressMsg = string.format(
            "%s - REPRESS INSANITY: %s%s",
            tostring(state.agent.name or "Agent"),
            resultText,
            success and " — episode suppressed." or " — episode is not suppressed."
        )

        broadcastToAll(repressMsg, success and {0.45,0.85,0.55} or {0.95,0.48,0.32})
        notifyHandlerAction(repressMsg)
        cachedPageDirty["psychology"] = true
    end

    if automation and automation.kind == "weaponAttack" then
        local attackSucceeded =
            resultText == "SUCCESS" or
            resultText == "CRITICAL SUCCESS"

        local critical = resultText == "CRITICAL SUCCESS"

        if attackSucceeded then
            local weaponName = tostring(automation.weaponName or label)
            local phase = tostring(automation.followup or "damage")
            local pendingRating = tonumber(automation.rating) or 0

            if phase == "lethality" and critical then
                pendingRating = math.min(99, pendingRating * 2)
            end

            state.pendingWeaponRoll = {
                weaponIndex = automation.weaponIndex,
                weaponName = weaponName,
                phase = phase,
                damage = tostring(automation.damage or ""),
                rating = pendingRating,
                critical = critical,
                damageMultiplier = critical and 2 or 1,
                fireMode = tostring(automation.fireMode or "SINGLE")
            }

            local nextText
            if phase == "lethality" then
                nextText = string.format(
                    "[DG] %s hit%s — next: ROLL LETHALITY %d%%.",
                    weaponName,
                    critical and " CRITICALLY" or "",
                    pendingRating
                )
            else
                nextText = string.format(
                    "[DG] %s hit%s — next: ROLL DAMAGE%s.",
                    weaponName,
                    critical and " CRITICALLY" or "",
                    critical and " (damage will be doubled)" or ""
                )
            end

            broadcastToAll(
                nextText,
                critical and {0.25, 0.60, 1.00} or {0.30, 0.90, 0.40}
            )

            cachedPageDirty["equipment"] = true
            if state.currentTab == "equipment" and getCachedHelper("equipment") then
                rebuildCachedPage("equipment")
                activateCachedPage("equipment")
            end
        else
            state.pendingWeaponRoll = nil
            cachedPageDirty["equipment"] = true
            if state.currentTab == "equipment" and getCachedHelper("equipment") then
                rebuildCachedPage("equipment")
                activateCachedPage("equipment")
            end
        end

        Wait.time(returnPhysicalDice, PHYSICAL_DICE_RETURN_DELAY)

    elseif automation and automation.kind == "sanLossTest" then
        local success =
            resultText == "SUCCESS" or
            resultText == "CRITICAL SUCCESS"

        local lossExpression =
            success and
            tostring(automation.successExpr or "0") or
            tostring(automation.failureExpr or "0")

        Wait.time(function()
            returnPhysicalDice()

            Wait.time(function()
                startDiceExpressionRoll(
                    "SAN LOSS",
                    lossExpression,
                    "sanLossPending",
                    { source = tostring(automation.source or state.psychology.sanSource or "Unnatural") }
                )
            end, 0.30)
        end, PHYSICAL_DICE_RETURN_DELAY)
    else
        Wait.time(returnPhysicalDice, PHYSICAL_DICE_RETURN_DELAY)
    end
end

function coroutine_monitorPhysicalPercentileRoll()
    if not physicalRoll then
        physicalRollMonitorRunning = false
        return 1
    end

    local frames = 0
    local settled = 0

    -- Give the dice time to actually enter the tower before checking rest.
    for _ = 1, 45 do
        coroutine.yield(0)
    end

    while physicalRoll and frames < PHYSICAL_DICE_TIMEOUT_FRAMES do
        frames = frames + 1

        local tensObj = physicalRoll.tensObj
        local onesObj = physicalRoll.onesObj

        if tensObj and onesObj and
           dieLooksSettled(tensObj) and dieLooksSettled(onesObj)
        then
            settled = settled + 1

            if settled >= PHYSICAL_DICE_SETTLE_FRAMES then
                physicalRollMonitorRunning = false

                if physicalRoll then
                    physicalRoll.resultPending = true
                end

                Wait.time(announcePhysicalRollResult, 0.35)
                return 1
            end
        else
            settled = 0
        end

        coroutine.yield(0)
    end

    physicalRollMonitorRunning = false

    local timedOutAutomation = physicalRoll and physicalRoll.automation or nil
    local timeoutKind = timedOutAutomation and tostring(timedOutAutomation.kind or "") or ""

    broadcastToAll(
        "[DG] Physical dice roll timed out. Dice returned; roll can be retried.",
        {1,0.35,0.35}
    )

    if timeoutKind == "lethality" then
        recoverPendingWeaponRollAfterTimeout("lethality")
    elseif timeoutKind == "weaponAttack" then
        recoverPendingWeaponRollAfterTimeout("attack")
    end

    returnPhysicalDice()
    return 1
end

local function beginPhysicalPercentileMonitoring()
    if physicalRollMonitorRunning then return end
    if not physicalRoll then return end
    if not physicalRoll.tensObj or not physicalRoll.onesObj then return end

    physicalRollMonitorRunning = true
    startLuaCoroutine(self, "coroutine_monitorPhysicalPercentileRoll")
end

startPhysicalPercentileRoll = function(playerColor, label, target, extra, skillName, automation)
    playerColor = SHEET_COLOR

    if physicalRoll or genericPhysicalRoll or diceBatchRoll then
        broadcastToAll("[DG] A physical dice roll is already in progress.", {1,0.65,0.25})
        return false
    end

    local config = getPhysicalDiceConfig(playerColor)

    if not config or
       not config.storage or config.storage == "" or
       not config.tower or config.tower == ""
    then
        broadcastToAll(
            "[DG] Physical percentile dice/tower are not configured yet for " ..
            tostring(playerColor) .. ".",
            {1,0.45,0.35}
        )
        return false
    end

    local storage = getObjectFromGUID(config.storage)

    if not storage then
        broadcastToAll("[DG] Dice storage " .. tostring(config.storage) .. " not found.", {1,0.35,0.35})
        return false
    end

    local tensGuid = findNamedDieGuid(storage, "d10s", playerColor)
    local onesGuid = findNamedDieGuid(storage, "d10", playerColor)

    if not tensGuid or not onesGuid then
        broadcastToAll(
            "[DG] Percentile dice missing. Need name=d10s and name=d10 with description=" ..
            tostring(playerColor) .. " in the dice container.",
            {1,0.45,0.35}
        )
        return false
    end

    local tensPos, onesPos, err = getDiceDropPoints(config)

    if err then
        broadcastToAll("[DG] " .. err, {1,0.35,0.35})
        return false
    end

    physicalRoll = {
        playerColor = playerColor,
        label = label,
        target = target,
        extra = extra or "",
        skillName = skillName,
        automation = automation,
        config = config,
        tensObj = nil,
        onesObj = nil
    }

    local function onDieReady(kind, obj)
        if not physicalRoll then return end

        obj.setLock(false)

        if kind == "tens" then
            physicalRoll.tensObj = obj
            obj.setPosition(tensPos)
        else
            physicalRoll.onesObj = obj
            obj.setPosition(onesPos)
        end

        kickRandomDiceSpin(obj)

        beginPhysicalPercentileMonitoring()
    end

    storage.takeObject({
        guid = tensGuid,
        position = tensPos,
        rotation = randomDiceRotation(),
        smooth = false,
        callback_function = function(obj)
            onDieReady("tens", obj)

            -- Feed the second percentile die through the exact same center
            -- point after a short delay so neither die can clip the tower side.
            Wait.time(function()
                if not physicalRoll then return end

                storage.takeObject({
                    guid = onesGuid,
                    position = onesPos,
                    rotation = randomDiceRotation(),
                    smooth = false,
                    callback_function = function(onesObj)
                        onDieReady("ones", onesObj)
                    end
                })
            end, 0.40)
        end
    })

    return true
end

local function spendDepressionWpForTest()
    ensureDisorderState()

    local wpSpent = 0
    local depressions = activeDepressionCount()

    for _ = 1, depressions do
        wpSpent = wpSpent + math.random(1,4)
    end

    if wpSpent > 0 then
        local oldWP = tonumber(state.agent.wp) or 0
        state.agent.wp = clampResourceValue("wp", oldWP - wpSpent)

        if uiReady then
            dgUISetValue("wp", tostring(state.agent.wp))
        end
    end

    return wpSpent
end

function rollD100(player, value, id)
    startPhysicalPercentileRoll(
        player.color,
        "RAW d100",
        nil,
        ""
    )
end

function rollStat(player, value, id)
    local statKey = tostring(id or ""):match("^stat_(%a+)_roll$")

    if not statKey then return end

    local labels = {
        str="STR", con="CON", dex="DEX",
        int="INT", pow="POW", cha="CHA"
    }

    local label = labels[statKey]
    if not label then return end

    ensureDisorderState()

    local statValue = tonumber(state.agent[statKey]) or 0
    local baseTarget = clamp(statValue * 5, 0, 99)
    local disorderMod = activeDisorderStatPenalty()
    local globalMod, manualMod, lowWpMod = currentRollModifier()
    local target = clamp(baseTarget + disorderMod + globalMod, 0, 99)

    local wpSpent = spendDepressionWpForTest()
    local extra = ""

    if disorderMod ~= 0 then
        extra = extra .. string.format(
            "[Disorder modifier %+d%%; base %d%%]",
            disorderMod,
            baseTarget
        )
    end


    if manualMod ~= 0 or lowWpMod ~= 0 then
        if extra ~= "" then extra = extra .. " " end
        extra = extra .. string.format(
            "[Global %+d%%; Low-WP %+d%%]",
            manualMod,
            lowWpMod
        )
    end

    if wpSpent > 0 then
        if extra ~= "" then extra = extra .. " " end
        extra = extra .. string.format(
            "[Depression cost %d WP; WP now %d/%d]",
            wpSpent,
            state.agent.wp,
            state.agent.wpMax
        )
    end

    startPhysicalPercentileRoll(
        player.color,
        label .. " Test",
        target,
        extra
    )
end

function rollEquipmentWeapon(player, value, id)
    local info = equipmentRollTargets[tostring(id or "")]

    if not info then
        broadcastToAll(
            "[DG] Could not identify equipment roll: " .. tostring(id),
            {1.0,0.45,0.25}
        )
        return
    end

    local pending = state.pendingWeaponRoll
    local pendingMatches = false
    if pending then
        local pendingIndex = tonumber(pending.weaponIndex)
        local infoIndex = tonumber(info.weaponIndex)
        pendingMatches =
            (pendingIndex and infoIndex and pendingIndex == infoIndex) or
            (not pendingIndex and tostring(pending.weaponName or "") == tostring(info.name or ""))
    end

    if pendingMatches then
        if pending.phase == "rolling" then
            return
        elseif pending.phase == "damage" then
            local damage = tostring(pending.damage or info.damage or "")
            if damage == "" or damage == "—" or not damage:lower():find("d%d") then
                broadcastToAll(
                    "[DG] " .. tostring(info.name or "Weapon") ..
                    " has no rollable damage expression.",
                    {1,0.55,0.30}
                )
                state.pendingWeaponRoll = nil
                cachedPageDirty["equipment"] = true
                return
            end

            pending.phase = "rolling"
            cachedPageDirty["equipment"] = true
            if state.currentTab == "equipment" and getCachedHelper("equipment") then
                rebuildCachedPage("equipment")
                activateCachedPage("equipment")
            end

            local ok = startDiceExpressionRoll(
                tostring(info.name or "Weapon") .. " DAMAGE",
                damage,
                "weaponDamage",
                { damageMultiplier = tonumber(pending.damageMultiplier) or 1 }
            )

            if not ok then
                pending.phase = "damage"
            end
            return

        elseif pending.phase == "lethality" then
            local rating = tonumber(pending.rating) or 0
            if rating <= 0 then
                state.pendingWeaponRoll = nil
                cachedPageDirty["equipment"] = true
                return
            end

            pending.phase = "rolling"
            cachedPageDirty["equipment"] = true
            if state.currentTab == "equipment" and getCachedHelper("equipment") then
                rebuildCachedPage("equipment")
                activateCachedPage("equipment")
            end

            local ok = startPhysicalPercentileRoll(
                SHEET_COLOR,
                tostring(info.name or "Weapon") .. " LETHALITY",
                math.min(99, rating),
                "",
                nil,
                {
                    kind = "lethality",
                    rating = math.min(99, rating),
                    weaponName = tostring(info.name or "Weapon"),
                    damageMultiplier = tonumber(pending.damageMultiplier) or 1
                }
            )

            if not ok then
                pending.phase = "lethality"
            end
            return
        end
    end

    -- Starting a fresh attack always clears an abandoned follow-up from another weapon.
    if state.pendingWeaponRoll then
        state.pendingWeaponRoll = nil
    end

    local skillName, baseTarget = liveSkillValue(tostring(info.skill or ""))

    ensureDisorderState()

    local disorderMod = activeDisorderSkillPenalty()
    local globalMod, manualMod, lowWpMod = currentRollModifier()
    local accessoryMod = tonumber(info.accessoryMod) or 0
    local target = clamp(baseTarget + disorderMod + globalMod + accessoryMod, 0, 99)
    local wpSpent = spendDepressionWpForTest()
    local extra = ""

    if disorderMod ~= 0 then
        extra = extra .. string.format(
            "[Disorder modifier %+d%%; base %d%%]",
            disorderMod,
            baseTarget
        )
    end


    if manualMod ~= 0 or lowWpMod ~= 0 then
        if extra ~= "" then extra = extra .. " " end
        extra = extra .. string.format(
            "[Global %+d%%; Low-WP %+d%%]",
            manualMod,
            lowWpMod
        )
    end

    if wpSpent > 0 then
        if extra ~= "" then extra = extra .. " " end

        extra = extra .. string.format(
            "[Depression cost %d WP; WP now %d/%d]",
            wpSpent,
            state.agent.wp,
            state.agent.wpMax
        )
    end

    local weaponIndex = tonumber(info.weaponIndex)
    if weaponIndex and state.importedWeapons[weaponIndex] then
        local w = state.importedWeapons[weaponIndex]
        local qty = math.max(0, tonumber(w.quantity) or 1)

        if qty <= 0 then
            broadcastToAll(
                "[DG] No " .. tostring(w.name or "weapon") .. " remaining.",
                {1,0.45,0.35}
            )
            return
        end

        local cap = tonumber(tostring(w.capacity or ""):match("(%d+)"))

        if w.consumable == true then
            w.quantity = math.max(0, qty - 1)

            if extra ~= "" then extra = extra .. " " end
            extra = extra .. string.format(
                "[Consumed 1; %d remaining]",
                tonumber(w.quantity) or 0
            )

            cachedPageDirty["equipment"] = true

        elseif cap then
            if w.ammoCurrent == nil then w.ammoCurrent = cap end

            local fireInfo = {
                name = tostring(w.name or ""),
                sourceCategory = tostring(w.sourceCategory or ""),
                capacity = tostring(w.capacity or ""),
                lethality = tostring(w.lethality or ""),
                fireMode = tostring(w.fireMode or "SINGLE")
            }

            local catalog = catalogEntryForItem(w.name)
            if catalog then
                if tostring(catalog.sourceCategory or "") ~= "" then
                    fireInfo.sourceCategory = tostring(catalog.sourceCategory)
                end
                if tostring(catalog.capacity or "") ~= "" then
                    fireInfo.capacity = tostring(catalog.capacity)
                end
                if tostring(catalog.lethality or "") ~= "" then
                    fireInfo.lethality = tostring(catalog.lethality)
                end
            end

            local mode = selectedFireModeForWeapon(fireInfo)
            local cost = ammoCostForFireMode(mode)

            if tonumber(w.ammoCurrent) < cost then
                broadcastToAll(
                    string.format(
                        "[DG] %s does not have enough ammunition for %s fire (%d needed, %d available).",
                        tostring(w.name or "Weapon"),
                        mode,
                        cost,
                        tonumber(w.ammoCurrent) or 0
                    ),
                    {1,0.45,0.35}
                )
                return
            end

            w.ammoCurrent = math.max(0, tonumber(w.ammoCurrent) - cost)
            refreshWeaponInventoryUi(weaponIndex)

            -- Keep chat focused on the actual roll result. Ammo, fire mode,
            -- and modifiers remain visible on the Agent sheet.
            cachedPageDirty["equipment"] = true
        end
    end

    local fireMode = selectedFireModeForWeapon(info)
    local lethalityRating =
        tonumber(tostring(info.lethality or ""):match("(%d+)")) or 0

    local useLethality = weaponUsesLethalityForMode(info, fireMode)

    local automation = {
        kind = "weaponAttack",
        weaponIndex = info.weaponIndex,
        weaponName = tostring(info.name or "Weapon"),
        followup = useLethality and "lethality" or "damage",
        damage = tostring(info.damage or ""),
        rating = math.min(99, lethalityRating),
        fireMode = fireMode
    }

    startPhysicalPercentileRoll(
        player.color,
        tostring(info.name or "Weapon") .. " ATTACK (D%)",
        target,
        extra,
        skillName,
        automation
    )
end

function rollSkill(player, value, id)
    local name = skillNameFromId(id)

    if not name then
        broadcastToAll(
            "[DG] Could not identify skill roll button: " .. tostring(id),
            {1.0,0.45,0.25}
        )
        return
    end

    if state.skillEnabled[name] == false then
        return
    end

    ensureDisorderState()

    local canonicalName, baseTarget = liveSkillValue(name)
    name = canonicalName
    local disorderMod = activeDisorderSkillPenalty()
    local globalMod, manualMod, lowWpMod = currentRollModifier()
    local target = clamp(baseTarget + disorderMod + globalMod, 0, 99)

    local wpSpent = spendDepressionWpForTest()
    local extra = ""

    if disorderMod ~= 0 then
        extra = extra .. string.format(
            "[Disorder modifier %+d%%; base %d%%]",
            disorderMod,
            baseTarget
        )
    end


    if manualMod ~= 0 or lowWpMod ~= 0 then
        if extra ~= "" then extra = extra .. " " end
        extra = extra .. string.format(
            "[Global %+d%%; Low-WP %+d%%]",
            manualMod,
            lowWpMod
        )
    end

    if wpSpent > 0 then
        if extra ~= "" then extra = extra .. " " end
        extra = extra .. string.format(
            "[Depression cost %d WP; WP now %d/%d]",
            wpSpent,
            state.agent.wp,
            state.agent.wpMax
        )
    end

    startPhysicalPercentileRoll(
        player.color,
        name,
        target,
        extra,
        name
    )
end

-----------------------------
-- OPTIONAL CHAT DEBUG COMMANDS
-----------------------------

function onDrop(player_color)
    Wait.frames(function()
        dgSyncActiveCachedHelperTransform(true)
    end, 2)
end

function dgPrintCachedHelperTransform()
    local helper = getCachedHelper(state.currentTab or "personnel")
    if not helper then
        broadcastToAll("[DG] No active cached helper found.", {1,0.45,0.35})
        return
    end

    local cardScale = self.getScale()
    local helperScale = helper.getScale()

    broadcastToAll(
        string.format(
            "[DG] CARD SCALE %.3f %.3f %.3f | HELPER SCALE %.3f %.3f %.3f",
            cardScale.x, cardScale.y, cardScale.z,
            helperScale.x, helperScale.y, helperScale.z
        ),
        {0.65,0.85,0.70}
    )
end

function onChat(message, player)
    if message == "!dgsheet ping" then
        broadcastToAll(
            "[DG] Purple Agent tuning commands are active.",
            {0.45,1.00,0.55}
        )
        return false
    end

    -- Manual fine tuning:
    -- !dgsheet top up/down/left/right/raise/lower
    -- !dgsheet top wider/narrower/taller/shorter/bigger/smaller
    -- Same commands with "bottom".
    local part, action = tostring(message or ""):match(
        "^!dgsheet%s+([%a]+)%s+([%w%-]+)%s*$"
    )

    if part and action then
        part = string.lower(part)
        action = string.lower(action)

        if part == "top" or part == "bottom" then
            if action == "status" then
                broadcastToAll(
                    "[DG] " .. dgFineTuneSummary(part),
                    {0.65,0.85,0.70}
                )
                return false
            end

            if dgApplyFineTuneCommand(part, action) then
                broadcastToAll(
                    "[DG] " .. dgFineTuneSummary(part),
                    {0.65,0.85,0.70}
                )
                return false
            end

            broadcastToAll(
                "[DG] Unknown tuning action: " .. tostring(action),
                {1.0,0.45,0.35}
            )
            return false
        end
    end

    if message == "!dgsheet tune" then
        broadcastToAll(
            "[DG] " .. dgFineTuneSummary("top") ..
            " || " .. dgFineTuneSummary("bottom"),
            {0.65,0.85,0.70}
        )
        return false
    end

    if message == "!dgsheet fit" then
        broadcastToAll(
            string.format(
                "[DG] PURPLE FIT: width=%d%% height=%d%% master=%dx%d",
                dgUiWidthPercent(),
                dgUiHeightPercent(),
                DG_MASTER_UI_WIDTH,
                DG_MASTER_UI_HEIGHT
            ),
            {0.65,0.85,0.70}
        )
        return false
    end

    if message == "!dgsheet w+" then
        state.uiWidthPercent = math.min(120, dgUiWidthPercent() + 1)
        applyScaleCompensation(true)
        broadcastToAll(
            string.format("[DG] Purple UI width: %d%%", dgUiWidthPercent()),
            {0.65,0.85,0.70}
        )
        return false
    end

    if message == "!dgsheet w-" then
        state.uiWidthPercent = math.max(70, dgUiWidthPercent() - 1)
        applyScaleCompensation(true)
        broadcastToAll(
            string.format("[DG] Purple UI width: %d%%", dgUiWidthPercent()),
            {0.65,0.85,0.70}
        )
        return false
    end

    if message == "!dgsheet h+" then
        state.uiHeightPercent = math.min(120, dgUiHeightPercent() + 1)
        applyScaleCompensation(true)
        broadcastToAll(
            string.format("[DG] Purple UI height: %d%%", dgUiHeightPercent()),
            {0.65,0.85,0.70}
        )
        return false
    end

    if message == "!dgsheet h-" then
        state.uiHeightPercent = math.max(70, dgUiHeightPercent() - 1)
        applyScaleCompensation(true)
        broadcastToAll(
            string.format("[DG] Purple UI height: %d%%", dgUiHeightPercent()),
            {0.65,0.85,0.70}
        )
        return false
    end

    if message == "!dgsheet size" then
        broadcastToAll(
            string.format(
                "[DG] Purple UI size = W %d%% / H %d%%",
                dgUiWidthPercent(),
                dgUiHeightPercent()
            ),
            {0.65,0.85,0.70}
        )
        return false
    end
    if message == "!dgsheet helper-scale" then
        dgPrintCachedHelperTransform()
        return false
    end



    if message == "!dgsheet reset-scale" then
        if player.color ~= "Black" and not player.admin and not player.host then return end
            lastScale = nil
        applyScaleCompensation(true)
        broadcastToColor("DG sheet scale baseline reset.",player.color,{0.5,1,0.6})
        return false
    end


    if message == "!dgsheet bigger" then
        CARD_UI_SCALE_X = CARD_UI_SCALE_X * 1.15
        CARD_UI_SCALE_Y = CARD_UI_SCALE_Y * 1.15
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end

    if message == "!dgsheet smaller" then
        CARD_UI_SCALE_X = CARD_UI_SCALE_X / 1.15
        CARD_UI_SCALE_Y = CARD_UI_SCALE_Y / 1.15
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end


    if message == "!dgsheet wider" then
        CARD_UI_SCALE_X = CARD_UI_SCALE_X * 1.08
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end

    if message == "!dgsheet narrower" then
        CARD_UI_SCALE_X = CARD_UI_SCALE_X / 1.08
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end

    if message == "!dgsheet taller" then
        CARD_UI_SCALE_Y = CARD_UI_SCALE_Y * 1.08
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end

    if message == "!dgsheet shorter" then
        CARD_UI_SCALE_Y = CARD_UI_SCALE_Y / 1.08
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end


    if message == "!dgsheet flip180" then
        if UI_ROTATION == "0 0 0" then
            UI_ROTATION = "0 0 180"
        else
            UI_ROTATION = "0 0 0"
        end
        rebuildUI()
        return false
    end


    if message == "!dgsheet closer" then
        UI_SURFACE_Z = UI_SURFACE_Z + 5
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end

    if message == "!dgsheet farther" then
        UI_SURFACE_Z = UI_SURFACE_Z - 5
        lastScale = nil
        applyScaleCompensation(true)
        return false
    end


    if message == "!dgsheet reset-starting-san" then
        initializeStartingSanityAndBreakingPoint()
        rebuildUI()
        return false
    end

    if message == "!dgsheet show" then
        state.uiVisible = true
        dgUIShow("dg_root")
        return false
    end

    if message == "!dgsheet hide" then
        state.uiVisible = false
        dgUIHide("dg_root")
        return false
    end
end