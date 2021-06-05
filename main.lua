local fontpath = ""
if RegisterMod == nil then
  RegisterMod = function(modname, apiversion)
    local mod = {
      Name = modname,
      AddCallback = function(self, callbackId, fn, entityId)
        if entityId == nil then entityId = -1; end
        Isaac.AddCallback(self, callbackId, fn, entityId)
      end,
      RemoveCallback = function(self, callbackId, fn)
        Isaac.RemoveCallback(self, callbackId, fn)
      end,
      SaveData = function(self, data)
        Isaac.SaveModData(self, data)
      end,
      LoadData = function(self)
        return Isaac.LoadModData(self)
      end,
      HasData = function(self)
        return Isaac.HasModData(self)
      end,
      RemoveData = function(self)
        Isaac.RemoveModData(self)
      end
    }
    Isaac.RegisterMod(mod, modname, apiversion)
    return mod
  end
  fontpath = "scripts/resources/font/"
else
  fontpath = "font/"
end
if StartDebug == nil then
  StartDebug = function()
    local ok, m = pcall(require, "mobdebug")
    if ok and m then
      m.start()
    else
      Isaac.DebugString("Failed to start debugging.")
      -- m is now the error
      -- Isaac.DebugString(m)
    end
  end
end
local EID = RegisterMod("EID Chinese Edition", 1)
local filepath = ""
local gameVersion = ""
if REPENTANCE then
  gameVersion = "rep"
else
  gameVersion = "ab+"
end
--[[
EID features four tables for mods to define their descriptions:
__eidTrinketDescriptions for trinkets
__eidCardDescriptions for cards
__eidPillDescriptions for pills
__eidItemDescriptions for Collectibles / items
__eidItemTransformations assigns transformationinformations to collectibles

For example: to add the item "My Item Name" and the Description "Most Fitting Description" do something like this:

-- 1. Get your itemid
local item = Isaac.GetItemIdByName("My Item Name");
-- 2. Make sure we're not adding to a nil table
if not __eidItemDescriptions then
  __eidItemDescriptions = {};
end
-- 3. Add the description
__eidItemDescriptions[item] = "Most Fitting Description";

--]]
local config = require("config")
local fontsizeReal = config["FontSize"]
if fontsizeReal < 18 then
  fontsizeReal = 15
else
  fontsizeReal = 20
end
local fontScaleReal = config["FontSize"] / fontsizeReal * config["FontScale"]
local fontmap = require("fontmap_"..fontsizeReal)
local kernings = require("kernings_"..fontsizeReal)
local spritetable = {}
local defaultpages={
  [15]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,277,278},
  [20]={0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,61,62,63,64,65,66,67,68,69,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,147,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,278,279,280,281,282,283,284,285,287,289}
}
require("descriptions.ab+")
if gameVersion == "rep" then
  require("descriptions.rep")
end

local function getTableLength(table)
  local count = 0
  for i in pairs(table) do count = count + 1 end
  return count
end

local collectibleCount = getTableLength(collectibleDescriptions)
local trinketCount = getTableLength(trinketDescriptions)
local cardCount = getTableLength(cardDescriptions)
local pillCount = getTableLength(pillDescriptions)
--[[
  Init variables for other mods to hand over Descriptions
  if they were not yet inited by another mod.
--]]
if not __eidItemDescriptions then
  __eidItemDescriptions = {};
end
if not __eidTrinketDescriptions then
  __eidTrinketDescriptions = {};
end
if not __eidCardDescriptions then
  __eidCardDescriptions = {};
end
if not __eidPillDescriptions then
  __eidPillDescriptions = {};
end
if not __eidItemTransformations then
  __eidItemTransformations = {};
end

function getModDescription(list, id)
  return (list) and (list[id])
end

function table.load(sfile)
  local ftables,err = loadfile(sfile)
  if err then return _,err end
  local tables = ftables()
  for idx = 1,#tables do
    local tolinki = {}
    for i,v in pairs(tables[idx]) do
      if type( v ) == "table" then
        tables[idx][i] = tables[v[1]]
      end
      if type( i ) == "table" and tables[i[1]] then
        table.insert(tolinki, {i, tables[i[1]]})
      end
    end
    for _,v in ipairs(tolinki) do
      tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
    end
  end
  return tables[1]
end
function SubStringUTF8(str, startIndex, endIndex)
  if startIndex < 0 then
    startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
  end

  if endIndex ~= nil and endIndex < 0 then
    endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
  end

  if endIndex == nil then
    return string.sub(str, SubStringGetTrueIndex(str, startIndex));
  else
    return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
  end
end

function SubStringGetTotalIndex(str)
  local curIndex = 0;
  local i = 1;
  local lastCount = 1;
  repeat
    lastCount = SubStringGetByteCount(str, i)
    i = i + lastCount;
    curIndex = curIndex + 1;
  until(lastCount == 0);
  return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
  local curIndex = 0;
  local i = 1;
  local lastCount = 1;
  repeat
    lastCount = SubStringGetByteCount(str, i)
    i = i + lastCount;
    curIndex = curIndex + 1;
  until(curIndex >= index);
  return i - lastCount;
end

function SubStringGetByteCount(str, index)
  local curByte = string.byte(str, index)
  local byteCount = 1;
  if curByte == nil then
    byteCount = 0
  elseif curByte > 0 and curByte <= 127 then
    byteCount = 1
  elseif curByte>=192 and curByte<=223 then
    byteCount = 2
  elseif curByte>=224 and curByte<=239 then
    byteCount = 3
  elseif curByte>=240 and curByte<=247 then
    byteCount = 4
  end
  return byteCount;
end

function FontPreLoad()
  local i = 0
  if config["FontLoadMode"] == 1 then
    for i=1,#defaultpages[fontsizeReal] do
      if spritetable[defaultpages[fontsizeReal][i]] == nil then
        local tmpsprite = Sprite()
        tmpsprite:Load(fontpath..fontsizeReal.."/font_"..string.rep("0",3-string.len(defaultpages[fontsizeReal][i]))..defaultpages[fontsizeReal][i]..".anm2", true)
        spritetable[defaultpages[fontsizeReal][i]] = tmpsprite
        tmpsprite = nil
      end
    end
  elseif config["FontLoadMode"] == 2 then
    for i=0,fontmap["pages"] - 1 do
      if spritetable[i] == nil then
        local tmpsprite = Sprite()
        tmpsprite:Load(fontpath..fontsizeReal.."/font_"..string.rep("0",3-string.len(i))..i..".anm2", true)
        spritetable[i] = tmpsprite
        tmpsprite = nil
      end
    end
  end
end

function DrawString(str, x, y, nowrap)
  if not(str) then
    return
  end
  local word = ""
  local lastid = 0
  local strlen = SubStringGetTotalIndex(str)
  local DrawPositionX = x
  local DrawPositionY = y
  if not(DrawPositionX) then
    DrawPositionX=config["XPosition"]
  end
  if not(DrawPositionY) then
    DrawPositionY=config["YPosition"]
  end
  for i = 1,strlen do
    word = SubStringUTF8(str, i, i)
    if (word ~= "\n") then
      if not(fontmap[word]) then
        word = "?"
      end
      if (not(nowrap) and (word ~= "，" and word ~= "。" and DrawPositionX + fontmap[word].xadvance * fontScaleReal + 2 > config["FontMaxLength"])) then
        DrawPositionX = config["XPosition"]
        DrawPositionY = DrawPositionY + config["FontLineHeigh"] * fontScaleReal
        lastid = 0
      end
      DrawFont(fontmap[word].id,fontmap[word].page,DrawPositionX + (fontmap[word].xoffset + GetKerning(fontmap[word].id,lastid)) * fontScaleReal,DrawPositionY + fontmap[word].yoffset * fontScaleReal)
      DrawPositionX = DrawPositionX + fontmap[word].xadvance * fontScaleReal + 2
      lastid = fontmap[word].id
    else
      DrawPositionX = config["XPosition"]
      DrawPositionY = DrawPositionY + config["FontLineHeigh"] * fontScaleReal
      lastid = 0
    end
  end
end

function DrawFont(id, pageid, x, y)
  if spritetable[pageid] == nil then
    local tmpsprite = Sprite()
    tmpsprite:Load(fontpath..fontsizeReal.."/font_"..string.rep("0",3-string.len(pageid))..pageid..".anm2", true)
    spritetable[pageid] = tmpsprite
    tmpsprite = nil
  end
  spritetable[pageid]:Play(id)
  spritetable[pageid].Scale = Vector(fontScaleReal,fontScaleReal)
  spritetable[pageid].Color = Color( 1, 1, 1, config["FontTransparency"] , 0, 0, 0 )
  spritetable[pageid]:Update()
  spritetable[pageid]:Render(Vector(x,y), Vector(0,0), Vector(0,0))
end

function GetKerning(id, lastid)
  if lastid ~= 0 then
    for i = 1,#kernings do
      if (kernings[i].second == id and kernings[i].first == lastid) then
        return kernings[i].amount
      end
    end
  end
  return 0
end

local function printTransformation(S)
  local str = transformations[tonumber(S)]
  if not(str) then
    str = "Custom"
  end
  return str
end

local function printDescription(desc)
  local temp = config["YPosition"]
  if not(desc[2] == "0" or desc[2] == "" or desc[2]==nil) then
    if config["TransformationText"] == "true" then
      if config["TransformationIcons"] == "true" and not(printTransformation(desc[2]) == "Custom") then
        DrawString(printTransformation(desc[2])[2])
      elseif not(transformations[desc[2]]) then --Custom transformationname
        DrawString(desc[2])
      else
        DrawString(printTransformation(desc[2])[2])
      end
    end
    if config["TransformationIcons"] == "true" and not(printTransformation(desc[2]) == "Custom") and printTransformation(desc[2])[1] ~= "" then
      local sprite = Sprite()
      sprite:Load("gfx/icons.anm2", true)
      sprite:Play(printTransformation(desc[2])[1])
      sprite.Scale = Vector(config["Scale"], config["Scale"])
      sprite.Color = Color(1, 1, 1, config["Transparency"] , 0, 0, 0)
      sprite:Update()
      sprite:Render(Vector(config["XPosition"] - 13 * config["Scale"], temp + 10 * config["Scale"]), Vector(0, 0), Vector(0, 0))
    end
    temp = temp + config["FontLineHeigh"] * fontScaleReal
  end
  DrawString(desc[1], config["XPosition"], temp)
end

function HasCurseBlind()
  local num = Game():GetLevel():GetCurses()
  local t = {}
  while num > 0 do
    rest=num % 2
    t[#t + 1]=rest
    num=(num - rest) / 2
  end
  return #t > 6 and t[7] == 1
end

local function onRender(t)
  if HasCurseBlind() and config["EnableOnCurse"] == "false" then
    return
  end
  local player = Isaac.GetPlayer(0)
  local closest = nil;
  local dist = 10000;
  for i, coin in ipairs(Isaac.GetRoomEntities()) do
    if coin.Type == EntityType.ENTITY_PICKUP and (coin.Variant == PickupVariant.PICKUP_COLLECTIBLE or coin.Variant == PickupVariant.PICKUP_TRINKET or coin.Variant == PickupVariant.PICKUP_TAROTCARD or coin.Variant == PickupVariant.PICKUP_PILL) and coin.SubType > 0 then
      local diff = coin.Position:__sub(player.Position);
      if diff:Length() < dist then
        closest = coin;
        dist = diff:Length();
      end
    elseif not(config["DisplayDiceRoomInfo"] == "false") and coin.Type == EntityType.ENTITY_EFFECT and coin.Variant == EffectVariant.DICE_FLOOR then
      local CurrentRoom=Game():GetRoom();
      DrawString(diceDescriptions[coin.SubType],CurrentRoom:GetRenderSurfaceTopLeft().X+CurrentRoom:GetCenterPos().X/2,CurrentRoom:GetRenderSurfaceTopLeft().Y+CurrentRoom:GetCenterPos().Y/2-70,true);
    end
  end
  if dist / 40 > tonumber(config["MaxDistance"]) then
    return
  end

  --TODO: Load Mode 3
  if closest.Type == EntityType.ENTITY_PICKUP then
    if closest.Variant == PickupVariant.PICKUP_TRINKET then
      --Handle Trinkets
      local goldenOffset = 32768
      local trinketId = closest.SubType
      local goldenTrinketDescription = ""
      -- REP判断金饰品
      if gameVersion == "rep" and trinketId > goldenOffset then
        trinketId = trinketId - goldenOffset
        goldenTrinketDescription = "\n·金饰品：效果翻倍"
      end
      if trinketId <= trinketCount then
        if not(trinketDescriptions[trinketId]) then
          DrawString("— 未知饰品："..trinketId..goldenTrinketDescription)
        else
          DrawString(trinketDescriptions[trinketId]..goldenTrinketDescription)
        end
      elseif getModDescription(__eidTrinketDescriptions, trinketId) then
        DrawString(getModDescription(__eidTrinketDescriptions, trinketId)..goldenTrinketDescription)
      else
        DrawString(config["ErrorMessage"])
      end
      --Handle Collectibles
    elseif closest.Variant == PickupVariant.PICKUP_COLLECTIBLE then
      if getModDescription(__eidItemDescriptions,closest.SubType) then
        local tranformation = "0"
        if  getModDescription(__eidItemTransformations,closest.SubType) then
          tranformation = getModDescription(__eidItemTransformations,closest.SubType)
        end
        printDescription({getModDescription(__eidItemDescriptions,closest.SubType),tranformation})
      elseif closest.SubType <= collectibleCount then
        if getModDescription(__eidItemTransformations,closest.SubType) then
          printDescription({collectibleDescriptions[closest.SubType][2],getModDescription(__eidItemTransformations,closest.SubType)})
        elseif not(collectibleDescriptions[closest.SubType]) then
          DrawString("— 未知道具："..closest.SubType)
        else
          printDescription(collectibleDescriptions[closest.SubType])
        end
      else
        DrawString(config["ErrorMessage"])
      end
      --Handle Cards & Runes
    elseif closest.Variant == PickupVariant.PICKUP_TAROTCARD then
      if not(config["DisplayCardInfo"]=="false") and not(closest:ToPickup():IsShopItem() and config["DisplayCardInfoShop"]=="false") then
        if closest.SubType <= cardCount then
          if not(cardDescriptions[closest.SubType]) then
            DrawString("— 未知卡牌："..closest.SubType)
          else
            DrawString(cardDescriptions[closest.SubType])
            local sprite = Sprite()
            sprite:Load("gfx/cardfronts.anm2", true)
            sprite.Scale = Vector(config["Scale"],config["Scale"])
            sprite.Color = Color(1, 1, 1, config["Transparency"], 0, 0, 0)
            sprite:Play(tostring(closest.SubType))
            sprite:Update()
            sprite:Render(Vector(config["XPosition"] - 10 * config["Scale"], config["YPosition"] + 12 * config["Scale"]), Vector(0, 0), Vector(0, 0))
          end
        elseif getModDescription(__eidCardDescriptions,closest.SubType) then
          DrawString(getModDescription(__eidCardDescriptions,closest.SubType))
          --TODO: add sprite
        else
          DrawString(config["ErrorMessage"])
        end
      end
      --Handle Pills
    elseif closest.Variant == PickupVariant.PICKUP_PILL then
      if config["DisplayPillInfo"] and not(closest:ToPickup():IsShopItem() and config["DisplayPillInfoShop"] == "false") then
        pillColor = closest.SubType
        pool = Game():GetItemPool()
        pillEffect = pool:GetPillEffect(pillColor)
        identified = pool:
        IsPillIdentified(pillColor)
        if (identified or config["ShowUnidentifiedPillDescriptions"] == "true") then
          if (pillEffect <= pillCount) or getModDescription(__eidPillDescriptions, pillEffect) then
            if pillEffect <= pillCount then
              if not(pillDescriptions[pillEffect]) then
                DrawString("— 未知胶囊："..pillEffect)
              else
                DrawString(pillDescriptions[pillEffect])
              end
            else
              DrawString(getModDescription(__eidPillDescriptions, pillEffect))
            end
            local pillsprite = closest:GetSprite()
            pillsprite.Scale = Vector(config["Scale"],config["Scale"])
            pillsprite.Color = Color(1, 1, 1, config["Transparency"], 0, 0, 0)
            pillsprite:Update()
            pillsprite:Render(Vector(config["XPosition"] - 12 * config["Scale"], config["YPosition"] + 16 * config["Scale"]), Vector(0, 0), Vector(0, 0))
            pillsprite.Scale = Vector(1, 1)
          else
            DrawString(config["ErrorMessage"])
          end
        else
          DrawString(config["UnidentifiedPillMessage"])
        end
      end
    end
  end
end
local function onExit()
  for key, value in pairs(spritetable) do
    spritetable[key]:Reset ()
    spritetable[key] = nil
  end
  return true
end
FontPreLoad()
EID:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)
EID:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, onExit)