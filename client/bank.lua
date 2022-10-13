--====================================================================================
--  Function APP BANK
--====================================================================================


ESX = nil
local bank = 0
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
      local accounts = playerData.accounts or {}
      for index, account in ipairs(accounts) do 
            if account.name == 'bank' then
                  setBankBalance(account.money)
            end
      end
      if ESX.PlayerData.job ~= nil then
            if ESX.PlayerData.job.grade_name == "boss" then
                  ESX.TriggerServerCallback('ybnv3phone8x:isparasicek', function(data)
                  setBankaparas(data)
                  end)
            end
      end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
      if account.name == 'bank' then
            setBankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
      setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
      setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
      setBankBalance(bank)
end)



--===============================================
--==         Transfer Event                    ==
--===============================================

RegisterNUICallback('transferPhoneNumber', function(data)
      TriggerServerEvent('ybnv3phone8x:transferPhoneNumber', data.to, data.totaltt, data.tfee)
end)

--===============================================
--==             Ad ve Soyad                   ==
--===============================================

RegisterNetEvent("ybnv3phone8x:firstname")
AddEventHandler("ybnv3phone8x:firstname", function(identifier, _firstname, jobname, joblabel, accmoney)
  firstname = _firstname

  SendNUIMessage({event = 'identifierrr', identifier = identifier})
  SendNUIMessage({event = 'updateMyFirstname', firstname = firstname})
  SendNUIMessage({event = 'jobkontrol', joblabel = joblabel})
  SendNUIMessage({event = 'jobname', jobname = jobname})

  setBankBalance(accmoney)
      if joblabel == "boss" then
            ESX.TriggerServerCallback('ybnv3phone8x:isparasicek', function(data)
               
            setBankaparas(data)
            end)
      end

end)

RegisterNetEvent("ybnv3phone8x:jobupdate")
AddEventHandler("ybnv3phone8x:jobupdate", function(identifier, jobname, joblabel)


  SendNUIMessage({event = 'identifierrr', identifier = identifier})
  SendNUIMessage({event = 'jobkontrol', joblabel = joblabel})
  SendNUIMessage({event = 'jobname', jobname = jobname})



end)

RegisterNetEvent("ybnv3phone8x:lastname")
AddEventHandler("ybnv3phone8x:lastname", function(_lastname)
  lastname = _lastname
  SendNUIMessage({event = 'updateMyListname', lastname = lastname})
end)


RegisterNetEvent("ybnv3phone8x:bank_getBilling")
AddEventHandler("ybnv3phone8x:bank_getBilling", function(bankkkkk)
  SendNUIMessage({event = 'bank_billingg', bankkkkk = bankkkkk})
end)

RegisterNUICallback('bank_getBilling', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:bank_getBilling')
end)



function setBankaparas(isciparasi)
      SendNUIMessage({event = 'societypara', isciparasi = isciparasi})
end

