function Chat(src, msg)
    TriggerClientEvent("chatMessage", src, "[FiveCore] " .. msg)
end

function LoadAnimation(Dict)
    while not HasAnimDictLoaded(Dict) do
        RequestAnimDict(Dict)
        Citizen.Wait(5)
    end
end

function KeyboardInput(TextEntry, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', '', '', '', '', MaxStringLenght)
    BlockInput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local Result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        BlockInput = false
        return Result
    else
        Citizen.Wait(500)
        BlockInput = false
        return nil
    end
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

-- got lazy again
function Notify(message)
    ShowNotification(message)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function PlayEmote(Emote, Name)
    if not DoesEntityExist(GetPlayerPed(-1)) then
        return
    end

    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        ShowNotification('Please exit the vehicle to use this emote!')
        return
    end

    TaskStartScenarioInPlace(GetPlayerPed(-1), Emote, 0, true)
    ShowNotification('~b~Playing Emote: ~g~' .. Name)
    EmotePlaying = true
end

function CancelEmote()
    ClearPedTasks(GetPlayerPed(-1))
    ShowNotification('~r~Stopping Emote')
    EmotePlaying = false
end

function DeleteEntity(Entity)
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(Entity))
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

function EnableShield()
    ShieldActive = true
    local Ped = GetPlayerPed(-1)
    local PedPos = GetEntityCoords(Ped, false)

    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        Notify('~r~You cannot be in a vehicle when getting your shield out!')
        ShieldActive = false
        return
    end

    RequestAnimDict('combat@gestures@gang@pistol_1h@beckon')
    while not HasAnimDictLoaded('combat@gestures@gang@pistol_1h@beckon') do
        Citizen.Wait(100)
    end

    TaskPlayAnim(Ped, 'combat@gestures@gang@pistol_1h@beckon', '0', 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

    RequestModel(GetHashKey('prop_ballistic_shield'))
    while not HasModelLoaded(GetHashKey('prop_ballistic_shield')) do
        Citizen.Wait(100)
    end

    local shield = CreateObject(GetHashKey('prop_ballistic_shield'), PedPos.x, PedPos.y, PedPos.z, 1, 1, 1)
    shieldEntity = shield
    AttachEntityToEntity(shieldEntity, Ped, GetEntityBoneIndexByName(Ped, 'IK_L_Hand'), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
    SetWeaponAnimationOverride(Ped, 'Gang1H')

    if HasPedGotWeapon(Ped, 'weapon_combatpistol', 0) or GetSelectedPedWeapon(Ped) == 'weapon_combatpistol' then
        SetCurrentPedWeapon(Ped, 'weapon_combatpistol', 1)
        HadPistol = true
    else
        GiveWeaponToPed(Ped, 'weapon_combatpistol', 300, 0, 1)
        SetCurrentPedWeapon(Ped, 'weapon_combatpistol', 1)
        HadPistol = false
    end
    SetEnableHandcuffs(Ped, true)
end

function DisableShield()
    local Ped = GetPlayerPed(-1)
    DeleteEntity(shieldEntity)
    ClearPedTasksImmediately(Ped)
    SetWeaponAnimationOverride(Ped, 'Default')
    SetCurrentPedWeapon(Ped, 'weapon_unarmed', 1)

    if not HadPistol then
        RemoveWeaponFromPed(Ped, 'weapon_combatpistol')
    end
    SetEnableHandcuffs(Ped, false)
    HadPistol = false
    ShieldActive = false
end
function SpawnProp(Object, Name)
    local Player = PlayerPedId()
    local Coords = GetEntityCoords(Player)
    local Heading = GetEntityHeading(Player)

    RequestModel(Object)
    while not HasModelLoaded(Object) do
        Citizen.Wait(0)
    end

    local OffsetCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 0.75, 0.0)
    local Prop = CreateObjectNoOffset(Object, OffsetCoords, false, true, false)
    SetEntityHeading(Prop, Heading)
    PlaceObjectOnGroundProperly(Prop)
    SetEntityCollision(Prop, false, true)
    SetEntityAlpha(Prop, 100)
    FreezeEntityPosition(Prop, true)
    SetModelAsNoLongerNeeded(Object)

    Notify('Press ~g~E ~w~to place\nPress ~r~R ~w~to cancel')

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local OffsetCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 0.75, 0.0)
            local Heading = GetEntityHeading(Player)

            SetEntityCoordsNoOffset(Prop, OffsetCoords)
            SetEntityHeading(Prop, Heading)
            PlaceObjectOnGroundProperly(Prop)
            DisableControlAction(1, 38, true) --E
            DisableControlAction(1, 140, true) --R


            if IsDisabledControlJustPressed(1, 38) then --E
                local PropCoords = GetEntityCoords(Prop)
                local PropHeading = GetEntityHeading(Prop)
                DeleteObject(Prop)

                RequestModel(Object)
                while not HasModelLoaded(Object) do
                    Citizen.Wait(0)
                end

                local Prop = CreateObjectNoOffset(Object, PropCoords, true, true, true)
                SetEntityHeading(Prop, PropHeading)
                PlaceObjectOnGroundProperly(Prop)
                FreezeEntityPosition(Prop, true)
                SetEntityInvincible(Prop, true)
                SetModelAsNoLongerNeeded(Object)
                return
            end

            if IsDisabledControlJustPressed(1, 140) then --R
                DeleteObject(Prop)
                return
            end
        end
    end)
end

function DeleteProp(Object)
    local Hash = GetHashKey(Object)
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    if DoesObjectOfTypeExistAtCoords(x, y, z, 1.5, Hash, true) then
        local Prop = GetClosestObjectOfType(x, y, z, 1.5, Hash, false, false, false)
        DeleteObject(Prop)
        Notify('~r~Prop Removed!')
    end
end

function Ad(Text, Name, Loc, File, ID)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    EndTextCommandThefeedPostMessagetext(Loc, File, true, 1, Name, '~b~Advertisement #' .. ID)
    DrawNotification(false, true)
end

function split(pString, pPattern)
   local Table = {}
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end
function SendToDiscord(msg)
    if Config.Config.DiscordLogs ~= false then
        PerformHttpRequest(Config.Config.DiscordLogs, function(a,b,c)end, "POST", json.encode({embeds={{title="FiveCore",description=msg:gsub("%^%d",""),color=65280,}}}), {["Content-Type"]="application/json"})
    end
end

function isAdmin(Player)
    for k,v in ipairs(Config.Admins) do
      if IsPlayerAceAllowed(Player, v) then return true end
    end
    return false
end

function GetLicense(Player)
  local license
  for k,v in ipairs(GetPlayerIdentifiers(Player))do
      if string.sub(v, 1, string.len("license:")) == "license:" then
          license = v
          break
      end
  end
  return license
end
