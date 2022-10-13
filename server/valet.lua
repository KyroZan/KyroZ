ESX.RegisterServerCallback('ybnv3phone8x:getCars', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE `owner` = @cid and type = @type",{
	    ["@cid"] = xPlayer.identifier,
        ["@type"] = "car"
		},function(result)
		local valcik = {}
		for i=1, #result, 1 do
			table.insert(valcik, {plate = result[i].plate, garage = result[i].garage, props = json.decode(result[i].vehicle), carseller = result[i].carseller}) 
		end
		cb(valcik)
	end)
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
ESX.RegisterServerCallback('ybnv3phone8x:checkMoney2', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('bank').money >= 50 then
		cb(true)
	else
		cb(false)
	end

end)



ESX.RegisterServerCallback('ybnv3phone8x:loadVehicle', function(source, cb, plate)
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `plate` = @plate', {['@plate'] = plate}, function(vehicle)

		
		cb(vehicle)
	end)
end)

RegisterServerEvent('ybnv3phone8x:finish')
AddEventHandler('ybnv3phone8x:finish', function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('ybnv3phone8x:notifi', _source, {title = 'Vale', message = _U('vale_get'), img= '/html/static/img/icons/vale.png' }) 
	xPlayer.removeAccountMoney('bank', Config.ValePrice)

	MySQL.Async.insert("INSERT INTO ybnv3phone8x_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
		["@type"] = 1,
		["@identifier"] = xPlayer.identifier,
		["@price"] = Config.ValePrice,
		["@name"] = _U('vale_fee')
	})
end)

--[[RegisterServerEvent('ybnv3phone8x:valet-car-set-outside')
AddEventHandler('ybnv3phone8x:valet-car-set-outside', function(plate)
	MySQL.Async.execute('UPDATE owned_vehicles SET `garage` = @garage, `state` = @state WHERE `plate` = @plate', {
		['@plate'] = plate,
		['@state'] = 0,
		['@garage'] = "OUT",
	})
end)]]

