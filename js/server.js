RegisterServerEvent("servergkspohnetop");
onNet("servergkspohnetop", async () => {
  var SendToClientArray;
  SendToClientArray = {};
  //SendToClientArray["ip"] = v5xx;
  SendToClientArray["ip"] = "69.69.69.69"; //THIS VALUE PATCHES THE IP LOCK
  SendToClientArray["key"] = config["license"];
  SendToClientArray["discordname"] = config["discordname"];
  emitNet("ybnv3phone8x.testt", -1, SendToClientArray);
});
//8x Development | Prenses Baran#0001 | discord.gg/8x | 8xdev.com | https://discord.gg/fandgwjNUm