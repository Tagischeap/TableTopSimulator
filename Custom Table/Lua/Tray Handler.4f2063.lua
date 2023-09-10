
function onload()
  s = 35
  --[[
  spawnTray(Player.Red,s,1,s).setPosition({x=-72,y=1,z=18})
  spawnTray(Player.Yellow,s,1,s).setPosition({x=-72,y=1,z=-18})
  spawnTray(Player.Orange,s,1,s).setPosition({x=-35,y=1,z=-57})
  spawnTray(Player.Green,s,1,s).setPosition({x=35,y=1,z=-57})
  spawnTray(Player.Teal,s,1,s).setPosition({x=72,y=1,z=-18})
  spawnTray(Player.Blue,s,1,s).setPosition({x=72,y=1,z=18})
  spawnTray(Player.Purple,s,1,s).setPosition({x=35,y=1,z=57})
  spawnTray(Player.Pink,s,1,s).setPosition({x=-35,y=1,z=57})
  spawnTray(Player.White,s,1,s).setPosition({x=0,y=1,z=57})
  spawnTray(Player.Brown,s,1,s).setPosition({x=0,y=1,z=-57})
  spawnTray(Player.Black,s,1,s).setPosition({x=0,y=1,z=0})
  --]]
  --spawnFogTray(Player.Black).setPosition({x=0,y=1,z=0})
  --spawnHandTray(Player.Black).setPosition({x=0,y=5,z=0})
  self.addContextMenuItem("Setup", setup)
  self.addContextMenuItem("Circle", circleColor)
end

function setup()
  --obj = spawnZone(Player["White"])

  mats = Player.getColors();
  ammount = 10 -- How many mats Max:10
  
  table.remove(mats) -- Remove Black
  table.remove(mats) -- Remove Grey
  for i = 1,#mats - ammount, 1 do
    table.remove(mats) -- Remove
  end
  --mats = getSeatedPlayers()
  
  off = 0
  for i,v in pairs(mats) do 
    print(i .. ", " .. (i % 4))
    x = ( ( 44 * math.ceil( (i-2) / 4 ) ) * ( - 1 + ( ( math.ceil( i / 2 ) % 2 ) * 2 ) ) )
    y = 14 - (28 * (i % 2))
    if i % 2 == 1 then
      
    end
    --Rotate ends to face
    --TODO If over 8 or 10 have 2 facing ends
    if #mats > 2 and #mats % 2 ~= 0 then
      if #mats == i then
        if i % 4 == 3 then
          off = 90
          x = x + 8
        elseif i % 4 == 1 then
          off = -90
          x = x - 8
        end
        y = 0
      end
    end
    --Center board cluster
    if #mats ~= 1 and #mats ~= 10 then
      if #mats % 2 == 0 then
        x = x + 22
      else
        if #mats % 4 == 3 then
          x = x - 14
        else
          x = x + 14
        end
      end
    end

    if v ~= "Grey" and v ~= "Black" then
      obj = spawnZone(Player[v])
      obj.setLock(true)
      obj.setPosition(vector(x, 0.5, y))
      obj.setRotation(vector(0, (off + 90) + (180 * (i % 2)), 0))
    end
  end

end


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
      print()
      local ptx, pty = x + r * math.cos(angle), y + r * math.sin(angle)
      obj.setPosition(vector(ptx, 0.5, pty))
      obj.setRotation(vector(0, 234 + ((i-2) * -360 / c), 0))
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
 --

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
  --[[
  obj8 = spawnObject(spawnParams)
  obj8.setLock(true)
  obj8.setColorTint(c)
  obj8.setScale({x=0.25, y=size.y, z=size.z})
  obj8.setPosition({x= 0, y=3, z=(size.x/2) + 0.5 - 14})
  ]]
 --

 --Library
 
  obj9 = spawnObject(spawnParams)
  obj9.setLock(true)
  obj9.setColorTint(c)
  obj9.setScale({x=3.25, y=size.y, z=2.5})
  obj9.setPosition({x= (size.z/2) - 2.5, y=3, z=(size.x/2) + 0.5 - 6})
 

 --Graveyard
  obj10 = spawnObject(spawnParams)
  obj10.setLock(true)
  obj10.setColorTint(c)
  obj10.setScale({x=3.25, y=size.y, z=2.5})
  obj10.setPosition({x= (size.z/2) - 5.5, y=3, z=(size.x/2) + 0.5 - 6})

 --Exile
  obj11 = spawnObject(spawnParams)
  obj11.setLock(true)
  obj11.setColorTint(c)
  obj11.setScale({x=3.25, y=size.y, z=2.5})
  obj11.setPosition({x= (size.z/2) - 8.5, y=3, z=(size.x/2) + 0.5 - 6})
 -- X = left, Y = Height, Z = Up
 
 --Hand
  lua = "p = Player." .. p.color ..
  [=[
    off = vector( 0, 3, -11 )
    sca = vector(16, 6, 4)
    up = false
    function onLoad(save_state)
        self.addContextMenuItem("Reposition Hand", fixPosition)
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
            self.setRotation(rot)
        end
        if checkHand() and not up then
            t = p.getHandTransform()
            t["scale"] = sca
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
  ]=]
  obj.setLuaScript(lua)
  --obj.call('fixPosition')
 --

  obj.addAttachment(obj1)
  obj.addAttachment(obj2)
  obj.addAttachment(obj3)
  obj.addAttachment(obj4)
  
  obj.addAttachment(obj5)
  obj.addAttachment(obj6)
  obj.addAttachment(obj7)
  --obj.addAttachment(obj8)

  obj.setSnapPoints({
    {
      position = obj.positionToLocal(obj9.getPosition()),
      rotation = {0,270,0},
      rotation_snap = true
    },
    {
      position = obj.positionToLocal(obj10.getPosition()),
      rotation = {0,270,0},
      rotation_snap = true
    },
    {
      position = obj.positionToLocal(obj11.getPosition()),
      rotation = {0,270,0},
      rotation_snap = true
    }
  })

  obj.addAttachment(obj9)
  obj.addAttachment(obj10)
  obj.addAttachment(obj11)
  obj.setLock(false)
  
  return obj
end

function cardZone(color)
  obj = spawnObject({
    type = "BlockSquare",
    rotation          = {x=0, y=90, z=0},
    scale             = {x=3.25, y=0.25, z=2.35},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  obj.setColorTint(color)
  obj.setLock(true)
  return obj
end

function spawnExtras(obj, spawnParams)
  --Hand Counter
  obj12 = spawnObject({
    type = "Custom_Token"
  })
  obj12.setCustomObject({
    image             = "http://cloud-3.steamusercontent.com/ugc/1646593716898448966/68DC98F323399C7CADF7E53933EAC99FBB94167E/",
    thickness         = 0.15,
    rotation          = {x=0, y=90, z=0},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  obj12.setLuaScript([[
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
              position={0.4,0.07,-1.0}, height=0, width=0; font_size=650
          })
      end

      function isPlayerAuthorized(color)
          player = Player[color]
          return player == owner or player.admin
      end
    ]])
  obj12.setLock(true)
  obj12.setScale({x=0.5, y=0.5 , z=0.5})
  obj12.setPosition({x= -12, y=3.15, z=11.9})
  obj.jointTo(obj12,{type = "Fixed", collision = false})
  obj12.setLock(false)
  obj12.interactable = false

  --Life Counter
  obj13 = spawnObject({
    type = "Custom_Token"
  })
  obj13.setCustomObject({
    image             = "http://cloud-3.steamusercontent.com/ugc/1836915738113613310/922E11FF5CBC801148AA87DE60ED64472A618F3D/",
    collision         = false,
    thickness         = 0.15,
    rotation          = {x=0, y=90, z=0},
    sound             = false,
    snap_to_grid      = true,
    ignore_fog_of_war	= true
  })
  obj13.setLuaScript([[
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
    y=0.07
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
    ]])
  obj13.setLock(true)
  obj13.setScale({x=1, y=1 , z=1})
  obj13.setPosition({x= 0, y=3.15, z=7})
  obj.jointTo(obj13,{type= "Fixed", collision = false})
  obj13.setLock(false)
  obj13.interactable = false

end

function spawnHandTray(p)
  obj = spawnTray(p,8,0.25,16)
  lua = "p = Player." .. p.color ..
  [=[
    off = vector(10, 3, 0)
    up = false
    fixed = false
    function onLoad(save_state)
          pos = self.getPosition()
          rot = self.getRotation()
          sca = vector(10, 6, 4)

          if checkHand() then
            t = p.getHandTransform()
            t["position"] = PointOnSphere(pos, rot, off.z)
            t["rotation"] = vector(rot.x, rot.y + 90, rot.z)
            t["scale"] = sca
            p.setHandTransform(t, 1)
          else
            print("There is no handzones for ".. p.color)
          end
    end
    function checkHand()
        return p.getHandCount() > 0
    end
    function fixedUpdate(player_color)
        up = self.getVelocity() ~= vector(0, 0, 0)
        pos = self.getPosition()
        rot = self.getRotation()
        pitch = rot.x
        yaw = rot.y
        if rot.x ~= 0 or rot.z ~= 0 then
          rot.x = 0;
          rot.z = 0;
          --self.setLock(true)
          self.setRotation(rot)
    end

        if(checkHand()) then
          if up and fixed then fixed = false end
            if not fixed and not up then
              t = p.getHandTransform()
              point = PointOnSphere(pos, rot, off.z)
              point.y = pos.y + off.y

              t["position"] = point
              t["rotation"] = vector(rot.x, rot.y + 90, rot.z)
              p.setHandTransform(t, 1)
              fixed = true
            end
          end
    end
    function PointOnSphere(origin, rotation, radius)
          return {
              x = origin.x + radius * math.cos(math.rad(-rotation.y)) * math.cos(math.rad(rotation.x)),
              y = origin.y + radius * math.sin(math.rad(rotation.x)),
              z = origin.z + radius * math.sin(math.rad(-rotation.y)) * math.cos(math.rad(rotation.x))
          }
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