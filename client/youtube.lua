
xSound = exports.xsound

RegisterNUICallback('youtplay', function(data)
    xSound:Cal(data.link, false)
end)

RegisterNUICallback('youtstop', function() 
    xSound:Durdur()
end)

RegisterNUICallback('musicDevamet', function()
    xSound:Devamet()
end)

RegisterNUICallback('musicDuraklat', function() 
    xSound:Duraklat()
end)

RegisterNUICallback('streamerMod', function(data) 
    xSound:Streamer(data)
end)

RegisterNUICallback('musicvolume', function(volume) 
    local serverId = GetPlayerServerId(PlayerId())
    local muzikAdi = tostring(serverId)
    TriggerServerEvent("ybnv3phone8x:ChangeVolume", muzikAdi, volume)
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
RegisterNetEvent("ybnv3phone8x:ChangeVolume")
AddEventHandler("ybnv3phone8x:ChangeVolume", function(muzikAdi, volume)
    xSound:setVolumeMax(muzikAdi, volume.volume)
end)