--====================================================================================
-- #Author: 8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
--====================================================================================

RegisterNetEvent("ybnv3phone8x:yellow_getPagess")
AddEventHandler("ybnv3phone8x:yellow_getPagess", function(pagess)
  SendNUIMessage({event = 'yellow_pagess', pagess = pagess})
end)

RegisterNetEvent("ybnv3phone8x:yellow_newPagess")
AddEventHandler("ybnv3phone8x:yellow_newPagess", function(pages)
  ESX.TriggerServerCallback('ybnv3phone8x:phone-check', function(durum)
    if durum ~= nil then
        SendNUIMessage({event = 'yellow_newPages', pages = pages})
    end
  end)
end)



RegisterNetEvent("ybnv3phone8x:yellow_showError")
AddEventHandler("ybnv3phone8x:yellow_showError", function(title, message)
  SendNUIMessage({event = 'yellow_showError', message = message, title = title})
end)

RegisterNetEvent("ybnv3phone8x:yellow_showSuccess")
AddEventHandler("ybnv3phone8x:yellow_showSuccess", function(title, message)
  SendNUIMessage({event = 'yellow_showSuccess', message = message, title = title})
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
RegisterNUICallback('yellow_getPagess', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:yellow_getPagess', data.firstname, data.phone_number)
end)

RegisterNUICallback('yellow_postPages', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:yellow_postPagess', data.firstname, data.phone_number, data.lastname, data.message, data.image)
end)






RegisterNUICallback('yellow_userssDeleteTweet', function(data, cb) 
  TriggerServerEvent('ybnv3phone8x:yellow_usersDeleteTweet', data.yellowId, data.phone_number)
end)



RegisterNUICallback('yellow_getUserTweets', function(data, cb)

  ESX.TriggerServerCallback('ybnv3phone8x:GetYellowUsers', function(usersyellow)
    UpdateYellow(usersyellow)
  end, data.phone_number)
end)

function UpdateYellow(usersyellow)
  SendNUIMessage({event = 'yellow_UserTweets', usersyellow = usersyellow})
end

RegisterNetEvent('DeleteYellow')
AddEventHandler('DeleteYellow', function(usersyellow)
    ESX.TriggerServerCallback('ybnv3phone8x:GetYellowUsers', function(data)
      UpdateYellow(data)
    end, usersyellow)
end)