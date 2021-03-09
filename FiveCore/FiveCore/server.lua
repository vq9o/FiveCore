RegisterServerEvent("FiveCore.getIsEmergency")
RegisterServerEvent("FiveCore.getIsAdmin")
RegisterServerEvent('playerConnecting')

RegisterCommand('admin', function(source, args, rawCommand)
    TriggerClientEvent("FiveCore:Menu", source, true)
end)

AddEventHandler("FiveCore.getIsAdmin", function(source)
    if IsPlayerAceAllowed(source, "fivecore.admin") then
        TriggerClientEvent("FiveCore.returnIsAdmin", source, true)
    else
        TriggerClientEvent("FiveCore.returnIsAdmin", source, false)
    end
end)

AddEventHandler("FiveCore.getIsEmergency", function(source)
    if IsPlayerAceAllowed(source, "fivecore.emergency") then
        TriggerClientEvent("FiveCore.returnIsEmergency", source, true)
    else
        TriggerClientEvent("FiveCore.returnIsEmergency", source, false)
    end
end)

AddEventHandler('playerConnecting', function(name, kick)
    local license
    for k,v in ipairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            break
        end
    end

    if not license then
        kick("No username, please restart FiveM")
        CancelEvent()
    end
end)
