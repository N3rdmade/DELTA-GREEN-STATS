-- Delta Green TTS Handler Dashboard
-- Version: v3.10
-- Published by Hellhorde
-- Date: 2026-09-30
-- Free to use, modify, and share provided this credit header remains intact.
-- Tabletop Simulator object script for Handler overview, rolls, Home Time,
-- inventory/funds management, equipment assignment, and Agent-sheet sync.

-- Core UI / object configuration
UI_WIDTH = 1240
UI_HEIGHT = 820

UI_POSITION = "0 0 -22"
UI_ROTATION = "0 0 0"

CARD_UI_SCALE_X = 0.174
CARD_UI_SCALE_Y = 0.386

MAX_ROLL_HISTORY = 40
MAX_HOME_HISTORY = 30

SHARED_DICE_STORAGE_GUID = "a50074"
BLACK_DICE_TOWER_GUID = "a66071"
RESULT_LOG_GUID = "ebc7e5"

DICE_RETURN_DELAY = 2.5
DICE_REST_FRAMES = 8

-- Randomized physical-die tumble settings
HANDLER_DICE_SPIN_MIN = 22
HANDLER_DICE_SPIN_MAX = 36


PLAYER_ORDER = {
    "Red",
    "Blue",
    "Green",
    "Purple",
    "Pink",
    "Orange"
}

local state = {
    currentTab = "overview",
    agents = {},
    rollHistory = {},
    homeHistory = {},
    rollChoice = "GUMSHOE",

    addTargetColor = "Red",
    addCategory = "Firearms",
    addSubcategory = "",
    addBrowseLevel = "root",
    addAssignPending = false,
    addCatalogSourceColor = "",
    addItemKey = "",
    addCaliberFilter = "ALL",
    addArmorRatingFilter = "ALL",
    addSelectedCaliber = "",
    addSelectedCapacity = "",
    addQuantity = 1,
    addReserveRounds = 0,
    addReserveMags = 0,
    addStatus = "",

    inventoryStatus = "",
    inventoryColor = "Red",
    inventorySubtab = "all",
    inventoryCurrencyDraft = "",
    inventoryCurrencyPickPending = false,

    availableDice = nil,
    handlerMultiQty1 = 1,
    handlerMultiDie1 = "d6",
    handlerMultiQty2 = 0,
    handlerMultiDie2 = "d4",
    handlerMultiQty3 = 0,
    handlerMultiDie3 = "d8",
    handlerMultiQty4 = 0,
    handlerMultiDie4 = "Hit Location",
    handlerMultiModifier = "0"
}

local uiReady = false


-------------------------------------------------
-- PHYSICAL DICE
-- Runs only while a Handler roll is active.
-------------------------------------------------

local activeRoll = nil

-- Forward declarations
local eventAppend
local rebuildUI

local function normalizeDieName(name)
    return tostring(name or ""):lower():gsub("%s+","")
end

local function findNamedDieGuid(storage, dieName)
    if not storage then return nil end

    local want = normalizeDieName(dieName)

    for _, entry in ipairs(storage.getObjects() or {}) do
        local nickname = entry.nickname or entry.Nickname or entry.name or entry.Name or ""
        local description = entry.description or entry.Description or ""
        local guid = entry.guid or entry.GUID

        if normalizeDieName(nickname) == want and
           tostring(description):lower() == "black"
        then
            return guid
        end
    end

    return nil
end

local function findSharedNamedDieGuid(storage, dieName)
    if not storage then return nil end

    local want = normalizeDieName(dieName)

    for _, entry in ipairs(storage.getObjects() or {}) do
        local nickname = entry.nickname or entry.Nickname or entry.name or entry.Name or ""
        local guid = entry.guid or entry.GUID

        if normalizeDieName(nickname) == want then
            return guid
        end
    end

    return nil
end

local function findHandlerDieGuid(storage, dieName)
    if not storage then return nil end

    -- Prefer a die explicitly marked Black, but older/shared dice may not
    -- carry that description. Fall back to the first matching die name.
    local guid = findNamedDieGuid(storage, dieName)
    if guid then return guid end
    return findSharedNamedDieGuid(storage, dieName)
end


local function appendResultLog(text)
    local log = getObjectFromGUID(RESULT_LOG_GUID)
    if not log then return end

    local old = tostring(log.getDescription() or "")
    if old ~= "" then
        old = old .. "\n"
    end

    log.setDescription(old .. tostring(text or ""))
end

local function towerPoint(localX)
    local tower = getObjectFromGUID(BLACK_DICE_TOWER_GUID)
    if not tower then return nil end

    local p = tower.positionToWorld({localX, 3.25, 0.00})

    return {
        x = tonumber(p.x or p[1]) or 0,
        y = tonumber(p.y or p[2]) or 0,
        z = tonumber(p.z or p[3]) or 0
    }
end

local function compactDicePoolPoint(index, totalDice)
    local i = math.max(1, math.floor(tonumber(index) or 1))
    local total = math.max(1, math.floor(tonumber(totalDice) or 1))

    if total == 1 then
        return towerPoint(0.00)
    elseif total == 2 then
        return towerPoint((i % 2 == 1) and 0.05 or -0.05)
    end

    -- Same 0.10 neighbor spacing as the original GUMSHOE pair, arranged
    -- around a compact ring. Pools over six dice reuse these positions.
    local slots = math.min(total, 6)
    local spacing = 0.0375
    local radius = spacing / (2 * math.sin(math.pi / slots))
    local slot = (i - 1) % slots
    local angle = (2 * math.pi * slot) / slots

    local tower = getObjectFromGUID(BLACK_DICE_TOWER_GUID)
    if not tower then return nil end

    local p = tower.positionToWorld({
        math.cos(angle) * radius,
        3.25,
        math.sin(angle) * radius
    })

    return {
        x = tonumber(p.x or p[1]) or 0,
        y = tonumber(p.y or p[2]) or 0,
        z = tonumber(p.z or p[3]) or 0
    }
end



local function handlerRandomSignedSpin()
    local magnitude = math.random(HANDLER_DICE_SPIN_MIN, HANDLER_DICE_SPIN_MAX)
    if math.random(0,1) == 0 then magnitude = -magnitude end
    return magnitude
end

local function handlerRandomDiceRotation()
    return {
        x = math.random(0,359),
        y = math.random(0,359),
        z = math.random(0,359)
    }
end

local function applyHandlerRandomSpin(obj)
    if not obj then return end

    pcall(function()
        obj.setLock(false)

        local spin = {
            x = handlerRandomSignedSpin(),
            y = handlerRandomSignedSpin(),
            z = handlerRandomSignedSpin()
        }

        obj.setAngularVelocity(spin)
        obj.addTorque({
            x = spin.x,
            y = spin.y,
            z = spin.z
        }, 4)
    end)
end

local function kickHandlerRandomSpin(obj)
    if not obj then return end

    Wait.frames(function()
        if obj then applyHandlerRandomSpin(obj) end
    end, 1)

    Wait.frames(function()
        if obj then applyHandlerRandomSpin(obj) end
    end, 4)
end

local HANDLER_HIT_LOCATION_RESULTS = {
    [1]  = "LEFT FOOT",
    [2]  = "RIGHT FOOT",
    [3]  = "LEFT LEG",
    [4]  = "RIGHT LEG",
    [5]  = "LEFT HAND",
    [6]  = "RIGHT HAND",
    [7]  = "LEFT ARM",
    [8]  = "RIGHT ARM",
    [9]  = "CROTCH",
    [10] = "STOMACH",
    [11] = "CHEST",
    [12] = "HEAD"
}

local function returnHandlerDice()
    if not activeRoll then return end

    local storage = getObjectFromGUID(SHARED_DICE_STORAGE_GUID)
    if storage then
        for i, obj in ipairs(activeRoll.objects or {}) do
            if obj and obj.getGUID and getObjectFromGUID(obj.getGUID()) then
                if activeRoll.cloneFlags and activeRoll.cloneFlags[i] == true then
                    pcall(function() destroyObject(obj) end)
                else
                    pcall(function() storage.putObject(obj) end)
                end
            end
        end
    end

    activeRoll = nil
end

local function finishHandlerRoll()
    if not activeRoll then return end

    local choice = activeRoll.choice
    local text = ""

    if choice == "MULTI" then
        local total = tonumber(activeRoll.modifier) or 0
        local parts = {}

        for i, obj in ipairs(activeRoll.objects or {}) do
            local name = tostring((activeRoll.dieNames or {})[i] or "die")
            local value = obj and tonumber(obj.getValue()) or 0

            if normalizeDieName(name) == normalizeDieName("Hit Location") then
                local location =
                    HANDLER_HIT_LOCATION_RESULTS[math.floor(value)] or
                    "UNKNOWN LOCATION"
                table.insert(parts, "HIT LOCATION=" .. location)
            else
                total = total + value
                table.insert(parts, string.upper(name) .. "=" .. tostring(value))
            end
        end

        if (tonumber(activeRoll.modifier) or 0) ~= 0 then
            table.insert(parts,
                string.format("MOD=%+d", tonumber(activeRoll.modifier) or 0))
        end

        text = string.format(
            "HANDLER - {DICE POOL} %s = %d",
            table.concat(parts, ", "),
            total
        )

    elseif choice == "GUMSHOE" then
        local tens = activeRoll.objects[1]
        local ones = activeRoll.objects[2]
        if not tens or not ones then
            returnHandlerDice()
            return
        end

        local tv = tonumber(tens.getValue()) or 0
        local ov = tonumber(ones.getValue()) or 0

        if tv == 10 then tv = 0 end
        if ov == 10 then ov = 0 end

        local total
        if tv == 0 and ov == 0 then
            total = 100
        elseif tv == 0 then
            total = ov
        elseif ov == 0 then
            total = tv * 10
        else
            total = tv * 10 + ov
        end

        local tDisplay = (tv == 0) and "00" or tostring(tv * 10)
        local oDisplay = tostring(ov)

        text = string.format(
            "HANDLER - {GUMSHOE} ［%s］ ［%s］ = %d",
            tDisplay,
            oDisplay,
            total
        )
    else
        local die = activeRoll.objects[1]
        if not die then
            returnHandlerDice()
            return
        end

        local value = tonumber(die.getValue()) or 0
        local display = tostring(value)

        if normalizeDieName(choice) == normalizeDieName("Hit Location") then
            local location =
                HANDLER_HIT_LOCATION_RESULTS[math.floor(value)] or
                "UNKNOWN LOCATION"

            -- Deliberately omit the numerical die face. The Hit Location die
            -- reports only the body part.
            text = "HANDLER - HIT LOCATION = " .. location

        else
            if normalizeDieName(choice) == "d10s" then
                if value == 0 or value == 10 then
                    display = "00"
                else
                    display = tostring(value * 10)
                end
            end

            text = string.format(
                "HANDLER - {%s} = %s",
                string.upper(choice),
                display
            )
        end
    end

    eventAppend(
        state.rollHistory,
        { color = "Black", text = text },
        MAX_ROLL_HISTORY
    )

    appendResultLog(text)
    broadcastToAll(text, {0.86,0.86,0.86})
    rebuildUI()

    Wait.time(returnHandlerDice, DICE_RETURN_DELAY)
end

local function watchHandlerDice()
    if not activeRoll then return end

    local allResting = true
    for _, obj in ipairs(activeRoll.objects or {}) do
        if not obj or not obj.resting then
            allResting = false
            break
        end
    end

    if allResting then
        activeRoll.restFrames = (activeRoll.restFrames or 0) + 1
    else
        activeRoll.restFrames = 0
    end

    if activeRoll.restFrames >= DICE_REST_FRAMES then
        finishHandlerRoll()
        return
    end

    Wait.frames(watchHandlerDice, 1)
end

local function startHandlerRoll(choice)
    if activeRoll then
        broadcastToColor(
            "A Handler roll is already in progress.",
            "Black",
            {1,0.55,0.3}
        )
        return
    end

    local storage = getObjectFromGUID(SHARED_DICE_STORAGE_GUID)
    local tower = getObjectFromGUID(BLACK_DICE_TOWER_GUID)

    if not storage or not tower then
        broadcastToColor(
            "Handler dice storage or Black dice tower is missing.",
            "Black",
            {1,0.35,0.35}
        )
        return
    end

    choice = tostring(choice or "GUMSHOE")

    local names = {}
    local points = {}

    if choice == "GUMSHOE" then
        names = {"d10s", "d10"}
        points = {
            towerPoint(0.00),
            towerPoint(0.00)
        }
    else
        names = {choice}
        points = {
            towerPoint(0.00)
        }
    end

    local guids = {}

    -- Resolve every die BEFORE taking anything out of the shared box.
    for i, name in ipairs(names) do
        local guid

        if normalizeDieName(name) == normalizeDieName("Hit Location") then
            guid = findSharedNamedDieGuid(storage, "Hit Location")
        else
            guid = findHandlerDieGuid(storage, name)
        end

        if not guid then
            broadcastToColor(
                "Die not found in shared storage: " .. tostring(name),
                "Black",
                {1,0.35,0.35}
            )
            return
        end

        guids[i] = guid
    end

    activeRoll = {
        choice = choice,
        objects = {},
        restFrames = 0
    }

    local function pullNext(index)
        if not activeRoll then return end

        if index > #names then
            -- Both GUMSHOE dice (or the one generic die) now exist physically.
            for _, obj in ipairs(activeRoll.objects) do
                if obj then
                    kickHandlerRandomSpin(obj)
                end
            end

            Wait.frames(watchHandlerDice, 8)
            return
        end

        storage.takeObject({
            guid = guids[index],
            position = points[index],
            rotation = handlerRandomDiceRotation(),
            smooth = false,
            callback_function = function(obj)
                if not activeRoll then return end

                -- Preserve exact role/order:
                -- [1] = d10s/tens, [2] = d10/ones.
                activeRoll.objects[index] = obj

                kickHandlerRandomSpin(obj)

                Wait.time(function()
                    pullNext(index + 1)
                end, 0.40)
            end
        })
    end

    pullNext(1)
end

local function startHandlerMultiRoll(names, modifier)
    if activeRoll then
        broadcastToColor(
            "A Handler roll is already in progress.",
            "Black",
            {1,0.55,0.3}
        )
        return false
    end

    local storage = getObjectFromGUID(SHARED_DICE_STORAGE_GUID)
    if not storage or not getObjectFromGUID(BLACK_DICE_TOWER_GUID) then
        broadcastToColor(
            "Handler dice storage or Black dice tower is missing.",
            "Black",
            {1,0.35,0.35}
        )
        return false
    end

    activeRoll = {
        choice = "MULTI",
        objects = {},
        dieNames = {},
        cloneFlags = {},
        originalsByName = {},
        modifier = tonumber(modifier) or 0,
        restFrames = 0
    }

    local function pullNext(index)
        if not activeRoll then return end

        if index > #names then
            Wait.frames(watchHandlerDice, 8)
            return
        end

        local name = tostring(names[index])
        local point = compactDicePoolPoint(index, #names)
        local original = activeRoll.originalsByName[name]

        local function register(obj, isClone)
            if not activeRoll or not obj then
                if obj and isClone then
                    pcall(function() destroyObject(obj) end)
                end
                return
            end

            activeRoll.objects[index] = obj
            activeRoll.dieNames[index] = name
            activeRoll.cloneFlags[index] = isClone == true

            if isClone ~= true then
                activeRoll.originalsByName[name] = obj
            end

            obj.setLock(false)
            obj.setPosition(point)
            obj.setRotation(handlerRandomDiceRotation())
            kickHandlerRandomSpin(obj)

            Wait.time(function()
                pullNext(index + 1)
            end, 0.40)
        end

        if original then
            -- Repeated dice use temporary clones of the first real die.
            -- Example: 3d6 = one storage d6 + two clones.
            local clone = nil

            pcall(function()
                clone = original.clone({
                    position = point,
                    rotation = handlerRandomDiceRotation(),
                    snap_to_grid = false
                })
            end)

            if not clone then
                broadcastToColor(
                    "Could not clone " .. name .. " for the dice pool.",
                    "Black",
                    {1,0.35,0.35}
                )
                returnHandlerDice()
                return
            end

            register(clone, true)

        else
            -- Only the first die of each type is looked up/taken from storage.
            local guid

            if normalizeDieName(name) == normalizeDieName("Hit Location") then
                guid = findSharedNamedDieGuid(storage, "Hit Location")
            else
                guid = findHandlerDieGuid(storage, name)
            end

            if not guid then
                broadcastToColor(
                    "Die not found in shared storage: " .. name,
                    "Black",
                    {1,0.35,0.35}
                )
                returnHandlerDice()
                return
            end

            storage.takeObject({
                guid = guid,
                position = point,
                rotation = handlerRandomDiceRotation(),
                smooth = false,
                callback_function = function(obj)
                    register(obj, false)
                end
            })
        end
    end

    pullNext(1)
    return true
end

local function scanHandlerAvailableDice()
    local storage = getObjectFromGUID(SHARED_DICE_STORAGE_GUID)
    local available = {"GUMSHOE"}

    if not storage then return available end

    if findSharedNamedDieGuid(storage, "Hit Location") then
        table.insert(available, "Hit Location")
    end

    for _, dieName in ipairs({"d4","d6","d8","d10","d10s","d12","d20"}) do
        if findHandlerDieGuid(storage, dieName) then
            table.insert(available, dieName)
        end
    end

    return available
end

local function handlerDiceOptionsXml()
    if type(state.availableDice) ~= "table" or #state.availableDice == 0 then
        state.availableDice = scanHandlerAvailableDice()
    end

    local options = {}
    local selected = tostring(state.rollChoice or "GUMSHOE")
    local foundSelected = false

    for _, name in ipairs(state.availableDice) do
        if name == selected then
            foundSelected = true
            table.insert(options,
                '<Option selected="true">' .. name .. '</Option>')
        else
            table.insert(options, '<Option>' .. name .. '</Option>')
        end
    end

    if not foundSelected then
        state.rollChoice = "GUMSHOE"
    end

    return table.concat(options, "\\n")
end

local function handlerPoolDiceChoices()
    local out = {}
    local allowed = {
        d4=true,d6=true,d8=true,d10=true,d12=true,d20=true,
        ["Hit Location"]=true
    }

    for _, name in ipairs(state.availableDice or {}) do
        if allowed[name] then table.insert(out,name) end
    end

    if #out == 0 then
        out={"d4","d6","d8","d10","d12","d20","Hit Location"}
    end
    return out
end

local function handlerSimpleOptionList(values, selected)
    local out = {}
    selected = tostring(selected or "")
    for _, value in ipairs(values or {}) do
        local t=tostring(value)
        if t==selected then
            table.insert(out,'<Option selected="true">'..t..'</Option>')
        else
            table.insert(out,'<Option>'..t..'</Option>')
        end
    end
    return table.concat(out,"")
end


-------------------------------------------------
-- HELPERS
-------------------------------------------------

local function esc(s)
    s = tostring(s or "")
    s = s:gsub("&","&amp;")
    s = s:gsub("<","&lt;")
    s = s:gsub(">","&gt;")
    s = s:gsub('"',"&quot;")
    return s
end

local function clamp(v, lo, hi)
    v = tonumber(v) or 0
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local function pct(cur, maxv)
    cur = tonumber(cur) or 0
    maxv = tonumber(maxv) or 0
    if maxv <= 0 then return 0 end
    return clamp(math.floor((cur / maxv) * 100 + 0.5), 0, 100)
end

local function colorHex(colorName)
    local map = {
        Red = "#8D2F2F",
        Blue = "#2F568D",
        Green = "#3D7048",
        Purple = "#674A82",
        Pink = "#9C5E78",
        Orange = "#A3652E",
        Black = "#AAB2AC"
    }
    return map[colorName] or "#45574D"
end

eventAppend = function(list, payload, maxCount)
    table.insert(list, 1, payload)

    while #list > maxCount do
        table.remove(list)
    end
end

local function tabButton(id, label, active, x)
    return string.format([[
      <Button id="dash_tab_%s"
          onClick="switchDashboardTab"
          text="%s"
          rectAlignment="UpperLeft"
          width="170" height="42"
          offsetXY="%d -60"
          fontSize="14"
          fontStyle="Bold"
          color="%s"
          textColor="#FFFFFF"/>]],
        esc(id),
        esc(label),
        x,
        active and "#456A53" or "#223229"
    )
end

local function bar(label, cur, maxv, y)
    local percent = pct(cur, maxv)
    local fillWidth = math.floor(300 * percent / 100)

    return string.format([[
      <Text text="%s"
          rectAlignment="UpperLeft"
          width="78" height="24"
          offsetXY="0 %d"
          fontSize="13"
          fontStyle="Bold"
          color="#BFD0C3"
          alignment="MiddleLeft"/>

      <Panel rectAlignment="UpperLeft"
          width="300" height="22"
          offsetXY="82 %d"
          color="#172019">

        <Panel rectAlignment="UpperLeft"
            width="%d" height="22"
            offsetXY="0 0"
            color="#456A53"/>
      </Panel>

      <Text text="%d / %d"
          rectAlignment="UpperLeft"
          width="95" height="24"
          offsetXY="390 %d"
          fontSize="13"
          color="#EDF3EE"
          alignment="MiddleLeft"/>]],
        esc(label), y,
        y,
        fillWidth,
        tonumber(cur) or 0,
        tonumber(maxv) or 0,
        y
    )
end

local function agentOverviewCard(colorName, agent, x, y)
    if not agent then
        return string.format([[
          <Panel rectAlignment="UpperLeft"
              width="530" height="190"
              offsetXY="%d %d"
              color="#101713CC">

            <Text text="%s — NO SHEET DATA"
                rectAlignment="UpperLeft"
                width="490" height="36"
                offsetXY="18 -16"
                fontSize="18"
                fontStyle="Bold"
                color="#75837A"
                alignment="MiddleLeft"/>
          </Panel>]],
            x, y, esc(colorName)
        )
    end

    local markedCount = tonumber(agent.markedCount) or 0
    local markedText = markedCount == 1 and "1 skill marked" or (markedCount .. " skills marked")

    return string.format([[
      <Panel rectAlignment="UpperLeft"
          width="530" height="190"
          offsetXY="%d %d"
          color="#101713E8">

        <Panel rectAlignment="UpperLeft"
            width="10" height="190"
            offsetXY="0 0"
            color="%s"/>

        <Text text="%s"
            rectAlignment="UpperLeft"
            width="330" height="34"
            offsetXY="24 -12"
            fontSize="19"
            fontStyle="Bold"
            color="#E5EEE7"
            alignment="MiddleLeft"/>

        <Text text="%s"
            rectAlignment="UpperRight"
            width="135" height="28"
            offsetXY="-18 -15"
            fontSize="14"
            fontStyle="Bold"
            color="%s"
            alignment="MiddleRight"/>

        %s
        %s
        %s

        <Text text="BP %d   |   %s"
            rectAlignment="LowerLeft"
            width="470" height="26"
            offsetXY="24 12"
            fontSize="13"
            color="#9AA9A0"
            alignment="MiddleLeft"/>

      </Panel>]],
        x, y,
        colorHex(colorName),
        esc(agent.name or "Agent"),
        esc(colorName),
        colorHex(colorName),
        bar("HP", agent.hp, agent.hpMax, -58),
        bar("WP", agent.wp, agent.wpMax, -91),
        bar("SAN", agent.san, agent.sanMax, -124),
        tonumber(agent.breakingPoint) or 0,
        esc(markedText)
    )
end

local function buildOverview()
    local xml = ""
    local positions = {
        {40, -90},
        {600, -90},
        {40, -300},
        {600, -300},
        {40, -510},
        {600, -510}
    }

    for i, colorName in ipairs(PLAYER_ORDER) do
        local p = positions[i]
        xml = xml .. agentOverviewCard(
            colorName,
            state.agents[colorName],
            p[1],
            p[2]
        )
    end

    return xml
end

local function buildHistoryRows(history, emptyText)
    if #history == 0 then
        return string.format([[
          <Text text="%s"
              rectAlignment="UpperLeft"
              width="1080" height="44"
              offsetXY="22 -28"
              fontSize="17"
              color="#718078"
              alignment="MiddleLeft"/>]],
            esc(emptyText)
        )
    end

    local xml = [[
      <Text text="RECENT ROLLS"
          rectAlignment="UpperLeft"
          width="300" height="34"
          offsetXY="42 -24"
          fontSize="18"
          fontStyle="Bold"
          color="#C8D8CC"
          alignment="MiddleLeft"/>

      <Button id="clear_all_roll_history"
          onClick="clearAllRollHistory"
          text="CLEAR ALL"
          rectAlignment="UpperRight"
          width="145" height="30"
          offsetXY="-45 -26"
          fontSize="11"
          fontStyle="Bold"
          color="#5B3030"
          textColor="#FFFFFF"/>
    ]]

    local y = -68

    for rollIndex, item in ipairs(history) do
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1080" height="54"
              offsetXY="42 %d"
              color="#111A15CC">

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="95" height="30"
                offsetXY="14 -12"
                fontSize="14"
                fontStyle="Bold"
                color="%s"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="875" height="40"
                offsetXY="110 -7"
                fontSize="14"
                color="#D9E3DC"
                alignment="MiddleLeft"
                horizontalOverflow="Wrap"/>

            <Button id="clear_roll_%d"
                onClick="clearRollHistoryEntry"
                text="X"
                rectAlignment="UpperRight"
                width="38" height="34"
                offsetXY="-12 -10"
                fontSize="15"
                fontStyle="Bold"
                color="#563434"
                textColor="#FFFFFF"/>
          </Panel>]],
            y,
            esc(item.color or ""),
            colorHex(item.color or ""),
            esc(item.text or ""),
            rollIndex
        )

        y = y - 62
    end

    return xml
end

local function markedSkillsText(agent)
    if not agent or type(agent.markedSkills) ~= "table" or #agent.markedSkills == 0 then
        return "No skills marked."
    end

    return table.concat(agent.markedSkills, ", ")
end


local function buildRoll()
    local poolChoices = handlerPoolDiceChoices()

    local qtyStyle = [[
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="280" itemHeight="32"]]

    local dieStyle = [[
            textColor="#F1F7F2"
            itemTextColor="#F1F7F2"
            itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
            dropdownBackgroundColor="#0F1210"
            checkColor="#9BC3A4"
            arrowColor="#FFFFFF"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A"
            dropdownHeight="360" itemHeight="34"]]

    return string.format([[
      <Panel rectAlignment="UpperLeft"
          width="1080" height="650"
          offsetXY="22 -28"
          color="#111A15CC">

        <Text text="HANDLER PHYSICAL DICE"
            rectAlignment="UpperLeft" width="500" height="42"
            offsetXY="28 -18" fontSize="24" fontStyle="Bold"
            color="#DDE9E0" alignment="MiddleLeft"/>

        <Button id="handler_check_dice"
            onClick="handlerCheckForNewDice"
            text="CHECK FOR NEW DICE"
            rectAlignment="UpperRight" width="220" height="34"
            offsetXY="-28 -22" fontSize="11" fontStyle="Bold"
            color="#355845" textColor="#FFFFFF"/>

        <Text text="The checked dice list stays fixed until you press CHECK FOR NEW DICE again."
            rectAlignment="UpperLeft" width="720" height="30"
            offsetXY="28 -60" fontSize="12" color="#91A397"/>

        <Dropdown id="handler_roll_dropdown"
            onValueChanged="selectHandlerRoll"
            rectAlignment="UpperLeft" width="330" height="44"
            offsetXY="28 -98" fontSize="17" color="#1B2921"
            %s>%s</Dropdown>

        <Button id="handler_roll_button"
            onClick="rollHandlerSelected"
            text="ROLL"
            rectAlignment="UpperLeft" width="180" height="44"
            offsetXY="374 -98" fontSize="17" fontStyle="Bold"
            color="#456A53" textColor="#FFFFFF"/>

        <Text text="MULTI-DIE ROLLER"
            rectAlignment="UpperLeft" width="360" height="34"
            offsetXY="28 -174" fontSize="19" fontStyle="Bold"
            color="#D2E5D6"/>

        <Text text="QTY" rectAlignment="UpperLeft" width="72" height="24"
            offsetXY="35 -210" fontSize="11" fontStyle="Bold" color="#A7C8B0"/>
        <Text text="DIE" rectAlignment="UpperLeft" width="200" height="24"
            offsetXY="120 -210" fontSize="11" fontStyle="Bold" color="#A7C8B0"/>

        <Dropdown id="handler_multi_qty_1" onValueChanged="handlerSelectMultiQty"
            rectAlignment="UpperLeft" width="72" height="38" offsetXY="35 -238"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>
        <Dropdown id="handler_multi_die_1" onValueChanged="handlerSelectMultiDie"
            rectAlignment="UpperLeft" width="205" height="38" offsetXY="120 -238"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>

        <Dropdown id="handler_multi_qty_2" onValueChanged="handlerSelectMultiQty"
            rectAlignment="UpperLeft" width="72" height="38" offsetXY="35 -288"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>
        <Dropdown id="handler_multi_die_2" onValueChanged="handlerSelectMultiDie"
            rectAlignment="UpperLeft" width="205" height="38" offsetXY="120 -288"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>

        <Dropdown id="handler_multi_qty_3" onValueChanged="handlerSelectMultiQty"
            rectAlignment="UpperLeft" width="72" height="38" offsetXY="35 -338"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>
        <Dropdown id="handler_multi_die_3" onValueChanged="handlerSelectMultiDie"
            rectAlignment="UpperLeft" width="205" height="38" offsetXY="120 -338"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>

        <Dropdown id="handler_multi_qty_4" onValueChanged="handlerSelectMultiQty"
            rectAlignment="UpperLeft" width="72" height="38" offsetXY="35 -388"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>
        <Dropdown id="handler_multi_die_4" onValueChanged="handlerSelectMultiDie"
            rectAlignment="UpperLeft" width="205" height="38" offsetXY="120 -388"
            fontSize="13" color="#1D2B24" %s>%s</Dropdown>

        <Text text="MODIFIER"
            rectAlignment="UpperLeft" width="140" height="24"
            offsetXY="380 -210" fontSize="11" fontStyle="Bold" color="#A7C8B0"/>

        <InputField id="handlerMultiModifier" text="%s"
            onEndEdit="handlerCaptureMultiModifier"
            rectAlignment="UpperLeft" width="150" height="40"
            offsetXY="380 -238" fontSize="15"
            color="#17201B" textColor="#FFFFFF"/>

        <Button id="handler_multi_roll" onClick="handlerRollMultiDice"
            text="ROLL DICE POOL"
            rectAlignment="UpperLeft" width="250" height="48"
            offsetXY="380 -302" fontSize="15" fontStyle="Bold"
            color="#355943" textColor="#FFFFFF"/>

        <Text text="Hit Location reports the body part separately and does not add its face number to the total."
            rectAlignment="UpperLeft" width="620" height="48"
            offsetXY="380 -370" fontSize="12" color="#BBC8BE"
            horizontalOverflow="Wrap"/>
      </Panel>]],
        dieStyle, handlerDiceOptionsXml(),

        qtyStyle,
        handlerSimpleOptionList({"0","1","2","3","4","5","6"},state.handlerMultiQty1 or 1),
        dieStyle, handlerSimpleOptionList(poolChoices,state.handlerMultiDie1 or "d6"),

        qtyStyle,
        handlerSimpleOptionList({"0","1","2","3","4","5","6"},state.handlerMultiQty2 or 0),
        dieStyle, handlerSimpleOptionList(poolChoices,state.handlerMultiDie2 or "d4"),

        qtyStyle,
        handlerSimpleOptionList({"0","1","2","3","4","5","6"},state.handlerMultiQty3 or 0),
        dieStyle, handlerSimpleOptionList(poolChoices,state.handlerMultiDie3 or "d8"),

        qtyStyle,
        handlerSimpleOptionList({"0","1","2","3","4","5","6"},state.handlerMultiQty4 or 0),
        dieStyle, handlerSimpleOptionList(poolChoices,state.handlerMultiDie4 or "Hit Location"),

        tostring(state.handlerMultiModifier or "0")
    )
end


local function buildHomeTime()
    local xml = ""
    local y = -90

    for _, colorName in ipairs(PLAYER_ORDER) do
        local agent = state.agents[colorName]

        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1080" height="82"
              offsetXY="42 %d"
              color="#111A15CC">

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="120" height="34"
                offsetXY="16 -12"
                fontSize="16"
                fontStyle="Bold"
                color="%s"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="250" height="34"
                offsetXY="145 -12"
                fontSize="17"
                fontStyle="Bold"
                color="#E3EEE6"
                alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft"
                width="650" height="52"
                offsetXY="410 -10"
                fontSize="14"
                color="#B7C5BB"
                alignment="UpperLeft"
                horizontalOverflow="Wrap"/>
          </Panel>]],
            y,
            esc(colorName),
            colorHex(colorName),
            esc(agent and agent.name or "No sheet data"),
            esc(markedSkillsText(agent))
        )

        y = y - 92
    end

    if #state.homeHistory > 0 then
        y = y - 8

        xml = xml .. string.format([[
          <Text text="RECENT HOME TIME"
              rectAlignment="UpperLeft"
              width="300" height="34"
              offsetXY="42 %d"
              fontSize="18"
              fontStyle="Bold"
              color="#C8D8CC"
              alignment="MiddleLeft"/>

          <Button id="clear_all_home_history"
              onClick="clearAllHomeHistory"
              text="CLEAR RECENT"
              rectAlignment="UpperRight"
              width="145" height="30"
              offsetXY="-45 %d"
              fontSize="11"
              fontStyle="Bold"
              color="#5B3030"
              textColor="#FFFFFF"/>]],
            y, y
        )

        y = y - 42

        for i = 1, math.min(#state.homeHistory, 12) do
            local item = state.homeHistory[i]

            xml = xml .. string.format([[
              <Panel rectAlignment="UpperLeft"
                  width="1040" height="34"
                  offsetXY="58 %d"
                  color="#111A15AA">

                <Text text="%s — %s"
                    rectAlignment="UpperLeft"
                    width="960" height="30"
                    offsetXY="8 -2"
                    fontSize="13"
                    color="#9EB0A4"
                    alignment="MiddleLeft"/>

                <Button id="clear_home_%d"
                    onClick="clearHomeHistoryEntry"
                    text="X"
                    rectAlignment="UpperRight"
                    width="42" height="26"
                    offsetXY="-6 -4"
                    fontSize="11"
                    color="#4A2D2D"
                    textColor="#FFFFFF"/>
              </Panel>]],
                y,
                esc(item.color or ""),
                esc(item.text or ""),
                i
            )

            y = y - 38
        end
    end

    return xml
end



local function handlerInventoryButton(colorName, action, indexOrKey, label, x, y, width)
    width = width or 112
    local safe = tostring(indexOrKey or ""):gsub("[^%w]","_")

    return string.format([[
      <Button id="handler_inventory_%s_%s_%s"
          onClick="handlerAdjustExistingInventory"
          text="%s"
          rectAlignment="UpperLeft"
          width="%d" height="30"
          offsetXY="%d %d"
          fontSize="10"
          fontStyle="Bold"
          color="#355845"
          textColor="#FFFFFF"/>]],
        esc(colorName), esc(action), esc(safe), esc(label),
        width, x, y
    )
end

local function buildHandlerInventoryWeaponRows(colorName, weapons)
    if #(weapons or {}) == 0 then
        return [[
          <Text text="No weapons."
              rectAlignment="UpperLeft" width="980" height="30"
              offsetXY="20 -4" fontSize="13" color="#748179"/>
        ]], 36
    end

    local xml = ""
    local y = 0

    for _, w in ipairs(weapons or {}) do
        local i = tonumber(w.index) or 0
        local usesQty = w.usesQuantity == true
        local cap = tonumber(w.capacity)
        local current = tonumber(w.ammoCurrent)
        local reserve = math.max(0, math.floor(tonumber(w.reserve) or 0))
        local qty = math.max(0, math.floor(tonumber(w.quantity) or 0))

        if current == nil and cap then current = cap end

        if usesQty and not cap then
            xml = xml .. string.format([[
              <Panel rectAlignment="UpperLeft"
                  width="1000" height="54"
                  offsetXY="10 %d"
                  color="#111A15CC">

                <Text text="%s"
                    rectAlignment="UpperLeft" width="430" height="30"
                    offsetXY="12 -11" fontSize="14" fontStyle="Bold"
                    color="#E3EEE6" alignment="MiddleLeft"/>

                <Text id="handler_inv_qty_%s_%d" text="QUANTITY: %d"
                    rectAlignment="UpperLeft" width="190" height="30"
                    offsetXY="455 -11" fontSize="13" fontStyle="Bold"
                    color="#D2E5D6" alignment="MiddleLeft"/>

                %s
                %s
              </Panel>]],
                -y,
                esc(tostring(w.name or "Item")),
                esc(colorName), i, qty,
                handlerInventoryButton(colorName, "qty1", i, "+1 QTY", 700, -10, 115),
                handlerInventoryButton(colorName, "qty5", i, "+5 QTY", 825, -10, 115)
            )
            y = y + 60

        elseif cap then
            local ammoLabel = tostring(w.ammoLabel or "")
            if ammoLabel == "" then ammoLabel = "rounds" end

            local status
            if current <= 0 then
                status = "EMPTY"
            elseif current >= cap then
                status = "FULL"
            else
                status = "PARTIAL"
            end

            xml = xml .. string.format([[
              <Panel rectAlignment="UpperLeft"
                  width="1000" height="92"
                  offsetXY="10 %d"
                  color="#111A15CC">

                <Text text="%s"
                    rectAlignment="UpperLeft" width="400" height="30"
                    offsetXY="12 -8" fontSize="14" fontStyle="Bold"
                    color="#E3EEE6" alignment="MiddleLeft"/>

                <Text text="MAGAZINE"
                    rectAlignment="UpperLeft" width="115" height="22"
                    offsetXY="420 -8" fontSize="10" fontStyle="Bold"
                    color="#84968B" alignment="MiddleLeft"/>

                <Text id="handler_inv_mag_%s_%d" text="%d / %d LOADED  [%s]"
                    rectAlignment="UpperLeft" width="250" height="30"
                    offsetXY="420 -29" fontSize="13" fontStyle="Bold"
                    color="#D2E5D6" alignment="MiddleLeft"/>

                <Text text="RESERVE POOL"
                    rectAlignment="UpperLeft" width="125" height="22"
                    offsetXY="680 -8" fontSize="10" fontStyle="Bold"
                    color="#84968B" alignment="MiddleLeft"/>

                <Text id="handler_inv_reserve_%s_%d" text="%d %s"
                    rectAlignment="UpperLeft" width="275" height="30"
                    offsetXY="680 -29" fontSize="13" fontStyle="Bold"
                    color="#D6BC7A" alignment="MiddleLeft"/>

                %s
                %s
                %s
                %s
              </Panel>]],
                -y,
                esc(tostring(w.name or "Weapon")),
                esc(colorName), i, current, cap, esc(status),
                esc(colorName), i, reserve, esc(ammoLabel),
                handlerInventoryButton(colorName, "loaded1", i, "+1 LOADED", 420, -58, 120),
                handlerInventoryButton(colorName, "fill", i, "RELOAD / FILL", 550, -58, 130),
                handlerInventoryButton(colorName, "reserve10", i, "+10 RESERVE", 690, -58, 125),
                handlerInventoryButton(colorName, "mag1", i, "+1 SPARE MAG", 825, -58, 135)
            )
            y = y + 100

        else
            xml = xml .. string.format([[
              <Panel rectAlignment="UpperLeft"
                  width="1000" height="48"
                  offsetXY="10 %d"
                  color="#111A15CC">

                <Text text="%s"
                    rectAlignment="UpperLeft" width="900" height="30"
                    offsetXY="12 -9" fontSize="14" fontStyle="Bold"
                    color="#E3EEE6" alignment="MiddleLeft"/>
              </Panel>]],
                -y, esc(tostring(w.name or "Weapon"))
            )
            y = y + 54
        end
    end

    return xml, y
end

local function buildHandlerInventoryGearRows(colorName, gear)
    if #(gear or {}) == 0 then
        return [[
          <Text text="No gear."
              rectAlignment="UpperLeft" width="980" height="30"
              offsetXY="20 -4" fontSize="13" color="#748179"/>
        ]], 36
    end

    local xml = ""
    local y = 0

    for _, g in ipairs(gear or {}) do
        local qty = tonumber(g.quantity)
        local qtyText = qty and ("QTY: " .. math.max(0, math.floor(qty))) or ""
        local controls = ""

        if qty ~= nil then
            local key = tostring(g.key or g.name or "")
            controls =
                handlerInventoryButton(colorName, "gear1", key, "+1 QTY", 790, -5, 100) ..
                handlerInventoryButton(colorName, "gear5", key, "+5 QTY", 900, -5, 100)
        end

        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1000" height="40"
              offsetXY="10 %d"
              color="#111A15AA">

            <Text text="%s"
                rectAlignment="UpperLeft" width="620" height="28"
                offsetXY="12 -6" fontSize="13"
                color="#E3EEE6" alignment="MiddleLeft"/>

            <Text text="%s"
                rectAlignment="UpperLeft" width="140" height="28"
                offsetXY="635 -6" fontSize="12"
                color="#B7C5BB" alignment="MiddleLeft"/>

            %s
          </Panel>]],
            -y, esc(tostring(g.name or "Gear")), esc(qtyText), controls
        )

        y = y + 46
    end

    return xml, y
end

local function buildHandlerInventoryArmorRows(armor)
    if #(armor or {}) == 0 then
        return [[
          <Text text="No armor."
              rectAlignment="UpperLeft" width="980" height="30"
              offsetXY="20 -4" fontSize="13" color="#748179"/>
        ]], 36
    end

    local xml = ""
    local y = 0

    for _, a in ipairs(armor or {}) do
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1000" height="40"
              offsetXY="10 %d"
              color="#111A15AA">

            <Text text="%s"
                rectAlignment="UpperLeft" width="650" height="28"
                offsetXY="12 -6" fontSize="13"
                color="#E3EEE6" alignment="MiddleLeft"/>

            <Text text="ARMOR: %s"
                rectAlignment="UpperRight" width="250" height="28"
                offsetXY="-12 -6" fontSize="12"
                color="#D6BC7A" alignment="MiddleRight"/>
          </Panel>]],
            -y, esc(tostring(a.name or "Armor")), esc(tostring(a.armor or ""))
        )

        y = y + 46
    end

    return xml, y
end


local HANDLER_CURRENCY_ORDER = {
    "USD","EUR","GBP","JPY","CNY","CAD","AUD","CHF","HKD","SGD",
    "NZD","SEK","NOK","DKK","MXN","BRL","INR","KRW","ZAR","AED",
    "GOLD","SILVER","COPPER"
}

local function handlerCurrencyBalancesText(inv)
    local balances = inv and inv.currencyBalances or {}
    local parts = {}

    for _, code in ipairs(HANDLER_CURRENCY_ORDER) do
        local amount = tonumber(balances[code]) or 0
        if amount ~= 0 then
            local shown
            if math.abs(amount - math.floor(amount)) < 0.000001 then
                shown = tostring(math.floor(amount))
            else
                shown = string.format("%.2f", amount):gsub("0+$",""):gsub("%.$","")
            end
            table.insert(parts, code .. " " .. shown)
        end
    end

    if #parts == 0 then
        return "CURRENCIES: —"
    end

    return "CURRENCIES: " .. table.concat(parts, "   |   ")
end

local HANDLER_INVENTORY_TABS = {
    {id="all", label="ALL"},
    {id="firearms", label="FIREARMS"},
    {id="melee", label="MELEE"},
    {id="heavy", label="HEAVY"},
    {id="lesslethal", label="LESS-LETHAL"},
    {id="armor", label="ARMOR"},
    {id="gear", label="GEAR"},
    {id="funds", label="FUNDS"}
}

local function handlerInventoryAgentButton(colorName, x, y)
    local selected = tostring(state.inventoryColor or "Red") == colorName

    return string.format([[
      <Button id="handler_inventory_agent_%s"
          onClick="handlerSelectInventoryAgent"
          text="%s"
          rectAlignment="UpperLeft"
          width="158" height="46"
          offsetXY="%d %d"
          fontSize="12" fontStyle="Bold"
          color="%s"
          textColor="#FFFFFF"/>]],
        esc(colorName),
        esc(string.upper(colorName)),
        x, y,
        selected and colorHex(colorName) or "#223229"
    )
end

local function handlerInventoryTabButton(id, label, active, x, width)
    return string.format([[
      <Button id="handler_inventory_tab_%s"
          onClick="handlerSelectInventorySubtab"
          text="%s"
          rectAlignment="UpperLeft"
          width="%d" height="36"
          offsetXY="%d -130"
          fontSize="11" fontStyle="Bold"
          color="%s"
          textColor="#FFFFFF"/>]],
        esc(id), esc(label), width, x,
        active and "#456A53" or "#223229"
    )
end

local function filterHandlerWeapons(weapons, category)
    if category == "all" then
        return weapons or {}
    end

    local result = {}
    for _, w in ipairs(weapons or {}) do
        if tostring(w.category or "gear") == category then
            table.insert(result, w)
        end
    end
    return result
end

local HANDLER_CURRENCIES = {
    {code="USD", label="US DOLLARS"},
    {code="EUR", label="EUROS"},
    {code="GBP", label="BRITISH POUNDS"},
    {code="JPY", label="JAPANESE YEN"},
    {code="CNY", label="CHINESE YUAN"},
    {code="CAD", label="CANADIAN DOLLARS"},
    {code="AUD", label="AUSTRALIAN DOLLARS"},
    {code="CHF", label="SWISS FRANCS"},
    {code="HKD", label="HONG KONG DOLLARS"},
    {code="SGD", label="SINGAPORE DOLLARS"},
    {code="NZD", label="NEW ZEALAND DOLLARS"},
    {code="SEK", label="SWEDISH KRONA"},
    {code="NOK", label="NORWEGIAN KRONE"},
    {code="DKK", label="DANISH KRONE"},
    {code="MXN", label="MEXICAN PESOS"},
    {code="BRL", label="BRAZILIAN REAL"},
    {code="INR", label="INDIAN RUPEES"},
    {code="KRW", label="SOUTH KOREAN WON"},
    {code="ZAR", label="SOUTH AFRICAN RAND"},
    {code="AED", label="UAE DIRHAMS"},
    {code="GOLD", label="GOLD"},
    {code="SILVER", label="SILVER"},
    {code="COPPER", label="COPPER"}
}

local function handlerCurrencyDef(code)
    for _, entry in ipairs(HANDLER_CURRENCIES) do
        if entry.code == tostring(code or "") then return entry end
    end
    return nil
end

local function handlerCurrencyAmount(value)
    local n = tonumber(value) or 0
    if math.abs(n - math.floor(n)) < 0.000001 then
        return tostring(math.floor(n))
    end
    return string.format("%.2f", n):gsub("0+$",""):gsub("%.$","")
end


local HANDLER_CURRENCY_SYMBOLS = {
    USD="$",
    EUR="€",
    GBP="£",
    JPY="¥",
    CNY="¥",
    CAD="C$",
    AUD="A$",
    CHF="CHF ",
    HKD="HK$",
    SGD="S$",
    NZD="NZ$",
    SEK="kr ",
    NOK="kr ",
    DKK="kr ",
    MXN="MX$",
    BRL="R$",
    INR="₹",
    KRW="₩",
    ZAR="R",
    AED="AED ",
    GOLD="Au ",
    SILVER="Ag ",
    COPPER="Cu "
}

local function handlerCurrencySymbol(code)
    return HANDLER_CURRENCY_SYMBOLS[tostring(code or "")] or
        (tostring(code or "") .. " ")
end

local function handlerCurrencyAmountWithSymbol(code, value)
    return handlerCurrencySymbol(code) .. handlerCurrencyAmount(value)
end

local function buildHandlerCurrencyRows(colorName, inv)
    local balances = inv.currencyBalances or {}
    local xml = ""
    local y = 0
    local shown = 0

    for _, entry in ipairs(HANDLER_CURRENCIES) do
        if balances[entry.code] ~= nil then
            local amount = tonumber(balances[entry.code]) or 0
            local code = entry.code

            xml = xml .. string.format([[
              <Panel rectAlignment="UpperLeft" width="990" height="46"
                  offsetXY="0 %d" color="#17201BCC">

                <Text text="%s / %s"
                    rectAlignment="UpperLeft" width="285" height="34"
                    offsetXY="10 -6" fontSize="12" fontStyle="Bold"
                    color="#C8D8CC" alignment="MiddleLeft"/>

                <Text id="handler_currency_balance_%s_%s" text="%s"
                    rectAlignment="UpperLeft" width="110" height="34"
                    offsetXY="298 -6" fontSize="14" fontStyle="Bold"
                    color="#FFFFFF" alignment="MiddleCenter"/>

                <Button id="handler_currency_%s_%s_minus100" onClick="handlerAdjustCurrency"
                    text="-100" rectAlignment="UpperLeft" width="70" height="30"
                    offsetXY="414 -8" fontSize="10" color="#5B3030" textColor="#FFFFFF"/>
                <Button id="handler_currency_%s_%s_minus10" onClick="handlerAdjustCurrency"
                    text="-10" rectAlignment="UpperLeft" width="64" height="30"
                    offsetXY="490 -8" fontSize="10" color="#5B3030" textColor="#FFFFFF"/>
                <Button id="handler_currency_%s_%s_minus1" onClick="handlerAdjustCurrency"
                    text="-1" rectAlignment="UpperLeft" width="58" height="30"
                    offsetXY="560 -8" fontSize="10" color="#5B3030" textColor="#FFFFFF"/>

                <Button id="handler_currency_%s_%s_plus1" onClick="handlerAdjustCurrency"
                    text="+1" rectAlignment="UpperLeft" width="58" height="30"
                    offsetXY="632 -8" fontSize="10" color="#355845" textColor="#FFFFFF"/>
                <Button id="handler_currency_%s_%s_plus10" onClick="handlerAdjustCurrency"
                    text="+10" rectAlignment="UpperLeft" width="64" height="30"
                    offsetXY="696 -8" fontSize="10" color="#355845" textColor="#FFFFFF"/>
                <Button id="handler_currency_%s_%s_plus100" onClick="handlerAdjustCurrency"
                    text="+100" rectAlignment="UpperLeft" width="70" height="30"
                    offsetXY="766 -8" fontSize="10" color="#355845" textColor="#FFFFFF"/>
              </Panel>]],
                -y,
                esc(code), esc(entry.label),
                esc(colorName), esc(code), esc(handlerCurrencyAmountWithSymbol(code, amount)),
                esc(colorName), esc(code),
                esc(colorName), esc(code),
                esc(colorName), esc(code),
                esc(colorName), esc(code),
                esc(colorName), esc(code),
                esc(colorName), esc(code)
            )

            y = y + 52
            shown = shown + 1
        end
    end

    if shown == 0 then
        return [[
          <Text text="No currency balances yet."
              rectAlignment="UpperLeft" width="960" height="34"
              offsetXY="10 0" fontSize="13" color="#748179"/>
        ]], 38
    end

    return xml, y
end

local function buildHandlerCurrencyChoiceButtons()
    local xml = ""
    local buttonW = 300
    local buttonH = 40
    local cols = 3

    for i, entry in ipairs(HANDLER_CURRENCIES) do
        local n = i - 1
        local col = n % cols
        local row = math.floor(n / cols)
        local x = 18 + col * 316
        local y = -86 - row * 48

        xml = xml .. string.format([[
          <Button id="handler_currency_pick_%s"
              onClick="handlerChooseCurrency"
              text="%s / %s"
              rectAlignment="UpperLeft"
              width="%d" height="%d"
              offsetXY="%d %d"
              fontSize="10" fontStyle="Bold"
              color="#2B4033" textColor="#FFFFFF"/>]],
            esc(entry.code), esc(entry.code), esc(entry.label),
            buttonW, buttonH, x, y
        )
    end

    return xml
end

local function buildHandlerFundsOnly(colorName, inv)
    local valuables = tostring(inv.valuables or "")
    if valuables == "" then valuables = "—" end

    if state.inventoryCurrencyPickPending == true then
        return string.format([[
          <Panel rectAlignment="UpperLeft" width="1010" height="520"
              offsetXY="10 0" color="#101713DD">

            <Text text="CHOOSE CURRENCY / METAL"
                rectAlignment="UpperLeft" width="500" height="34"
                offsetXY="18 -16" fontSize="18" fontStyle="Bold"
                color="#D2E5D6"/>

            <Text text="ADD AMOUNT: %s"
                rectAlignment="UpperLeft" width="320" height="30"
                offsetXY="18 -52" fontSize="13" fontStyle="Bold"
                color="#FFFFFF"/>

            <Button id="handler_currency_cancel"
                onClick="handlerCancelCurrencyPick"
                text="‹ BACK"
                rectAlignment="UpperRight" width="120" height="32"
                offsetXY="-18 -18" fontSize="11" fontStyle="Bold"
                color="#4A3030" textColor="#FFFFFF"/>

            %s
          </Panel>]],
            esc(tostring(state.inventoryCurrencyDraft or "")),
            buildHandlerCurrencyChoiceButtons()
        ), 540
    end

    local rows, rowsHeight = buildHandlerCurrencyRows(colorName, inv)

    return string.format([[
      <Panel rectAlignment="UpperLeft"
          width="1010" height="%d"
          offsetXY="10 0"
          color="#101713DD">

        <Text text="ADD AMOUNT"
            rectAlignment="UpperLeft" width="180" height="26"
            offsetXY="18 -16" fontSize="12" fontStyle="Bold"
            color="#A9B8AD"/>

        <InputField id="handlerCurrencyAmountInput"
            text="%s"
            onEndEdit="handlerCaptureCurrencyAmount"
            lineType="SingleLine"
            contentType="DecimalNumber"
            rectAlignment="UpperLeft" width="280" height="38"
            offsetXY="18 -44" fontSize="15"
            color="#17201B" textColor="#FFFFFF"/>

        <Button id="handler_currency_add"
            onClick="handlerBeginCurrencyPick"
            text="ADD CURRENCY"
            rectAlignment="UpperLeft" width="160" height="38"
            offsetXY="310 -44" fontSize="12" fontStyle="Bold"
            color="#355845" textColor="#FFFFFF"/>

        <Text text="VALUABLES / ASSETS: %s"
            rectAlignment="UpperLeft" width="490" height="50"
            offsetXY="495 -34" fontSize="11"
            color="#B7C5BB" horizontalOverflow="Wrap"/>

        <Text text="CURRENCY BALANCES"
            rectAlignment="UpperLeft" width="260" height="26"
            offsetXY="18 -98" fontSize="13" fontStyle="Bold"
            color="#A9B8AD"/>

        <Panel rectAlignment="UpperLeft" width="990" height="%d"
            offsetXY="10 -130">%s</Panel>
      </Panel>]],
        math.max(260, 160 + rowsHeight),
        esc(tostring(state.inventoryCurrencyDraft or "")),
        esc(valuables),
        math.max(80, rowsHeight),
        rows
    ), math.max(280, 180 + rowsHeight)
end


local function buildInventory()
    local xml = ""

    xml = xml .. string.format([[
      <Text text="AGENT FUNDS &amp; INVENTORY"
          rectAlignment="UpperLeft" width="560" height="40"
          offsetXY="30 -18" fontSize="22" fontStyle="Bold"
          color="#D2E5D6"/>

      <Text text="Select an Agent, then choose an inventory category."
          rectAlignment="UpperLeft" width="700" height="30"
          offsetXY="30 -54" fontSize="12"
          color="#9EB0A4"/>

      %s %s %s %s %s %s
    ]],
        handlerInventoryAgentButton("Red",30,-82),
        handlerInventoryAgentButton("Blue",196,-82),
        handlerInventoryAgentButton("Green",362,-82),
        handlerInventoryAgentButton("Purple",528,-82),
        handlerInventoryAgentButton("Pink",694,-82),
        handlerInventoryAgentButton("Orange",860,-82)
    )

    local activeTab = tostring(state.inventorySubtab or "all")
    local x = 30
    local widths = {
        all=88, firearms=130, melee=105, heavy=105,
        lesslethal=140, armor=100, gear=95, funds=100
    }

    for _, tab in ipairs(HANDLER_INVENTORY_TABS) do
        local w = widths[tab.id] or 100
        xml = xml .. handlerInventoryTabButton(
            tab.id, tab.label, activeTab == tab.id, x, w
        )
        x = x + w + 8
    end

    local colorName = tostring(state.inventoryColor or "Red")
    local agent = state.agents[colorName]

    if not agent then
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1010" height="100"
              offsetXY="30 -186"
              color="#101713CC">
            <Text text="%s — NO SHEET DATA"
                rectAlignment="UpperLeft" width="950" height="38"
                offsetXY="20 -26" fontSize="18" fontStyle="Bold"
                color="#748179"/>
          </Panel>]],
            esc(colorName)
        )
        return xml, 900
    end

    local inv = agent.inventory
    if not inv then
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft"
              width="1010" height="110"
              offsetXY="30 -186"
              color="#101713CC">
            <Text text="%s — %s"
                rectAlignment="UpperLeft" width="950" height="32"
                offsetXY="20 -18" fontSize="17" fontStyle="Bold"
                color="%s"/>
            <Text text="Inventory data unavailable. Install the matching r54 Agent sheet, then press SYNC NOW."
                rectAlignment="UpperLeft" width="950" height="40"
                offsetXY="20 -56" fontSize="12" color="#B99A76"/>
          </Panel>]],
            esc(colorName),
            esc(tostring(agent.name or "Agent")),
            colorHex(colorName)
        )
        return xml, 900
    end

    xml = xml .. string.format([[
      <Text text="%s — %s"
          rectAlignment="UpperLeft" width="600" height="38"
          offsetXY="30 -178" fontSize="19" fontStyle="Bold"
          color="%s"/>

      <Text text="%s"
          rectAlignment="UpperRight" width="390" height="32"
          offsetXY="-35 -180" fontSize="11"
          color="#C8D8CC" alignment="MiddleRight"/>

      <Panel rectAlignment="UpperLeft"
          width="1025" height="%d"
          offsetXY="25 -224">%s</Panel>
    ]],
        esc(colorName),
        esc(tostring(agent.name or "Agent")),
        colorHex(colorName),
        esc(tostring(state.inventoryStatus or "")),
        1200,
        ""
    )

    local content = ""
    local contentHeight = 0

    if activeTab == "funds" then
        content, contentHeight = buildHandlerFundsOnly(colorName, inv)

    elseif activeTab == "armor" then
        content, contentHeight =
            buildHandlerInventoryArmorRows(inv.armor or {})

    elseif activeTab == "gear" then
        content, contentHeight =
            buildHandlerInventoryGearRows(colorName, inv.gear or {})

    else
        local weapons =
            filterHandlerWeapons(inv.weapons or {}, activeTab)

        content, contentHeight =
            buildHandlerInventoryWeaponRows(colorName, weapons)
    end

    -- Replace the intentionally-empty content panel once, keeping the outer
    -- layout clean and consistent across category changes.
    xml = xml:gsub(
        '<Panel rectAlignment="UpperLeft"%s+width="1025" height="1200"%s+offsetXY="25 %-224"></Panel>',
        string.format(
            '<Panel rectAlignment="UpperLeft" width="1025" height="%d" offsetXY="25 -224">%s</Panel>',
            math.max(300, contentHeight + 30),
            content
        ),
        1
    )

    return xml, math.max(900, 270 + contentHeight)
end


local function getAgentSheetForColor(colorName)
    local agent = state.agents[tostring(colorName or "")]
    if not agent then return nil, "No Agent sheet data for that color." end

    local guid = tostring(agent.sheetGuid or "")
    if guid == "" then return nil, "Agent sheet GUID is not available yet. Press SYNC NOW." end

    local obj = getObjectFromGUID(guid)
    if not obj then return nil, "Agent sheet object is not currently available." end

    return obj, nil
end

local function getHandlerCatalogSourceAgent()
    local preferred = tostring(state.addCatalogSourceColor or "")
    if preferred ~= "" then
        local obj = getAgentSheetForColor(preferred)
        if obj then return obj, preferred, nil end
    end

    for _, colorName in ipairs(PLAYER_ORDER) do
        local obj = getAgentSheetForColor(colorName)
        if obj then
            state.addCatalogSourceColor = colorName
            return obj, colorName, nil
        end
    end

    return nil, nil, "No updated Agent sheet is currently available. Press SYNC NOW."
end

local function getHandlerCatalogSnapshot(category)
    local obj, sourceColor, err = getHandlerCatalogSourceAgent()
    if not obj then
        return { category = tostring(category or state.addCategory or "Firearms"), categories = {}, subcategories = {}, items = {} }, err
    end

    local ok, result = pcall(function()
        return obj.call("handlerGetEquipmentCatalog", {
            category = tostring(category or state.addCategory or "Firearms")
        })
    end)

    if not ok or type(result) ~= "table" then
        return { category = tostring(category or state.addCategory or "Firearms"), categories = {}, subcategories = {}, items = {} },
            "Agent sheets need the updated r37+ script for the Handler item browser."
    end

    result.sourceColor = sourceColor
    return result, nil
end

local function dropdownOptions(values, selected, useKeys)
    local xml = ""
    selected = tostring(selected or "")

    for _, entry in ipairs(values or {}) do
        local value, label
        if type(entry) == "table" then
            value = tostring(entry.key or entry.value or entry.name or "")
            label = tostring(entry.name or entry.label or value)
        else
            value = tostring(entry)
            label = value
        end

        local selectedAttr = value == selected and ' selected="true"' or ""
        xml = xml .. string.format(
            '<Option value="%s"%s>%s</Option>',
            esc(value), selectedAttr, esc(label)
        )
    end

    return xml
end

local function handlerAssignmentButton(colorName, x, y)
    local agent = state.agents[colorName]
    local label = string.upper(colorName)
    if agent and agent.name and tostring(agent.name) ~= "" then
        label = label .. "\n" .. tostring(agent.name)
    else
        label = label .. "\n(no synced Agent)"
    end

    return string.format([[
      <Button id="handler_assign_%s"
          onClick="handlerAssignPreparedItem"
          text="%s"
          rectAlignment="UpperLeft"
          width="310" height="82"
          offsetXY="%d %d"
          fontSize="14"
          fontStyle="Bold"
          color="%s"
          textColor="#FFFFFF"/>]],
        esc(colorName), esc(label), x, y, colorHex(colorName)
    )
end

local function handlerCatalogItemByKey(snapshot, key)
    key = tostring(key or "")
    for _, item in ipairs(snapshot.items or {}) do
        if tostring(item.key or "") == key then return item end
    end
    return nil
end

local function handlerParseVariantSpec(item)
    local result = {}
    local spec = tostring(item and item.variantSpec or "")

    if spec ~= "" then
        for group in spec:gmatch("[^;]+") do
            local caliber, caps = group:match("^%s*(.-)%s*=%s*(.-)%s*$")
            if caliber and caliber ~= "" then
                local capacities = {}
                for cap in tostring(caps or ""):gmatch("[^/]+") do
                    local n = tonumber(tostring(cap):match("(%d+)"))
                    if n then table.insert(capacities, tostring(n)) end
                end
                table.insert(result, {caliber=caliber, capacities=capacities})
            end
        end
    end

    if #result == 0 and item then
        local caliber = tostring(item.caliber or "")
        local cap = tonumber(tostring(item.capacity or ""):match("(%d+)"))
        if caliber ~= "" and string.lower(caliber) ~= "various" then
            table.insert(result, {
                caliber = caliber,
                capacities = cap and {tostring(cap)} or {}
            })
        end
    end

    return result
end

local function handlerItemCaliberOptions(item)
    local result = {}
    for _, variant in ipairs(handlerParseVariantSpec(item)) do
        table.insert(result, tostring(variant.caliber or ""))
    end
    return result
end

local function handlerItemCapacityOptions(item, caliber)
    local wanted = tostring(caliber or "")
    for _, variant in ipairs(handlerParseVariantSpec(item)) do
        if wanted == "" or tostring(variant.caliber or "") == wanted then
            return variant.capacities or {}
        end
    end
    local cap = tonumber(tostring(item and item.capacity or ""):match("(%d+)"))
    return cap and {tostring(cap)} or {}
end

local function handlerItemMatchesCaliber(item, filter)
    filter = tostring(filter or "ALL")
    if filter == "" or filter == "ALL" then return true end
    for _, caliber in ipairs(handlerItemCaliberOptions(item)) do
        if caliber == filter then return true end
    end
    return tostring(item and item.caliber or "") == filter
end

local function handlerAvailableCalibers(snapshot)
    local found = {}
    for _, item in ipairs(snapshot.items or {}) do
        if tostring(state.addBrowseLevel or "") ~= "subcategory" or
           tostring(item.subcategory or "") == tostring(state.addSubcategory or "")
        then
            for _, caliber in ipairs(handlerItemCaliberOptions(item)) do
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

local function handlerItemMatchesArmorRating(item, filter)
    filter = tostring(filter or "ALL")
    if filter == "" or filter == "ALL" then return true end
    local rating = tonumber(tostring(item and item.armor or ""):match("(%d+)"))
    return rating ~= nil and tostring(rating) == filter
end

local function handlerAvailableArmorRatings(snapshot)
    local found = {}
    for _, item in ipairs(snapshot.items or {}) do
        local rating = tonumber(tostring(item.armor or ""):match("(%d+)"))
        if rating then found[rating] = true end
    end
    local values = {}
    for rating in pairs(found) do table.insert(values, rating) end
    table.sort(values)
    local result = {"ALL"}
    for _, rating in ipairs(values) do table.insert(result, tostring(rating)) end
    return result
end

local function handlerSelectedVariant(item)
    if not item then return "", nil end

    local calibers = handlerItemCaliberOptions(item)
    local caliber = tostring(state.addSelectedCaliber or "")
    local valid = false
    for _, value in ipairs(calibers) do
        if value == caliber then valid = true break end
    end
    if not valid then
        caliber = tostring(calibers[1] or item.caliber or "")
        state.addSelectedCaliber = caliber
    end

    local capacities = handlerItemCapacityOptions(item, caliber)
    local capText = tostring(state.addSelectedCapacity or "")
    valid = false
    for _, value in ipairs(capacities) do
        if tostring(value) == capText then valid = true break end
    end
    if not valid then
        capText = tostring(capacities[1] or tostring(item.capacity or ""):match("(%d+)") or "")
        state.addSelectedCapacity = capText
    end

    return caliber, tonumber(capText)
end

local function handlerVariantCapacityDropdownsXml(item, chosenCaliber, chosenCapacity)
    local variants = handlerParseVariantSpec(item)
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
            <Dropdown id="handler_variant_capacity_%d"
                active="%s"
                onValueChanged="handlerSelectVariantCapacity"
                rectAlignment="UpperLeft" width="105" height="32" offsetXY="132 -34"
                fontSize="11" color="#1D2B24" textColor="#F1F7F2"
                itemTextColor="#F1F7F2"
                itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
                dropdownBackgroundColor="#0F1210"
                checkColor="#9BC3A4" arrowColor="#FFFFFF"
                dropdownHeight="260" itemHeight="30">%s</Dropdown>
        ]],
            index,
            tostring(variant.caliber or "") == tostring(chosenCaliber or "") and
                "true" or "false",
            dropdownOptions(values, selected)
        )
    end

    return xml
end


local function handlerResetSelectedVariant(item)
    state.addSelectedCaliber = ""
    state.addSelectedCapacity = ""
    if item then handlerSelectedVariant(item) end
end

local function handlerItemsForSubcategory(snapshot, subcategory)
    local result = {}
    for _, item in ipairs(snapshot.items or {}) do
        if tostring(item.subcategory or "Other") == tostring(subcategory or "") then
            table.insert(result, item)
        end
    end
    return result
end

local function handlerSubcategoryHasFilteredItems(snapshot, subcategory)
    local filter = tostring(state.addCaliberFilter or "ALL")

    for _, item in ipairs(snapshot.items or {}) do
        if tostring(item.subcategory or "") == tostring(subcategory or "") and
           (tostring(state.addCategory or "") ~= "Firearms" or
            handlerItemMatchesCaliber(item, filter))
        then
            return true
        end
    end

    return false
end

local function handlerBrowseTitle()
    local level = tostring(state.addBrowseLevel or "root")
    if level == "root" then return "ALL EQUIPMENT" end
    if level == "category" then return tostring(state.addCategory or "CATEGORY") end
    if level == "subcategory" then return tostring(state.addSubcategory or "SUBCATEGORY") end
    return "ALL EQUIPMENT"
end

local function buildHandlerBreadcrumbXml()
    local level = tostring(state.addBrowseLevel or "root")
    local xml = ""
    local x = 20

    local function chip(id, label, active)
        local width = math.max(100, math.min(250, 32 + (#tostring(label) * 9)))
        local bg = active and "#426A52" or "#223229"
        xml = xml .. string.format([[
          <Panel rectAlignment="UpperLeft" width="%d" height="32" offsetXY="%d -84">
            <Panel rectAlignment="MiddleCenter" width="%d" height="32" color="%s"/>
            <Text text="%s" rectAlignment="MiddleCenter" width="%d" height="28"
                fontSize="12" fontStyle="Bold" color="#FFFFFF" alignment="MiddleCenter"/>
            <Button id="handler_crumb_%s" onClick="handlerEquipmentBreadcrumbClick"
                text="" rectAlignment="MiddleCenter" width="%d" height="32" color="#00000000"/>
          </Panel>]],
            width, x, width, bg, esc(label), width - 12, esc(id), width)
        x = x + width + 10
    end

    chip("root", "ALL EQUIPMENT", level == "root")
    if level == "category" or level == "subcategory" then
        chip("category", tostring(state.addCategory or "CATEGORY"), level == "category")
    end
    if level == "subcategory" then
        chip("subcategory", tostring(state.addSubcategory or "SUBCATEGORY"), true)
    end
    return xml
end

local function buildHandlerBrowseRows(snapshot)
    local level = tostring(state.addBrowseLevel or "root")
    local rows = ""
    local y = 0

    local function addRow(id, label, kind)
        local safe = tostring(id or ""):gsub("[^%w]", "_")
        rows = rows .. string.format([[
          <Panel rectAlignment="UpperLeft" width="690" height="40" offsetXY="0 %d">
            <Panel rectAlignment="MiddleCenter" width="690" height="40" color="#1B2821"/>
            <Text text="%s" rectAlignment="MiddleLeft" width="610" height="34"
                offsetXY="18 0" fontSize="14" fontStyle="Bold" color="#FFFFFF" alignment="MiddleLeft"/>
            <Text text="%s" rectAlignment="MiddleRight" width="50" height="34"
                offsetXY="-18 0" fontSize="18" color="#A9B8AD" alignment="MiddleCenter"/>
            <Button id="handler_browse_%s_%s" onClick="handlerEquipmentBrowseRowClick"
                text="" rectAlignment="MiddleCenter" width="690" height="40" color="#00000000"/>
          </Panel>]],
            -y, esc(label), kind == "item" and "" or "›", esc(kind), esc(safe))
        y = y + 46
    end

    if level == "root" then
        for _, cat in ipairs(snapshot.categories or {}) do addRow(cat, cat, "category") end
    elseif level == "category" then
        local subs = snapshot.subcategories or {}
        if #subs > 0 then
            for _, sub in ipairs(subs) do
                if handlerSubcategoryHasFilteredItems(snapshot, sub) then
                    addRow(sub, sub, "subcategory")
                end
            end

            for _, item in ipairs(snapshot.items or {}) do
                if tostring(item.subcategory or "") == "" and
                   (tostring(state.addCategory or "") ~= "Firearms" or
                    handlerItemMatchesCaliber(item, state.addCaliberFilter))
                then
                    addRow(item.key, item.name or item.key, "item")
                end
            end
        else
            for _, item in ipairs(snapshot.items or {}) do
                local visible = true
                if tostring(state.addCategory or "") == "Firearms" then
                    visible = handlerItemMatchesCaliber(item, state.addCaliberFilter)
                elseif tostring(state.addCategory or "") == "Body Armor" then
                    visible = handlerItemMatchesArmorRating(item, state.addArmorRatingFilter)
                end
                if visible then
                    addRow(item.key, item.name or item.key, "item")
                end
            end
        end
    elseif level == "subcategory" then
        for _, item in ipairs(handlerItemsForSubcategory(snapshot, state.addSubcategory)) do
            if tostring(state.addCategory or "") ~= "Firearms" or
               handlerItemMatchesCaliber(item, state.addCaliberFilter)
            then
                addRow(item.key, item.name or item.key, "item")
            end
        end
    end

    if rows == "" then
        if snapshot.loading == true then
            rows = [[<Text text="LOADING EQUIPMENT LIST..."
                rectAlignment="UpperLeft"
                width="650" height="40" offsetXY="10 0"
                fontSize="14" fontStyle="Bold" color="#BFD0C3"
                alignment="MiddleLeft"/>]]
        else
            rows = [[<Text text="No items found at this level."
                rectAlignment="UpperLeft"
                width="650" height="40" offsetXY="10 0"
                fontSize="14" color="#A9B8AD"
                alignment="MiddleLeft"/>]]
        end
        y = 46
    end
    return rows, math.max(380, y + 12)
end

local function buildHandlerAssignItemScreen(snapshot, selectedItem)
    local itemName = selectedItem and tostring(selectedItem.name or selectedItem.key or "Item") or "Item"
    local detail = selectedItem and tostring(selectedItem.details or "") or ""
    local status = tostring(state.addStatus or "")

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1050" height="720" offsetXY="0 0" color="#111A15CC">
        <Text text="ASSIGN ITEM TO AGENT" rectAlignment="UpperLeft" width="520" height="38"
            offsetXY="20 -16" fontSize="21" fontStyle="Bold" color="#D2E5D6" alignment="MiddleLeft"/>
        <Button id="handler_assign_back" onClick="handlerCancelAssignItem" text="‹ BACK TO ITEM"
            rectAlignment="UpperRight" width="175" height="32" offsetXY="-20 -18"
            fontSize="11" color="#2B4033" textColor="#FFFFFF"/>

        <Panel rectAlignment="UpperLeft" width="1010" height="120" offsetXY="20 -70" color="#17201BCC">
          <Text text="%s" rectAlignment="UpperLeft" width="380" height="38" offsetXY="18 -14"
              fontSize="19" fontStyle="Bold" color="#FFFFFF" alignment="MiddleLeft"/>
          <Text text="%s" rectAlignment="UpperLeft" width="575" height="86" offsetXY="415 -14"
              fontSize="12" color="#A9B8AD" alignment="UpperLeft" horizontalOverflow="Wrap"/>
        </Panel>

        <Text text="WHO RECEIVES THIS ITEM?" rectAlignment="UpperLeft" width="400" height="30"
            offsetXY="20 -218" fontSize="15" fontStyle="Bold" color="#A9B8AD" alignment="MiddleLeft"/>

        %s %s %s
        %s %s %s

        <Text text="%s" rectAlignment="UpperLeft" width="1000" height="56" offsetXY="20 -500"
            fontSize="13" color="#BFD0C3" alignment="MiddleLeft" horizontalOverflow="Wrap"/>
      </Panel>]],
        esc(itemName), esc(detail),
        handlerAssignmentButton("Red",20,-260),
        handlerAssignmentButton("Blue",370,-260),
        handlerAssignmentButton("Green",720,-260),
        handlerAssignmentButton("Purple",20,-362),
        handlerAssignmentButton("Pink",370,-362),
        handlerAssignmentButton("Orange",720,-362),
        esc(status)
    )
end

local function handlerDisplaySkill(skill)
    local map = {
        firearms="Firearms", heavy_weapons="Heavy Weapons",
        melee_weapons="Melee Weapons", unarmed_combat="Unarmed Combat",
        demolitions="Demolitions", artillery="Artillery",
        athletics="Athletics", dex="DEX×5", throw="Athletics"
    }
    return map[string.lower(tostring(skill or ""))] or tostring(skill or "")
end

local function handlerSelectedDetailsXml(item)
    if not item then return "" end

    local rows = {}
    local function add(label, value, allowBlank)
        value = tostring(value or "")
        if value ~= "" or allowBlank then
            if value == "" then value = "N/A" end
            table.insert(rows, {label=label, value=value})
        end
    end

    local kind = tostring(item.kind or "gear")
    if kind == "weapon" then
        add("TYPE", "Weapon")
        local cls = tostring(item.subcategory or "")
        if cls == "" then cls = tostring(item.sourceCategory or "Weapon") end
        add("WEAPON CLASS", cls)
        if tostring(item.caliber or "") ~= "" and string.lower(tostring(item.caliber)) ~= "various" then
            add("CALIBER", item.caliber)
        end
        add("SKILL", handlerDisplaySkill(item.skill), true)
        add("RANGE", item.range, true)
        if tostring(item.damage or "") ~= "" then add("DAMAGE", item.damage) end
        if tostring(item.lethality or "") ~= "" then add("LETHALITY", item.lethality) end
        local ap = tonumber(tostring(item.ap or ""):match("(%d+)")) or 0
        if ap > 0 then add("ARMOR PIERCING", tostring(ap)) end
        if tostring(item.killRadius or "") ~= "" and tostring(item.killRadius) ~= "N/A" then
            add("BLAST RADIUS", item.killRadius)
        end
        if tostring(item.capacity or "") ~= "" then add("MAG / CAPACITY", item.capacity) end
    elseif kind == "armor" then
        add("TYPE", "Body Armor")
        add("ARMOR RATING", item.armor, true)
        if tostring(item.description or "") ~= "" then add("NOTES", item.description) end
    else
        add("TYPE", "Gear")
        local cat = tostring(item.subcategory or "")
        if cat == "" then cat = "Other Gear" end
        add("GEAR CATEGORY", cat)
        if tostring(item.description or "") ~= "" then add("DETAILS", item.description) end
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
    return xml
end


local function buildAddItemToAgent()
    local snapshot, err = getHandlerCatalogSnapshot(state.addCategory)
    local status = tostring(state.addStatus or "")
    if err and err ~= "" then status = err end

    local categories = snapshot.categories or {}
    if #categories > 0 then
        local valid = false
        for _, category in ipairs(categories) do
            if tostring(category) == tostring(state.addCategory or "") then valid = true break end
        end
        if not valid then state.addCategory = tostring(categories[1] or "Firearms") end
    end

    if tostring(snapshot.category or "") ~= tostring(state.addCategory or "") then
        snapshot = getHandlerCatalogSnapshot(state.addCategory)
    end

    local selectedItem = handlerCatalogItemByKey(snapshot, state.addItemKey)
    local selectedDetailsXml = handlerSelectedDetailsXml(selectedItem)
    if state.addAssignPending == true then
        return buildHandlerAssignItemScreen(snapshot, selectedItem)
    end

    local browseRows, browseHeight = buildHandlerBrowseRows(snapshot)
    local showSelected = selectedItem ~= nil
    local showAmmo = showSelected and selectedItem.hasReserveAmmo == true
    local showQty = showSelected and selectedItem.usesQuantity == true
    local mags = math.max(0, math.floor(tonumber(state.addReserveMags) or 0))

    local chosenCaliber, cap = handlerSelectedVariant(selectedItem)
    local magHint = cap and string.format(
        "1 spare mag = %d rounds. %d mags = %d reserve rounds.", cap, mags, cap * mags
    ) or ""

    local filterXml = ""
    if tostring(state.addCategory or "") == "Firearms" and
       tostring(state.addBrowseLevel or "") ~= "root"
    then
        local values = handlerAvailableCalibers(snapshot)
        local selectedFilter = tostring(state.addCaliberFilter or "ALL")
        local valid = false
        for _, value in ipairs(values) do
            if tostring(value) == selectedFilter then valid = true break end
        end
        if not valid then
            selectedFilter = "ALL"
            state.addCaliberFilter = "ALL"
        end

        filterXml = string.format([[
          <Text text="CALIBER" rectAlignment="UpperLeft" width="80" height="28"
              offsetXY="430 -124" fontSize="11" fontStyle="Bold" color="#A9B8AD"/>
          <Dropdown id="handler_caliber_filter" onValueChanged="handlerSelectCaliberFilter"
              rectAlignment="UpperLeft" width="195" height="34" offsetXY="505 -120"
              fontSize="12" color="#1D2B24" textColor="#F1F7F2"
              itemTextColor="#F1F7F2"
              itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
              dropdownBackgroundColor="#0F1210" checkColor="#9BC3A4"
              arrowColor="#FFFFFF" dropdownHeight="360" itemHeight="32">%s</Dropdown>
        ]], dropdownOptions(values, selectedFilter))
    elseif tostring(state.addCategory or "") == "Body Armor" and
           tostring(state.addBrowseLevel or "") ~= "root"
    then
        local values = handlerAvailableArmorRatings(snapshot)
        local selectedFilter = tostring(state.addArmorRatingFilter or "ALL")
        local valid = false
        for _, value in ipairs(values) do
            if tostring(value) == selectedFilter then valid = true break end
        end
        if not valid then
            selectedFilter = "ALL"
            state.addArmorRatingFilter = "ALL"
        end

        filterXml = string.format([[
          <Text text="ARMOR RATING" rectAlignment="UpperLeft" width="110" height="28"
              offsetXY="405 -124" fontSize="11" fontStyle="Bold" color="#A9B8AD"/>
          <Dropdown id="handler_armor_rating_filter" onValueChanged="handlerSelectArmorRatingFilter"
              rectAlignment="UpperLeft" width="170" height="34" offsetXY="525 -120"
              fontSize="12" color="#1D2B24" textColor="#F1F7F2"
              itemTextColor="#F1F7F2"
              itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
              dropdownBackgroundColor="#0F1210" checkColor="#9BC3A4"
              arrowColor="#FFFFFF" dropdownHeight="260" itemHeight="32">%s</Dropdown>
        ]], dropdownOptions(values, selectedFilter))
    end

    local variantPanel = ""
    local hasVariants = showSelected and tostring(selectedItem.variantSpec or "") ~= ""

    if hasVariants then
        local calibers = handlerItemCaliberOptions(selectedItem)
        local capacities = handlerItemCapacityOptions(selectedItem, chosenCaliber)

        variantPanel = string.format([[
          <Panel rectAlignment="UpperLeft" width="250" height="94" offsetXY="18 -266" color="#0F1712CC">
            <Panel rectAlignment="MiddleCenter" width="246" height="90"
                color="#00000000" outline="#44584A" outlineSize="1"/>
            <Text text="CALIBER" rectAlignment="UpperLeft" width="110" height="20"
                offsetXY="10 -10" fontSize="10" fontStyle="Bold" color="#A9B8AD"/>
            <Dropdown id="handler_variant_caliber" onValueChanged="handlerSelectVariantCaliber"
                rectAlignment="UpperLeft" width="112" height="32" offsetXY="10 -34"
                fontSize="11" color="#1D2B24" textColor="#F1F7F2"
                itemTextColor="#F1F7F2" itemBackgroundColors="#141816|#1D2521|#2B3831|#0F1210"
                dropdownBackgroundColor="#0F1210" checkColor="#9BC3A4" arrowColor="#FFFFFF"
                dropdownHeight="300" itemHeight="30">%s</Dropdown>
            <Text text="MAG" rectAlignment="UpperLeft" width="105" height="20"
                offsetXY="132 -10" fontSize="10" fontStyle="Bold" color="#A9B8AD"/>
            %s
          </Panel>
        ]],
            dropdownOptions(calibers, chosenCaliber),
            handlerVariantCapacityDropdownsXml(selectedItem, chosenCaliber, tostring(cap or ""))
        )
    end

    local optionsY = hasVariants and -374 or -282

    local ammoPanel = ""
    if showAmmo then
        ammoPanel = string.format([[
          <Panel rectAlignment="UpperLeft" width="250" height="126" offsetXY="18 %d" color="#0F1712CC">
            <Panel rectAlignment="MiddleCenter" width="246" height="122"
                color="#00000000" outline="#44584A" outlineSize="1"/>

            <Text text="STARTING RESERVE" rectAlignment="UpperLeft" width="110" height="18"
                offsetXY="10 -10" fontSize="10" fontStyle="Bold" color="#A9B8AD"/>
            <InputField id="handler_add_reserve_rounds" onValueChanged="captureHandlerReserveRounds"
                text="%d" rectAlignment="UpperLeft" width="92" height="30" offsetXY="10 -34"
                fontSize="14" color="#17231C" textColor="#FFFFFF"/>

            <Text text="SPARE MAGS" rectAlignment="UpperLeft" width="112" height="18"
                offsetXY="126 -10" fontSize="10" fontStyle="Bold" color="#A9B8AD"/>
            <Button id="handler_add_mags_minus" onClick="adjustHandlerAddReserveMags" text="-"
                rectAlignment="UpperLeft" width="28" height="30" offsetXY="126 -34"
                fontSize="16" color="#563434" textColor="#FFFFFF"/>
            <Text id="handler_add_mags_count" text="%d" rectAlignment="UpperLeft"
                width="34" height="30" offsetXY="157 -34" fontSize="14"
                fontStyle="Bold" color="#FFFFFF" alignment="MiddleCenter"/>
            <Button id="handler_add_mags_plus" onClick="adjustHandlerAddReserveMags" text="+"
                rectAlignment="UpperLeft" width="28" height="30" offsetXY="194 -34"
                fontSize="16" color="#355845" textColor="#FFFFFF"/>

            <Text id="handler_add_mag_hint" text="%s" rectAlignment="UpperLeft"
                width="225" height="38" offsetXY="10 -78" fontSize="9"
                color="#84968B" alignment="UpperLeft" horizontalOverflow="Wrap"/>
          </Panel>
        ]], optionsY,
            math.max(0, math.floor(tonumber(state.addReserveRounds) or 0)),
            mags, esc(magHint))
    end

    local qtyPanel = ""
    if showQty then
        qtyPanel = string.format([[
          <Panel rectAlignment="UpperLeft" width="250" height="90" offsetXY="18 %d" color="#111812AA">
            <Text text="QUANTITY" rectAlignment="UpperLeft" width="100" height="24"
                offsetXY="14 -12" fontSize="12" fontStyle="Bold" color="#A9B8AD"/>
            <Button id="handler_add_qty_minus" onClick="adjustHandlerAddQuantity" text="-"
                rectAlignment="UpperLeft" width="38" height="36" offsetXY="14 -42"
                fontSize="18" color="#563434" textColor="#FFFFFF"/>
            <Text id="handler_add_qty_count" text="%d" rectAlignment="UpperLeft"
                width="70" height="36" offsetXY="60 -42" fontSize="17"
                fontStyle="Bold" color="#FFFFFF" alignment="MiddleCenter"/>
            <Button id="handler_add_qty_plus" onClick="adjustHandlerAddQuantity" text="+"
                rectAlignment="UpperLeft" width="38" height="36" offsetXY="138 -42"
                fontSize="18" color="#355845" textColor="#FFFFFF"/>
          </Panel>
        ]], optionsY, math.max(1, math.floor(tonumber(state.addQuantity) or 1)))
    end

    return string.format([[
      <Panel rectAlignment="UpperLeft" width="1050" height="720" offsetXY="0 0" color="#111A15CC">
        <Text text="ADD EQUIPMENT" rectAlignment="UpperLeft" width="420" height="38"
            offsetXY="20 -16" fontSize="21" fontStyle="Bold" color="#D2E5D6" alignment="MiddleLeft"/>
        <Text text="SOURCE: %s%s" rectAlignment="UpperLeft" width="760" height="30"
            offsetXY="20 -51" fontSize="12" color="#A9B8AD"/>

        %s
        <Text text="%s" rectAlignment="UpperLeft" width="390" height="30" offsetXY="20 -126"
            fontSize="16" fontStyle="Bold" color="#D2E5D6" alignment="MiddleLeft"/>
        %s

        <VerticalScrollView id="handler_equipment_browse_scroll" width="710" height="490"
            rectAlignment="UpperLeft" offsetXY="20 -162" scrollSensitivity="32"
            color="#0D151100" verticalScrollbarVisibility="AutoHide"
            scrollbarBackgroundColor="#101712"
            scrollbarColors="#55705D|#66836D|#78937E|#33443A">
          <Panel width="690" height="%d" rectAlignment="UpperLeft">%s</Panel>
        </VerticalScrollView>

        <Panel id="handler_add_selected_panel" active="%s" rectAlignment="UpperRight"
            width="290" height="520" offsetXY="-20 -162" color="#17201BCC">
          <Text text="SELECTED" rectAlignment="UpperLeft" width="250" height="24" offsetXY="18 -12"
              fontSize="12" fontStyle="Bold" color="#A9B8AD"/>
          <Text text="%s" rectAlignment="UpperLeft" width="250" height="58" offsetXY="18 -38"
              fontSize="18" fontStyle="Bold" color="#FFFFFF" alignment="UpperLeft" horizontalOverflow="Wrap"/>

          <Text text="EXPENSE LEVEL" rectAlignment="UpperLeft" width="250" height="20"
              offsetXY="18 -101" fontSize="11" fontStyle="Bold" color="#A9B8AD"/>
          <Text text="%s" rectAlignment="UpperLeft" width="250" height="26" offsetXY="18 -122"
              fontSize="14" fontStyle="Bold" color="#D9C07A"/>

          <Panel rectAlignment="UpperLeft" width="250" height="140" offsetXY="0 -154">
            %s
          </Panel>

          %s
          %s
          %s

          <Button id="handler_prepare_add_item" onClick="handlerPrepareAddItem"
              text="ADD ITEM" rectAlignment="LowerLeft" width="250" height="42" offsetXY="18 10"
              fontSize="15" fontStyle="Bold" color="#355845" textColor="#FFFFFF"/>
        </Panel>

        <Text text="%s" rectAlignment="UpperLeft" width="1010" height="36" offsetXY="20 -695"
            fontSize="12" color="#BFD0C3" alignment="MiddleLeft" horizontalOverflow="Wrap"/>
      </Panel>]],
        esc(snapshot.loading == true and "Loading equipment catalog..." or tostring(snapshot.source or "Agent catalog")),
        snapshot.sourceColor and (" via " .. tostring(snapshot.sourceColor)) or "",
        buildHandlerBreadcrumbXml(),
        esc(handlerBrowseTitle()), filterXml,
        browseHeight, browseRows,
        showSelected and "true" or "false",
        esc(showSelected and tostring(selectedItem.name or selectedItem.key or "") or ""),
        esc(showSelected and tostring(selectedItem.expense or "—") or "—"),
        selectedDetailsXml,
        variantPanel, ammoPanel, qtyPanel,
        esc(status)
    )
end



local function buildXml()
    local tab = state.currentTab or "overview"
    local content = ""
    local contentHeight = 900

    if tab == "rolls" then
        content = buildHistoryRows(state.rollHistory, "No rolls received yet.")
        contentHeight = math.max(900, 165 + (#state.rollHistory * 62))
    elseif tab == "roll" then
        content = buildRoll()
    elseif tab == "home" then
        content = buildHomeTime()
        contentHeight = 1450
    elseif tab == "inventory" then
        content, contentHeight = buildInventory()
    elseif tab == "add" then
        content = buildAddItemToAgent()
    else
        content = buildOverview()
    end

    return string.format([[
<Panel id="dg_handler_root"
    width="%d" height="%d"
    position="%s"
    rotation="%s"
    scale="%f %f 1"
    color="#0B120EF4">

  <Panel rectAlignment="UpperCenter"
      width="1160" height="112"
      offsetXY="0 -10"
      color="#0C1511">

    <Text text="DELTA GREEN — HANDLER DASHBOARD"
        rectAlignment="UpperLeft"
        width="690" height="38"
        offsetXY="20 -10"
        fontSize="22"
        fontStyle="Bold"
        color="#9BC3A4"
        alignment="MiddleLeft"/>

    <Button id="dash_sync_now"
        onClick="syncDashboardNow"
        text="SYNC NOW"
        rectAlignment="UpperRight"
        width="125" height="30"
        offsetXY="-18 -13"
        fontSize="12"
        fontStyle="Bold"
        color="#2B4033"
        textColor="#FFFFFF"/>

    %s
    %s
    %s
    %s
    %s
    %s
  </Panel>

  <VerticalScrollView id="dash_scroll"
      width="1145" height="670"
      rectAlignment="UpperCenter"
      offsetXY="0 -124"
      scrollSensitivity="38"
      color="#0D151100"
      verticalScrollbarVisibility="AutoHide"
      scrollbarBackgroundColor="#101712"
      scrollbarColors="#55705D|#66836D|#78937E|#33443A">

    <Panel width="1125" height="%d" rectAlignment="UpperCenter">
      %s
    </Panel>
  </VerticalScrollView>

</Panel>]],
        UI_WIDTH,
        UI_HEIGHT,
        UI_POSITION,
        UI_ROTATION,
        CARD_UI_SCALE_X,
        CARD_UI_SCALE_Y,
        tabButton("overview","OVERVIEW",tab=="overview",20),
        tabButton("roll","ROLL",tab=="roll",198),
        tabButton("rolls","ROLLS",tab=="rolls",376),
        tabButton("home","HOME TIME",tab=="home",554),
        tabButton("inventory","INVENTORY",tab=="inventory",732),
        tabButton("add","ADD ITEM",tab=="add",910),
        contentHeight,
        content
    )
end

rebuildUI = function()
    self.UI.setXml(buildXml())
    uiReady = true
end

-- PERFORMANCE: several Agent sheets can report changes on the same frame.
-- Coalesce those inbound updates into one XML rebuild.
local dashboardRebuildPending = false

local function scheduleDashboardRebuild()
    if dashboardRebuildPending then return end
    dashboardRebuildPending = true

    Wait.frames(function()
        dashboardRebuildPending = false
        rebuildUI()
    end, 2)
end

-------------------------------------------------
-- PUBLIC API CALLED BY AGENT SHEETS
-------------------------------------------------

function receiveAgentUpdate(payload)
    if type(payload) ~= "table" then return end

    local colorName = tostring(payload.color or "")
    if colorName == "" then return end

    local snapshot = {
        color = colorName,
        sheetGuid = tostring(payload.sheetGuid or ""),
        name = tostring(payload.name or "Agent"),

        hp = tonumber(payload.hp) or 0,
        hpMax = tonumber(payload.hpMax) or 0,

        wp = tonumber(payload.wp) or 0,
        wpMax = tonumber(payload.wpMax) or 0,

        san = tonumber(payload.san) or 0,
        sanMax = tonumber(payload.sanMax) or 0,

        breakingPoint = tonumber(payload.breakingPoint) or 0,

        markedSkills = payload.markedSkills or {},
        markedCount = tonumber(payload.markedCount) or 0,

        inventory = payload.inventory
    }

    state.agents[colorName] = snapshot

    local eventType = tostring(payload.eventType or "")
    local eventText = tostring(payload.eventText or "")

    if eventType == "roll" and eventText ~= "" then
        eventAppend(
            state.rollHistory,
            {
                color = colorName,
                text = eventText
            },
            MAX_ROLL_HISTORY
        )

    elseif eventType == "home" and eventText ~= "" then
        eventAppend(
            state.homeHistory,
            {
                color = colorName,
                text = eventText
            },
            MAX_HOME_HISTORY
        )
    end

    scheduleDashboardRebuild()
end

-------------------------------------------------

-------------------------------------------------
-- ONE-SHOT AGENT SHEET DISCOVERY
-- Only runs on dashboard load or SYNC NOW.
-------------------------------------------------

function requestAllAgentSheets()
    local requested = 0

    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self then
            local ok = pcall(function()
                obj.call("requestDashboardSync", {})
            end)

            if ok then
                requested = requested + 1
            end
        end
    end

    return requested
end

-- UI EVENTS
-------------------------------------------------


function handlerCheckForNewDice(player, value, id)
    state.availableDice = scanHandlerAvailableDice()

    local found={}
    for _,name in ipairs(state.availableDice or {}) do found[name]=true end
    if not found[state.rollChoice or "GUMSHOE"] then
        state.rollChoice="GUMSHOE"
    end

    -- Force every known Agent sheet to refresh its own color-specific list.
    for _, colorName in ipairs(PLAYER_ORDER) do
        local agent=state.agents[colorName]
        local guid=agent and tostring(agent.sheetGuid or "") or ""
        if guid ~= "" then
            local obj=getObjectFromGUID(guid)
            if obj then
                pcall(function()
                    obj.call("refreshAvailableDiceFromStorage",{force=true})
                end)
            end
        end
    end

    state.inventoryStatus=""
    rebuildUI()
    broadcastToColor("[DG] Dice lists refreshed for Handler and all connected Agents.","Black",{0.55,0.85,0.65})
end

function handlerSelectMultiQty(player,value,id)
    local i=tonumber(tostring(id or ""):match("^handler_multi_qty_(%d)$"))
    if not i or i<1 or i>4 then return end
    local q=math.max(0,math.floor(tonumber(value) or 0))
    q=math.min(6,q)
    state["handlerMultiQty"..tostring(i)]=q
end

function handlerSelectMultiDie(player,value,id)
    local i=tonumber(tostring(id or ""):match("^handler_multi_die_(%d)$"))
    if not i or i<1 or i>4 then return end
    state["handlerMultiDie"..tostring(i)]=tostring(value or "")
end

function handlerCaptureMultiModifier(player,value,id)
    state.handlerMultiModifier=tostring(value or "0")
end

function handlerRollMultiDice(player,value,id)
    local names={}

    for i=1,4 do
        local q=math.max(0,math.floor(tonumber(state["handlerMultiQty"..i]) or 0))
        local name=tostring(state["handlerMultiDie"..i] or "d6")
        q=math.min(6,q)
        for _=1,q do table.insert(names,name) end
    end

    if #names==0 then
        broadcastToColor("Handler dice pool is empty.","Black",{1,0.45,0.35})
        return
    end

    startHandlerMultiRoll(names,math.floor(tonumber(state.handlerMultiModifier) or 0))
end

function selectHandlerRoll(player, value, id)
    if value and value ~= "" then
        state.rollChoice = tostring(value)
    end
end

function rollHandlerSelected(player, value, id)
    local choice = state.rollChoice or "GUMSHOE"

    if self.UI.getValue then
        local ok, current = pcall(function()
            return self.UI.getValue("handler_roll_dropdown")
        end)

        if ok and current and current ~= "" then
            choice = tostring(current)
        end
    end

    startHandlerRoll(choice)
end


function handlerEquipmentBreadcrumbClick(player, value, id)
    local target = tostring(id or ""):gsub("^handler_crumb_", "")
    if target == "root" then
        state.addBrowseLevel = "root"
        state.addCategory = "Firearms"
        state.addSubcategory = ""
        state.addItemKey = ""
        state.addCaliberFilter = "ALL"
        state.addArmorRatingFilter = "ALL"
        handlerResetSelectedVariant(nil)
    elseif target == "category" then
        state.addBrowseLevel = "category"
        state.addSubcategory = ""
        state.addItemKey = ""
    elseif target == "subcategory" then
        state.addBrowseLevel = "subcategory"
        state.addItemKey = ""
    else
        return
    end
    state.addAssignPending = false
    state.addStatus = ""
    rebuildUI()
end

function handlerEquipmentBrowseRowClick(player, value, id)
    local kind, safe = tostring(id or ""):match("^handler_browse_([%a]+)_(.+)$")
    if not kind or not safe then return end

    local snapshot = getHandlerCatalogSnapshot(state.addCategory)

    if kind == "category" then
        local selected = nil
        for _, cat in ipairs(snapshot.categories or {}) do
            if tostring(cat):gsub("[^%w]", "_") == safe then selected = tostring(cat); break end
        end
        if not selected then return end
        state.addCategory = selected
        state.addSubcategory = ""
        state.addBrowseLevel = "category"
        state.addItemKey = ""
        state.addCaliberFilter = "ALL"
        state.addArmorRatingFilter = "ALL"
        handlerResetSelectedVariant(nil)

    elseif kind == "subcategory" then
        snapshot = getHandlerCatalogSnapshot(state.addCategory)
        local selected = nil
        for _, sub in ipairs(snapshot.subcategories or {}) do
            if tostring(sub):gsub("[^%w]", "_") == safe then selected = tostring(sub); break end
        end
        if not selected then return end
        state.addSubcategory = selected
        state.addBrowseLevel = "subcategory"
        state.addItemKey = ""
        handlerResetSelectedVariant(nil)

    elseif kind == "item" then
        snapshot = getHandlerCatalogSnapshot(state.addCategory)
        local selected = nil
        for _, item in ipairs(snapshot.items or {}) do
            if tostring(item.key or ""):gsub("[^%w]", "_") == safe then
                selected = tostring(item.key or "")
                break
            end
        end
        if not selected then return end
        state.addItemKey = selected
        handlerResetSelectedVariant(handlerCatalogItemByKey(snapshot, selected))
        state.addQuantity = 1
        state.addReserveRounds = 0
        state.addReserveMags = 0
        state.addStatus = ""
    else
        return
    end

    state.addAssignPending = false
    rebuildUI()
end

function handlerSelectCaliberFilter(player, value, id)
    state.addCaliberFilter = tostring(value or "ALL")
    state.addItemKey = ""
    handlerResetSelectedVariant(nil)
    rebuildUI()
end

function handlerSelectArmorRatingFilter(player, value, id)
    state.addArmorRatingFilter = tostring(value or "ALL")
    state.addItemKey = ""
    handlerResetSelectedVariant(nil)
    rebuildUI()
end

function handlerSelectVariantCaliber(player, value, id)
    state.addSelectedCaliber = tostring(value or "")
    state.addSelectedCapacity = ""

    local snapshot = getHandlerCatalogSnapshot(state.addCategory)
    local item = handlerCatalogItemByKey(snapshot, state.addItemKey)
    local _, cap = handlerSelectedVariant(item)

    if item then
        local variants = handlerParseVariantSpec(item)

        pcall(function()
            for index, variant in ipairs(variants) do
                self.UI.setAttribute(
                    "handler_variant_capacity_" .. tostring(index),
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
                self.UI.setAttribute(
                    "handler_add_mag_hint",
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

function handlerSelectVariantCapacity(player, value, id)
    state.addSelectedCapacity = tostring(value or "")

    local cap = tonumber(state.addSelectedCapacity)
    local mags = math.max(
        0,
        math.floor(tonumber(state.addReserveMags) or 0)
    )

    if cap then
        pcall(function()
            self.UI.setAttribute(
                "handler_add_mag_hint",
                "text",
                string.format(
                    "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
                    cap, mags, cap * mags
                )
            )
        end)
    end
end

function adjustHandlerAddQuantity(player, value, id)
    local qty = math.max(1, math.floor(tonumber(state.addQuantity) or 1))
    if id == "handler_add_qty_minus" then qty = math.max(1, qty - 1)
    elseif id == "handler_add_qty_plus" then qty = qty + 1
    else return end
    state.addQuantity = qty

    pcall(function()
        self.UI.setAttribute("handler_add_qty_count", "text", tostring(qty))
    end)
end

function captureHandlerReserveRounds(player, value, id)
    local n = tonumber(value)
    if n == nil then return end
    state.addReserveRounds = math.max(0, math.floor(n))
end

function adjustHandlerAddReserveMags(player, value, id)
    local mags = math.max(0, math.floor(tonumber(state.addReserveMags) or 0))
    if id == "handler_add_mags_minus" then mags = math.max(0, mags - 1)
    elseif id == "handler_add_mags_plus" then mags = mags + 1
    else return end
    state.addReserveMags = mags

    local snapshot = getHandlerCatalogSnapshot(state.addCategory)
    local selectedItem = handlerCatalogItemByKey(snapshot, state.addItemKey)
    local _, cap = handlerSelectedVariant(selectedItem)
    local hint = cap and string.format(
        "1 spare mag = %d rounds. %d mags = %d reserve rounds.",
        cap, mags, cap * mags
    ) or ""

    pcall(function()
        self.UI.setAttribute("handler_add_mags_count", "text", tostring(mags))
        self.UI.setAttribute("handler_add_mag_hint", "text", hint)
    end)
end

function handlerPrepareAddItem(player, value, id)
    if tostring(state.addItemKey or "") == "" then
        state.addStatus = "Choose an item first."
        rebuildUI()
        return
    end
    state.addAssignPending = true
    state.addStatus = "Choose the Agent who receives this item."
    rebuildUI()
end

function handlerCancelAssignItem(player, value, id)
    state.addAssignPending = false
    state.addStatus = ""
    rebuildUI()
end

function handlerAssignPreparedItem(player, value, id)
    local colorName = tostring(id or ""):match("^handler_assign_(.+)$")
    if not colorName then return end

    local obj, err = getAgentSheetForColor(colorName)
    if not obj then
        state.addStatus = tostring(err or "Target Agent not available.")
        rebuildUI()
        return
    end

    local key = tostring(state.addItemKey or "")
    if key == "" then
        state.addStatus = "Choose an item first."
        state.addAssignPending = false
        rebuildUI()
        return
    end

    local ok, result = pcall(function()
        return obj.call("handlerAddEquipmentItem", {
            itemKey = key,
            quantity = math.max(1, math.floor(tonumber(state.addQuantity) or 1)),
            reserveRounds = math.max(0, math.floor(tonumber(state.addReserveRounds) or 0)),
            reserveMags = math.max(0, math.floor(tonumber(state.addReserveMags) or 0)),
            caliber = tostring(state.addSelectedCaliber or ""),
            capacity = tonumber(state.addSelectedCapacity)
        })
    end)

    if not ok or type(result) ~= "table" then
        state.addStatus = "Could not add item. Target Agent needs the updated r37+ script."
        rebuildUI()
        return
    end

    if result.ok == true then
        state.addTargetColor = colorName
        state.addStatus = tostring(result.message or "Item added.") .. " → " .. colorName
        state.addAssignPending = false
        state.addQuantity = 1
        state.addReserveRounds = 0
        state.addReserveMags = 0
        handlerResetSelectedVariant(nil)

        pcall(function()
            broadcastToColor(
                "[DG] Handler added " .. tostring(result.itemName or key) .. " to your equipment.",
                colorName,
                {0.45,0.85,0.55}
            )
        end)
    else
        state.addStatus = tostring(result.message or "Could not add item.")
    end

    rebuildUI()
end


function clearHomeHistoryEntry(player, value, id)
    local index = tonumber(tostring(id or ""):match("^clear_home_(%d+)$"))
    if not index or not state.homeHistory[index] then return end

    table.remove(state.homeHistory, index)
    rebuildUI()
end

function clearAllHomeHistory(player, value, id)
    state.homeHistory = {}
    rebuildUI()
end


function handlerSelectInventoryAgent(player, value, id)
    local colorName =
        tostring(id or ""):match("^handler_inventory_agent_(.+)$")
    if not colorName then return end

    state.inventoryColor = colorName
    state.inventoryStatus = ""
    state.inventoryCurrencyPickPending = false
    state.inventoryCurrencyDraft = ""
    rebuildUI()
end

function handlerSelectInventorySubtab(player, value, id)
    local tab =
        tostring(id or ""):match("^handler_inventory_tab_(.+)$")

    local valid = {
        all=true,
        firearms=true,
        melee=true,
        heavy=true,
        lesslethal=true,
        armor=true,
        gear=true,
        funds=true
    }

    if not valid[tab] then return end

    state.inventorySubtab = tab
    state.inventoryStatus = ""
    state.inventoryCurrencyPickPending = false
    state.inventoryCurrencyDraft = ""
    rebuildUI()
end

function handlerCaptureCurrencyAmount(player, value, id)
    local raw = tostring(value or "")
    local cleaned = raw:gsub("[^%d%.]", "")
    local first = cleaned:find("%.", 1, false)

    if first then
        cleaned =
            cleaned:sub(1, first) ..
            cleaned:sub(first + 1):gsub("%.", "")
    end

    state.inventoryCurrencyDraft = cleaned

    if cleaned ~= raw then
        pcall(function()
            self.UI.setAttribute("handlerCurrencyAmountInput", "text", cleaned)
        end)
    end
end

function handlerBeginCurrencyPick(player, value, id)
    local draft = nil
    pcall(function()
        draft = self.UI.getValue("handlerCurrencyAmountInput")
    end)

    if draft == nil then draft = state.inventoryCurrencyDraft end

    draft = tostring(draft or ""):gsub("[^%d%.]", "")
    local amount = tonumber(draft)

    if not amount or amount <= 0 then
        state.inventoryStatus = "Enter a positive amount first."
        return
    end

    state.inventoryCurrencyDraft = draft
    state.inventoryCurrencyPickPending = true
    rebuildUI()
end

function handlerCancelCurrencyPick(player, value, id)
    state.inventoryCurrencyPickPending = false
    rebuildUI()
end

function handlerChooseCurrency(player, value, id)
    local code =
        tostring(id or ""):match("^handler_currency_pick_(.+)$")

    if not code or not handlerCurrencyDef(code) then return end

    local amount = tonumber(state.inventoryCurrencyDraft)
    if not amount or amount <= 0 then return end

    local colorName = tostring(state.inventoryColor or "Red")
    local obj, err = getAgentSheetForColor(colorName)

    if not obj then
        state.inventoryStatus = tostring(err or "Agent sheet unavailable.")
        return
    end

    local ok, result = pcall(function()
        return obj.call("handlerAdjustExistingInventory", {
            kind = "currency",
            code = code,
            amount = amount
        })
    end)

    if not ok or type(result) ~= "table" or result.ok ~= true then
        state.inventoryStatus =
            type(result) == "table" and tostring(result.message or "Could not add currency.") or
            "Target Agent needs the matching r55 sheet."
        return
    end

    state.agents[colorName] = state.agents[colorName] or {color=colorName}
    state.agents[colorName].inventory = result.inventory
    state.inventoryStatus = tostring(result.message or "")
    state.inventoryCurrencyDraft = ""
    state.inventoryCurrencyPickPending = false
    rebuildUI()
end

function handlerAdjustCurrency(player, value, id)
    local colorName, code, action =
        tostring(id or ""):match("^handler_currency_([^_]+)_([^_]+)_(.+)$")

    if not colorName or not code or not action then return end

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

    local obj, err = getAgentSheetForColor(colorName)
    if not obj then
        state.inventoryStatus = tostring(err or "Agent sheet unavailable.")
        return
    end

    local ok, result = pcall(function()
        return obj.call("handlerAdjustExistingInventory", {
            kind = "currency",
            code = code,
            amount = delta
        })
    end)

    if not ok or type(result) ~= "table" or result.ok ~= true then
        state.inventoryStatus =
            type(result) == "table" and tostring(result.message or "Could not adjust currency.") or
            "Target Agent needs the matching r55 sheet."
        return
    end

    state.agents[colorName] = state.agents[colorName] or {color=colorName}
    state.agents[colorName].inventory = result.inventory
    state.inventoryStatus = tostring(result.message or "")

    local balance =
        tonumber(result.inventory.currencyBalances and
                 result.inventory.currencyBalances[code]) or 0

    pcall(function()
        self.UI.setAttribute(
            "handler_currency_balance_" .. colorName .. "_" .. code,
            "text",
            handlerCurrencyAmountWithSymbol(code, balance)
        )
    end)
end

function handlerAdjustFunds(player, value, id)
    local colorName, action =
        tostring(id or ""):match("^handler_funds_([^_]+)_(.+)$")

    if not colorName or not action then return end

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

    local obj, err = getAgentSheetForColor(colorName)
    if not obj then
        state.inventoryStatus = tostring(err or "Agent sheet unavailable.")
        return
    end

    local ok, result = pcall(function()
        return obj.call("handlerAdjustExistingInventory", {
            kind = "funds",
            amount = delta
        })
    end)

    if not ok or type(result) ~= "table" then
        state.inventoryStatus =
            colorName .. " needs the matching r53 Agent sheet for fund controls."
        return
    end

    state.inventoryStatus = tostring(result.message or "")

    if result.ok == true and type(result.inventory) == "table" then
        state.agents[colorName] = state.agents[colorName] or {color=colorName}
        state.agents[colorName].inventory = result.inventory

        local spendable =
            math.max(0, math.floor(tonumber(result.inventory.spendable) or 0))

        pcall(function()
            self.UI.setAttribute(
                "handler_spendable_" .. tostring(colorName),
                "text",
                "SPENDABLE: " .. tostring(spendable)
            )
        end)
    end
end

function handlerAdjustExistingInventory(player, value, id)
    local colorName, action, safe =
        tostring(id or ""):match("^handler_inventory_([^_]+)_([^_]+)_(.+)$")

    if not colorName or not action or not safe then return end

    local obj, err = getAgentSheetForColor(colorName)
    if not obj then
        state.inventoryStatus = tostring(err or "Agent sheet unavailable.")
        return
    end

    local params = {
        kind = "weapon",
        index = tonumber(safe)
    }

    if action == "reserve10" then
        params.action = "reserve"
        params.amount = 10
    elseif action == "mag1" then
        params.action = "mag"
        params.amount = 1
    elseif action == "loaded1" then
        params.action = "loaded"
        params.amount = 1
    elseif action == "fill" then
        params.action = "fill"
        params.amount = 1
    elseif action == "qty1" then
        params.action = "quantity"
        params.amount = 1
    elseif action == "qty5" then
        params.action = "quantity"
        params.amount = 5
    elseif action == "gear1" or action == "gear5" then
        params.kind = "gear"
        params.action = "quantity"
        params.amount = action == "gear5" and 5 or 1

        local agent = state.agents[colorName]
        local inv = agent and agent.inventory
        local found = nil

        for _, g in ipairs(inv and inv.gear or {}) do
            local key = tostring(g.key or g.name or "")
            if key:gsub("[^%w]","_") == safe then
                found = g
                break
            end
        end

        if not found then
            state.inventoryStatus = "That gear item is no longer available."
            return
        end

        params.key = tostring(found.key or found.name or "")
        params.name = tostring(found.name or params.key)
        params.index = nil
    else
        return
    end

    local ok, result = pcall(function()
        return obj.call("handlerAdjustExistingInventory", params)
    end)

    if not ok or type(result) ~= "table" then
        state.inventoryStatus =
            colorName .. " needs the matching r53 Agent sheet for inventory controls."
        return
    end

    state.inventoryStatus = tostring(result.message or "")

    if result.ok == true and type(result.inventory) == "table" then
        state.agents[colorName] = state.agents[colorName] or {color=colorName}
        state.agents[colorName].inventory = result.inventory

        if params.kind == "weapon" and params.index then
            local idx = tonumber(params.index)
            local w = nil

            for _, candidate in ipairs(result.inventory.weapons or {}) do
                if tonumber(candidate.index) == idx then
                    w = candidate
                    break
                end
            end

            if w then
                local cap = tonumber(w.capacity)
                local current = tonumber(w.ammoCurrent)
                if current == nil and cap then current = cap end

                if cap then
                    local status =
                        (current or 0) <= 0 and "EMPTY" or
                        ((current or 0) >= cap and "FULL" or "PARTIAL")

                    pcall(function()
                        self.UI.setAttribute(
                            "handler_inv_mag_" .. tostring(colorName) .. "_" .. tostring(idx),
                            "text",
                            string.format(
                                "%d / %d LOADED  [%s]",
                                current or 0,
                                cap,
                                status
                            )
                        )

                        self.UI.setAttribute(
                            "handler_inv_reserve_" .. tostring(colorName) .. "_" .. tostring(idx),
                            "text",
                            tostring(
                                math.max(
                                    0,
                                    math.floor(tonumber(w.reserve) or 0)
                                )
                            ) .. " " .. tostring(w.ammoLabel or "rounds")
                        )
                    end)
                else
                    pcall(function()
                        self.UI.setAttribute(
                            "handler_inv_qty_" .. tostring(colorName) .. "_" .. tostring(idx),
                            "text",
                            "QUANTITY: " ..
                                tostring(
                                    math.max(
                                        0,
                                        math.floor(tonumber(w.quantity) or 0)
                                    )
                                )
                        )
                    end)
                end
            end
        end
    end
end

function syncDashboardNow(player, value, id)
    requestAllAgentSheets()
end

function clearRollHistoryEntry(player, value, id)
    local index = tonumber(tostring(id or ""):match("^clear_roll_(%d+)$"))

    if not index or not state.rollHistory[index] then
        return
    end

    table.remove(state.rollHistory, index)
    rebuildUI()
end

function clearAllRollHistory(player, value, id)
    state.rollHistory = {}
    rebuildUI()
end

function switchDashboardTab(player, value, id)
    local tab = tostring(id or ""):gsub("^dash_tab_","")

    if tab == "overview" or tab == "roll" or tab == "rolls" or
       tab == "home" or tab == "inventory" or tab == "add"
    then
        state.currentTab = tab
        rebuildUI()
    end
end

-------------------------------------------------
-- SAVE / LOAD
-------------------------------------------------

function onSave()
    return JSON.encode(state)
end

function onLoad(saved_data)
    if saved_data and saved_data ~= "" then
        local ok, loaded = pcall(JSON.decode, saved_data)

        if ok and type(loaded) == "table" then
            state = loaded
        end
    end

    state.currentTab = state.currentTab or "overview"
    state.agents = state.agents or {}
    state.rollHistory = state.rollHistory or {}
    state.homeHistory = state.homeHistory or {}
    state.rollChoice = state.rollChoice or "GUMSHOE"
    state.addTargetColor = state.addTargetColor or "Red"
    state.addCategory = state.addCategory or "Firearms"
    state.addSubcategory = state.addSubcategory or ""
    state.addBrowseLevel = state.addBrowseLevel or "root"
    state.addAssignPending = state.addAssignPending == true
    state.addCatalogSourceColor = state.addCatalogSourceColor or ""
    state.addItemKey = state.addItemKey or ""
    state.addCaliberFilter = state.addCaliberFilter or "ALL"
    state.addSelectedCaliber = state.addSelectedCaliber or ""
    state.addSelectedCapacity = state.addSelectedCapacity or ""
    state.addQuantity = math.max(1, tonumber(state.addQuantity) or 1)
    state.addReserveRounds = math.max(0, tonumber(state.addReserveRounds) or 0)
    state.addReserveMags = math.max(0, tonumber(state.addReserveMags) or 0)
    state.addStatus = state.addStatus or ""
    state.inventoryStatus = state.inventoryStatus or ""
    state.inventoryColor = state.inventoryColor or "Red"
    state.inventorySubtab = state.inventorySubtab or "all"
    state.inventoryCurrencyDraft = state.inventoryCurrencyDraft or ""
    state.inventoryCurrencyPickPending = state.inventoryCurrencyPickPending == true

    state.handlerMultiQty1 = tonumber(state.handlerMultiQty1) or 1
    state.handlerMultiDie1 = state.handlerMultiDie1 or "d6"
    state.handlerMultiQty2 = tonumber(state.handlerMultiQty2) or 0
    state.handlerMultiDie2 = state.handlerMultiDie2 or "d4"
    state.handlerMultiQty3 = tonumber(state.handlerMultiQty3) or 0
    state.handlerMultiDie3 = state.handlerMultiDie3 or "d8"
    state.handlerMultiQty4 = tonumber(state.handlerMultiQty4) or 0
    state.handlerMultiDie4 = state.handlerMultiDie4 or "Hit Location"
    state.handlerMultiModifier = state.handlerMultiModifier or "0"

    -- One initial scan for old saves. After that the list is persistent until
    -- CHECK FOR NEW DICE is pressed.
    if type(state.availableDice) ~= "table" or #state.availableDice == 0 then
        state.availableDice = scanHandlerAvailableDice()
    end

    pcall(function()
        Global.setVar("DG_HANDLER_DASHBOARD_GUID", self.getGUID())
    end)

    rebuildUI()

    Wait.frames(function()
        requestAllAgentSheets()
    end, 30)
end