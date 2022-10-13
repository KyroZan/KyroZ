function Billing(billingg)
  SendNUIMessage({event = 'fatura_billingg', billingg = billingg})
end

RegisterNUICallback('fatura_getBilling', function(data, cb)
  ESX.TriggerServerCallback('ybnv3phone8x:getbilling', function(data)
    Billing(data)
  end)
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
RegisterNUICallback('faturapayBill', function(data)
  TriggerServerEvent('ybnv3phone8x:faturapayBill', data.id, data.sender, data.amount, data.target)
end)

RegisterNetEvent('updatebilling')
AddEventHandler('updatebilling', function(billingg)
    ESX.TriggerServerCallback('ybnv3phone8x:getbilling', function(data)
      Billing(data)
    end, billingg)
end)
