local OnDuty = false
local ACTIVE = false
local ACTIVE_EMERGENCY_PERSONNEL = {}

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/MainMenu', 'Open gang menu (must be on as a gangster)')
    TriggerEvent('chat:addSuggestion', '/gang', 'Go onduty as a gangster')
    TriggerEvent('chat:addSuggestion', '/changegang', 'In more than one gang? Change to correct gang')
end)

AddEventHandler('playerSpawned', function()
	TriggerServerEvent('GangMenu:RegisterUser');
end)

RegisterNetEvent('RecieveGangPermissions')
AddEventHandler('RecieveGangPermissions', function(bool)
  OnDuty = bool
end)

RegisterNetEvent("eblips:toggle")
AddEventHandler("eblips:toggle", function(on)
	ACTIVE = on
	if not ACTIVE then
		RemoveAnyExistingEmergencyBlips()
	end
end)

RegisterNetEvent("eblips:updateAll")
AddEventHandler("eblips:updateAll", function(personnel)
	ACTIVE_EMERGENCY_PERSONNEL = personnel
end)

RegisterNetEvent("eblips:update")
AddEventHandler("eblips:update", function(person)
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
end)

RegisterNetEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	RemoveAnyExistingEmergencyBlipsById(src)
end)

_MenuPool = NativeUI.CreatePool()
MainMenu = NativeUI.CreateMenu()

function Menu()
    _MenuPool:Remove()
    _MenuPool = NativeUI.CreatePool()
    MainMenu = NativeUI.CreateMenu(MenuTitle, 'SACRP Gang Menu', 1320)
    _MenuPool:Add(MainMenu)
    MainMenu:SetMenuWidthOffset(80)
    collectgarbage()
    MainMenu:SetMenuWidthOffset(80)
    _MenuPool:ControlDisablingEnabled(false)
    _MenuPool:MouseControlsEnabled(false)
    if OnDuty == true then
        local GangAdminOption = _MenuPool:AddSubMenu(MainMenu, 'Gang Admin', 'Manage your gang', true)
        GangAdminOption:SetMenuWidthOffset(80)
        local Rank = NativeUI.CreateItem('Add', 'Add closest player to your gang')
        local DeRank = NativeUI.CreateItem('Remove', 'Remove closest player to your gang')
        GangAdminOption:AddItem(Rank)
        GangAdminOption:AddItem(DeRank)
    end
  --  if OnDuty == true then
        local GangOption = _MenuPool:AddSubMenu(MainMenu, 'Gang Toolbox', 'Gang Related Menu', true)
        GangOption:SetMenuWidthOffset(80)
        local Cuff = NativeUI.CreateItem('Cuff', 'Cuff/Uncuff the closest player')
        local Drag = NativeUI.CreateItem('Drag', 'Drag/Undrag the closest player')
        local Seat = NativeUI.CreateItem('Seat', 'Place a player in the closest vehicle')
        local Unseat = NativeUI.CreateItem('Unseat', 'Remove a player from the closest vehicle')
        local Inventory = NativeUI.CreateItem('Inventory', 'Search the closest player\'s inventory')
        local Loadout = NativeUI.CreateItem('Loadout', 'Get gang loadout')
        GangOption:AddItem(Cuff)
        GangOption:AddItem(Drag)
        GangOption:AddItem(Seat)
        GangOption:AddItem(Unseat)
        GangOption:AddItem(Inventory)
        GangOption:AddItem(Loadout)
        Cuff.Activated = function(ParentMenu, SelectedItem)
            local player = GetClosestPlayer()
            if player ~= false then
                TriggerServerEvent('SEM_InteractionMenu:CuffNear', player)
            end
        end
        Drag.Activated = function(ParentMenu, SelectedItem)
            local player = GetClosestPlayer()
            if player ~= false then
                TriggerServerEvent('SEM_InteractionMenu:DragNear', player)
            end
        end
        Seat.Activated = function(ParentMenu, SelectedItem)
            local Veh = GetVehiclePedIsIn(Ped, true)

            local player = GetClosestPlayer()
            if player ~= false then
                TriggerServerEvent('SEM_InteractionMenu:SeatNear', player, Veh)
            end
        end
        Unseat.Activated = function(ParentMenu, SelectedItem)
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                Notify('~o~You need to be outside of the vehicle')
                return
            end

            local player = GetClosestPlayer()
            if player ~= false then
                TriggerServerEvent('SEM_InteractionMenu:UnseatNear', player)
            end
        end
        Inventory.Activated = function(ParentMenu, SelectedItem)
            local player = GetClosestPlayer()
            if player ~= false then
                Notify('~b~Searching ...')
                TriggerServerEvent('SEM_InteractionMenu:InventorySearch', player)
            end
        end
        Loadout.Activated = function(ParentMenu, SelectedItem)
            GiveWeapon("weapon_combatpistol")
            GiveWeapon("weapon_carbinerifle")
            GiveWeapon("weapon_knuckle")
            GiveWeapon("weapon_microsmg")
            GiveWeapon("weapon_flashlight")
            GiveWeapon("weapon_bottle")
        end
  --  end
end

RegisterCommand('gangmenu', function(source, args, rawCommand)
--    if OnDuty == true then
        Menu()
        MainMenu:Visible(true)
--    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _MenuPool:ProcessMenus()
        _MenuPool:ControlDisablingEnabled(false)
        _MenuPool:MouseControlsEnabled(false)
        -- F6
        if IsControlJustPressed(1, 167) and GetLastInputMethod(2) then
            if not menuOpen then
                Menu()
                MainMenu:Visible(true)
            else
                _MenuPool:CloseAllMenus()
            end
        end
    end
end)

function RemoveAnyExistingEmergencyBlips()
	for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(src)))
		if possible_blip ~= 0 then
			RemoveBlip(possible_blip)
			ACTIVE_EMERGENCY_PERSONNEL[src] = nil
		end
	end
end

function RemoveAnyExistingEmergencyBlipsById(id)
		local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(id)))
		if possible_blip ~= 0 then
			RemoveBlip(possible_blip)
			ACTIVE_EMERGENCY_PERSONNEL[id] = nil
		end
end

function GiveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

Citizen.CreateThread(function()
	while true do
		if ACTIVE then
			for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
				local player = GetPlayerFromServerId(src)
				local ped = GetPlayerPed(player)
				if GetPlayerPed(-1) ~= ped then
					if GetBlipFromEntity(ped) == 0 then
						local blip = AddBlipForEntity(ped)
						SetBlipSprite(blip, 1)
						SetBlipColour(blip, info.color)
						SetBlipAsShortRange(blip, true)
						SetBlipDisplay(blip, 4)
						SetBlipShowCone(blip, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(info.name)
						EndTextCommandSetBlipName(blip)
					end
				end
			end
		end
		Wait(1)
	end
end)
