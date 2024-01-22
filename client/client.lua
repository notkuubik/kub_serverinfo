local resourceName = GetCurrentResourceName()
local isFirstOpen = true
local isServerInfoPopUpOpen, lastRequestTime, latestInfo = false, 0, {}

local function openServerInfoPopUp()
    if isFirstOpen == true then
        isFirstOpen = false
        sendLocaleDataToNui()
    end
    isServerInfoPopUpOpen = true

    local time, serverInfo = GetCloudTimeAsInt()
    if time - lastRequestTime < clientConfig.updateDelay then
        serverInfo = latestInfo
    else
        TriggerServerEvent('kub_serverinfo:server:getServerInfo')
        return
    end

    SendNUIMessage({
        action = 'setServerInfoVisibility',
        status = true,
        info = serverInfo
    })
end

local function closeServerInfoPopUp()
    isServerInfoPopUpOpen = false
    SendNUIMessage({
        action = 'setServerInfoVisibility',
        status = false
    })
end

CreateThread(function()
    while true do
        if IsControlJustPressed(0, clientConfig.key) and not isServerInfoPopUpOpen then
            openServerInfoPopUp()
        elseif isServerInfoPopUpOpen and IsControlJustReleased(0, clientConfig.key) then
            closeServerInfoPopUp()
        end
        Wait(0)
    end
end)

RegisterNetEvent('kub_serverinfo:client:getServerInfo', function(info)
    latestInfo = info
    lastRequestTime = GetCloudTimeAsInt()
    SendNUIMessage({
        action = 'setServerInfoVisibility',
        status = true,
        info = latestInfo
    })
end)

function sendLocaleDataToNui()
    local JSON = LoadResourceFile(resourceName, ('locales/%s.json'):format(sharedConfig.locale)) or
        LoadResourceFile(resourceName, 'locales/en.json')
    SendNUIMessage({
        action = 'setLocale',
        data = JSON and json.decode(JSON) or {}
    })
end
