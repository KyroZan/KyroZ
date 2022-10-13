

Config = {}
Config.OpenPhone = 'f1'   --## Phone open key ## https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/


Config.Phones       = {"phone"} -- dont add more phone items only change name if u want
-- but dont add like white_phone, green_phone its will broke phone maybe later i can update
-- Change this lines too btw: ybnv3phone8x\server\server.lua line 892 and  ybnv3phone8x\server\server.lua line 19
-- if on your server there are more phone items remove them only use one bcs ppl will have issues.

Config.Locale = 'en'
Config.Fahrenheit = false

Config.ESXVersion = "1.1" -- 1.1 OR 1.2


-- Discord WebHook - start --
Config.Carseller = 'https://discord.com/api/webhooks/1027166315816960090/YVpq2nuNYnudE0WpQlcGG_9hBzjNl0IfIUU_X6ATRfwMVejkZqoaJtSyZLBdOneLewHb'
Config.JobNotif = 'https://discord.com/api/webhooks/1027166607165886524/HWUN_L3t-UVCHpWLTgwV6Xs5weuCxA8PXPa1yrhQnsemiuDnDIS16vQCaavvC5J_AEn3'
Config.TwitterWeb = 'https://discord.com/api/webhooks/1027089637317029888/iyeyZ3dKDPisdOy_GrTfnOSRKwkLpMdV-P-1y_UMNUtm7Ov5Y9efviVX5x-EmJGiovdH'
Config.YellowWeb = 'https://discord.com/api/webhooks/1027166713940299826/K0ESJGh_7xs0ZTwhB9GGICCBHqepWT93J7cDx6nsZDrf6aEuSk93ZdVYJPUQa1mzECNA'
Config.InstagramWeb = 'https://discord.com/api/webhooks/1027166869750304789/4j0UkLikaOm1UCjGVTK1MXqoNXvpt8bqfbyGO3k9KrfG9lNOVDO5vLTZZIecempyTmSg'
Config.Crypto = 'https://discord.com/api/webhooks/1027167001556291585/DCZFltr_X20kgLvkp59QaAAg2HEhIZhpSbk12hQQXW4goXHsoD4mr_6CiRyFV-C-DyBk'
Config.BankTrasnfer = 'https://discord.com/api/webhooks/1027168243204497450/qr_rtg1I6hrs_zhcBULRtZOJ-_bk1VcQg-tYLNQsO9NTZ4mrxVvbdLYztgLjW36paek6'
Config.BankLimit = 5000 -- # Minimum money transfer for discord webhook
-- Discord WebHook - end --



-- Phone Settings - Start --

Config.UseMumbleVoIP    = false -- Use Frazzle's Mumble-VoIP Resource (Recomended!) https://github.com/FrazzIe/mumble-voip
Config.PMAVoice         = true
Config.UseTokoVoIP      = false
Config.SaltyChat        = false

Config.CallPhone        = true  -- If the player is not in the game or there is no item on it, it will give a warning.

-- Phone Settings - Finish --

Config.ValePrice        = 100    -- Vale Price
Config.TaxiPrice        = 75     -- Taxi Price ( 75$/KM )