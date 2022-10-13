--====================================================================================
-- #8x dev : discord.gg/8x | 8xdev.com
--====================================================================================

RegisterNetEvent("ybnv3phone8x:insto_getinstas")
AddEventHandler("ybnv3phone8x:insto_getinstas", function(instas)
  SendNUIMessage({event = 'insto_instas', instas = instas})
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
RegisterNetEvent("ybnv3phone8x:insto_getFavoriteinstas")
AddEventHandler("ybnv3phone8x:insto_getFavoriteinstas", function(instas)
  SendNUIMessage({event = 'insto_favoriteinstas', instas = instas})
end)

RegisterNetEvent("ybnv3phone8x:insto_newinstas")
AddEventHandler("ybnv3phone8x:insto_newinstas", function(inap)
  ESX.TriggerServerCallback('ybnv3phone8x:phone-check', function(durum)
    if durum ~= nil then
      SendNUIMessage({event = 'insto_newinap', inap = inap})
    end
  end)
end)

RegisterNetEvent("ybnv3phone8x:insto_updateinapLikes")
AddEventHandler("ybnv3phone8x:insto_updateinapLikes", function(inapId, likes)
  SendNUIMessage({event = 'insto_updateinapLikes', inapId = inapId, likes = likes})
end)

RegisterNetEvent("ybnv3phone8x:insto_setAccount")
AddEventHandler("ybnv3phone8x:insto_setAccount", function(forename, surname, username, password, avatarUrl)
  SendNUIMessage({event = 'insto_setAccount', forename = forename, surname = surname, username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("ybnv3phone8x:insto_createAccount")
AddEventHandler("ybnv3phone8x:insto_createAccount", function(account)
  SendNUIMessage({event = 'insto_createAccount', account = account})
end)

RegisterNetEvent("ybnv3phone8x:insto_showError")
AddEventHandler("ybnv3phone8x:insto_showError", function(title, message, image)
  SendNUIMessage({event = 'insto_showError', message = message, title = title, image = image})
end)

RegisterNetEvent("ybnv3phone8x:insto_showSuccess")
AddEventHandler("ybnv3phone8x:insto_showSuccess", function(title, message, image, filters)
  SendNUIMessage({event = 'insto_showSuccess', message = message, title = title, image = image, filters = filters})
end)

RegisterNetEvent("ybnv3phone8x:insto_setinapLikes")
AddEventHandler("ybnv3phone8x:insto_setinapLikes", function(inapId, isLikes)
  SendNUIMessage({event = 'insto_setinapLikes', inapId = inapId, isLikes = isLikes})
end)



RegisterNUICallback('insto_login', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_login', data.username, data.password)
end)
RegisterNUICallback('insto_changePassword', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_changePassword', data.forename, data.surname, data.username, data.password, data.newPassword)
end)


RegisterNUICallback('insto_createAccount', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_createAccount', data.forename, data.surname, data.username, data.password, data.avatarUrl)
end)

RegisterNUICallback('insto_getinstas', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_getinstas', data.forename, data.surname, data.username, data.password)
end)

RegisterNUICallback('insto_getFavoriteinstas', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_getFavoriteinstas', data.forename, data.surname, data.username, data.password)
end)

RegisterNUICallback('insto_postinap', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_postinstas', data.username or '', data.password or '', data.message or '', data.image or '', data.filters)
end)

RegisterNUICallback('insto_toggleLikeinap', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_toogleLikeinap', data.forename or '', data.surname or '', data.username or '', data.password or '', data.inapId)
end)

RegisterNUICallback('insto_setAvatarUrl', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:insto_setAvatarUrl', data.username or '', data.password or '', data.avatarUrl)
end)



function setkSroys(storie)
  
  SendNUIMessage({event = 'getStorie', storie = storie})

end

function setStorytB(storiemy)
  
  SendNUIMessage({event = 'getBStorie', storiemy = storiemy})

end

RegisterNUICallback('getBStorys', function(data)
  ESX.TriggerServerCallback('ybnv3phone8x:getsBStorys', function(data)
    setStorytB(data)
  end)
end)

RegisterNetEvent('ybnv3phone8xe:getBstory')
AddEventHandler('ybnv3phone8xe:getBstory', function(coin)

  ESX.TriggerServerCallback('ybnv3phone8x:getsBStorys', function(data)
    setStorytB(data)
  
  end)
end)

RegisterNUICallback('getStorys', function(data)
  ESX.TriggerServerCallback('ybnv3phone8x:getsStorys', function(data)
    setkSroys(data)
  end)
end)


RegisterNetEvent('ybnv3phone8xe:getStorie')
AddEventHandler('ybnv3phone8xe:getStorie', function(coin)

  ESX.TriggerServerCallback('ybnv3phone8x:getsStorys', function(data)
    setkSroys(data)
  
  end, coin)
end)


RegisterNUICallback('instostoyry', function(data)
  TriggerServerEvent('ybnv3phone8x:storysa', data.username, data.password, data.stories, data.time)
end)



RegisterNUICallback('instofollow', function(data)
  TriggerServerEvent('ybnv3phone8x:instofollow', data.username, data.password, data.id)
end)

RegisterNUICallback('instounfollow', function(data)
  TriggerServerEvent('ybnv3phone8x:instounfollow', data.username, data.password, data.id)
end)


function getInstaAcc(instaacc)
  
  SendNUIMessage({event = 'getInstaAcc', instaacc = instaacc})

end

RegisterNUICallback('getInstoAcxc', function(data)
  ESX.TriggerServerCallback('ybnv3phone8x:getInstoAacc', function(data)
    getInstaAcc(data)
  end)
end)

RegisterNetEvent('ybnv3phone8xe:getInstoAcc')
AddEventHandler('ybnv3phone8xe:getInstoAcc', function()

  ESX.TriggerServerCallback('ybnv3phone8x:getInstoAacc', function(data)
    getInstaAcc(data)
  
  end)
end)

RegisterNetEvent("ybnv3phone8x:instologout")
AddEventHandler("ybnv3phone8x:instologout", function(inap)
  SendNUIMessage({event = 'insto_logout'})
end)

RegisterNetEvent("ybnv3phone8x:twlogout")
AddEventHandler("ybnv3phone8x:twlogout", function(inap)
  SendNUIMessage({event = 'twitter_logout'})
end)

RegisterNetEvent("ybnv3phone8x:tnlogout")
AddEventHandler("ybnv3phone8x:tnlogout", function(inap)
  SendNUIMessage({event = 'tinder_logout'})
end)
--====================================================================================
-- #8x dev : discord.gg/8x | 8xdev.com
--====================================================================================