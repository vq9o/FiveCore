function Chat(src, msg)
    TriggerClientEvent("chatMessage", src, "[FiveCore] " .. msg)
end

function GetClosestPlayer()
    local Ped = PlayerPedId()
    for _, Player in ipairs(GetActivePlayers()) do
        if GetPlayerPed(Player) ~= GetPlayerPed(-1) then
            local Ped2 = GetPlayerPed(Player)
            local x, y, z = table.unpack(GetEntityCoords(Ped))
            if (GetDistanceBetweenCoords(GetEntityCoords(Ped2), x, y, z) < 2) then
                return GetPlayerServerId(Player)
            end
        end
    end
    exports["mythic_notify"]:DoHudText("error", "No player found")
    return false
end

function GiveWeapon(Hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(Hash), 999, false)
    exports["mythic_notify"]:DoHudText("success", "Gave Weapon " .. Hash .. "!")
end

function SpawnVehicle(VehicleHash)
    exports["mythic_notify"]:DoHudText("success", "Spawned " .. VehicleHash .. "!")
    local Vehicle = GetHashKey(Vehicle)
    RequestModel(Vehicle)
    while not HasModelLoaded(Vehicle) do
        RequestModel(Vehicle)
        exports["mythic_notify"]:DoHudText(
            "inform",
            "Attempting to load model " .. VehicleHash .. ". Please wait a few moments..."
        )
        Citizen.Wait(50)
    end
end

function RemoveVehicle(entity)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
end

function ShowNotification(message)
    exports["mythic_notify"]:DoHudText("inform", message)
end

function HandsUpEmote()
    local lPed = GetPlayerPed(-1)
    if DoesEntityExist(lPed) and not IsPedInAnyVehicle(lPed) then
        if not IsEntityPlayingAnim(lPed, "mp_arresting", "idle", 3) then
            RequestAnimDict("random@mugging3")
            while not HasAnimDictLoaded("random@mugging3") do
                Citizen.Wait(50)
            end

            if IsEntityPlayingAnim(lPed, "random@mugging3", "handsup_standing_base", 3) then
                ClearPedSecondaryTask(lPed)
            else
                TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end
    elseif IsPedInAnyVehicle(lPed) then
        ShowNotification("Please exit the vehicle to be avail to use this animation.")
    end
end

function HUKEmote()
    local player = GetPlayerPed(-1)
    if (DoesEntityExist(player) and not IsEntityDead(player)) and not IsPedInAnyVehicle(player) then
        loadAnimDict("random@arrests")
        loadAnimDict("random@arrests@busted")
        if (IsEntityPlayingAnim(player, "random@arrests@busted", "idle_a", 3)) then
            TaskPlayAnim(player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(50)
            TaskPlayAnim(player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0)
        else
            TaskPlayAnim(player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(75)
            TaskPlayAnim(player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(500)
            TaskPlayAnim(player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(500)
            TaskPlayAnim(player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
        end
    elseif IsPedInAnyVehicle(player) then
        ShowNotification("Please exit the vehicle to be avail to use this animation.")
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function LoadModel(modelHash)
    local model = GetHashKey(modelHash)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(localPed, model)
    SetModelAsNoLongerNeeded(model)
end
