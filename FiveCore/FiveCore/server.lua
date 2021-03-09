Gangs = {
    -- Short Name, Gang Name, Discord RoleId, Blip Color
    ["ESG"] = {"East Side Gunnas", 799036062638932008, 83},
    ["RRZ"] = {"Rug Ratzs", 792928635647557652, 84},
    ["RM"] = {"Richman", 760269644635963452, 85},
    ["SMG"] = {"Savage Money Boyz", 760269664831143936, 49},
    ["TPF"] = {"The Petrovich Family", 775816239615967242, 76},
    ["IDF"] = {"Israeli Defense Forces", 792560541318643722, 18},
    ["FNO"] = {"Fear No One", 809908367203762206, 85},
    ["BD"] = {"Brouge Disciples", 810062050599764019, 38},
    ["TG"] = {"The Ghosts", 810971000698175519, 45},
    ["PB"] = {"Peaky Blinders", 811660036677173289, 69}
}

local GangsOnline = {}
local Gangster = {}
local ActiveGangBlips = {}
local HasPerms = {}
local PermTracker = {}
local OnDuty = false

RegisterCommand('gang', function(source, args, rawCommand)
    if HasPerms[source] ~= nil then
        if Gangster[source] == nil then
            local colorr = Gangs[ActiveGangBlips[source]][3];
            local tag = ActiveGangBlips[source];
            OnDuty = true
            TriggerClientEvent("RecieveGangPermissions", -1, true)
            TriggerEvent('eblips:add', {name = tag .. GetPlayerName(source), src = source, color = colorr});
            Gangster[source] = true;
        else
            OnDuty = false
            TriggerClientEvent("RecieveGangPermissions", -1, false)
            Gangster[source] = nil;
            local tag = ActiveGangBlips[source];
            TriggerEvent('eblips:remove', source)
        end
    else
        sendMsg(source, '^1You are not in a gang')
    end
end)

RegisterCommand('changegang', function(source, args, rawCommand)
    if HasPerms[source] ~= nil then
        if #args == 0 then
            sendMsg(source, 'You have access to the following gangs:');
            for i = 1, #PermTracker[source] do
                TriggerClientEvent('chatMessage', source, '^9[^4' .. i .. '^9] ^0' .. PermTracker[source][i]);
            end
        else
            local selection = args[1];
            if tonumber(selection) ~= nil then
                local sel = tonumber(selection);
                local theirBlips = PermTracker[source];
                if sel <= #theirBlips then
                    local tag = ActiveGangBlips[source];
                    ActiveGangBlips[source] = PermTracker[source][sel];
                    sendMsg(source, 'You have set your gang to ^1' .. PermTracker[source][sel]);
                    if Gangster[source] ~= nil then
                        tag = ActiveGangBlips[source];
                        local colorr = Gangs[ActiveGangBlips[source]][3]
                        TriggerEvent('eblips:remove', source)
                        TriggerEvent('eblips:add', {name = tag .. GetPlayerName(source), src = source, color = colorr});
                    end
                else
                    sendMsg(source, '^1ERROR: That is not a valid selection...')
                end
            else
                sendMsg(source, '^1ERROR: That is not a number...')
            end
        end
    else
        sendMsg(source, '^1Must be roled in Certified Gang Discord')
    end
end)



AddEventHandler("playerDropped", function()
    if GangsOnline[source] then
        GangsOnline[source] = nil
    end
    Gangster[source] = nil;
    PermTracker[source] = nil;
    HasPerms[source] = nil;
    ActiveGangBlips[source] = nil;
    TriggerEvent('eblips:remove', source)
end)

RegisterNetEvent('GangMenu:RegisterUser')
AddEventHandler('GangMenu:RegisterUser', function()
	local src = source
	for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
	end
	local perms = {}
	if identifierDiscord then
		local roleIDs = exports.GangAPI:GetDiscordRoles(src)
		if not (roleIDs == false) then
			for k, v in pairs(Gangs) do
				for j = 1, #roleIDs do
					if exports.GangAPI:CheckEqual(v[2], roleIDs[j]) then
						table.insert(perms, k);
						ActiveGangBlips[src] = k;
						HasPerms[src] = true;
					end
				end
			end
			PermTracker[src] = perms;
    else
    print("[Gangs] " .. GetPlayerName(src) .. " has not gotten their permissions cause roleIDs == false")
		end
  else
  print("[Gangs] " .. GetPlayerName(src) .. " has not gotten their permissions cause discord was not detected...")
	end
	PermTracker[src] = perms;
end)

RegisterServerEvent("eblips:add")
AddEventHandler("eblips:add", function(person)
    GangsOnline[person.src] = person
    for k, v in pairs(GangsOnline) do
        TriggerClientEvent("eblips:updateAll", k, GangsOnline)
    end
    TriggerClientEvent("eblips:toggle", person.src, true)
end)

RegisterServerEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
    GangsOnline[src] = nil
    for k, v in pairs(GangsOnline) do
        TriggerClientEvent("eblips:remove", tonumber(k), src)
    end
    TriggerClientEvent("eblips:toggle", src, false)
end)

RegisterServerEvent('GangMenu:Chat')
AddEventHandler('GangMenu:Chat', function(Color, Prefix, Message)
    TriggerClientEvent('chatMessage', -1, Prefix, Color, Message)
end)

RegisterServerEvent('GangMenu:Rank')
AddEventHandler('GangMenu:Rank', function(ID)
    if ID == -1 or ID == '-1' then
        if source ~= '' then
            DropPlayer(source, '\n[GangMenu] Attempting to rank all players in there gang')
        else
            print('^1Someone attempted to cuff all players^7')
        end
        return
    end

    if ID ~= false then
        print("ranking is coming soon!")
    end
end)

RegisterServerEvent('GangMenu:DeRank')
AddEventHandler('GangMenu:DeRank', function(ID)
    if ID == -1 or ID == '-1' then
        if source ~= '' then
            DropPlayer(source, '\n[GangMenu] Attempting to rank all players in there gang')
        else
            print('^1Someone attempted to cuff all players^7')
        end
        return
    end

    if ID ~= false then
        print("ranking is coming soon!")
    end
end)

function sendMsg(src, msg)
    TriggerClientEvent('chatMessage', src, "[SACRP]" .. msg);
end
