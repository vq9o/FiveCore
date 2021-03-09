local Emergency = false
local Admin = false
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/fivecore', 'Open Menu')
    TriggerServerEvent("FiveCore:getIsEmergency")
    TriggerServerEvent("FiveCore:getIsAdmin")
end)
RegisterNetEvent("FiveCore:returnIsEmergency")
RegisterNetEvent("FiveCore:returnIsAdmin")
RegisterNetEvent("FiveCore:Menu")
AddEventHandler("FiveCore:returnIsEmergency", function(bool)
    Emergency = bool
end)
AddEventHandler("FiveCore:returnIsAdmin", function(bool)
    Admin = bool
end)
AddEventHandler("FiveCore:Menu", function(bool)
      Menu:Visible(not Menu:Visible())
end)

_menuPool = NativeUI.CreatePool()
Menu = NativeUI.CreateMenu(GetPlayerName(source), "~b~FiveCore Framework", Config.Orientation)
_menuPool:Add(Menu)
Menu:SetMenuWidthOffset(80)
_menuPool:ControlDisablingEnabled(false)
_menuPool:MouseControlsEnabled(false)

local PlayerMenu = _menuPool:AddSubMenu(Menu, 'Player Options', 'Player Releated Options', true)
PlayerMenu:SetMenuWidthOffset(80)
local VehicleMenu = _menuPool:AddSubMenu(Menu, 'Vehicle Options', 'Vehicle Related Options', true)
VehicleMenu:SetMenuWidthOffset(80)
if Admin == true then
  local AdminMenu = _menuPool:AddSubMenu(Menu, 'Admin Menu', 'Manage Server ~r~WIP', true)
  AdminMenu:SetMenuWidthOffset(80)
end

function PlayerActions()
    local Handsup = NativeUI.CreateItem("Handsup", "Put your hands up")
    local HUK = NativeUI.CreateItem("Handsup & Kneel", "Put your hands up and kneel down")
    local Heal = NativeUI.CreateItem("Heal Player", "Refill your health bar up")
    local Armor = NativeUI.CreateItem("Refill Armor", "Refill your armor bar up")
    local ClearWanted = NativeUI.CreateItem("Clear Wanted Status", "Remove wanted status")
    local AddWanted = NativeUI.CreateItem("Increase Wanted Level", "Increase wanted status")
    local Suicide = NativeUI.CreateItem("~r~Reset Character", "Kills player") --yes, it's reset character, as suicide rp is a serious topic, and shouldn't be roleplayed.
    local Peds = NativeUI.CreateListItem("Change Ped", Config.Peds, 1, "Changes Player Ped")
    local TeleportToWaypoint = NativeUI.CreateItem("Teleport To Waypoint", "Teleports you to your desired waypoint")
    PlayerMenu:AddItem(HUK)
    PlayerMenu:AddItem(Handsup)
    PlayerMenu:AddItem(Heal)
    PlayerMenu:AddItem(Armor)
    PlayerMenu:AddItem(ClearWanted)
    PlayerMenu:AddItem(AddWanted)
    PlayerMenu:AddItem(Suicide)
    PlayerMenu.OnItemSelect = function(sender, item, index)
        if item == TeleportToWaypoint then
            local Waypoint = GetFirstBlipInfoId(8)
            if DoesBlipExist(waypoint) then
                SetEntityCoords(PlayerPedId(), GetBlipInfoIdCoord(waypoint))
                exports["mythic_notify"]:DoHudText("inform", "Teleporting...")
            else
                exports["mythic_notify"]:DoHudText("error", "No waypoint found")
            end
        elseif item == HUK then
            HUKEmote()
        elseif item == Handsup then
            HandsUpEmote()
        elseif item == Armor then
            SetPedArmour(GetPlayerPed(-1), 50)
            exports["mythic_notify"]:DoHudText("success", "Armor Added")
        elseif item == Suicide then
            SetEntityHealth(GetPlayerPed(-1), 0)
            exports["mythic_notify"]:DoHudText("success", "Character died")
        elseif item == ClearWanted then
            if GetPlayerWantedLevel(PlayerId()) ~= 0 then
                SetPlayerWantedLevel(PlayerId(), 0, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
                exports["mythic_notify"]:DoHudText("success", "Wanted level removed")
            else
                exports["mythic_notify"]:DoHudText("error", "You are not wanted")
            end
        elseif item == AddWanted then
            local level = GetPlayerWantedLevel(PlayerId())
            if level < 5 then
                SetPlayerWantedLevel(PlayerId(), level + 1, false)
                SetPlayerWantedLevelNow(PlayerId(), true)
                exports["mythic_notify"]:DoHudText("success", "Wanted level increased")
            else
                exports["mythic_notify"]:DoHudText("error", "You can't go above 5 stars")
            end
        elseif item == Peds then
            local SelectedPed = item:IndexToItem(index)
            LoadModel(SelectedPed)
            exports["mythic_notify"]:DoHudText("success", "Ped Changed")
        end
    end
    if Config.WaypointTeleport == true then
        PlayerMenu:AddItem(TeleportToWaypoint)
    end
    if Config.ChangePed == true then
        PlayerMenu:AddItem(Peds)
    end
    if Config.EmotesMenu == true then
        local EmotesMenu = _menuPool:AddSubMenu(PlayerMenu, "Emotes Menu")
    end
    if Config.WeaponMenu == true then
        WeaponsMenu = _menuPool:AddSubMenu(PlayerMenu, "Weapons Menu", "Weapon Releated Options", true)
        local GunList = NativeUI.CreateListItem("Weapons", Config.Weapons, 1)
        local ClearWeapons = NativeUI.CreateItem("~r~ Clear Weapon(s)", "Removes all Weapons in inventory")
        local GiveAll = NativeUI.CreateItem("~b~Give All Weapons", "Gives all weapons in the server")
        WeaponsMenu:AddItem(ClearWeapons)
        WeaponsMenu:AddItem(GiveAll)
        WeaponMenu.OnListSelect = function(sender, item, index)
            if item == GunList then
                local Gun = item:IndexToItem(index)
                GiveWeapon(Gun)
            elseif item == GiveAll then
                giveWeapon("weapon_knife")
                giveWeapon("weapon_knightstick")
                giveWeapon("weapon_hammer")
                giveWeapon("weapon_bat")
                giveWeapon("weapon_crowbar")
                giveWeapon("weapon_golfclub")
                giveWeapon("weapon_pistol")
                giveWeapon("weapon_combatpistol")
                giveWeapon("weapon_appistol")
                giveWeapon("weapon_pistol50")
                giveWeapon("weapon_microsmg")
                giveWeapon("weapon_smg")
                giveWeapon("weapon_assaultsmg")
                giveWeapon("weapon_assaultrifle")
                giveWeapon("weapon_carbinerifle")
                giveWeapon("weapon_advancedrifle")
                giveWeapon("weapon_pumpshotgun")
                giveWeapon("weapon_fireextinguisher")
                giveWeapon("weapon_flare")
                giveWeapon("weapon_snspistol")
                giveWeapon("weapon_heavypistol")
                giveWeapon("weapon_bullpuprifle")
                giveWeapon("weapon_dagger")
                giveWeapon("weapon_vintagepistol")
                giveWeapon("weapon_firework")
                giveWeapon("weapon_flaregun")
                giveWeapon("weapon_marksmanpistol")
                giveWeapon("weapon_knuckle")
                giveWeapon("weapon_hatchet")
                giveWeapon("weapon_switchblade")
                giveWeapon("weapon_revolver")
                giveWeapon("weapon_battleaxe")
                giveWeapon("weapon_minismg")
                giveWeapon("weapon_poolcue")
                giveWeapon("weapon_wrench")
                exports["mythic_notify"]:DoHudText("success", "Weapons Added")
            elseif item == ClearWeapons then
                RemoveAllPedWeapons(GetPlayerPed(-1), true)
                exports["mythic_notify"]:DoHudText("success", "Weapons Removed")
            end
        end
    end
end

function VehicleSpawner()
    if Config.VehicleSpawner == true then
        VehicleSpawner = _menuPool:AddSubMenu(VehicleMenu, "Vehicle Spawner", "Spawn Vehicles", true)
        local EmergencyVehicles = NativeUI.CreateListItem("Spawn Emergency", Config.EmergencyVehicles, 1)
        local RegularVehicles = NativeUI.CreateListItem("Spawn Vehicle", Config.Vehicles, 1)
        VehicleSpawner.OnListSelect = function(sender, item, index)
            if item == EmergencyVehicles then
                if Emergency then
                    exports['mythic_notify']:DoHudText('inform', "Spawning Vehicle...")
                    local Vehicle = item:IndexToItem(index)
                    SpawnVehicle(Vehicle)
                    Citizen.Wait(1)
                else
                    exports['mythic_notify']:DoHudText('error', "You're not a emergency worker, you can't use this.")
                end
            elseif item == RegularVehicles then
                exports['mythic_notify']:DoHudText('inform', "Spawning Vehicle...")
                local Vehicle = item:IndexToItem(index)
                SpawnVehicle(Vehicle)
                Citizen.Wait(1)
            end
        end
    end
end

function VehicleManager()
    --  local VehicleManagement = _menuPool:AddSubMenu(VehicleMenu, "Vehicle Menu", "Vehicle Options", true)
    local hood = NativeUI.CreateItem("Toggle Vehicle Hood", "Toggles Vehicle's Hood")
    local trunk = NativeUI.CreateItem("Toggle Trunk", "Toggles Vehicle's Trunk")
    local door1 = NativeUI.CreateItem("Toggle Passenger Door", "Opens Front Right Door")
    local door2 = NativeUI.CreateItem("Toggle Driver Door", "Opens Front Left Door")
    local door3 = NativeUI.CreateItem("Toggle Rear Left Door", "Opens Rear Left Door")
    local door4 = NativeUI.CreateItem("Toggle Rear Right Door", "Opens Rear Right Door")
    local engine = NativeUI.CreateItem("Toggle Engine", "Toggles Vehicle's Engine")
    local repaircar = NativeUI.CreateItem("Fix Vehicle", "Repairs Vehicle")
    local cleancar = NativeUI.CreateItem("Clean Vehicle", "Cleans Vehicle")
    local deletecar = NativeUI.CreateItem("~r~Delete Vehicle", "Deletes Vehicle or use F9")
    VehicleMenu:AddItem(engine)
    VehicleMenu:AddItem(door2)
    VehicleMenu:AddItem(door1)
    VehicleMenu:AddItem(door3)
    VehicleMenu:AddItem(door4)
    VehicleMenu:AddItem(hood)
    VehicleMenu:AddItem(trunk)
    VehicleMenu:AddItem(repaircar)
    VehicleMenu:AddItem(cleancar)
    VehicleMenu:AddItem(deletecar)
    local VehicleSeats = {-1, 0, 1, 2}
    local Seat = NativeUI.CreateSliderItem("Change Seat", VehicleSeats, 1)
    VehicleMenu:AddItem(Seat)
    VehicleMenu.OnSliderChange = function(sender, item, index)
        if item == Seat then
            VehicleSeat = item:IndexToItem(index)
            local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetPedIntoVehicle(PlayerPedId(), Vehicle, VehicleSeat)
            exports["mythic_notify"]:DoHudText("success", "Seat changed")
        end
    end
    VehicleMenu.OnItemSelect = function(sender, item, index)
        if item == engine then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
            end
        elseif item == repaircar then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleEngineHealth(vehicle, 0)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleFixed(vehicle)
        elseif item == cleancar then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleDirtLevel(vehicle, 0)
        elseif item == deletecar then
            local ped = GetPlayerPed(-1)
            if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
                local pos = GetEntityCoords(ped)
                if (IsPedSittingInAnyVehicle(ped)) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        deleteCar(vehicle)
                        if (DoesEntityExist(vehicle)) then
                            exports["mythic_notify"]:DoHudText("error", "Failed to delete vehicle, please try again.")
                        else
                            exports["mythic_notify"]:DoHudText("success", "Vehicle Deleted")
                        end
                    else
                        exports["mythic_notify"]:DoHudText("error", "You must be the driver of the vehicle")
                    end
                else
                    local playerPos = GetEntityCoords(ped, 1)
                    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(ped, 0.0, distanceToCheck, 0.0)
                    local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
                    if (DoesEntityExist(vehicle)) then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        deleteCar(vehicle)
                        if (DoesEntityExist(vehicle)) then
                            exports["mythic_notify"]:DoHudText("error", "Failed to delete vehicle, please try again.")
                        else
                            exports["mythic_notify"]:DoHudText("success", "Vehicle Deleted")
                        end
                    else
                        exports["mythic_notify"]:DoHudText("error", "You must be the driver of the vehicle")
                    end
                end
            end
        elseif item == engine then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
                exports["mythic_notify"]:DoHudText("success", "Engine Toggled")
            else
                exports["mythic_notify"]:DoHudText("error", "Failed to toggle engine")
            end
        elseif item == door1 then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= nil and veh ~= 0 and veh ~= 1 then
                if GetVehicleDoorAngleRatio(veh, 1) > 0 then
                    SetVehicleDoorShut(veh, 1, false)
                else
                    SetVehicleDoorOpen(veh, 1, false, false)
                end
            end
        else
            if item == door2 then
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped, false)
                if veh ~= nil and veh ~= 0 and veh ~= 1 then
                    if GetVehicleDoorAngleRatio(veh, 0) > 0 then
                        SetVehicleDoorShut(veh, 0, false)
                    else
                        SetVehicleDoorOpen(veh, 0, false, false)
                    end
                end
            else
                if item == door3 then
                    local ped = PlayerPedId()
                    local veh = GetVehiclePedIsIn(ped, false)
                    if veh ~= nil and veh ~= 0 and veh ~= 1 then
                        if GetVehicleDoorAngleRatio(veh, 2) > 0 then
                            SetVehicleDoorShut(veh, 2, false)
                        else
                            SetVehicleDoorOpen(veh, 2, false, false)
                        end
                    end
                else
                    if item == door4 then
                        local ped = PlayerPedId()
                        local veh = GetVehiclePedIsIn(ped, false)
                        if veh ~= nil and veh ~= 0 and veh ~= 1 then
                            if GetVehicleDoorAngleRatio(veh, 3) > 0 then
                                SetVehicleDoorShut(veh, 3, false)
                            else
                                SetVehicleDoorOpen(veh, 3, false, false)
                            end
                        end
                    else
                        if item == hood then
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsIn(ped, false)
                            if veh ~= nil and veh ~= 0 and veh ~= 1 then
                                if GetVehicleDoorAngleRatio(veh, 4) > 0 then
                                    SetVehicleDoorShut(veh, 4, false)
                                else
                                    SetVehicleDoorOpen(veh, 4, false, false)
                                end
                            end
                        else
                            if item == trunk then
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh ~= nil and veh ~= 0 and veh ~= 1 then
                                    if GetVehicleDoorAngleRatio(veh, 5) > 0 then
                                        SetVehicleDoorShut(veh, 5, false)
                                    else
                                        SetVehicleDoorOpen(veh, 5, false, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- :/
PlayerActions()
VehicleSpawner()
VehicleManager()

_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, Config.MenuButton) then
            Menu:Visible(not Menu:Visible())
        end
    end
end)
