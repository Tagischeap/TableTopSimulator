ply = {}
mats = {}


function onload()
  --setMats(5)
  self.addContextMenuItem("Setup", setup)
  self.addContextMenuItem("Circle", circleColor)
  self.setPosition({0, 1, 0})
  self.setRotation({0, 0, 0})
  self.setScale({2,1,2})
  self.setLock(true)
  --spawnCircles()
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
  mats = Player.getColors()
  table.remove(mats) -- Remove Black
  table.remove(mats) -- Remove Grey
  for i = 1,#mats - ammount, 1 do
    table.remove(mats) -- Remove
  end
end

function setup()
  removeCircles()
  --obj = spawnZone(Player["White"])
  mats = getSeatedPlayers()

 --Spawns everything
  for i,v in pairs(mats) do 
    --Spawns stuff
    if v ~= "Grey" and v ~= "Black" then
      tr = findSeats(#mats,i)
      obj = spawnZone(Player[v])
      obj.setPosition(tr.position)
      obj.setRotation(tr.rotation)
      stuff = spawnExtras(Player[v])
      
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

function spawnZone(p)
 --[[
  obj = spawnTray(p,24,0.25,24)
  obj.setLock(true)

  obj1 = spawnHandTray(p)
  obj1.setLock(true)
    
  obj.addAttachment(obj1)
  obj.setLock(false)
  ]]
 --|
  self.setPosition({0, -15, 0})
  --print("" .. xSize .. " " .. ySize .. " " .. zSize)
  size = vector(28, 0.25, 44)

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
  --|
 --<Base Peices>
 --Base
  obj = spawnObject(spawnParams)
  obj.setLock(true)
  obj.setColorTint(color(c.r, c.g, c.b, 65/255))
  obj.setScale({x=size.x-1, y=0.25, z=size.z-1})
  obj.setPosition({x=0, y=3, z=0})
 --Bottom
  obj1 = spawnObject(spawnParams)
  obj1.setLock(true)
  obj1.setColorTint(c)
  obj1.setScale({x=1, y=size.y, z=size.z})
  obj1.setPosition({x= 0, y=3, z=-(size.x/2) + 0.5})
 --Top
  obj2 = spawnObject(spawnParams)
  obj2.setLock(true)
  obj2.setColorTint(c)
  obj2.setScale({x=1, y=size.y, z=size.z})
  obj2.setPosition({x= 0, y=3, z=(size.x/2) - 0.5})
 --Left
  obj3 = spawnObject(spawnParams)
  obj3.setLock(true)
  obj3.setColorTint(c)
  obj3.setScale({x=size.x, y=size.y, z=1})
  obj3.setPosition({x= (size.z/2) - 0.5, y=3, z=0})
 --Right
  obj4 = spawnObject(spawnParams)
  obj4.setLock(true)
  obj4.setColorTint(c)
  obj4.setScale({x=size.x, y=size.y, z=1})
  obj4.setPosition({x= -(size.z/2) + 0.5, y=3, z=0})
 --

 --<Dividers>
 --Hand Divider
  obj5 = spawnObject(spawnParams)
  obj5.setLock(true)
  obj5.setColorTint(c)
  obj5.setScale({x=0.25, y=size.y, z=size.z - 20.25})
  obj5.setPosition({x= 0, y=3, z=(size.x/2) + 0.5 - 7.5})

 --Left Divider
  obj6 = spawnObject(spawnParams)
  obj6.setLock(true)
  obj6.setColorTint(c)
  obj6.setScale({x=6, y=size.y, z=0.25})
  obj6.setPosition({x= (size.z/2) - 10.25, y=3, z=10})

 --Right Divider
  obj7 = spawnObject(spawnParams)
  obj7.setLock(true)
  obj7.setColorTint(c)
  obj7.setScale({x=6, y=size.y, z=0.25})
  obj7.setPosition({x= -(size.z/2) + 10.25, y=3, z=10})
 --Divider
  
  obj8 = spawnObject(spawnParams)
  obj8.setLock(true)
  obj8.setColorTint(c)
  obj8.setScale({x=0.25, y=size.y, z=size.z})
  obj8.setPosition({x= 0, y=3, z=(size.x/2) + 0.5 - 10})
  
 --

  -- X = left, Y = Height, Z = Up

 --Hand
  lua = "p = Player." .. p.color ..
  [=[

    off = vector( 0, 3, -11 )
    sca = vector(23.50, 6, 3)
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
  --obj.call('fixPosition')
 --
 --<Attach everything>
  obj.addAttachment(obj1)
  obj.addAttachment(obj2)
  obj.addAttachment(obj3)
  obj.addAttachment(obj4)
  
  obj.addAttachment(obj5)
  obj.addAttachment(obj6)
  obj.addAttachment(obj7)
  obj.addAttachment(obj8)

  --
  obj.interactable = false

  
  return obj
end

function spawnExtras(p)
  extras = {}
 --Hand Counter
  obj = spawnHandCounter(p)
  obj.setPosition({x=-6.25, y=0.6, z=-4})
  obj.setRotation({x=0, y=-90, z=0})
  obj.setLock(true)
  obj.interactable = false
  table.insert(extras, obj)
 --Life
  obj2 = spawnLifeCounter(p)
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
      cd = spawnCommanderDamage(p)
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
  obj9 = spawnCardZone(p.color)
  obj9.setPosition({x= 8.5 -16, y=0.5, z= 22 - 2.5})
  table.insert(extras, obj9)
  
 --Graveyard
  obj10 = spawnCardZone(p.color)
  obj10.setPosition({x= 8.5 -16, y=0.5, z= 22 - 5.5})
  table.insert(extras, obj10)

 --Exile
  obj11 = spawnCardZone(p.color)
  obj11.setPosition({x= 8.5 -16, y=0.5, z= 22 - 8.5})
  table.insert(extras, obj11)
  
 --Commander 1
  obj5 = spawnCardZone(p.color)
  obj5.setPosition({x= 8.5 -16, y=0.5, z= -(22 - 8.5)})
  table.insert(extras, obj5)

 --Commander 2
  obj4 = spawnCardZone(p.color)
  obj4.setPosition({x= 8.5 -16, y=0.5, z= -(22 - 5.5)})
  table.insert(extras, obj4)

 --Extra
  obj3 = spawnCardZone(p.color)
  obj3.setPosition({x= 8.5 -16, y=0.5, z= -(22 - 2.5)})
  table.insert(extras, obj3)
  
  local zone = spawnObject({
    type = "ScriptingTrigger",
    rotation          = {x=0, y=90, z=0},
    scale             = {x=42, y=3, z=17.5},
    position          = {x=4.25, y=1, z=0}
  })
  table.insert(extras, zone)

  obj8 = spawnUntapper(p.color, zone.getGUID())
  obj8.setPosition({x= 8.5 -16 +1.75, y=0.525, z= 22 - 2.5 -10})
  table.insert(extras, obj8)

  --[[
  obj9 = spawnDrawer(p.color, zone.getGUID())
  obj9.setPosition({x= 8.5 -16 +1.75, y=0.5, z= 22 - 2.5 -11.5})
  table.insert(extras, obj9)
  ]]


  secondHand = spawnObject(
    {
      type              = "HandTrigger",
      color             = v,
      position          = {x= 5 -16, y=3.5, z= 22 - 5.65},
      scale             = {x= 9.25, y=6, z=2},
      rotation          = {x=0,y=90,z=0},
      sound             = false,
      snap_to_grid      = true,
      ignore_fog_of_war	= true
    }
  )
  table.insert(extras, secondHand)

  thirdHand = spawnObject(
    {
      type              = "HandTrigger",
      color             = v,
      position          = {x= 5 -16, y=3.5, z= -22 + 5.65},
      scale             = {x= 9.25, y=6, z=2},
      rotation          = {x=0,y=90,z=0},
      sound             = false,
      snap_to_grid      = true,
      ignore_fog_of_war	= true
    }
  )
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

  obj.setLuaScript(
    [[
      --- Hand counter by Schokolabbi

      --- Click delay time in seconds
      options = {["clickDelay"] = 0.3}

      clickCounter = 0

      doubleClickParameters = {
          ["identifier"] = "ClickTimer" .. self.guid,
          ["function_name"] = "resetClickCounter",
          ["delay"] = options.clickDelay,
      }

      function onSave()
          if not owner then return nil end
          return JSON.encode({
              ["ownerColor"] = owner.color,
          })
      end

      function onLoad(jsonData)
          if jsonData == "" then
              setOwner(nill)
              findOwner("]] .. p.color .. [[")
              setOwner("]] .. p.color .. [[")
          else
              local data = JSON.decode(jsonData)
              setOwner(data.ownerColor)
          end
      end

      function update()
          if not owner then return end
          if owner.getHandTransform() == nill then return end
          self.editButton({index=0, label=#owner.getHandObjects()})
          self.setName(#owner.getHandObjects())
      end

      function findOwner(color)
          if not isPlayerAuthorized(color) then return end
          if clickCounter == 0 then
              Timer.create(doubleClickParameters)
          end
          if isDoubleClick() then
              setOwner(nil)
          elseif not owner then
              setOwner(color)
          end
      end

      function onPickedUp(color)
          findOwner(color)
      end

      function onClick(object, color)
          findOwner(color)
      end

      function resetClickCounter()
          clickCounter = 0
      end

      function isDoubleClick()
          clickCounter = clickCounter + 1
          return clickCounter > 1
      end

      function setOwner(color)
          local objectCount = 0
          if color then
              owner = Player[color]
              objectCount = #owner.getHandObjects()
              self.setName(objectCount)
          else
              owner = nil
              color = "Grey"
              objectCount = 0
              self.setName("Card Counter - Click to claim!")
          end
          local rgbColorTable = stringColorToRGB(color)
          self.setColorTint(rgbColorTable)
          self.clearButtons()
          self.createButton({
              label=tostring(objectCount), click_function="onClick", function_owner=self,
              position={0.4,0.15,-1.0}, height=0, width=0; font_size=650
          })
      end

      function isPlayerAuthorized(color)
          player = Player[color]
          return player == owner or player.admin
      end
    ]]
  )
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

  obj.setLuaScript(
    [[
      --By Amuzet
      mod_name,version='LifeTracker',1
      author='76561198045776458'

      function updateSave()
        self.script_state=JSON.encode({['c']=count})
      end

      function wait(t)
        local s=os.time()
        repeat coroutine.yield(0) until os.time()>s+t
      end

      function sL(l,n)
        plus=''
        if n~=nil then
          if n>0 then plus='+' end
          if n==0 then
            n=nil
          end
        end
        self.editButton({index=0,label=l})
        self.editButton({index=1,label=plus..(n or'')})

      end

      function option(o,c,a)
        local n=1
        if a then
          n=-n
        end
        click_changeValue(o,c,n)
      end

      function click_changeValue(obj, color, val)
        if color==owner or Player[color].admin then
          local C3=count
          count=count+val
          local C1=count
          function clickCoroutine()
            if not C2 then
              C2=C3
            end
            sL(count,(count-C2))
            wait(3)
            if C2 and C1==count then
              local gl='lost'
              if C1>C2 then
                gl='gained'
              end
              if C1~=C2 then
                sL(count)
                local t=txt:format(gl,math.abs(count-C2),count)
                printToAll(t,ownerRGB)
                log(t)
              end
              C2=nil
            end
          return 1
          end
          startLuaCoroutine(self,'clickCoroutine')
          updateSave()
        end
      end

      local lCheck={
        ['extort_']=function(n,c)if c==owner then for _,p in pairs(Player.getPlayers())do if p.seated and p.color~=owner then count=count+n end end return count,'extorted everyone for'else return count-n,false,true end end,
        ['drain_']=function(n,c)if c==owner then return count+n,'drained everyone for'else return count-n,false,true end end,
        ['opponents_lose_']=function(n,c)if c~=owner then return count-n else return count,'opponents lost'end end,
        ['everyone_loses_']=function(n,c)return count-n,'made everyone lose'end,
        ['double_my_life_']=function(n,c)if c==owner then return count*2^n,'doubled their life this many times'end end,
        ['set_life_']=function(n,c)if c==owner then return n,'life total changed by '..math.abs(n-count)..'. Setting it to'end end,
        ['RESET_Life_']=function(n,c)return n,'reset life totals to'end,
        -- ['test_']=function(n,c)return count end,
      }

      function onChat(msg,player)
        if msg:find('[ _]%d+') then
          local m=msg:lower():gsub(' ','_')
          local a,sl,t,n=false,false,'',tonumber(m:match('%d+'))
          for k,f in pairs(lCheck) do
            if m:find(k..'%d+') then
              a,t,sl=f(n,player.color)
              if a then
                count=a
                if sl then
                  sL(count,n)
                end
              break
              else
                return msg
              end
            end
          end
          updateSave()
          if t and t~='' then
            broadcastToAll(player.color..'[999999] '..t..' [-]'..n,ownerRGB)
            sL(count,count-JSON.decode(self.script_state).c)
            return false
          end
        end
      end

      function onload(s)
        owner = "]] .. p.color .. [["
        ownerRGB = Color.fromString(owner)
        ref_type = self.getName():gsub('%s.+','')
        txt = owner..' [888888]%s %s '..ref_type..'.[-] |%s|'
        self.setColorTint(ownerRGB)
        if s~='' then
          local ld=JSON.decode(s); count=ld.c
        else
          count=40
        end
        local rgb = stringColorToRGB(owner)

        self.createButton({             -- the main button
          tooltip='Click to increase\nRight click to decrease',
          click_function='option',
          function_owner=self,
          height=750,
          width=950,
          font_size=1000,
          label='\n'..count..'\n',
          position={0,y,z},
          hover_color={1,1,1,0.1},
          scale=scale,
          color=back,
          font_color=font
        })

        self.createButton({             -- moved the change value to a separate button for more control
          click_function='null',
          function_owner=self,
          height=0,
          width=0,
          font_size=400,
          label='',
          position={0-0.05,y,z+1},
          hover_color={1,1,1,0.1},
          scale=scale,
          color=back,
          font_color=font
        })

        for i,v in ipairs({             -- the side buttons
            {n=1,l='▲',p={x*0.95,y,z+0.2}},
            {n=-1,l='▼',p={-x,y,z+0.2}},
            {n=20,l='+20',p={x*1.05,y,z-0.4}},
            {n=-20,l='-20',p={-x*1.1,y,z-0.4}}}) do

          local fn='valueChange'..i
          self.setVar(fn, function(o,c,a) local b=1 if a then b=5 end click_changeValue(o,c,v.n*b) end)
          self.createButton({
            tooltip='Right-click for '..v.n*5,
            label=v.l,
            position=v.p,
            click_function=fn,
            function_owner=self,
            height=800,
            width=800,
            font_size=700,
            hover_color={1,1,1,0.1},
            scale=scale2,
            color=back,
            font_color={font[1],font[2],font[3],50},
          })
        end

        self.createButton({            -- reset life to 40 button
          label='[R]',
          click_function='resetLife',
          tooltip='Reset Life',
          function_owner=self,
          position={x*0.72,y,z-1.05},
          height=800,
          width=800,
          alignment = 3,
          font_size=700,
          hover_color={1,1,1,0.1},
          scale=scale2,
          font_color={font[1],font[2],font[3],20},
          color=back,
        })
      end

      function resetLife(obj,color)
        --if color==owner then
          sL(40,0)
          count=40
          printToAll(owner..'[999999] reset their life to [-]|'..count..'|',ownerRGB)
          updateSave()
        --end
      end

      function null()
      end

      x=1.2
      y=0.15
      z=-0.3
      objsca = self.getScale()
      scale  = {1,1,1}
      scale2 = {0.3,1,0.3}
      back = {0,0,0,0}
      font = {1,1,1,100}
      mode=''
      ref_type=''
      owner=''
      C2=nil
    ]]
  )
  return obj
end

function spawnCommanderDamage(p)
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

function spawnUntapper(p,g)
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

function spawnDrawer(p,g)
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

--Old

function circleColor()
  
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