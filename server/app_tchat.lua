function TchatGetMessageChannel (channel, cb)
    MySQL.Async.fetchAll("SELECT * FROM ybnv3phone8x_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", { 
        ['@channel'] = channel
    }, cb)
end
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
function TchatAddMessage (channel, message)
  local Query = "INSERT INTO ybnv3phone8x_app_chat (`channel`, `message`) VALUES(@channel, @message);"
  local Query2 = 'SELECT * from ybnv3phone8x_app_chat WHERE `id` = @id;'
  local Parameters = {
    ['@channel'] = channel,
    ['@message'] = message
  }
  MySQL.Async.insert(Query, Parameters, function (id)
    MySQL.Async.fetchAll(Query2, { ['@id'] = id }, function (reponse)
      TriggerClientEvent('ybnv3phone8x:darkreceive', -1, reponse[1])
    end)
  end)
end


RegisterServerEvent('ybnv3phone8x:darkchannel')
AddEventHandler('ybnv3phone8x:darkchannel', function(channel)
  local sourcePlayer = tonumber(source)
  if sourcePlayer ~= nil then
    TchatGetMessageChannel(channel, function (messages)
      TriggerClientEvent('ybnv3phone8x:darkchannel', sourcePlayer, channel, messages)
    end)
  end
end)

RegisterServerEvent('ybnv3phone8x:darkaddMessage')
AddEventHandler('ybnv3phone8x:darkaddMessage', function(channel, message)
  local sourcePlayer = tonumber(source)
  if sourcePlayer ~= nil then
    TchatAddMessage(channel, message)
  end
end)


