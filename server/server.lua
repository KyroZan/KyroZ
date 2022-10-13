
ESX = nil

ESX = exports["es_extended"]:getSharedObject()

math.randomseed(os.time()) 


function getPhoneRandomNumber()

    local numBase = math.random(1000000,9999999)
    num = string.format("%07d", numBase)
    return num
end




ESX.RegisterUsableItem('blue_phone', function(source)
    TriggerClientEvent('gks:use', source)
end)

--================== EMS ===========
function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        getSourceFromIdentifier(otherIdentifier, function (osou)
            if tonumber(osou) ~= nil then 
                -- TriggerClientEvent("gcPhone:allMessage", osou, getMessages(otherIdentifier))
                TriggerClientEvent("gcPhone:receiveMessage", tonumber(osou), tomess)
            end
        end) 
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
end
--================== EMS ===========

--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
    local xPlayers = ESX.GetPlayers()
    
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        
        if(xPlayer.identifier ~= nil and xPlayer.identifier == identifier) or (xPlayer.identifier == identifier) then
            cb(xPlayer.source)
            return
        end
    end
    cb(nil)
end

function getSource(a)
    local Lawyers = {}
    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayerFromId(v)

        if Player ~= nil then
            if Player.job.name == a then
                table.insert(Lawyers, {
                    id = Player.source,
                })
            end
        end
    end
    return Lawyers
end

function NumberControl(identifier, source)

    local result = MySQL.Sync.fetchAll("SELECT phone_number FROM ybnv3phone8x_settings WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })

    if result[1] == nil then

            repeat
                number = getPhoneRandomNumber()
                local id = getIdentifierByPhoneNumber(number)
            until id == nil
            MySQL.Async.fetchAll("SELECT * FROM `ybnv3phone8x_settings` WHERE `phone_number` = @phone_number", {["@phone_number"] = number}, function(numberr)
                if numberr[1] == nil then
                    MySQL.Async.execute('INSERT INTO ybnv3phone8x_settings (`identifier`, `phone_number`) VALUES(@identifier, @phone_number);', {['@phone_number'] =  number,  ['@identifier'] =  identifier})
                end
            end)
            return number

    else
        return result[1].phone_number
    end
end


function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_number FROM ybnv3phone8x_settings WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end



function getIdentifierByPhoneNumber(phone_number) 
  
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM ybnv3phone8x_settings WHERE phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })

    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end


RegisterServerEvent("ybnv3phone8x:alNumber")
AddEventHandler("ybnv3phone8x:alNumber",function(a)
    local src = source
    local e = ESX.GetPlayerFromId(src)
    local ident = getIdentifierByPhoneNumber(a)
    if e then
        if ident then
            MySQL.Async.insert('INSERT INTO ybnv3phone8x_blockednumber (`identifier`, `hex`, `number`) VALUES(@identifier, @hex, @number);', {
                ['@identifier'] = e.identifier,
                ['@hex'] = ident,
                ['@number'] = a,
            }, function (result)
            
                TriggerClientEvent('yenNumber', -1)
        
            end)
        end
    end
end)



function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end




--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ybnv3phone8x_users_contacts WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    return result
end

function addContact(source, identifier, number, display, avatar)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("INSERT INTO ybnv3phone8x_users_contacts (`identifier`, `number`,`display`,`avatar`) VALUES(@identifier, @number, @display, @avatar)", {
        ['@identifier'] = identifier,
        ['@number'] = number,
        ['@display'] = display,
        ['@avatar'] = avatar,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function updateContact(source, identifier, id, number, display, avatar)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE ybnv3phone8x_users_contacts SET number = @number, display = @display, avatar = @avatar WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@avatar'] = avatar,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function ProfilChange(source, identifier, avatar_url)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE ybnv3phone8x_settings SET avatar_url = @avatar_url WHERE identifier = @identifier", { 
        ['@avatar_url'] = avatar_url,
        ['@identifier'] = identifier
    },function()
    end)
end

ESX.RegisterServerCallback('ybnv3phone8x:getAvatar', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local myPhoneNumber = getNumberPhone(xPlayer.identifier)
    MySQL.Async.fetchAll('SELECT avatar_url FROM ybnv3phone8x_settings WHERE `phone_number` = @myPhoneNumber',{["@myPhoneNumber"] = myPhoneNumber},function(result)
        local avatar = {}
        for i=1, #result, 1 do
            table.insert(avatar, {avatar_url = result[i].avatar_url}) 
        end
        cb(avatar)
    end)
end)


RegisterServerEvent('ybnv3phone8x:avatarChange')
AddEventHandler('ybnv3phone8x:avatarChange', function(avatar_url)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    ProfilChange(sourcePlayer, identifier, avatar_url)
end)

function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    MySQL.Sync.execute("DELETE FROM ybnv3phone8x_users_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = identifier,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end

function deleteAllContact(identifier)
    MySQL.Sync.execute("DELETE FROM ybnv3phone8x_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end

function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("ybnv3phone8x:contactList", sourcePlayer, getContacts(identifier))
    end
end

ESX.RegisterServerCallback('ybnv3phone8x:phone-check', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
    for k, v in pairs(Config.Phones) do
        local items = xPlayer.getInventoryItem(v)
        if items.count > 0 then
            cb(v)
            return
        end
    end
    cb(nil)
end)


RegisterServerEvent('ybnv3phone8x:addContact')
AddEventHandler('ybnv3phone8x:addContact', function(display, phoneNumber, avatar)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    addContact(sourcePlayer, identifier, phoneNumber, display, avatar)
end)

RegisterServerEvent('ybnv3phone8x:updateContact')
AddEventHandler('ybnv3phone8x:updateContact', function(id, display, phoneNumber, avatar)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    updateContact(sourcePlayer, identifier, id, phoneNumber, display, avatar)
end)

RegisterServerEvent('ybnv3phone8x:deleteContact')
AddEventHandler('ybnv3phone8x:deleteContact', function(id)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Group Message
--====================================================================================

RegisterServerEvent('ybnv3phone8x:creategroup')
AddEventHandler('ybnv3phone8x:creategroup', function(a, b, c, d)

local src = source
local e = ESX.GetPlayerFromId(src)
local identifier = e.identifier
local deneyy = json.decode(c)

    if e then
        MySQL.Async.insert('INSERT INTO ybnv3phone8x_messages_group (`owner`, `ownerphone`, `groupname`, `gimage`, `contacts`) VALUES(@owner, @ownerphone, @groupname, @gimage, @contacts);', {
            ['@owner'] = identifier,
            ['@ownerphone'] = d,
            ['@groupname'] = a,
            ['@gimage'] = b,
            ['@contacts'] = c,
        }, function(result)

            local data = {id = result, owner = identifier, ownerphone = d, groupname = a, gimage = b, contacts = deneyy}
            for i = 1, #deneyy do
                    
                local otherIdentifier = getIdentifierByPhoneNumber(deneyy[i])
                
                if otherIdentifier ~= nil then
                    
                    getSourceFromIdentifier(otherIdentifier, function (osou)
                        if tonumber(osou) ~= nil then 
                            if tonumber(osou) ~= src then

                                TriggerClientEvent('ybnv3phone8x:creategroup', tonumber(osou), data, a)
                            else
                                TriggerClientEvent('ybnv3phone8x:creategroupsrc', src, data)
                            end
                        end

                    end)
     
                    
                end

            end
        end)

    end
end)

RegisterServerEvent('ybnv3phone8x:newpeople')
AddEventHandler('ybnv3phone8x:newpeople', function(a, b)
    local src = source
    local e = ESX.GetPlayerFromId(src)
    local deneamd = json.decode(b)

  
    if e then
        MySQL.Async.execute("UPDATE ybnv3phone8x_messages_group SET contacts = @contacts WHERE id = @id", { 
            ['@id'] = a,
            ['@contacts'] = b
        })

        for i = 1, #deneamd do

            local otherIdentifier = getIdentifierByPhoneNumber(deneamd[i])
    

            if otherIdentifier ~= nil then

                getSourceFromIdentifier(otherIdentifier, function (osou)
                    if tonumber(osou) ~= nil then 
                        TriggerClientEvent('ybnv3phone8x:updatenewpeoppel', tonumber(osou),  getGroup(deneamd[i]), getGroupMessage(deneamd[i]))
                        TriggerClientEvent('ybnv3phone8x:notifi', tonumber(osou), {title = 'Messages', message = _U('group_newpeop'), img= '/html/static/img/icons/messages.png' })
                    end
                end)
            

            end

        end

    end
end)


RegisterServerEvent('ybnv3phone8x:updategroup')
AddEventHandler('ybnv3phone8x:updategroup', function(a, b, c)
    local src = source
    local e = ESX.GetPlayerFromId(src)
    local deneamd = b


    if e then
        MySQL.Async.execute("UPDATE ybnv3phone8x_messages_group SET contacts = @contacts WHERE id = @id", { 
            ['@id'] = a,
            ['@contacts'] = json.encode(b)
        })

        for i = 1, #deneamd do

            local otherIdentifier = getIdentifierByPhoneNumber(deneamd[i])
            local otherIdentifiersource = getIdentifierByPhoneNumber(c)

            if otherIdentifier ~= nil then

                getSourceFromIdentifier(otherIdentifier, function (osou)
                    if tonumber(osou) ~= nil then 
                        TriggerClientEvent('ybnv3phone8x:updategroup', tonumber(osou),  getGroup(deneamd[i]), getGroupMessage(deneamd[i]))
                        TriggerClientEvent('ybnv3phone8x:notifi', tonumber(osou), {title = 'Messages', message = c .._U('group_delpeop'), img= '/html/static/img/icons/messages.png' })
                    end
                end)
            

            end



        end

        local otherIdentifiersource = getIdentifierByPhoneNumber(c)

        if otherIdentifiersource ~= nil then

            getSourceFromIdentifier(otherIdentifiersource, function (osou)
                if tonumber(osou) ~= nil then 
               
                    TriggerClientEvent('ybnv3phone8x:updategroup', tonumber(osou),  getGroup(c), getGroupMessage(c))
                    TriggerClientEvent('ybnv3phone8x:notifi', tonumber(osou), {title = 'Messages', message = c .._U('group_delpeop'), img= '/html/static/img/icons/messages.png' })
                end
            end)
        

        end

    end
end)


RegisterServerEvent('ybnv3phone8x:deletegroup')
AddEventHandler('ybnv3phone8x:deletegroup', function(a, b)
    local src = source
    local e = ESX.GetPlayerFromId(src)
    local deneamd = b

    if e then
        MySQL.Async.execute("DELETE FROM ybnv3phone8x_group_message WHERE `groupid` = @groupid", {
            ['@groupid'] = a
        })
        MySQL.Async.execute("DELETE FROM ybnv3phone8x_messages_group WHERE `id` = @id", {
            ['@id'] = a
        })
        local wanted = {}


             for i = 1, #deneamd do
                    
                local otherIdentifier = getIdentifierByPhoneNumber(deneamd[i])
                
                if otherIdentifier ~= nil then
                    
                    getSourceFromIdentifier(otherIdentifier, function (osou)
                        if tonumber(osou) ~= nil then 
                       
                            TriggerClientEvent('ybnv3phone8x:deletegroup', tonumber(osou), getGroup(deneamd[i]), getGroupMessage(deneamd[i]))
                        end
                    end)
     
                    
                end

            end


     
    end
end)


RegisterServerEvent('ybnv3phone8x:sendgroupmessage')
AddEventHandler('ybnv3phone8x:sendgroupmessage', function(a, b, c, d, edd)

local src = source
local e = ESX.GetPlayerFromId(src)
local identifier = e.identifier

local deneyy = json.decode(d)


    if e then
        MySQL.Async.insert('INSERT INTO ybnv3phone8x_group_message (`groupid`, `owner`, `ownerphone`, `groupname`, `messages`, `contacts`) VALUES(@groupid, @owner, @ownerphone, @groupname, @messages, @contacts);', {
            ['@groupid'] = a,
            ['@owner'] = identifier,
            ['@ownerphone'] = edd,
            ['@groupname'] = b,
            ['@messages'] = c,
            ['@contacts'] = d,
        }, function(result)
            local data = {id = result, groupid = a, owner = identifier, ownerphone = edd, groupname = b, messages = c, contacts = deneyy, time = tonumber(os.time().."000.0")}
           
                for i = 1, #deneyy do
                    
                    local otherIdentifier = getIdentifierByPhoneNumber(deneyy[i])
                    
                    if otherIdentifier ~= nil then
                        
                        getSourceFromIdentifier(otherIdentifier, function (osou)
                            if tonumber(osou) ~= nil then 
                                if tonumber(osou) ~= src then
                                    TriggerClientEvent('ybnv3phone8x:csendgroupmessage', tonumber(osou), data)
                                    TriggerClientEvent('ybnv3phone8x:notifi', tonumber(osou), {title = 'Messages', message = b .._U('group_newmes'), img= '/html/static/img/icons/messages.png', appinfo = a })
                                else
                                    TriggerClientEvent('ybnv3phone8x:csendgroupmessagesrc', src, data)
                                   -- TriggerClientEvent('ybnv3phone8x:notifi', src, {title = 'Messages', message = b .._U('group_newmes'), img= '/html/static/img/icons/messages.png', appinfo = data.id })
                                end
                            end
                        end)
         
                        
                    end

                end

                
     
            
        end)

    end
end)

--====================================================================================
--  Messages
--====================================================================================

function getMessages(identifier)
    local result = MySQL.Sync.fetchAll("SELECT ybnv3phone8x_messages.*, ybnv3phone8x_settings.phone_number FROM ybnv3phone8x_messages LEFT JOIN ybnv3phone8x_settings ON ybnv3phone8x_settings.identifier = @identifier WHERE ybnv3phone8x_messages.receiver = ybnv3phone8x_settings.phone_number", {
         ['@identifier'] = identifier
    })
    return result
end

function getGroup(num)
    local wanted = {}
   local result = MySQL.Sync.fetchAll("SELECT * FROM ybnv3phone8x_messages_group", {
        ['@identifier'] = identifier
   })
        
        for i=1, #result, 1 do
            table.insert(wanted, {id = result[i].id, owner = result[i].owner, ownerphone = result[i].ownerphone, groupname = result[i].groupname, gimage = result[i].gimage, contacts= json.decode(result[i].contacts)}) 
        end
        

   return wanted
end

function getGroupMessage(num)
    local wanted = {}
    local result = MySQL.Sync.fetchAll("SELECT * FROM ybnv3phone8x_group_message", {
        ['@identifier'] = identifier
   })

   for i=1, #result, 1 do
     table.insert(wanted, {id = result[i].id, groupid = result[i].groupid, owner = result[i].owner, ownerphone = result[i].ownerphone, groupname = result[i].groupname, messages = result[i].messages, contacts= json.decode(result[i].contacts), time = result[i].time}) 
   end


return wanted

end

RegisterServerEvent("ybnv3phone8x:jobgetmessage")
AddEventHandler("ybnv3phone8x:jobgetmessage",function(a)
    local src = source

    local result = MySQL.Sync.fetchAll("SELECT * FROM ybnv3phone8x_job_message WHERE jobm = @jobm ORDER BY TIME DESC", {
         ['@jobm'] = a
    })

    local valcik = {}
    for i=1, #result, 1 do
        table.insert(valcik, {id = result[i].id, name = result[i].name, number = result[i].number, message = result[i].message, photo = result[i].photo, gps = result[i].gps, owner = result[i].owner, jobm = result[i].jobm, time = result[i].time}) 
    end
   
    TriggerClientEvent('ybnv3phone8x:jobmesaae', src, valcik)

end)

RegisterServerEvent("ybnv3phone8x:jbmessage")
AddEventHandler("ybnv3phone8x:jbmessage",function(name, number, message, photo, gps, jobm)
    local  xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    if identifier ~= nil then
        MySQL.Async.insert("INSERT INTO ybnv3phone8x_job_message (`name`, `number`,`message`, `photo`, `gps`, `owner`, `jobm`) VALUES(@name, @number, @message, @photo, @gps, @owner, @jobm)", {
            ['@name'] = name,
            ['@number'] = number,
            ['@message'] = message,
            ['@photo'] = photo,
            ['@gps'] = gps,
            ['@owner'] = 0,
            ['@jobm'] = jobm
        })
        local jobs = getSource(jobm)

        if (json.encode(jobs) ~= '[]') then
            for i=1, #jobs, 1 do
                TriggerClientEvent('ybnv3phone8x:mesajjgetir', jobs[i].id, jobm)
                TriggerClientEvent('ybnv3phone8x:notifi', jobs[i].id, {title = 'JOB notification', message = _U('job_notifi'), img= '/html/static/img/icons/jobm.png' })

                TriggerClientEvent('ybnv3phone8x:jobnotisound', jobs[i].id)
            end
            TriggerEvent('ybnv3phone8x:jobnotif', name, number, message, photo, jobm, identifier, 1)
        else
            TriggerClientEvent('ybnv3phone8x:notifi', source, {title = 'JOB notification', message = _U('not_player'), img= '/html/static/img/icons/jobm.png' })
        end
    end
end)

RegisterServerEvent('ybnv3phone8x:jobmfinish')
AddEventHandler('ybnv3phone8x:jobmfinish', function(a, b)
    local src = source
    local e = ESX.GetPlayerFromId(src)
    if e then
        MySQL.Async.execute("UPDATE ybnv3phone8x_job_message SET owner = 1 WHERE id = @id", { 
            ['@id'] = a
        })
    end

    local result = MySQL.Sync.fetchAll("SELECT * FROM ybnv3phone8x_job_message WHERE id = @jobm", {
        ['@jobm'] = a
   })


   local name2 = getFirstname(e.identifier)  .. " " .. getLastname(e.identifier)

    TriggerEvent('ybnv3phone8x:jobnotif', result[1].name, result[1].number, result[1].message, result[1].photo, result[1].jobm, e.identifier, 0, name2)
   
    TriggerClientEvent('ybnv3phone8x:mesajjgetir', src, b)
end)

AddEventHandler('ybnv3phone8x:jobnotif', function (name, number, message, photo, jobm, identifier, new, name2)
 
    local discord_webhook = Config.JobNotif
    if discord_webhook == '' then
      return
    end

    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = 'Job Notif',
      ["avatar_url"] = 'https://media.discordapp.net/attachments/722981093455822958/882974778334523392/stock-market.png?width=480&height=480',
      ["embeds"] = {{
        ["color"] = 15258703
      }}
    }
    local isHttp = string.sub(photo, 0, 7) == 'http://' or string.sub(photo, 0, 8) == 'https://'
    local ext = string.sub(photo, -4)
    local isImg = ext == '.png' or ext == '.jpg' or ext == '.gif' or string.sub(photo, -5) == '.jpeg'
  
    if new == 1 then
    data['embeds'][1]['title'] = '[' .. name ..']  Occupation Notification : ' ..jobm 
    data['embeds'][1]['image'] = { ['url'] = photo }
    data['embeds'][1]['description'] = 'Message : ' ..message
    data['embeds'][1]['footer']  = { ['text'] = ' [Number : ' ..number ..', identifier : ' ..identifier .. ']'}
    end
    if new == 0 then
        data['embeds'][1]['title'] = '[' .. name2 ..'] Incoming Problem Solved : ' ..jobm 
        data['embeds'][1]['image'] = { ['url'] = photo }
        data['embeds'][1]['description'] = 'Message : ' ..message
        data['embeds'][1]['footer']  = { ['text'] = '[Name : '.. name ..' ,Number : ' ..number ..']'}
    end
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)


function _sendMessageAdd(transmitter, receiver, message, owner)
    MySQL.Async.insert("INSERT INTO ybnv3phone8x_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    })
    local data = {message = message, time = tonumber(os.time().."000.0"), receiver = receiver, transmitter = transmitter, owner = owner, isRead = owner}
    return data
end





function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Async.execute("UPDATE ybnv3phone8x_messages SET ybnv3phone8x_messages.isRead = 1 WHERE ybnv3phone8x_messages.receiver = @receiver AND ybnv3phone8x_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Async.execute("DELETE FROM ybnv3phone8x_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Async.execute("DELETE FROM ybnv3phone8x_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {
        ['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number
    })
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Async.execute("DELETE FROM ybnv3phone8x_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end



RegisterServerEvent('ybnv3phone8x:sendMessages')
AddEventHandler('ybnv3phone8x:sendMessages', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
    local identifier = xPlayer.identifier
    
    if xPlayer ~= nil then
        local otherIdentifier = getIdentifierByPhoneNumber(phoneNumber)
        local myPhone = getNumberPhone(identifier)

            if otherIdentifier ~= nil then 
                local tomess = _sendMessageAdd(myPhone, phoneNumber, message, 0)
                getSourceFromIdentifier(otherIdentifier, function (osou)
                    if tonumber(osou) ~= nil then 
                        TriggerClientEvent("ybnv3phone8x:receiveMessage", tonumber(osou), tomess)
                    end
                end) 
            end
            local memess = _sendMessageAdd(phoneNumber, myPhone, message, 1)
            TriggerClientEvent("ybnv3phone8x:receiveMessage", sourcePlayer, memess)

    end
end)

RegisterServerEvent('ybnv3phone8x:deleteMessage')
AddEventHandler('ybnv3phone8x:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('ybnv3phone8x:deleteMessageNumber')
AddEventHandler('ybnv3phone8x:deleteMessageNumber', function(number)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
end)

RegisterServerEvent('ybnv3phone8x:deleteAllMessage')
AddEventHandler('ybnv3phone8x:deleteAllMessage', function()
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessage(identifier)
end)

RegisterServerEvent('ybnv3phone8x:setReadMessageNumber')
AddEventHandler('ybnv3phone8x:setReadMessageNumber', function(num)
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('ybnv3phone8x:deleteALL')
AddEventHandler('ybnv3phone8x:deleteALL', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("ybnv3phone8x:contactList", sourcePlayer, {})
    TriggerClientEvent("ybnv3phone8x:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall(num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ybnv3phone8x_calls WHERE ybnv3phone8x_calls.owner = @num ORDER BY time DESC LIMIT 30", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall(src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('ybnv3phone8x:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO ybnv3phone8x_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            num = "#######"
        end
        MySQL.Async.insert("INSERT INTO ybnv3phone8x_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('ybnv3phone8x:getHistoriqueCall')
AddEventHandler('ybnv3phone8x:getHistoriqueCall', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)


function startCallFonk (source, phone_number, who, extraData)

    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcIdentifier = xPlayer.identifier

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local destYPlayer = ESX.GetPlayerFromIdentifier(destPlayer)
 
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    
    if not destYPlayer then
        AppelsEnCours[indexCall] = {
            id = indexCall,
            transmitter_src = sourcePlayer,
            transmitter_num = srcPhone,
            receiver_src = nil,
            receiver_num = phone_number,
            is_valid = destPlayer ~= nil,
            is_accepts = false,
            hidden = hidden,
            extraData = extraData
        }
    else
        AppelsEnCours[indexCall] = {
            id = indexCall,
            transmitter_src = sourcePlayer,
            transmitter_num = srcPhone,
            receiver_src = destYPlayer.source,
            receiver_num = phone_number,
            is_valid = destPlayer ~= nil,
            is_accepts = false,
            hidden = hidden,
            extraData = extraData
        }
    end

    if Config.CallPhone then
        if not destYPlayer then 
            TriggerClientEvent('ybnv3phone8x:notifi', sourcePlayer, {title = 'Call', message = _U('offline_call'), img= '/html/static/img/icons/call.png' })
        return
        end
        local item = destYPlayer.getInventoryItem('phone')
        if item.count > 0 then   
            
                if is_valid == true then
                    getSourceFromIdentifier(destPlayer, function (srcTo)
                        if srcTo ~= nil then
                            AppelsEnCours[indexCall].receiver_src = srcTo
                            TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true, who)
                            TriggerClientEvent('ybnv3phone8x:waitingCallto', srcTo, AppelsEnCours[indexCall], false, who) -- karşı oyuncuyu arama
                            
                        else
                            TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true, who)
                        end
                    end)
                    else
                        TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true, who)
                end
        
        else 
            
            TriggerClientEvent('ybnv3phone8x:notifi', sourcePlayer, {title = 'Call', message = _U('nophone_call'), img= '/html/static/img/icons/call.png' }) 
        
        end

    else

            if is_valid == true then
                getSourceFromIdentifier(destPlayer, function (srcTo)
                    if srcTo ~= nil then
                        AppelsEnCours[indexCall].receiver_src = srcTo
                        TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true, who)
                        TriggerClientEvent('ybnv3phone8x:waitingCallto', srcTo, AppelsEnCours[indexCall], false, who) -- karşı oyuncuyu arama
                        

                    else
                        TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true, who)
                    end
                end)
            else
                TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true, who)
            end

    end
end

RegisterServerEvent('ybnv3phone8x:startCall')
AddEventHandler('ybnv3phone8x:startCall', function(phone_number, who, extraData)
    local source = source
    startCallFonk(source, phone_number, who, extraData)
end)


RegisterServerEvent('ybnv3phone8x:acceptCall')
AddEventHandler('ybnv3phone8x:acceptCall', function(infoCall, rtcAnswer)

    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src ~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('ybnv3phone8x:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], false)
            TriggerClientEvent('ybnv3phone8x:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)

            if Config.SaltyChat then
                exports['saltychat']:EstablishCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src)
            end

            saveAppels(AppelsEnCours[id])


        end
    end
end)

RegisterServerEvent('ybnv3phone8x:rejectCall')
AddEventHandler('ybnv3phone8x:rejectCall', function (infoCall)
    if infoCall ~= nil then
        if infoCall.id ~= nil then
            local id = infoCall.id
            if AppelsEnCours[id] ~= nil then
                if AppelsEnCours[id].transmitter_src ~= nil then
                    TriggerClientEvent('ybnv3phone8x:rejectCall', AppelsEnCours[id].transmitter_src)
                    if Config.SaltyChat then
                        exports['saltychat']:EndCall(AppelsEnCours[id].transmitter_src, AppelsEnCours[id].receiver_src)
                    end
                end
                if AppelsEnCours[id].receiver_src ~= nil then
                    TriggerClientEvent('ybnv3phone8x:rejectCall', AppelsEnCours[id].receiver_src)
                    if Config.SaltyChat then
                        exports['saltychat']:EndCall(AppelsEnCours[id].receiver_src, AppelsEnCours[id].transmitter_src)
                    end
                end
                if AppelsEnCours[id].is_accepts == false then 
                    saveAppels(AppelsEnCours[id])
                end
                TriggerEvent('ybnv3phone8x:removeCall', AppelsEnCours)
                AppelsEnCours[id] = nil
            end
        end
    end
end)

RegisterServerEvent('ybnv3phone8x:appelsDeleteHistorique')
AddEventHandler('ybnv3phone8x:appelsDeleteHistorique', function (numero)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local srcPhone = getNumberPhone(identifier)
    MySQL.Async.execute("DELETE FROM ybnv3phone8x_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Async.execute("DELETE FROM ybnv3phone8x_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('ybnv3phone8x:appelsDeleteAllHistorique')
AddEventHandler('ybnv3phone8x:appelsDeleteAllHistorique', function ()
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    appelsDeleteAllHistorique(srcIdentifier)
end)

--====================================================================================
--  OnLoad
--====================================================================================

RegisterCommand('telfix', function(source)
    TriggerEvent('ybnv3phone8x:playerLoad', source)
end)

RegisterCommand('logi', function(source)
    TriggerClientEvent('ybnv3phone8x:instologout', source)
end)

RegisterCommand('logt', function(source)
    TriggerClientEvent('ybnv3phone8x:twlogout', source)
end)

RegisterCommand('logti', function(source)
    TriggerClientEvent('ybnv3phone8x:tnlogout', source)
end)

function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    xPlayer = ESX.GetPlayerFromId(_source)
    srcIdentifier = xPlayer.identifier

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('ybnv3phone8x:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('ybnv3phone8x:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end


AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
    TriggerEvent('ybnv3phone8x:playerLoad', playerId)
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)

   local xPlayer = ESX.GetPlayerFromId(source)
   local identifier = xPlayer.identifier

   TriggerClientEvent("ybnv3phone8x:jobupdate", source, identifier, xPlayer.getJob().name, xPlayer.getJob().grade_name)

end)


RegisterServerEvent('ybnv3phone8x:playerLoad')
AddEventHandler('ybnv3phone8x:playerLoad',function(source)
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
if (xPlayer ~= nil) then
    local identifier = xPlayer.identifier
    local num = NumberControl(identifier, _source)
    local fst = getFirstname(identifier) 
    local lst = getLastname(identifier)

    if (num ~= nil) then
    
        TriggerClientEvent("ybnv3phone8x:firstname", sourcePlayer, identifier, fst, xPlayer.getJob().name, xPlayer.getJob().grade_name, xPlayer.getAccount('bank').money)
        TriggerClientEvent("ybnv3phone8x:lastname", sourcePlayer, lst)
        TriggerClientEvent("ybnv3phone8x:loadingphone", sourcePlayer, num, getContacts(identifier), getMessages(identifier), getGroup(num), getGroupMessage(num))
        sendHistoriqueCall(sourcePlayer, num)
        TriggerClientEvent('yenNumber', sourcePlayer)

    else
        


    end

end

end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Citizen.Wait(3000)
    MySQL.Async.execute('DELETE FROM ybnv3phone8x_insto_story WHERE time < (CURDATE() - INTERVAL 1 DAY)', {})
    MySQL.Async.execute('DELETE FROM ybnv3phone8x_job_message WHERE time < (CURDATE() - INTERVAL 1 DAY)', {})
end)


