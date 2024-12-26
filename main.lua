-- Check to ensure that it's a member of the group/raid
local function IsInGroup(unit)
    return UnitInParty(unit) or UnitInRaid(unit) or UnitIsUnit(unit, "pet")
end

-- Function to check mana and print a warning if low
local function CheckMana()
    local maxMana = UnitPowerMax("player", 0)
    local currentMana = UnitPower("player", 0)
    local manaPercentage = (currentMana / maxMana) * 100

    if manaPercentage > 35 then
        manaMessageCount = 0
    elseif manaPercentage <= 25 then
        SendChatMessage("Warning: Critically low mana", "PARTY")
        manaMessageCount = 1
    elseif manaPercentage <= 35 and manaMessageCount <= 2 then
        SendChatMessage("Mana Low", "PARTY")
        manaMessageCount = manaMessageCount + 1
    end
end

-- Function to check health and print a warning if low
local function CheckHealth(unit)
    local maxHealth = UnitHealthMax(unit)
    local currentHealth = UnitHealth(unit)
    local healthPercentage = (currentHealth / maxHealth) * 100
    local playerName = UnitName(unit)

    if healthPercentage <= 30 then
        SendChatMessage("WARNING: " .. playerName .. " needs heals!!", "PARTY")
        healthMessageCount = 1
    elseif healthPercentage <= 50 and healthMessageCount <= 3 then
        SendChatMessage(playerName .. " is low", "PARTY")
        healthMessageCount = healthMessageCount + 1
    end
end

-- Register events to update mana and health on power change and heal prediction
local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_POWER_UPDATE")
frame:RegisterEvent("UNIT_HEALTH")

manaMessageCount = 0
healthMessageCount = 0

frame:SetScript("OnEvent", function(self, event, arg1, arg2)
    if arg1 == "player" and event == "UNIT_POWER_UPDATE" and arg2 == "MANA" then
        CheckMana()
    elseif event == "UNIT_HEALTH" and IsInGroup(arg1) == true then
        CheckHealth(arg1)
    end
end)