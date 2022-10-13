RegisterNetEvent("ybnv3phone8x:twitter_getTweets")
AddEventHandler("ybnv3phone8x:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("ybnv3phone8x:twitter_getFavoriteTweets")
AddEventHandler("ybnv3phone8x:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("ybnv3phone8x:twitter_getUserTweets")
AddEventHandler("ybnv3phone8x:twitter_getUserTweets", function(tweets)
  SendNUIMessage({event = 'twitter_UserTweets', tweets = tweets})
end)

RegisterNetEvent("ybnv3phone8x:twitter_newTweets")
AddEventHandler("ybnv3phone8x:twitter_newTweets", function(tweet)
  ESX.TriggerServerCallback('ybnv3phone8x:phone-check', function(durum)
    if durum ~= nil then
      SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
    end
  end)
end)
--8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm
RegisterNetEvent("ybnv3phone8x:twitter_updateTweetLikes")
AddEventHandler("ybnv3phone8x:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("ybnv3phone8x:twitter_setAccount")
AddEventHandler("ybnv3phone8x:twitter_setAccount", function(username, password, avatarUrl, profilavatar)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl, profilavatar = profilavatar})
end)

RegisterNetEvent("ybnv3phone8x:twitter_createAccount")
AddEventHandler("ybnv3phone8x:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("ybnv3phone8x:twitter_showError")
AddEventHandler("ybnv3phone8x:twitter_showError", function(title, message, image)
  SendNUIMessage({event = 'twitter_showError', message = message, image = image, title = title})
end)

RegisterNetEvent("ybnv3phone8x:twitter_showSuccess")
AddEventHandler("ybnv3phone8x:twitter_showSuccess", function(title, message, image)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, image = image, title = title})
end)

RegisterNetEvent("ybnv3phone8x:twitter_setTweetLikes")
AddEventHandler("ybnv3phone8x:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)





RegisterNUICallback('twitter_userssDeleteTweet', function(data, cb) 
  TriggerServerEvent('ybnv3phone8x:twitter_usersDeleteTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_login', data.username, data.password)
end)
RegisterNUICallback('twitter_changePassword', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_changePassword', data.username, data.password, data.newPassword)
end)


RegisterNUICallback('twitter_createAccount', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_createAccount', data.username, data.password, data.avatarUrl, data.profilavatar)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_getTweets', data.username, data.password)
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_getFavoriteTweets', data.username, data.password)
end)



RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_postTweets', data.username or '', data.password or '', data.message or '', data.image or '')
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_toogleLikeTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
  TriggerServerEvent('ybnv3phone8x:twitter_setAvatarUrl', data.username or '', data.password or '', data.avatarUrl)
end)

RegisterNUICallback('twitter_setProfilURL', function(data, cb)

  TriggerServerEvent('ybnv3phone8x:twitter_setProfilUrl', data.username or '', data.password or '', data.avatarUrl or '', data.profilavatar)
end)

RegisterNUICallback('twitter_getUserTweets', function(data, cb)
  ESX.TriggerServerCallback('ybnv3phone8x:getTwitterUsers', function(usersTweets)
    UpdateTwiiter(usersTweets)
  end, data.username, data.password)
end)

function UpdateTwiiter(usersTweets)
  SendNUIMessage({event = 'twitter_UserTweets', usersTweets = usersTweets})
end

RegisterNetEvent('DeleteTwitter')
AddEventHandler('DeleteTwitter', function(username, password)
    ESX.TriggerServerCallback('ybnv3phone8x:getTwitterUsers', function(data)
      UpdateTwiiter(data)
    end, username, password)
end)




RegisterNUICallback('twitter_getSearchUsers', function(data, cb)
  ESX.TriggerServerCallback('ybnv3phone8x:getsearchusers', function(SearchUserTwitter)

    SendNUIMessage({event = 'twitter_SearchTwitter', searchusertwitter = SearchUserTwitter})

  end, data.username)
end)


RegisterNUICallback('twitter_getusertwitterr', function(data, cb)
  ESX.TriggerServerCallback('ybnv3phone8x:getuserveri', function(twitteruser)

    SendNUIMessage({event = 'twitter_twittsuser', twitteruser = twitteruser})

  end, data.id)
end)