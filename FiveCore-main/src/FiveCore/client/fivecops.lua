-- Source: https://github.com/Sc0ttM/FiveCopsClient/blob/master/client.lua
-- Credits to SEM

--Cuffing Event
local isCuffed = false
RegisterNetEvent('FiveCopsClient:Cuff')
AddEventHandler('FiveCopsClient:Cuff', function()
    local Ped = PlayerPedId()
    if (DoesEntityExist(Ped)) then
        Citizen.CreateThread(function()
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
            end

            if isCuffed then
                isCuffed = false
                Citizen.Wait(500)
                SetEnableHandcuffs(Ped, false)
                ClearPedTasksImmediately(Ped)
            else
                isCuffed = true
                SetEnableHandcuffs(Ped, true)
                TaskPlayAnim(Ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end)
    end
end)

--Cuff Animation & Restructions
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if isCuffed then
            if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 3) then
                TaskPlayAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end

            SetCurrentPedWeapon(PlayerPedId(), 'weapon_unarmed', true)

            if not Config.VehEnterCuffed then
                DisableControlAction(1, 23, true) --F | Enter Vehicle
                DisableControlAction(1, 75, true) --F | Exit Vehicle
            end
            DisableControlAction(1, 140, true) --R
            DisableControlAction(1, 141, true) --Q
            DisableControlAction(1, 142, true) --LMB
            SetPedPathCanUseLadders(GetPlayerPed(PlayerId()), false)
            if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
                DisableControlAction(0, 59, true) --Vehicle Driving
            end
        end
    end
end)

RegisterNetEvent('FiveCopsClient:Seat')
AddEventHandler('FiveCopsClient:Seat', function(Veh)
    local Pos = GetEntityCoords(PlayerPedId())
    local EntityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
    local RayHandle = CastRayPointToPoint(Pos.x, Pos.y, Pos.z, EntityWorld.x, EntityWorld.y, EntityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, VehicleHandle = GetRaycastResult(RayHandle)
    if VehicleHandle ~= nil then
        SetPedIntoVehicle(PlayerPedId(), VehicleHandle, 1)
    end
end)

RegisterNetEvent('FiveCopsClient:Unseat')
AddEventHandler('FiveCopsClient:Unseat', function(ID)
    local Ped = GetPlayerPed(ID)
    ClearPedTasksImmediately(Ped)
    PlayerPos = GetEntityCoords(PlayerPedId(),  true)
    local X = PlayerPos.x - 0
    local Y = PlayerPos.y - 0

    SetEntityCoords(PlayerPedId(), X, Y, PlayerPos.z)
end)

local Drag = false
local OfficerDrag = -1
RegisterNetEvent('FiveCopsClient:Drag')
AddEventHandler('FiveCopsClient:Drag', function(ID)
    Drag = not Drag
    OfficerDrag = ID
    if not Drag then
        DetachEntity(PlayerPedId(), true, false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if Drag then
            local Ped = GetPlayerPed(GetPlayerFromServerId(OfficerDrag))
            local Ped2 = PlayerPedId()
            AttachEntityToEntity(Ped2, Ped, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            DisableControlAction(1, 140, true) --R
            DisableControlAction(1, 141, true) --Q
            DisableControlAction(1, 142, true) --LMB
        end
    end
end)

--Spike Strip Spawn Event
local SpawnedSpikes = {}
RegisterNetEvent('FiveCopsClient:Spikes-SpawnSpikes')
AddEventHandler('FiveCopsClient:Spikes-SpawnSpikes', function(Length)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        exports["mythic_notify"]:DoHudText("error", "You can't use spike strips while in a vehicle")
        return
    end

    local SpawnCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()) , 0.0, 2.0, 0.0)
    for a = 1, Length do
        local Spike = CreateObject(GetHashKey('P_ld_stinger_s'), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, 1, 1, 1)
        local NetID = NetworkGetNetworkIdFromEntity(Spike)
        SetNetworkIdExistsOnAllMachines(NetID, true)
        SetNetworkIdCanMigrate(NetID, false)
        SetEntityHeading(Spike, GetEntityHeading(GetPlayerPed(PlayerId()) ))
        PlaceObjectOnGroundProperly(Spike)
        FreezeEntityPosition(Spike, true)
        SpawnCoords = GetOffsetFromEntityInWorldCoords(Spike, 0.0, 4.0, 0.0)
        table.insert(SpawnedSpikes, NetID)
    end
end)

--Spike Strip Delete Event
RegisterNetEvent('FiveCopsClient:Spikes-DeleteSpikes')
AddEventHandler('FiveCopsClient:Spikes-DeleteSpikes', function()
    for a = 1, #SpawnedSpikes do
        local Spike = NetworkGetEntityFromNetworkId(SpawnedSpikes[a])
        DeleteEntity(Spike)
    end
    exports["mythic_notify"]:DoHudText("success", "Spike strips removed!")
    SpawnedSpikes = {}
end)

--Spike Strip Tire Popping
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(25)

        if IsPedInAnyVehicle(PlayerPedId() , false) then
            local Vehicle = GetVehiclePedIsIn(PlayerPedId() , false)

            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()  then
                local VehiclePos = GetEntityCoords(Vehicle, false)
                local Spike = GetClosestObjectOfType(VehiclePos.x, VehiclePos.y, VehiclePos.z, 2.0, GetHashKey('P_ld_stinger_s'), 1, 1, 1)

                if Spike ~= 0 then
                    local Tires = {
                        {bone = 'wheel_lf', index = 0},
                        {bone = 'wheel_rf', index = 1},
                        {bone = 'wheel_lm', index = 2},
                        {bone = 'wheel_rm', index = 3},
                        {bone = 'wheel_lr', index = 4},
                        {bone = 'wheel_rr', index = 5}
                    }

                    for a = 1, #Tires do
                        local TirePos = GetWorldPositionOfEntityBone(Vehicle, GetEntityBoneIndexByName(Vehicle, Tires[a].bone))
                        local Spike = GetClosestObjectOfType(TirePos.x, TirePos.y, TirePos.z, 2.0, GetHashKey('P_ld_stinger_s'), 1, 1, 1)
                        local SpikePos = GetEntityCoords(Spike, false)
                        local Distance = Vdist(TirePos.x, TirePos.y, TirePos.z, SpikePos.x, SpikePos.y, SpikePos.z)

                        if Distance < 1.8 then
                            if not IsVehicleTyreBurst(Vehicle, Tires[a].index, true) or IsVehicleTyreBurst(Vehicle, Tires[a].index, false) then
                                SetVehicleTyreBurst(Vehicle, Tires[a].index, false, 1000.0)
                            end
                        end
                    end
                end
            end
        end
    end
end)

--Jail
CurrentlyJailed = false
EarlyRelease = false
OriginalJailTime = 0
RegisterNetEvent('FiveCopsClient:JailPlayer')
AddEventHandler('FiveCopsClient:JailPlayer', function(JailTime)
    if CurrentlyJailed then
        return
    end
    if CurrentlyHospitaled then
        return
    end

    OriginalJailTime = JailTime

    local Ped = PlayerPedId()
    if DoesEntityExist(Ped) then
        Citizen.CreateThread(function()
            SetEntityCoords(Ped, Config.JailLocation.Jail.x, Config.JailLocation.Jail.y, Config.JailLocation.Jail.z)
            SetEntityHeading(Ped, Config.JailLocation.Jail.h)
            CurrentlyJailed = true

            while JailTime >= 0 and not EarlyRelease do
                SetEntityInvincible(Ped, true)
                if IsPedInAnyVehicle(Ped, false) then
                    ClearPedTasksImmediately(Ped)
                end

                if JailTime % 30 == 0 and JailTime ~= 0 then
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Judge', JailTime .. ' months until release.'},
                    })
                    exports["mythic_notify"]:DoHudText("inform", JailTime .. ' months until release.')
                end

                Citizen.Wait(1000)

                local Location = GetEntityCoords(Ped, true)
                local Distance = Vdist(Config.JailLocation.Jail.x, Config.JailLocation.Jail.y, Config.JailLocation.Jail.z, Location['x'], Location['y'], Location['z'])
                if Distance > 100 then
                    SetEntityCoords(Ped, Config.JailLocation.Jail.x, Config.JailLocation.Jail.y, Config.JailLocation.Jail.z)
                    SetEntityHeading(Ped, Config.JailLocation.Jail.h)
                    exports["mythic_notify"]:DoHudText("error", "Don't try to escape buddy, it's impossible.")
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Judge', 'Don\'t try escape, its impossible'},
                    })
                end

                JailTime = JailTime - 1
            end

            if EarlyRelease then
                TriggerServerEvent('FiveCops:GlobalChat', {86, 96, 252}, 'Judge', GetPlayerName(PlayerId()) .. ' was released from Jail on Parole')
            else
                TriggerServerEvent('FiveCops:GlobalChat', {86, 96, 252}, 'Judge', GetPlayerName(PlayerId()) .. ' was released from Jail after ' .. OriginalJailTime .. ' months(s).')
            end
            SetEntityCoords(Ped, Config.JailLocation.Release.x, Config.JailLocation.Release.y, Config.JailLocation.Release.z)
            SetEntityHeading(Ped, Config.JailLocation.Release.h)
            CurrentlyJailed = false
            EarlyRelease = false
        end)
    end
end)

RegisterNetEvent('FiveCopsClient:UnjailPlayer')
AddEventHandler('FiveCopsClient:UnjailPlayer', function()
    EarlyRelease = true
end)

--Civilian Adverts
RegisterNetEvent('FiveCopsClient:SyncAds')
AddEventHandler('FiveCopsClient:SyncAds',function(Text, Name, Loc, File, ID)
    Ad(Text, Name, Loc, File, ID)
end)

--Inventory
RegisterNetEvent('FiveCopsClient:InventoryResult')
AddEventHandler('FiveCopsClient:InventoryResult', function(Inventory)
    Citizen.Wait(5000)

    if Inventory ==  nil then
        Inventory = 'Empty'
    end
    exports["mythic_notify"]:DoHudText("inform",'~b~Inventory Items: ~g~' .. Inventory)
end)



--BAC
RegisterNetEvent('FiveCopsClient:BACResult')
AddEventHandler('FiveCopsClient:BACResult', function(BACLevel)
    Citizen.Wait(5000)

    if BACLevel == nil then
        BACLevel = 0.00
    end

    if tonumber(BACLevel) < 0.08 then
        exports["mythic_notify"]:DoHudText("inform", "BAC Level: ".. tostring(BACLevel))
    else
        exports["mythic_notify"]:DoHudText("inform", "BAC Level: ".. tostring(BACLevel))
    end
end)




--Hospital
CurrentlyHospitalized = false
EarlyDischarge = false
OriginalHospitalTime = 0
RegisterNetEvent('FiveCopsClient:HospitalizePlayer')
AddEventHandler('FiveCopsClient:HospitalizePlayer', function(HospitalTime, HospitalLocation)
    if CurrentlyHospitaled then
        return
    end
    if CurrentlyJailed then
        return
    end

    OriginalHospitalTime = HospitalTime

    local Ped = PlayerPedId()
    if DoesEntityExist(Ped) then
        Citizen.CreateThread(function()
            SetEntityCoords(Ped, HospitalLocation.Hospital.x, HospitalLocation.Hospital.y, HospitalLocation.Hospital.z)
            SetEntityHeading(Ped, HospitalLocation.Hospital.h)
            CurrentlyHospitaled = true

            while HospitalTime >= 0 and not EarlyDischarge do
                SetEntityInvincible(Ped, true)
                if IsPedInAnyVehicle(Ped, false) then
                    ClearPedTasksImmediately(Ped)
                end

                if HospitalTime % 30 == 0 and HospitalTime ~= 0 then
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Doctor', HospitalTime .. ' months until release.'},
                    })
                    exports["mythic_notify"]:DoHudText("inform", HospitalTime .. ' months until release.')
                end

                Citizen.Wait(1000)

                local Location = GetEntityCoords(Ped, true)
                local Distance = Vdist(HospitalLocation.Hospital.x, HospitalLocation.Hospital.y, HospitalLocation.Hospital.z, Location['x'], Location['y'], Location['z'])
                if Distance > 30 then
                    SetEntityCoords(Ped, HospitalLocation.Hospital.x, HospitalLocation.Hospital.y, HospitalLocation.Hospital.z)
                    SetEntityHeading(Ped, HospitalLocation.Hospital.h)
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Doctor', 'You cannot discharge yourself!'},
                    })
                    exports["mythic_notify"]:DoHudText("error", 'You cannot discharge yourself!')
                end

                HospitalTime = HospitalTime - 1
            end

            if EarlyDischarge then
                TriggerServerEvent('FiveCops:GlobalChat', {86, 96, 252}, 'Doctor', GetPlayerName(PlayerId()) .. ' was discharged from Hospital early')
            else
                TriggerServerEvent('FiveCops:GlobalChat', {86, 96, 252}, 'Doctor', GetPlayerName(PlayerId()) .. ' was discharged from Hospital after ' .. OriginalHospitalTime .. ' months(s).')
            end
            SetEntityCoords(Ped, HospitalLocation.Release.x, HospitalLocation.Release.y, HospitalLocation.Release.z)
            SetEntityHeading(Ped, HospitalLocation.Release.h)
            CurrentlyHospitaled = false
            EarlyDischarge = false
        end)
    end
end)

RegisterNetEvent('FiveCopsClient:UnhospitalizePlayer')
AddEventHandler('FiveCopsClient:UnhospitalizePlayer', function()
    EarlyDischarge = true
end)

--Station Blips
Citizen.CreateThread(function()
    if Config.DisplayStationBlips then
        local function CreateBlip(x, y, z, Name, Colour, Sprite)
            StationBlip = AddBlipForCoord(x, y, z)
            SetBlipSprite(StationBlip, Sprite)
            if Config.StationBlipsDispalyed == 1 then
                SetBlipDisplay(StationBlip, 3)
            elseif Config.StationBlipsDispalyed == 2 then
                SetBlipDisplay(StationBlip, 5)
            else
                SetBlipDisplay(StationBlip, 2)
            end
            SetBlipScale(StationBlip, 1.0)
            SetBlipColour(StationBlip, Colour)
            SetBlipAsShortRange(StationBlip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Name)
            EndTextCommandSetBlipName(StationBlip)
        end

        for _, Station in pairs(Config.LEOStations) do
            CreateBlip(Station.coords.x, Station.coords.y, Station.coords.z, 'Police Station', 38, 60)
        end
        for _, Station in pairs(Config.FireStations) do
            CreateBlip(Station.coords.x, Station.coords.y, Station.coords.z, 'Fire Station', 1, 60)
        end
        for _, Station in pairs(Config.HospitalStations) do
            CreateBlip(Station.coords.x, Station.coords.y, Station.coords.z, 'Hospital', 2, 61)
        end
    end
end)

RegisterCommand('coords', function(source, args, rawCommand)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())

    TriggerEvent('chatMessage', 'Coords', {255, 255, 0}, '\nX: ' .. Coords.x .. '\nY: ' .. Coords.y .. '\nZ: ' .. Coords.z .. '\nHeading: ' .. Heading)
end)

RegisterNetEvent('FiveCopsClient:Unseat')
AddEventHandler('FiveCopsClient:Unseat', function(ID)
    local Ped = GetPlayerPed(ID)
    ClearPedTasksImmediately(Ped)
    PlayerPos = GetEntityCoords(PlayerPedId(),  true)
    local X = PlayerPos.x - 0
    local Y = PlayerPos.y - 0

    SetEntityCoords(PlayerPedId(), X, Y, PlayerPos.z)
end)

local Drag = false
local OfficerDrag = -1
RegisterNetEvent('FiveCopsClient:Drag')
AddEventHandler('FiveCopsClient:Drag', function(ID)
    Drag = not Drag
    OfficerDrag = ID

    if not Drag then
        DetachEntity(PlayerPedId(), true, false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if Drag then
            local Ped = GetPlayerPed(GetPlayerFromServerId(OfficerDrag))
            local Ped2 = PlayerPedId()
            AttachEntityToEntity(Ped2, Ped, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            DisableControlAction(1, 140, true) --R
            DisableControlAction(1, 141, true) --Q
            DisableControlAction(1, 142, true) --LMB
        end
    end
end)
