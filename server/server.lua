local resourceName = GetCurrentResourceName()

function getLocale()
    local JSON = LoadResourceFile(resourceName, ('locales/%s.json'):format(sharedConfig.locale)) or
        LoadResourceFile(resourceName, 'locales/en.json')
    return json.decode(JSON) or {}
end

local locale = getLocale()

-- Modify this if you're not using connectqueue
function getQueueSize()
    if not serverConfig.isQueueEnabled then
        return 0
    elseif serverConfig.isQueueEnabled and GetResourceState('connectqueue') == 'started' then
        local queueInfo = exports.connectqueue:GetQueueExports()
        return queueInfo:GetSize()
    else
        print('[^1ERROR^7] ^3connectqueue not found, please install connectqueue or configure another queue system')
        return 0
    end
end

function getServerPlayerCount()
    local players = GetNumPlayerIndices()
    local maxPlayers = GetConvarInt("sv_maxclients", 0)
    return string.format(locale.PlayersInServer, players, maxPlayers)
end

RegisterNetEvent('kub_serverinfo:server:getServerInfo', function()
    local playerId = source
    local info =
    {
        players = getServerPlayerCount(),
        queue = getQueueSize(),
        time = os.date(serverConfig.dateTimeFormat),
        id = source
    }
    TriggerClientEvent('kub_serverinfo:client:getServerInfo', playerId, info)
end)
