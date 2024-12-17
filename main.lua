-- Function to check mana and print a warning if low
local function CheckMana()
    local maxMana = UnitPowerMax("player", 0)
    local currentMana = UnitPower("player", 0)

    if currentMana / maxMana <= 0.25 then
        SendChatMessage("Warning: Critically low mana", "PARTY")
    elseif currentMana / maxMana <= 0.35 then
        SendChatMessage("Warning: Mana Low", "PARTY")
    end
end

-- Register events to update mana and health on power change and heal prediction
local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_POWER_UPDATE")

frame:SetScript("OnEvent", function(self, event, arg1, arg2)
    if arg1 == "player" and event == "UNIT_POWER_UPDATE" and arg2 == "MANA" then
        CheckMana()
    end
end)

-- Also check the mana on login
CheckMana()
