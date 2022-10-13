RegisterNetEvent("ybnv3phone8x:darkreceive")
AddEventHandler("ybnv3phone8x:darkreceive", function(message)
  SendNUIMessage({event = 'darkreceive', message = message})
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
RegisterNetEvent("ybnv3phone8x:darkchannel")
AddEventHandler("ybnv3phone8x:darkchannel", function(channel, messages)
  SendNUIMessage({event = 'darkchannel', messages = messages})
end)

RegisterNUICallback('darkaddMessage', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:darkaddMessage', data.channel, data.message)
end)

RegisterNUICallback('darkgetChannel', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:darkchannel', data.channel)
end)


RegisterNUICallback('darkreceive', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:darkreceive', data.channel, data.message)
end)
