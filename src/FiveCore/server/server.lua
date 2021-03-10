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

RegisterServerEvent("checkMyPingBro")
RegisterServerEvent("FiveCore.getIsEmergency")
RegisterServerEvent("FiveCore.getIsAdmin")
RegisterServerEvent('playerConnecting')
RegisterServerEvent("FiveCore:AFKBoot")

AddEventHandler("FiveCore:AFKBoot", function()
	DropPlayer(source, "You were AFK for too long.")
end)

AddEventHandler("PingPonglol", function()
	ping = GetPlayerPing(source)
	if Config.HighPingKick == true then
    if ping >= Config.PingLimit then
  		DropPlayer(source, "Ping is too high (Limit: " .. pingLimit .. " Your Ping: " .. ping .. ")")
  	end
  end
end)

RegisterCommand('admin', function(source, args, rawCommand)
    TriggerClientEvent("FiveCore:Menu", source, true)
end)

AddEventHandler("FiveCore.getIsAdmin", function(source)
    if IsPlayerAceAllowed(source, "fivecore.admin") or IsPlayerAceAllowed(source, "group.admin") then
        TriggerClientEvent("FiveCore.returnIsAdmin", source, true)
    else
        TriggerClientEvent("FiveCore.returnIsAdmin", source, false)
    end
end)

AddEventHandler("FiveCore.getIsEmergency", function(source)
--    if IsPlayerAceAllowed(source, "fivecore.emergency") then
        TriggerClientEvent("FiveCore.returnIsEmergency", source, true)
  --  else
--        TriggerClientEvent("FiveCore.returnIsEmergency", source, false)
--    end
end)


RegisterServerEvent('FiveCops:Seat')
AddEventHandler('FiveCops:Seat', function(ID, Vehicle)
    TriggerClientEvent('FiveCopsClient:Seat', ID, Vehicle)
end)

RegisterServerEvent('FiveCops:Unseat')
AddEventHandler('FiveCops:Unseat', function(ID, Vehicle)
    TriggerClientEvent('FiveCopsClient:Unseat', ID, Vehicle)
end)

RegisterServerEvent('FiveCops:Cuff')
AddEventHandler('FiveCops:Cuff', function(ID)
    if ID == -1 or ID == '-1' then
        if source ~= '' then
            print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to cuff all players^7')
            DropPlayer(source, '\nAttempting to cuff all players')
        else
            print('^1Someone attempted to cuff all players^7')
        end

        return
    end
    if ID ~= false then
        TriggerClientEvent('FiveCopsClient:Cuff', ID)
    end
end)

RegisterServerEvent('FiveCops:Drag')
AddEventHandler('FiveCops:Drag', function(ID)
    if ID == -1 or ID == '-1' then
        if source ~= '' then
            print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to drag all players^7')
            DropPlayer(source, '\nAttempting to drag all players')
        else
            print('^1Someone attempted to drag all players^7')
        end

        return
    end
    if ID ~= false and ID ~= source then
        TriggerClientEvent('FiveCopsClient:Drag', ID, source)
    end
end)

RegisterServerEvent('FiveCops:Unjail')
AddEventHandler('FiveCops:Unjail', function(ID)
    TriggerClientEvent('FiveCopsClient:UnjailPlayer', ID)
end)

RegisterServerEvent('FiveCops:Ads')
AddEventHandler('FiveCops:Ads', function(Text, Name, Loc, File)
    TriggerClientEvent('FiveCopsClient:SyncAds', -1, Text, Name, Loc, File, source)
end)

BACList = {}
RegisterServerEvent('FiveCops:BACSet')
AddEventHandler('FiveCops:BACSet', function(BACLevel)
    BACList[source] = BACLevel
end)

RegisterServerEvent('FiveCops:BACTest')
AddEventHandler('FiveCops:BACTest', function(ID)
    local BACLevel = BACList[ID]
    TriggerClientEvent('FiveCopsClient:BACResult', source, BACLevel)
end)

Inventories = {}
RegisterServerEvent('FiveCops:InventorySet')
AddEventHandler('FiveCops:InventorySet', function(Items)
    Inventories[source] = Items
end)

RegisterServerEvent('FiveCops:InventorySearch')
AddEventHandler('FiveCops:InventorySearch', function(ID)
    local Inventory = Inventories[ID]
    TriggerClientEvent('FiveCopsClient:InventoryResult', source, Inventory)
end)

RegisterServerEvent('FiveCops:Unhospitalize')
AddEventHandler('FiveCops:Unhospitalize', function(ID)
    TriggerClientEvent('FiveCopsClient:UnhospitalizePlayer', ID)
end)

RegisterServerEvent('FiveCops:Hospitalize')
AddEventHandler('FiveCops:Hospitalize', function(ID, Time, Location)
    if ID == -1 or ID == '-1' then
        if source ~= '' then
            print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to hospitalize all players^7')
            DropPlayer(source, '\n Attempting to hospitalize all players')
        else
            print('^1Someone attempted to hospitalize all players^7')
        end

        return
    end

    TriggerClientEvent('FiveCopsClient:HospitalizePlayer', ID, Time, Location)
    TriggerClientEvent('chatMessage', -1, 'Doctor ', {86, 96, 252}, GetPlayerName(ID) .. ' has been Hospitalized for ' .. Time .. ' months(s)')
end)

RegisterServerEvent('FiveCops:Jail')
AddEventHandler('FiveCops:Jail', function(ID, Time)
    if ID == -1 or ID == '-1' then
        if source ~= '' then
            print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to jail all players^7')
            DropPlayer(source, '\n Attempting to jail all players')
        else
            print('^1Someone attempted to jail all players^7')
        end

        return
    end

    TriggerClientEvent('FiveCopsClient:JailPlayer', ID, Time)
    TriggerClientEvent('chatMessage', -1, 'Judge ', {86, 96, 252}, GetPlayerName(ID) .. ' has been Jailed for ' .. Time .. ' months(s)')
end)

RegisterServerEvent('FiveCops:GlobalChat')
AddEventHandler('FiveCops:GlobalChat', function(Color, Prefix, Message)
	TriggerClientEvent('chatMessage', -1, Prefix, Color, Message)
end)
