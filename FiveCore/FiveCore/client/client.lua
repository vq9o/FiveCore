local Emergency = false
local Admin = false
local SecondsUntilKick = 0
SecondsUntilKick = Config.AFKTime
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/fivecore', 'Open Menu')
    TriggerServerEvent("FiveCore:getIsEmergency")
    TriggerServerEvent("FiveCore:getIsAdmin")
    while true do
        Wait(1000)
        PlayerPed = GetPlayerPed(-1)
        if PlayerPed then
            CurrentPos = GetEntityCoords(PlayerPed, true)
            if CurrentPos == PrevPos then
                if time > 0 then
                    if Config.KickWarning and time == math.ceil(SecondsUntilKick / 4) then
                        if Config.AFKKick then
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          exports["mythic_notify"]:DoHudText("error", "MOVE IN ".. time .." SECONDS OR YOU WILL BE KICKED FOR BEING AFK TOO LONG")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
                          -- that should scare them lol
                        end
                    end

                    time = time - 1
                else
                    if Config.AFKKick == true then
                        TriggerServerEvent("FiveCore:AFKBoot")
                    end
                end
            else
                time = SecondsUntilKick
            end
            PrevPos = currentPos
        end
        TriggerServerEvent("FiveCore:PingPonglol")
    end
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
    local AdminMenu = _menuPool:AddSubMenu(Menu, "Server Settings", "Manage Server")
    AdminMenu:SetMenuWidthOffset(80)
    local Players = _menuPool:AddSubMenu(AdminMenu, "Online Players", "Manage players")
    Players.Activated = function()
      exports["mythic_notify"]:DoHudText("error", "Manage players is not completed")
    end
    local Unjail = NativeUI.CreateItem("Unjail", "Unjail a player")
    AdminMenu:AddItem(Unjail)
    local Peacetime = _menuPool:AddSubMenu(AdminMenu, "Peacetime", "Activate peacetime")
    Peacetime:SetMenuWidthOffset(80)
    Peacetime.Activated = function()
    TriggerServerEvent("FiveCore:Peacetime")
    end
    local Announce = _menuPool:AddSubMenu(AdminMenu, "Announce", "Create Server Announcement")
    Announce:SetMenuWidthOffset(80)
    Announce.Activated = function()
      local Announcement = tonumber(KeyboardInput('Message'))
      if Announcement == nil then
          exports["mythic_notify"]:DoHudText("error", "Must choose your announcement to say")
          return
        else
          TriggerServerEvent("FiveCore:Announce", table.concat(Announcement, " ");)
      end
    end
    local AOP = _menuPool:AddSubMenu(AdminMenu, "Area Of Play", "Change Area Of Play")
    AOP:SetMenuWidthOffset(80)
    AOP.Activated = function()
      local ChoosenAOP = tonumber(KeyboardInput('Area Of Play'))
      if ChoosenAOP == nil then
          exports["mythic_notify"]:DoHudText("error", "Must choose a area of play")
          return
        else
          TriggerServerEvent("FiveCore:AOP", ChoosenAOP)
      end
    end
    local Revive = _menuPool:AddSubMenu(AdminMenu, "Revive Player", "Revive an player")
    Revive:SetMenuWidthOffset(80)
    Revive.Activated = function()
      local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
      if PlayerID == nil then
          exports["mythic_notify"]:DoHudText("error", "You need to enter a player id")
          return
        else
          TriggerServerEvent("FiveCore:Revive", PlayerID)
      end
    end
    local Respawn = _menuPool:AddSubMenu(AdminMenu, "Respawn Player", "Respawn an player")
    Respawn:SetMenuWidthOffset(80)
    Respawn.Activated = function()
      local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
      if PlayerID == nil then
          exports["mythic_notify"]:DoHudText("error", "You need to enter a player id")
          return
        else
          TriggerServerEvent("FiveCore:Respawn", PlayerID)
      end
    end
end


function ResponderMenu()
    local FirstResponderMenu = _menuPool:AddSubMenu(Menu, 'First Responders', 'Police & Fire Related Options', true)
    FirstResponderMenu:SetMenuWidthOffset(80)
    local LEOActions = _menuPool:AddSubMenu(FirstResponderMenu, 'Police', 'Law Enforcement Actions', true)
    LEOActions:SetMenuWidthOffset(80)
    local FireActions = _menuPool:AddSubMenu(FirstResponderMenu, 'Fire & EMS', 'Fire & EMS Actions', true)
    FireActions:SetMenuWidthOffset(80)
    local Cuff = NativeUI.CreateItem("Cuff", "Cuff closest player")
    local Drag = NativeUI.CreateItem("Drag", "Drag closest player")
    local Dragv2 = NativeUI.CreateItem("Drag", "Drag closest player")
    local Undragv2 = NativeUI.CreateItem("Undrag", "Undrag closest player")
    local SeatPed = NativeUI.CreateItem("Seat", "Seat closest player")
    local SeatPedv2 = NativeUI.CreateItem("Seat", "Seat closest player")
    local Unseatv2 = NativeUI.CreateItem("Unseat", "Unseat closest player")
    local Unseat = NativeUI.CreateItem("Unseat", "Unseat closest player")
    local Spikes = NativeUI.CreateItem("Deploy Spikes", "Deploy Spikes")
    local RemoveSpikes = NativeUI.CreateItem("Remove Spikes", "Remove Spikes")
    local Inventory = NativeUI.CreateItem('Inventory', 'Search the closest player\'s inventory')
    local BAC = NativeUI.CreateItem('BAC', 'Test the BAC level of the closest player')
    local Jail = NativeUI.CreateItem('Jail', 'Jail a player')
    local Unjail = NativeUI.CreateItem('Unjail', 'Unjail a player')
    local Shield = NativeUI.CreateItem('Toggle Shield', 'Toggle the bulletproof shield')
    PropsList = {}
    for _, Prop in pairs(Config.Props) do
        table.insert(PropsList, Prop.name)
    end
    local Props = NativeUI.CreateListItem('Spawn Props', PropsList, 1, 'Spawn props on the ground')
    local RemoveProps = NativeUI.CreateItem('Remove Props', 'Remove the closest prop')
    local Propsv2 = NativeUI.CreateListItem('Spawn Props', PropsList, 1, 'Spawn props on the ground')
    local RemovePropsv2 = NativeUI.CreateItem('Remove Props', 'Remove the closest prop')
    LEOActions:AddItem(Cuff)
    LEOActions:AddItem(Drag)
    LEOActions:AddItem(SeatPed)
    LEOActions:AddItem(Unseat)
    LEOActions:AddItem(Inventory)
    LEOActions:AddItem(BAC)
    LEOActions:AddItem(Spikes)
    LEOActions:AddItem(DelSpikes)
    LEOActions:AddItem(Shield)
    LEOActions:AddItem(Jail)
    if Admin == true then
        LEOActions:AddItem(Unjail)
    end
    LEOActions:AddItem(Props)
    LEOActions:AddItem(RemoveProps)

    FireActions:AddItem(Dragv2)
    FireActions:AddItem(SeatPedv2)
    FireActions:AddItem(Unseatv2)
    FireActions:AddItem(Propsv2)
    FireActions:AddItem(RemovePropsv2)

    Cuff.Activated = function(ParentMenu, SelectedItem)
        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('FiveCops:Cuff', player)
        end
    end
    Drag.Activated = function(ParentMenu, SelectedItem)
        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('FiveCops:Drag', player)
        end
    end
    SeatPed.Activated = function(ParentMenu, SelectedItem)
        local Vehicle = GetVehiclePedIsIn(Ped, true)
        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('FiveCops:Seat', player, Veh)
        end
    end
    Unseat.Activated = function(ParentMenu, SelectedItem)
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            exports["mythic_notify"]:DoHudText("error", "You need to be outside a vehicle")
            return
        end

        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('FiveCops:Unseat', player)
        end
    end
    BAC.Activated = function(ParentMenu, SelectedItem)
        local player = GetClosestPlayer()
        if player ~= false then
            exports["mythic_notify"]:DoHudText("inform", "Testing...")
            TriggerServerEvent('FiveCops:BACTest', player)
        end
    end
    Jail.Activated = function(ParentMenu, SelectedItem)
        local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
        if PlayerID == nil then
            exports["mythic_notify"]:DoHudText("error", "You need to enter a player id")
            return
        end

        local JailTime = tonumber(KeyboardInput('Time: (Seconds) - Max Time: ' .. Config.MaxJailTime .. ' | Default Time: 30', string.len(Config.MaxJailTime)))
        if JailTime == nil then
            JailTime = 30
        end
        if JailTime > Config.MaxJailTime then
            exports["mythic_notify"]:DoHudText("error", '~y~Exceeded Max Time\nMax Time: ' .. Config.MaxJailTime .. ' seconds')
            JailTime = Config.MaxJailTime
        end
        exports["mythic_notify"]:DoHudText("error", "Player jailed for ".. JailTime .." Months(seconds)")
        TriggerServerEvent('FiveCops:Jail', PlayerID, JailTime)
    end
    Unjail.Activated = function(ParentMenu, SelectedItem)
        local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
        if PlayerID == nil then
            exports["mythic_notify"]:DoHudText("error", "You need to enter a player id")
            return
        end

        TriggerServerEvent('FiveCops:Unjail', PlayerID)
    end
    DelSpikes.Activated = function(ParentMenu, SelectedItem)
        TriggerEvent('FiveCops:Spikes-DeleteSpikes')
    end
    Shield.Activated = function(ParentMenu, SelectedItem)
        if ShieldActive then
            DisableShield()
        else
            EnableShield()
        end
    end
    FirstResponderMenu.OnListSelect = function(sender, item, index)
        if item == Spikes then
            TriggerEvent('FiveCops:Spikes-SpawnSpikes', tonumber(index))
        elseif item == Props then
            for _, Prop in pairs(Config.Props) do
                if Prop.name == item:IndexToItem(index) then
                    SpawnProp(Prop.spawncode, Prop.name)
                end
            end
        end
    end
    RemoveProps.Activated = function(ParentMenu, SelectedItem)
        for _, Prop in pairs(Config.Props) do
            DeleteProp(Prop.spawncode)
        end
    end
    if Config.ShowStations then
        local LEOStation = _menuPool:AddSubMenu(FirstResponderMenu, 'Stations', '', true)
        LEOStation:SetMenuWidthOffset(Config.MenuWidth)
        for _, Station in pairs(Config.LEOStations) do
            local StationCategory = _menuPool:AddSubMenu(LEOStation, Station.name, '', true)
            StationCategory:SetMenuWidthOffset(Config.MenuWidth)
            local SetWaypoint = NativeUI.CreateItem('Set Waypoint', 'Set a waypoint to the station')
            local Teleport = NativeUI.CreateItem('Teleport', 'Teleport to the station')
            StationCategory:AddItem(SetWaypoint)
            if Config.AllowStationTeleport then
                StationCategory:AddItem(Teleport)
            end
            SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                SetNewWaypoint(Station.coords.x, Station.coords.y)
            end
            Teleport.Activated = function(ParentMenu, SelectedItem)
                SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                SetEntityHeading(PlayerPedId(), Station.coords.h)
            end
        end
    end
    if Config.DisplayTrafficManager then
        local LEOTrafficManager = _menuPool:AddSubMenu(FirstResponderMenu, 'Traffic Manager', '', true)
        LEOTrafficManager:SetMenuWidthOffset(Config.MenuWidth)

        TMSize = 10.0
        TMSpeed = 0.0
        RaduiesNames = {}
        Raduies = {
            {name = '10m', size = 10.0},
            {name = '20m', size = 20.0},
            {name = '30m', size = 30.0},
            {name = '40m', size = 40.0},
            {name = '50m', size = 50.0},
            {name = '60m', size = 60.0},
            {name = '70m', size = 70.0},
            {name = '80m', size = 80.0},
            {name = '90m', size = 90.0},
            {name = '100m', size = 100.0},
        }
        SpeedsNames = {}
        Speeds = {
            {name = '0 mph', speed = 0.0},
            {name = '5 mph', speed = 5.0},
            {name = '10 mph', speed = 10.0},
            {name = '15 mph', speed = 15.0},
            {name = '20 mph', speed = 20.0},
            {name = '25 mph', speed = 25.0},
            {name = '30 mph', speed = 30.0},
            {name = '40 mph', speed = 40.0},
            {name = '50 mph', speed = 50.0},
        }

        for _, RaduisInfo in pairs(Raduies) do
            table.insert(RaduiesNames, RaduisInfo.name)
        end
        for _, SpeedsInfo in pairs(Speeds) do
            table.insert(SpeedsNames, SpeedsInfo.name)
        end

        local Radius = NativeUI.CreateListItem('Radius', RaduiesNames, 1, '')
        local Speed = NativeUI.CreateListItem('Speed', SpeedsNames, 1, '')
        local TMCreate = NativeUI.CreateItem('Create Speed Zone', '')
        local TMDelete = NativeUI.CreateItem('Delete Speed Zone', '')
        LEOTrafficManager:AddItem(Radius)
        LEOTrafficManager:AddItem(Speed)
        LEOTrafficManager:AddItem(TMCreate)
        LEOTrafficManager:AddItem(TMDelete)
        Radius.OnListChanged = function(sender, item, index)
            TMSize = Raduies[index].size
        end
        Speed.OnListChanged = function(sender, item, index)
            TMSpeed = Speeds[index].speed
        end
        TMCreate.Activated = function(ParentMenu, SelectedItem)
            if Zone == nil then
                Zone = AddSpeedZoneForCoord(GetEntityCoords(PlayerPedId()), TMSize, TMSpeed, false)
                Area = AddBlipForRadius(GetEntityCoords(PlayerPedId()), TMSize)
                SetBlipAlpha(Area, 100)
                Notify('Speed Zone Created')
            else
                Notify('You already have a Speed Zone created')
            end
        end
        TMDelete.Activated = function(ParentMenu, SelectedItem)
            if Zone ~= nil then
                RemoveSpeedZone(Zone)
                RemoveBlip(Area)
                Zone = nil
                Notify('Speed Zone Deleted')
            else
                Notify('You don\'t have a Speed Zone')
            end
        end
    end
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
    local CivAdverts = _menuPool:AddSubMenu(PlayerMenu, 'Advertisements', '', true)
    CivAdverts:SetMenuWidthOffset(80)
    for _, Ad in pairs(Config.CivAdverts) do
        local Advert  = NativeUI.CreateItem(Ad.name, 'Send an advert for ' .. Ad.name)
        CivAdverts:AddItem(Advert)
        Advert.Activated = function(ParentMenu, SelectedItem)
            local Message = KeyboardInput('Message:', 128)
            if Message == nil or Message == '' then
                Notify('No Advert Message Provided!')
                return
            end

            TriggerServerEvent('FiveCops:Ads', Message, Ad.name, Ad.loc, Ad.file)
        end
    end
    HUK.Activated = function(ParentMenu, SelectedItem)
        HUKEmote()
    end
    Handsup.Activated = function(ParentMenu, SelectedItem)
        HandsUpEmote()
    end
    Heal.Activated = function(ParentMenu, SelectedItem)
        SetEntityHealth(PlayerPedId(), 200)
        exports["mythic_notify"]:DoHudText("success", "Health Refilled")
    end
    Armor.Activated = function(ParentMenu, SelectedItem)
        SetPedArmour(GetPlayerPed(-1), 50)
        exports["mythic_notify"]:DoHudText("success", "Armor Refilled")
    end
    ClearWanted.Activated = function(ParentMenu, SelectedItem)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            exports["mythic_notify"]:DoHudText("success", "Wanted level removed")
        else
            exports["mythic_notify"]:DoHudText("error", "You are not wanted")
        end
    end
    AddWanted.Activated = function(ParentMenu, SelectedItem)
        local level = GetPlayerWantedLevel(PlayerId())
        if level < 5 then
            SetPlayerWantedLevel(PlayerId(), level + 1, false)
            SetPlayerWantedLevelNow(PlayerId(), true)
            exports["mythic_notify"]:DoHudText("success", "Wanted level increased")
        else
            exports["mythic_notify"]:DoHudText("error", "You can't go above 5 stars")
        end
    end
    Suicide.Activated = function(ParentMenu, SelectedItem)
        SetEntityHealth(GetPlayerPed(-1), 0)
        exports["mythic_notify"]:DoHudText("success", "Character died")
    end
    TeleportToWaypoint.Activated = function(ParentMenu, SelectedItem)
        local Waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            SetEntityCoords(PlayerPedId(), GetBlipInfoIdCoord(waypoint))
            exports["mythic_notify"]:DoHudText("inform", "Teleporting...")
        else
            exports["mythic_notify"]:DoHudText("error", "No waypoint found")
        end
    end
    PlayerMenu.OnItemSelect = function(sender, item, index)
        if item == Peds then
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
        ClearWeapons.Activated = function(ParentMenu, SelectedItem)
            RemoveAllPedWeapons(GetPlayerPed(-1), true)
            exports["mythic_notify"]:DoHudText("success", "Weapons Removed")
        end
        GiveAll.Activated = function(ParentMenu, SelectedItem)
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
        end
        WeaponMenu.OnListSelect = function(sender, item, index)
            if item == GunList then
                local Gun = item:IndexToItem(index)
                GiveWeapon(Gun)
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
    local VehicleSeats = {-1, 0, 1, 2}
    local lock = NativeUI.CreateItem("Lock Vehicle", "Lock Vehicle")
    local unlock = NativeUI.CreateItem("Unlock Vehicle", "Unlock Vehicle")
    local hood = NativeUI.CreateItem("Toggle Vehicle Hood", "Toggles Vehicle's Hood")
    local trunk = NativeUI.CreateItem("Toggle Trunk", "Toggles Vehicle's Trunk")
    local door1 = NativeUI.CreateItem("Toggle Passenger Door", "Opens Front Right Door")
    local door2 = NativeUI.CreateItem("Toggle Driver Door", "Opens Front Left Door")
    local door3 = NativeUI.CreateItem("Toggle Rear Left Door", "Opens Rear Left Door")
    local door4 = NativeUI.CreateItem("Toggle Rear Right Door", "Opens Rear Right Door")
    local engine = NativeUI.CreateItem("Toggle Engine", "Toggles Vehicle's Engine")
    local repaircar = NativeUI.CreateItem("Fix Vehicle", "Repairs Vehicle")
    local cleancar = NativeUI.CreateItem("Clean Vehicle", "Cleans Vehicle")
    local deletecar = NativeUI.CreateItem("~r~Delete Vehicle", "Deletes Vehicle")
    local seat = NativeUI.CreateSliderItem("Change Seat", VehicleSeats, 1)
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
    VehicleMenu:AddItem(lock)
    VehicleMenu:AddItem(unlock)
    VehicleMenu:AddItem(Seat)
    lock.Activated = function(ParentMenu, SelectedItem)
        exports["mythic_notify"]:DoHudText("error", "This feature isn't completed")
    end
    unlock.Activated = function(ParentMenu, SelectedItem)
        exports["mythic_notify"]:DoHudText("error", "This feature isn't completed")
    end
    VehicleMenu.OnSliderChange = function(sender, item, index)
        if item == seat then
            VehicleSeat = item:IndexToItem(index)
            local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetPedIntoVehicle(PlayerPedId(), Vehicle, VehicleSeat)
            exports["mythic_notify"]:DoHudText("success", "Seat changed")
        end
    end
    engine.Activated = function(ParentMenu, SelectedItem)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
            SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
            exports["mythic_notify"]:DoHudText("success", "Engine Toggled")
        else
            exports["mythic_notify"]:DoHudText("error", "Failed to toggle engine")
        end
    end
    repaircar.Activated = function(ParentMenu, SelectedItem)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleEngineHealth(vehicle, 0)
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleFixed(vehicle)
    end
    cleancar.Activated = function(ParentMenu, SelectedItem)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleDirtLevel(vehicle, 0)
    end
    deletecar.Activated = function(ParentMenu, SelectedItem)
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
    end
    door1.Activated = function(ParentMenu, SelectedItem)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= nil and veh ~= 0 and veh ~= 1 then
            if GetVehicleDoorAngleRatio(veh, 1) > 0 then
                SetVehicleDoorShut(veh, 1, false)
            else
                SetVehicleDoorOpen(veh, 1, false, false)
            end
        end
    end
    door2.Activated = function(ParentMenu, SelectedItem)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= nil and veh ~= 0 and veh ~= 1 then
            if GetVehicleDoorAngleRatio(veh, 0) > 0 then
                SetVehicleDoorShut(veh, 0, false)
            else
                SetVehicleDoorOpen(veh, 0, false, false)
            end
        end
    end
    door3.Activated = function(ParentMenu, SelectedItem)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= nil and veh ~= 0 and veh ~= 1 then
            if GetVehicleDoorAngleRatio(veh, 2) > 0 then
                SetVehicleDoorShut(veh, 2, false)
            else
                SetVehicleDoorOpen(veh, 2, false, false)
            end
        end
    end
    door4.Activated = function(ParentMenu, SelectedItem)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= nil and veh ~= 0 and veh ~= 1 then
            if GetVehicleDoorAngleRatio(veh, 3) > 0 then
                SetVehicleDoorShut(veh, 3, false)
            else
                SetVehicleDoorOpen(veh, 3, false, false)
            end
        end
    end
    hood.Activated = function(ParentMenu, SelectedItem)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= nil and veh ~= 0 and veh ~= 1 then
            if GetVehicleDoorAngleRatio(veh, 4) > 0 then
                SetVehicleDoorShut(veh, 4, false)
            else
                SetVehicleDoorOpen(veh, 4, false, false)
            end
        end
    end
    trunk.Activated = function(ParentMenu, SelectedItem)
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

-- :/
PlayerActions()
VehicleSpawner()
VehicleManager()

if Config.FirstResponderMenu == true then
    FirstResponderMenu()
end

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
