ply = {}
mats = {}
ammount = 0
playerHand = ""
handCounter = ""
lifeCounter = ""
CardImporterGUID = "d936a8"
CardImporter = nil
DrafterGUID = "488f9f"
Drafter = nil

function onload()
  self.addContextMenuItem("Setup", setup)
  self.addContextMenuItem("Circle", circleColor)
  self.addContextMenuItem("Spawn Booster", spawnSet)
  self.setPosition({0, 0.75, 0})
  self.setRotation({0, 0, 0})
  self.setScale({2,1,2})
  self.setLock(true)
  --spawnCircles()

  --Load playerHand Lua
  WebRequest.get("https://raw.githubusercontent.com/Tagischeap/TableTopSimulator/master/Custom%20Table/Fetch/PlayerHand.lua", function(request)
    if request.is_error then
        log(request.error)
    else
      playerHand = request.text
    end
  end)
  --Load handCounter Lua
  WebRequest.get("https://raw.githubusercontent.com/Tagischeap/TableTopSimulator/master/Custom%20Table/Fetch/HandCounter.lua", function(request)
    if request.is_error then
        log(request.error)
    else
      handCounter = request.text
    end
  end)
  --Load lifeCounter Lua
  WebRequest.get("https://raw.githubusercontent.com/Tagischeap/TableTopSimulator/master/Custom%20Table/Fetch/LifeCounter.lua", function(request)
    if request.is_error then
        log(request.error)
    else
      lifeCounter = request.text
    end
  end)

  CardImporter = getObjectFromGUID(CardImporterGUID)
  Drafter = getObjectFromGUID(DrafterGUID)

end

function onPickUp(player_color)
  if self.getRotation().z <= 0 and self.getRotation().z >= -120 then
    self.setRotationSmooth({0,0,180}, false, false)
    spawnCircles()
  else
    self.setRotationSmooth({0,0,0}, false, false)
    removeCircles()
  end
end

function spawnCircles()
  if ply ~= nil then
    removeCircles()
  end
  for i,v in pairs(Player.getColors()) do
    if i==11 then return end
    --reversi_chip
    obj = spawnObject({
      type = "reversi_chip",
      rotation          = circlePoint(i).rotation,
      scale             = {x=3, y=3, z=3},
      sound             = false,
      snap_to_grid      = true,
      ignore_fog_of_war	= true
    })
    pos = circlePoint(i).position
    pos.y = pos.y + 5
    obj.setPosition(pos)
    obj.setColorTint(v)
    --obj.setLock(true)
    table.insert(ply, obj)
  end
end

function removeCircles()
  for i,v in pairs(ply) do
    v.destruct()
  end
  ply = {}
end
--Returns the point in a circle
function circlePoint(i)
  local x, y, r = 0, 0, 30 -- offset x, offset y, radious
  local c = 10 -- Amount of points
  local angle = (i - 3.5) * math.pi / (c / 2)
  local ptx, pty = x + r * math.cos(angle), y + r * math.sin(angle)

  return { 
    position = vector(roundNumberToFactor(ptx, 15), 0.5, roundNumberToFactor(pty, 15)), 
    rotation = vector(0, 234 + (i-2) * -360 / c, 0)
  }
end

function setMats(c)
  ammount = c -- How many mats Max:10
  if ammount == 0 then return end
  mats = Player.getColors()
  table.remove(mats) -- Remove Black
  table.remove(mats) -- Remove Grey
  for i = 1,#mats - ammount, 1 do
    table.remove(mats) -- Remove
  end
end

function setup()
  clearPly()
  self.setPosition({-150, 5, 150})
  if #ply > 0 then
    --positionSeat(5,ply)
  return end 

  --obj = spawnZone(Player["White"])
  mats = getSeatedPlayers()
  setMats(ammount)
 --Spawns everything
  for i,v in pairs(mats) do 
    --Spawns stuff
    if v ~= "Grey" and v ~= "Black" then
      tr = findSeats(#mats,i)
      obj = spawnZone(Player[v])
      obj.setPosition(tr.position)
      obj.setRotation(tr.rotation)
      stuff = spawnExtras(Player[v])

      table.insert(ply, {obj, stuff})

      for a,b in pairs(stuff) do
        local pos = b.getPosition()
        local rot = b.getRotation()
        
        local rotation_radians = math.rad(tr.rotation[2])
        -- Calculate the new position
        local fixpos = {
            tr.position[1] + math.cos(rotation_radians) * pos.x + math.sin(rotation_radians) * pos.z,
            pos.y,
            tr.position[3] - math.sin(rotation_radians) * pos.x + math.cos(rotation_radians) * pos.z
        }
    
        -- Calculate the new rotation
        local fixrot = {
            tr.rotation[1] + rot.x,
            tr.rotation[2] + rot.y,
            tr.rotation[3] + rot.z
        }
    
        -- Set the new position and rotation
        b.setPosition(fixpos)
        b.setRotation(fixrot)
        b.interactable = false
        
      end
    end
  end
end

function setupSealed()

  for i,k in pairs(ply) do
    local y = 0
    Wait.time(function() 
      local pos = k[1].getPosition()
      pos.x = pos.x + (y*3.5)
      pos.y = 1
      local p = getSeatedPlayers()[1]
      local data = "neo"
      CardImporter = getObjectFromGUID(CardImporterGUID)
      local t ={
        position={pos.x, pos.y + 2, pos.z},
        player=Player[p].steam_id,
        color=Player[p].color,
        full=data,
        mode="Booster",--data:gsub('(http%S+)',''):match('(%S+)'),
        name=data:gsub('(http%S+)',''):gsub(' ',''),
        url=data:match('(http%S+)')
      }
      CardImporter.call('Importer', t)
      
      pack = spawnEmptyPack().setPosition(pos)
      --Wait.condition(function() pack.setRotation(k[1].getRotation()) end, function() return pack.getQuantity() ~= 0 end, 20, function() end)
      y = y+1
    end, 5*#ply, 6)
  end
end

function spawnSet() --Spawns a set
  local set = "neo"
  local y=0
  local pos = self.getPosition()
  local zones = Drafter.getVar("zones")
  pos.y = 3
  pos.x = pos.x + 3
  local p = getSeatedPlayers()[1]
  local data = "set=neo r=c c="
  for i=0,5 do
    data = "-t%3Abasic+in%3Abooster+set%3A"..set.."+r%3Ac+c%3A"
    if i == 0 then
      data = data .. "w"
    elseif i == 1 then
      data = data .. "u"
    elseif i == 2 then
      data = data .. "b"
    elseif i == 3 then
      data = data .. "r"
    elseif i == 4 then
      data = data .. "g"
    elseif i == 5 then
      data = data .. "c"
    end
    --pos.x = pos.x + 2.5
    zon = getObjectFromGUID(zones[i+1])
    pos = zon.getPosition()
    searchScryfall(data,pos)
  end
  

  --pack = spawnEmptyPack().setPosition(pos)
end

function spawnEmptyPack()
  return getObjectFromGUID("987b7c").clone()
end

function setupPods()
--TODO: Different 1v1 groups
end

function positionSeat(a,p)
  for o,l in pairs(p) do 
    local nr = findSeats(a,o)
    l[1].setPosition(nr.position)
    l[1].setRotation(nr.rotation)
    for a,b in pairs(l[2]) do
      local pos = b.getPosition()
      local rot = b.getRotation()
      
      local rotation_radians = math.rad(nr.rotation[2])
      -- Calculate the new position
      local fixpos = {
          nr.position[1] + math.cos(rotation_radians) * pos.x + math.sin(rotation_radians) * pos.z,
          pos.y,
          nr.position[3] - math.sin(rotation_radians) * pos.x + math.cos(rotation_radians) * pos.z
      }
      -- Calculate the new rotation
      local fixrot = {
        nr.rotation[1] + rot.x,
        nr.rotation[2] + rot.y,
        nr.rotation[3] + rot.z
      }
  
      -- Set the new position and rotation
      b.setPosition(fixpos)
      b.setRotation(fixrot)
      b.interactable = false
      
    end
  end
end

function spawnZone(p)
  local size = vector(28, 0.25, 44)
  local colors = {
    White   = color(1.000, 1.000, 1.000, 1),
    Brown   = color(0.443, 0.231, 0.090, 1),
    Red     = color(0.856, 0.100, 0.094, 1),
    Orange  = color(0.956, 0.392, 0.113, 1),
    Yellow  = color(0.905, 0.898, 0.172, 1),
    Green   = color(0.192, 0.701, 0.168, 1),
    Teal    = color(0.129, 0.694, 0.607, 1),
    Blue    = color(0.118, 0.530, 1.000, 1),
    Purple  = color(0.627, 0.125, 0.941, 1),
    Pink    = color(0.960, 0.439, 0.807, 1),
    Grey    = color(0.500, 0.500, 0.500, 1),
    Black   = color(0.250, 0.250, 0.250, 1) }
  local c = colors[p.color]
  local spawnParams = {
    type = "BlockSquare",
    rotation          = {x=0, y=90, z=0},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true }
  --
 --<Base Peices>
 --Base
  local obj = spawnObject(spawnParams)
  obj.setLock(true)
  obj.setColorTint(color(c.r, c.g, c.b, 65/255))
  obj.setScale({x=size.x-1, y=0.25, z=size.z-1})
  obj.setPosition({x=0, y=3, z=0})
 --Bottom
  local obj1 = spawnObject(spawnParams)
  obj1.setLock(true)
  obj1.setColorTint(c)
  obj1.setScale({x=1, y=size.y, z=size.z})
  obj1.setPosition({x= 0, y=3, z=-(size.x/2) + 0.5})
  obj.addAttachment(obj1)
 --Top
  local obj2 = spawnObject(spawnParams)
  obj2.setLock(true)
  obj2.setColorTint(c)
  obj2.setScale({x=1, y=size.y, z=size.z})
  obj2.setPosition({x= 0, y=3, z=(size.x/2) - 0.5})
  obj.addAttachment(obj2)
 --Left
  local obj3 = spawnObject(spawnParams)
  obj3.setLock(true)
  obj3.setColorTint(c)
  obj3.setScale({x=size.x, y=size.y, z=1})
  obj3.setPosition({x= (size.z/2) - 0.5, y=3, z=0})
  obj.addAttachment(obj3)
 --Right
  local obj4 = spawnObject(spawnParams)
  obj4.setLock(true)
  obj4.setColorTint(c)
  obj4.setScale({x=size.x, y=size.y, z=1})
  obj4.setPosition({x= -(size.z/2) + 0.5, y=3, z=0})
  obj.addAttachment(obj4)
 --
 --<Dividers>
 --Hand Divider
  local obj5 = spawnObject(spawnParams)
  obj5.setLock(true)
  obj5.setColorTint(c)
  obj5.setScale({x=0.25, y=size.y, z=size.z - 20.25})
  obj5.setPosition({x= 0, y=3, z=(size.x/2) + 0.5 - 7.5})
  obj.addAttachment(obj5)
 --Left Divider
  local obj6 = spawnObject(spawnParams)
  obj6.setLock(true)
  obj6.setColorTint(c)
  obj6.setScale({x=6, y=size.y, z=0.25})
  obj6.setPosition({x= (size.z/2) - 10.25, y=3, z=10})
  obj.addAttachment(obj6)
 --Right Divider
  local obj7 = spawnObject(spawnParams)
  obj7.setLock(true)
  obj7.setColorTint(c)
  obj7.setScale({x=6, y=size.y, z=0.25})
  obj7.setPosition({x= -(size.z/2) + 10.25, y=3, z=10})
  obj.addAttachment(obj7)
 --Divider
  local obj8 = spawnObject(spawnParams)
  obj8.setLock(true)
  obj8.setColorTint(c)
  obj8.setScale({x=0.25, y=size.y, z=size.z})
  obj8.setPosition({x= 0, y=3, z=(size.x/2) + 0.5 - 10})
  obj.addAttachment(obj8)
 --

 --Hand
 local lua = "p = Player." .. p.color .. playerHand .. [[
  function onPlayerTurnStart(player_color_start, player_color_previous)
    c = stringColorToRGB(p.color)
    if player_color_start == p.color then
      self.setColorTint( {r = c.r, g = c.g, b = c.b, a = 75/255} )
    else
      self.setColorTint( {r = c.r, g = c.g, b = c.b, a = 5/255} )
    end
  end
 ]]
  obj.setLuaScript(lua)
  --obj.call('fixPosition')
  --obj.interactable = false
  
  obj.setName(p.color .. " zone")
  return obj
end
  


function spawnExtras(p)
  local extras = {}
 --Hand Counter
  local obj = spawnHandCounter(p)
  obj.setPosition({x=-6.25, y=0.6, z=-4})
  obj.setRotation({x=0, y=-90, z=0})
  obj.setLock(true)
  obj.interactable = false
  table.insert(extras, obj)
 --Life
  local obj2 = spawnLifeCounter(p)
  obj2.setPosition({x= -7, y=0.56, z=0})
  obj2.setRotation({x=0, y=-90, z=0})
  obj2.setLock(true)
  obj2.interactable = false
  table.insert(extras, obj2)
 --Commander Damage
  local ni = 0
  for i,v in pairs(mats) do
    if v ~= p.color then
      ni = ni + 1
      local cd = spawnCommanderDamage(p)
      cd.setPosition({x= -4.5, y=0.575, 
      z=( (ni * 1.25) - (((#mats) * 1.25) / 2) )})
      cd.setRotation({x=0, y=-90, z=0})
      cd.setColorTint(v)
      cd.setLock(true)
      cd.interactable = false
      table.insert(extras, cd)
    else

    end
  end
 --<Card Zones>
 --Library
  local obj9 = spawnCardZone(p.color)
  obj9.setPosition({x= 8.5 -16, y=0.5, z= 22 - 2.5})
  table.insert(extras, obj9)
  
 --Graveyard
  local obj10 = spawnCardZone(p.color)
  obj10.setPosition({x= 8.5 -16, y=0.5, z= 22 - 5.5})
  table.insert(extras, obj10)

 --Exile
  local obj11 = spawnCardZone(p.color)
  obj11.setPosition({x= 8.5 -16, y=0.5, z= 22 - 8.5})
  table.insert(extras, obj11)
  
 --Commander 1
  local obj5 = spawnCardZone(p.color)
  obj5.setPosition({x= 8.5 -16, y=0.5, z= -(22 - 8.5)})
  table.insert(extras, obj5)

 --Commander 2
  local obj4 = spawnCardZone(p.color)
  obj4.setPosition({x= 8.5 -16, y=0.5, z= -(22 - 5.5)})
  table.insert(extras, obj4)

 --Extra
  local obj3 = spawnCardZone(p.color)
  obj3.setPosition({x= 8.5 -16, y=0.5, z= -(22 - 2.5)})
  table.insert(extras, obj3)
  
  local zone = spawnObject({
    type = "ScriptingTrigger",
    rotation          = {x=0, y=90, z=0},
    scale             = {x=42, y=3, z=17.5},
    position          = {x=4.25, y=1, z=0}
  })
  table.insert(extras, zone)

  local obj8 = spawnUntapper(p.color, zone.getGUID())
  obj8.setPosition({x= 8.5 -16 +1.75, y=0.525, z= 22 - 2.5 -10})
  table.insert(extras, obj8)

  --[[
  obj9 = spawnDrawer(p.color, zone.getGUID())
  obj9.setPosition({x= 8.5 -16 +1.75, y=0.5, z= 22 - 2.5 -11.5})
  table.insert(extras, obj9)
  ]]
  local secondHand = spawnObject(
    {
      type              = "HandTrigger",
      position          = {x= 5 -16, y=3.5, z= 22 - 5.65},
      scale             = {x= 9.25, y=6, z=2},
      rotation          = {x=0,y=90,z=0},
      sound             = false,
      snap_to_grid      = true,
      ignore_fog_of_war	= true,
    }
  )
  secondHand.setValue(p.color)
  table.insert(extras, secondHand)

  local thirdHand = spawnObject(
    {
      type              = "HandTrigger",
      FogColor             = p.color,
      position          = {x= 5 -16, y=3.5, z= -22 + 5.65},
      scale             = {x= 9.25, y=6, z=2},
      rotation          = {x=0,y=90,z=0},
      sound             = false,
      snap_to_grid      = true,
      ignore_fog_of_war	= true
    }
  )
  thirdHand.setValue(p.color)
  table.insert(extras, thirdHand)

  return extras
end

function spawnCardZone(color)
  local cardz = spawnObject({
    type = "BlockSquare",
    rotation          = {x=0, y=0, z=0},
    scale             = {x=3.25, y=0.25, z=2.35},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  cardz.setColorTint(color)
  cardz.setLock(true)
  cardz.interactable = false
  cardz.setSnapPoints({
    {
      position = cardz.getPosition(),
      rotation = {0,270,0},
      rotation_snap = true
    }
  })
  return cardz
end

function spawnHandCounter(p)
  --Hand Counter
  local obj = spawnObject({
    type              = "Custom_Token",
    scale             = {x=0.5, y=0.5 , z=0.5},
  })
  obj.setCustomObject({
    image             = "http://cloud-3.steamusercontent.com/ugc/1646593716898448966/68DC98F323399C7CADF7E53933EAC99FBB94167E/",
    thickness         = 0.15,
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  local lua = [[playercolor = "]] ..  p.color .. [["]] .. handCounter
  obj.setLuaScript( lua )
  obj.setName(p.color .. "Hand Counter")
  return obj
end

function spawnLifeCounter(p)
  --Life Counter
  local obj = spawnObject({
    type = "Custom_Token",
    scale             = {x=1, y=1 , z=1},
  })
  obj.setCustomObject({
    image             = "http://cloud-3.steamusercontent.com/ugc/1836915738113613310/922E11FF5CBC801148AA87DE60ED64472A618F3D/",
    collision         = false,
    thickness         = 0.15,
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  local lua = [[playercolor = "]] .. p.color .. [["]] .. lifeCounter
  obj.setLuaScript(lua)
  obj.setName(p.color .. "Life Counter")
  return obj
end

function spawnCommanderDamage(p) --Spawns Commander Damage Counter
  local obj = spawnObject({
    type = "Custom_Token",
    scale             = {x=0.32, y=1 , z=0.32},
  })
  obj.setCustomObject({
    image             = "http://cloud-3.steamusercontent.com/ugc/1009313481328783631/DDCC83524ED154C1F937AC5319E4903077E4A335/",
    collision         = false,
    thickness         = 0.15,
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  obj.setLuaScript(
    [[
    MIN_VALUE = 0
    MAX_VALUE = 21
    
    function onload(saved_data)
      val = 0
      if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        val = loaded_data[1]
      end
      createAll()
    end
    
    function updateSave()
      local data_to_save = {val}
      saved_data = JSON.encode(data_to_save)
      self.script_state = saved_data
    end
    
    function createAll()
      s_color = {0.5, 0.5, 0.5, 95}
      f_color = {0.9,0.9,0.9,100}
      
      if tooltip_show then
        ttText = "     " .. val .. "\n" .. self.getName()
      else
        ttText = self.getName()
      end
      
      self.createButton({
        label=tostring(val),
        click_function="null",
        tooltip=ttText,
        function_owner=self,
        position={0-0.1,0.1,0+0.1},
        height=0,
        width=0,
        scale={1.65, 1.65, 1.65},
        font_size=800,
        font_color={1-f_color[1],1-f_color[2],1-f_color[3],95},
        color={0,0,0,0}
      })
      
      self.createButton({
        label=tostring(val),
        click_function="add_subtract",
        tooltip=ttText,
        function_owner=self,
        position={0-0.04,0.18,0-0.04},
        height=500,
        width= 500,
        scale={1.65, 1.65, 1.65},
        font_size=800,
        font_color={0.1,0.1,0.1,100},
        color={0,0,0,0}
      })
      
      self.createButton({
        label=tostring(val),
        click_function="add_subtract",
        tooltip=ttText,
        function_owner=self,
        position={0-0.04,0.18,0+0.04},
        height=500,
        width= 500,
        scale={1.65, 1.65, 1.65},
        font_size=800,
        font_color={0.1,0.1,0.1,100},
        color={0,0,0,0}
      })
      
      self.createButton({
        label=tostring(val),
        click_function="add_subtract",
        tooltip=ttText,
        function_owner=self,
        position={0+0.04,0.18,0-0.04},
        height=500,
        width= 500,
        scale={1.65, 1.65, 1.65},
        font_size=800,
        font_color={0.1,0.1,0.1,100},
        color={0,0,0,0}
      })
      
      self.createButton({
        label=tostring(val),
        click_function="add_subtract",
        tooltip=ttText,
        function_owner=self,
        position={0+0.04,0.18,0+0.04},
        height=500,
        width= 500,
        scale={1.65, 1.65, 1.65},
        font_size=800,
        font_color={0.1,0.1,0.1,100},
        color={0,0,0,0}
      })
      
      self.createButton({
        label=tostring(val),
        click_function="add_subtract",
        tooltip=ttText,
        function_owner=self,
        position={0,0.18,0},
        height=500,
        width= 500,
        scale={1.65, 1.65, 1.65},
        font_size=800,
        font_color=f_color,
        color={0,0,0,0}
      })
      
      self.createButton({
        label='[R]',
        tooltip='Reset',
        click_function="reset_val",
        function_owner=self,
        position={0-0.04,0.1,1.3+0.04},
        rotation={0,0,0},
        height=400,
        width=600,
        scale={x=0.5, y=0.5, z=0.5},
        font_size=600,
        font_color={1-f_color[1],1-f_color[2],1-f_color[3],95},
        color={0,0,0,0}
      })
      
      self.createButton({
        label='[R]',
        tooltip='Reset',
        click_function="reset_val",
        function_owner=self,
        position={0,0.1,1.3},
        rotation={0,0,0},
        height=400,
        width=600,
        scale={x=0.5, y=0.5, z=0.5},
        font_size=600,
        font_color=f_color,
        color={0,0,0,0}
      })
      
    end
    
    function add_subtract(_obj, _color, alt_click)
      mod = alt_click and -1 or 1
      new_value = math.min(math.max(val + mod, MIN_VALUE), MAX_VALUE)
      if val ~= new_value then
        val = new_value
        updateVal()
        updateSave()
      end
    end
    
    function updateVal()
      if tooltip_show then
        ttText = "     " .. val .. "\n" .. self.getName()
      else
        ttText = self.getName()
      end
      
      for ind=0,5,1 do
        self.editButton({
          index = ind,
          label = tostring(val),
          tooltip = ttText
        })
      end
      
    end
    
    function reset_val()
      val = 0
      updateVal()
      updateSave()
    end
    
    function null()
    end
    ]]
  )
  return obj
end

function spawnUntapper(p,g) --Spawns Untapper Button
  local untapper = spawnObject({
    type = "BlockSquare",
    rotation          = {x=0, y=-90, z=0},
    scale             = {x=1.25, y=0.25, z=1.25},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  local lc = stringColorToRGB(p)
  lc.r = lc.r + 0.4
  lc.g = lc.g + 0.4
  lc.b = lc.b + 0.4
  untapper.setColorTint(p)
  untapper.setLock(true)
  untapper.interactable = false

  untapper.setLuaScript(
    [[
      function onload(save_state)
        self.createButton({ 
          click_function = 'untap',
          label = 'Untap',
          function_owner = self, 
          color = {]] .. "r=".. lc.r .. ",b=".. lc.b .. ",g=".. lc.g  .. [[},
          position = {0, 0.55, 0},rotation = {0, 0, 0},
          width = 500,
          height = 500,
          font_size = 150})
        if self.getDescription()=='' then
          setDefaultState()
        end
      end

      function onSave()
        return self.getDescription()
      end

      function setDefaultState()
        self.setDescription(JSON.encode({zone="]].. g ..[[", flip="yes"}))
      end

      function split(s, delimiter)
        result = {};
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
          table.insert(result, match);
        end
        return result;
      end

      function untap(clicked_object, player)
        if self.getDescription()=="" then
          setDefaultState()
          printToAll('Warning - invalid description. Restored defaut configuration.', {0.8,0.5,0})
        end

        local data = JSON.decode(self.getDescription())
        if data==nil then
          setDefaultState()
          data = JSON.decode(self.getDescription())
          printToAll('Warning - invalid description. Restored defaut configuration.', {0.8,0.5,0})
        end

        for num,zoneGUID in pairs(split(data.zone, ";")) do
          zone=getObjectFromGUID(zoneGUID)
          if zone!=nil and zone.type=="Scripting" then
            for k,v in pairs(zone.getObjects()) do
              if v.type=="Card" then
                if data.flip=="no" then
                  v.setRotationSmooth({self.getRotation().x,self.getRotation().y,v.getRotation().z})
                else
                  v.setRotationSmooth(self.getRotation())
                end
              end
            end
          else
            printToAll("I can't find zone from desctiption - " .. zoneGUID, {0.8,0.5,0})
          end
        end
      end
    ]]
  )

  return untapper
end

function spawnDrawer(p,g) --TODO:Spawns Draw Button
  local button = spawnObject({
    type = "BlockSquare",
    rotation          = {x=0, y=-90, z=0},
    scale             = {x=1.25, y=0.25, z=1.25},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  button.setColorTint(p)
  button.setLock(true)
  button.interactable = false

  button.setLuaScript(
    [[
      function onload(save_state)
        self.createButton({ 
          click_function = 'draw',
          label = 'Draw',
          function_owner = self,
          position = {0, 0.55, 0},rotation = {0, 0, 0},
          width = 500,
          height = 500,
          font_size = 150})
        if self.getDescription()=='' then
          setDefaultState()
        end
      end

      function draw(clicked_object, player)

      end
    ]]
  )

  return button
end

function findSeats(a, i) -- Amount of players, Player number
  transform = {}
  if i ~= nil and a ~= nil then
    off = 0
    x = ( ( 44 * math.ceil( (i-2) / 4 ) ) * ( - 1 + ( ( math.ceil( i / 2 ) % 2 ) * 2 ) ) )
    y = 14 - (28 * (i % 2))
    --print(i%2)
    --Rotate ends to face
    --TODO If over 8 or 10 have 2 facing ends
    if i % 2 == 1 and  a > 2 and a % 2 ~= 0 and a == i then
      if i % 4 == 3 then
        off = 90
        x = x + 8
      elseif i % 4 == 1 then
        off = -90
        x = x - 8
      end
      y = 0
    end
    --Centers cluster
    if a > 2 and a ~= 10 then
      if a % 2 == 0 then
        x = x + 22
      else
      end
      if a % 4 == 3 then
        x = x + 14
      end
    end
    
    transform = 
    {
      position          = { x, 0.5, y },
      rotation          = {0, (off + 90) + (180 * (i % 2)), 0}
    }
    --print("Transform set: " .. tr.position)
  else
    print("Seat values nil")
  end
  return transform
end

function clearPly() --Delete Playmats
  if #ply > 0 and ply ~= nil then 
    print(#ply)
    for i,j in pairs(ply) do
      print(j)
      if j ~= nil then
        j[1].destruct()
        for l,y in pairs(j[2]) do
         y.destruct()
         y = nil
        end
      end
      ply[i] = nil
    end
    ply = {}
  end
end

--Old

function circleColor()
  clearPly()
  sx,sy = 10,15 -- size of tray
  local x, y, r = 0, 0, 30 -- offset x, offset y, radious
  local c = 10 -- Amount of points
  for i,v in pairs(Player.getColors()) do
    if v ~= "Grey" and v ~= "Black" then
      --obj = spawnTray(Player[v],sx,0.25,sy)
      obj = spawnHandTray(Player[v],sx,0.25,sy)
      --obj = spawnZone(Player[v])
      obj.setLock(true)
      local angle = (i - 3.5) * math.pi / (c / 2)
      local ptx, pty = x + r * math.cos(angle), y + r * math.sin(angle)
      obj.setPosition(vector(ptx, 0.5, pty))
      obj.setRotation(vector(0, 234 + ((i-2) * -360 / c), 0))

      table.insert(ply, obj)
    end
  end
end

function spawnHandTray(p)
  obj = spawnTray(p,8,0.25,16)
  lua = "p = Player." .. p.color ..
  [=[

    off = vector( 0, 3, 0 )
    sca = vector(16, 6, 4)
    up = false
    function onLoad(save_state)
        self.addContextMenuItem("Reposition Hand", fixPosition)
        Wait.frames(fixPosition, 1)
    end
    function checkHand()
        return p.getHandCount() > 0
    end
    function fixPosition()
        up = self.getVelocity() ~= vector(0, 0, 0)
        pos = self.getPosition()
        rot = self.getRotation()
        if rot.x ~= 0 or rot.z ~= 0 then
            rot.x = 0;
            rot.z = 0;
            self.setRotation({rot.x,roundNumberToFactor(rot.y,15),rot.z})
        end
        if checkHand() and not up then
            t = p.getHandTransform()
            t["scale"] = sca

            pos.x = pos.x + off.x
            pos.y = pos.y + off.y

            t["position"] = PointOnSphere(pos, rot, off.z)
            t["rotation"] = vector(rot.x, rot.y + 90, rot.z)
            p.setHandTransform(t, 1)
        else
            print("There is no handzones for ".. p.color)
        end
    end
    function PointOnSphere(origin, rotation, radius)
        return {
            x = origin.x + radius * math.cos(math.rad(-rotation.y)) * math.cos(math.rad(rotation.x)),
            y = origin.y + radius * math.sin(math.rad(rotation.x)),
            z = origin.z + radius * math.sin(math.rad(-rotation.y)) * math.cos(math.rad(rotation.x))
        }
    end
    function roundNumberToFactor(number, factor)
      if(number % factor > factor/2) then
          return number + (factor - (number % factor))
      else
          return number - (number % factor)
      end
    end
  ]=]
  obj.setLuaScript(lua)
  return obj
end

function spawnTray(p, xSize, ySize, zSize)
  --print("" .. xSize .. " " .. ySize .. " " .. zSize)
  size = vector(xSize, ySize, zSize)

  colors = {
    White   = color(1.000, 1.000, 1.000, 1),
    Brown   = color(0.443, 0.231, 0.090, 1),
    Red     = color(0.856, 0.100, 0.094, 1),
    Orange  = color(0.956, 0.392, 0.113, 1),
    Yellow  = color(0.905, 0.898, 0.172, 1),
    Green   = color(0.192, 0.701, 0.168, 1),
    Teal    = color(0.129, 0.694, 0.607, 1),
    Blue    = color(0.118, 0.530, 1.000, 1),
    Purple  = color(0.627, 0.125, 0.941, 1),
    Pink    = color(0.960, 0.439, 0.807, 1),
    Grey    = color(0.500, 0.500, 0.500, 1),
    Black   = color(0.250, 0.250, 0.250, 1),
  }
  c = colors[p.color]

  spawnParams = {
    type = "BlockSquare",
    rotation          = {x=0, y=90, z=0},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  }

  --Base
  obj = spawnObject(spawnParams)
  obj.setLock(true)
  obj.setColorTint(color(c.r, c.g, c.b, 65/255))
  obj.setPosition({x=0, y=3, z=0})
  obj.setScale({x=size.x-1, y=0.25, z=size.z-1})
  --Bottom
  obj1 = spawnObject(spawnParams)
  obj1.setLock(true)
  obj1.setColorTint(c)
  obj1.setPosition({x= 0, y=3, z=-(size.x/2) + 0.5})
  obj1.setScale({x=1, y=size.y, z=size.z})
  --Top
  obj2 = spawnObject(spawnParams)
  obj2.setLock(true)
  obj2.setColorTint(c)
  obj2.setPosition({x= 0, y=3, z=(size.x/2) - 0.5})
  obj2.setScale({x=1, y=size.y, z=size.z})
  --Left
  obj3 = spawnObject(spawnParams)
  obj3.setLock(true)
  obj3.setColorTint(c)
  obj3.setPosition({x= (size.z/2) - 0.5, y=3, z=0})
  obj3.setScale({x=size.x, y=size.y, z=1})
  --Right
  obj4 = spawnObject(spawnParams)
  obj4.setLock(true)
  obj4.setColorTint(c)
  obj4.setPosition({x= -(size.z/2) + 0.5, y=3, z=0})
  obj4.setScale({x=size.x, y=size.y, z=1})

  obj.addAttachment(obj1)
  obj.addAttachment(obj2)
  obj.addAttachment(obj3)
  obj.addAttachment(obj4)
  obj.setLock(false)
  return obj
end

--Utilities

function searchScryfall(data,pos) --Uses the Card Importer to spawn a search
  local p = getSeatedPlayers()[1]
  CardImporter = getObjectFromGUID(CardImporterGUID)
  local t ={
    position={pos.x, pos.y + 2, pos.z},
    player=Player[p].steam_id,
    color=Player[p].color,
    full=data,
    mode="Search",--data:gsub('(http%S+)',''):match('(%S+)'),
    name=data:gsub('(http%S+)',''):gsub(' ',''),
    url=data:match('(http%S+)')
  }
  CardImporter.call('Importer', t)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function roundNumberToFactor(number, factor)
  if(number % factor > factor/2) then
      return number + (factor - (number % factor))
  else
      return number - (number % factor)
  end
end