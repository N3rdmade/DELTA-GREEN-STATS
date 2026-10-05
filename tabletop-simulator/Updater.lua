-- Delta Green TTS GitHub Updater / GUID Registry
-- Version: u2.0
-- Published by Hellhorde
-- Central updater, tag-based object registry, and GitHub bootstrap.

local REPO_RAW =
    "https://raw.githubusercontent.com/N3rdmade/DELTA-GREEN-STATS/main/"

local SELF_PATH = "tabletop-simulator/Updater.lua"

local SCRIPT_TARGETS = {
    { tag="DG_HANDLER",      path="tabletop-simulator/character-sheets/Handler.lua",     label="Handler" },
    { tag="DG_AGENT_RED",    path="tabletop-simulator/character-sheets/Agent_Red.lua",   label="Red Agent" },
    { tag="DG_AGENT_BLUE",   path="tabletop-simulator/character-sheets/Agent_Blue.lua",  label="Blue Agent" },
    { tag="DG_AGENT_GREEN",  path="tabletop-simulator/character-sheets/Agent_Green.lua", label="Green Agent" },
    { tag="DG_AGENT_PURPLE", path="tabletop-simulator/character-sheets/Agent_Purple.lua",label="Purple Agent" },
    { tag="DG_AGENT_PINK",   path="tabletop-simulator/character-sheets/Agent_Pink.lua",  label="Pink Agent" },
    { tag="DG_AGENT_WHITE",  path="tabletop-simulator/character-sheets/Agent_White.lua", label="White Agent" }
}

local REGISTRY_TAGS = {
    "DG_UPDATER",
    "DG_HANDLER",

    "DG_AGENT_RED","DG_AGENT_BLUE","DG_AGENT_GREEN",
    "DG_AGENT_PURPLE","DG_AGENT_PINK","DG_AGENT_WHITE",

    "DG_NAMEPLATE_RED","DG_NAMEPLATE_BLUE","DG_NAMEPLATE_GREEN",
    "DG_NAMEPLATE_PURPLE","DG_NAMEPLATE_PINK","DG_NAMEPLATE_WHITE",

    "DG_FIGURINE_RED","DG_FIGURINE_BLUE","DG_FIGURINE_GREEN",
    "DG_FIGURINE_PURPLE","DG_FIGURINE_PINK","DG_FIGURINE_WHITE",

    "DG_DICE_TOWER_RED","DG_DICE_TOWER_BLUE","DG_DICE_TOWER_GREEN",
    "DG_DICE_TOWER_PURPLE","DG_DICE_TOWER_PINK","DG_DICE_TOWER_WHITE",

    "DG_SHARED_DICE_STORAGE",
    "DG_HANDLER_DICE_TOWER",
    "DG_RESULT_LOG"
}

local state = {
    registry = {},
    duplicates = {},
    lastScanCount = 0,
    lastUpdateSummary = "",
    bootGeneration = 0
}

local updateRunning = false
local bootContinued = false

local function normalizeScript(s)
    s = tostring(s or "")
    s = s:gsub("\r\n","\n")
    s = s:gsub("[ \t]+\n","\n")
    s = s:gsub("%s+$","")
    return s
end

local function status(msg, rgb)
    msg = "[DG Updater] " .. tostring(msg or "")
    broadcastToAll(msg, rgb or {0.55,0.85,0.65})
    state.lastUpdateSummary = msg
end

local function taggedObjects(tag)
    local found = {}
    for _,obj in ipairs(getAllObjects() or {}) do
        local ok, has = pcall(function() return obj.hasTag(tag) end)
        if ok and has then
            table.insert(found,obj)
        end
    end
    return found
end

local function publishRegistry()
    pcall(function()
        Global.setTable("DG_GUID_REGISTRY", state.registry or {})
    end)
end

local function scanRegistry(silent)
    state.registry = {}
    state.duplicates = {}

    local count = 0

    for _,tag in ipairs(REGISTRY_TAGS) do
        local found = taggedObjects(tag)

        if #found > 0 then
            state.registry[tag] = found[1].getGUID()
            count = count + 1
        end

        if #found > 1 then
            local extras = {}
            for i=2,#found do
                table.insert(extras,found[i].getGUID())
            end
            state.duplicates[tag] = extras
        end
    end

    if not state.registry["DG_UPDATER"] then
        state.registry["DG_UPDATER"] = self.getGUID()
    end

    state.lastScanCount = count
    publishRegistry()

    if not silent then
        local dupCount = 0
        for _ in pairs(state.duplicates or {}) do dupCount = dupCount + 1 end

        if dupCount > 0 then
            status(
                string.format(
                    "Scanned %d tagged roles; %d duplicate role tag(s) need cleanup.",
                    count, dupCount
                ),
                {1.0,0.65,0.25}
            )
        else
            status("Scanned " .. tostring(count) .. " tagged object roles.")
        end
    end

    return state.registry
end

function getGuidForTag(params)
    local tag
    if type(params) == "table" then
        tag = tostring(params.tag or "")
    else
        tag = tostring(params or "")
    end

    if tag == "" then return "" end

    local guid = (state.registry or {})[tag]
    if guid and guid ~= "" and getObjectFromGUID(guid) then
        return guid
    end

    scanRegistry(true)
    return tostring((state.registry or {})[tag] or "")
end

function getRegistry()
    local copy = {}
    for tag,guid in pairs(state.registry or {}) do
        copy[tag] = guid
    end
    return copy
end

function rescanTaggedObjects(player, value, id)
    scanRegistry(false)
end

local function getSingleTargetObject(tag)
    local found = taggedObjects(tag)
    if #found == 0 then return nil, "not found" end
    if #found > 1 then
        return nil, tostring(#found) .. " objects share tag " .. tag
    end
    return found[1], nil
end

local function updateTargetAt(index, changed, skipped, missing)
    if index > #SCRIPT_TARGETS then
        updateRunning = false
        scanRegistry(true)
        status(string.format(
            "Update pass complete: %d changed, %d current, %d missing/tag errors.",
            changed, skipped, missing
        ))
        return
    end

    local target = SCRIPT_TARGETS[index]
    local obj, err = getSingleTargetObject(target.tag)

    if not obj then
        if err ~= "not found" then
            status(target.label .. ": " .. tostring(err), {1.0,0.65,0.25})
        end
        updateTargetAt(index+1, changed, skipped, missing+1)
        return
    end

    WebRequest.get(REPO_RAW .. target.path, function(req)
        if req.is_error or tonumber(req.response_code or 0) ~= 200 then
            status(
                target.label .. ": GitHub fetch failed (" ..
                tostring(req.error or req.response_code or "unknown") .. ").",
                {1.0,0.40,0.35}
            )
            updateTargetAt(index+1, changed, skipped, missing+1)
            return
        end

        local remote = tostring(req.text or "")
        local current = tostring(obj.getLuaScript() or "")

        if normalizeScript(remote) == normalizeScript(current) then
            updateTargetAt(index+1, changed, skipped+1, missing)
            return
        end

        obj.setLuaScript(remote)

        Wait.frames(function()
            local existing = getObjectFromGUID(obj.getGUID())
            if existing then
                pcall(function() existing.reload() end)
            end

            Wait.frames(function()
                updateTargetAt(index+1, changed+1, skipped, missing)
            end, 8)
        end, 2)
    end)
end

local function updateAllTargets()
    if updateRunning then
        status("An update pass is already running.", {1.0,0.65,0.25})
        return
    end

    updateRunning = true
    scanRegistry(true)
    updateTargetAt(1,0,0,0)
end

local function continueBoot(manual)
    if bootContinued then return end
    bootContinued = true

    scanRegistry(true)

    Wait.frames(function()
        updateAllTargets()
    end, manual and 1 or 20)
end

function checkSelfThenContinue(manual)
    scanRegistry(true)

    WebRequest.get(REPO_RAW .. SELF_PATH, function(req)
        if req.is_error or tonumber(req.response_code or 0) ~= 200 then
            status(
                "Could not check Updater.lua; continuing with the installed updater.",
                {1.0,0.65,0.25}
            )
            continueBoot(manual)
            return
        end

        local remote = tostring(req.text or "")
        local current = tostring(self.getLuaScript() or "")

        if normalizeScript(remote) ~= normalizeScript(current) then
            self.setLuaScript(remote)
            Wait.frames(function()
                self.reload()
            end, 1)
            return
        end

        continueBoot(manual)
    end)
end

function checkForUpdatesNow(player, value, id)
    bootContinued = false
    checkSelfThenContinue(true)
end

local function buildContextMenu()
    self.clearContextMenu()

    self.addContextMenuItem(
        "Check DG Updates Now",
        function() checkForUpdatesNow() end
    )

    self.addContextMenuItem(
        "Rescan DG Tagged GUIDs",
        function() rescanTaggedObjects() end
    )

    self.addContextMenuItem(
        "Print DG GUID Registry",
        function()
            scanRegistry(true)
            local keys = {}
            for tag,_ in pairs(state.registry or {}) do
                table.insert(keys,tag)
            end
            table.sort(keys)

            broadcastToAll("[DG Updater] GUID registry:", {0.65,0.85,0.70})
            for _,tag in ipairs(keys) do
                broadcastToAll(
                    "  " .. tag .. " = " .. tostring(state.registry[tag]),
                    {0.75,0.75,0.75}
                )
            end
        end
    )
end

function onLoad(saved_data)
    if saved_data and saved_data ~= "" then
        local ok, loaded = pcall(JSON.decode,saved_data)
        if ok and type(loaded) == "table" then
            state = loaded
        end
    end

    state.registry = state.registry or {}
    state.duplicates = state.duplicates or {}
    state.bootGeneration = (tonumber(state.bootGeneration) or 0) + 1

    updateRunning = false
    bootContinued = false

    buildContextMenu()
    scanRegistry(true)

    Wait.frames(function()
        checkSelfThenContinue(false)
    end, 4)
end

function onSave()
    return JSON.encode(state)
end
