Zone = {}
OutZone = {}
size = 0.75
bricks = {}

function onPickUp(player_color)
  setup()
end

dex = 1
function addBrick(obj)
  bricks[dex] = obj.getGUID()
  dex = dex + 1
  print(dex)
end

function dismantle()
  for i,v in pairs(bricks) do
    if v ~= nil then
      getObjectFromGUID(v).destruct()
      bricks[i] = nil
    end
  end
  dex = 1
end

function setup()
  if dex > 1 then
    dismantle()
  end

  off = 10
  random = math.random(0,8)
  sp = size * 0.75
  a,b,c,d = 0,0,0,0
  sx,sy,sz = size, size * 0.6, (size*3) + (sp/4)

  ba,bb,bc = (sx*sy*sz)*10, 2.25, 0

  loc = sx + (sp/8)

  max, min, inc = 225, 25, 12.5
  cx,cy,cz = max, min, min
  aa,ab,ac = 0, 0.25, 0

  for i=1, 25 do
    b = (i * (sy + 0.5)) + sp
    for j=1, 3 do
      a,c,d = 0,0,0

      if i % 2 == 0 then
        d=0
        if j==1 then
          a = 0
        elseif j == 2 then
          a = loc
        elseif j == 3 then
          a = -loc
        end
      else
        d=90
        if j==1 then
          c = 0
        elseif j == 2 then
          c = loc
        elseif j == 3 then
          c = -loc
        end
      end
      spawnParams =
      {
        type = "BlockSquare",
        position          = {x=a, y=b, z=c},
        rotation          = {x=0, y=d, z=0},
        scale             = {x=sx, y=sy, z=sz},
        sound             = false,
        snap_to_grid      = true,
        callback_function = function(obj) addBrick(obj)
            obj.setSnapPoints(
            {
              {
                position = {0,0.5,0},
                rotation = {0,90,0},
                rotation_snap = true
              },
              {
                position = {0,0.5,0.34},
                rotation = {0,90,0},
                rotation_snap = true
              },
              {
                position = {0,0.5,-0.34},
                rotation = {0,90,0},
                rotation_snap = true
              },
            })
        end
      }
      obj = spawnObject(spawnParams)
      --[[
      spawnParams =
      {
        type = "Custom_Model",
        position          = {x=a, y=b, z=c},
        rotation          = {x=0, y=d, z=0},
        scale             = {x=0.38, y=0.38, z=0.38},
        sound             = false,
        snap_to_grid      = true,
        callback_function = function(obj) addBrick(obj) end,
      }
      obj = spawnObject(spawnParams)
      obj.setCustomObject({
        mesh              = "https://pastebin.com/raw/YYDzRqYH",
        diffuse           = "http://i.imgur.com/PhxIIX5.png",
      })
      --]]
      obj.static_friction = aa
      obj.dynamic_friction = ab
      obj.bounciness = ac
      obj.mass = ba
      obj.drag = bb
      obj.angular_drag = bc
      obj.auto_raise = false
      obj.sticky = false
      obj.use_grid = false
      obj.drag_selectable = false

      --Rainbow
      if random == 0 then
        if cx >= max and cy < max and cz == min then
          cy = cy + inc
        end
        if cx == min and  cy >= max and cz < max then
          cz = cz + inc
        end
        if cx < max and  cy == min and cz >= max then
          cx = cx + inc
        end

        if cx > min and cy == max and cz == min then
          cx = cx - inc
        end
        if cx == min and cy > min and cz == max then
          cy = cy - inc
        end
        if cx == max and cy == min and cz > min then
          cz = cz - inc
        end
        --off = 10 * math.abs(c+a) + ofs
        obj.setColorTint(Color( (cx + off)/255, (cy + off)/255, (cz + off)/255))
      elseif random > 1 and random < 3 then
        obj.setColorTint(Player.getColors()[ ((i + j - 1)  % 8 ) + 3])
      else
        off = math.random(50)
        obj.setColorTint(Color( (off+ 200)/255, (off+ 150)/255, (off+ 100)/255))
      end
    end
  end
  Wait.condition(function() Zone = getZone() end, function() return spawnZone() ~= nil end)
end

function spawnZone()
  if getZone() == nil then
    spawnObject({
      type = "ScriptingTrigger",
      position = vector(0, 1, 0),
      rotation = vector(0, 0, 0),
      scale = vector(sz*1.5, 75, sz*1.5),
      sound = false
    })
    spawnObject({
      type = "ScriptingTrigger",
      position = vector(0, 0, 0),
      rotation = vector(0, 0, 0),
      scale = vector(25, 75, 25),
      sound = false
    })
  end
  return getZone()
end

function getZone()
  local zone
  for i, v in pairs(getAllObjects()) do
    if v.getPosition() == vector(0, 1, 0) and v.tag == "Scripting" then
      zone = v.guid
    end
    if v.getPosition() == vector(0, 0, 0) and v.tag == "Scripting" then
      OutZone = v.guid
    end
  end
  return zone
end

count = 0
counting = false
function onObjectLeaveScriptingZone(zone, leave_object)
  if leave_object.tag == "Block" then
    leave_object.auto_raise = true

    Wait.time(function()
      --Sometimes the piece makes it self sideways
      rot = leave_object.getRotation()
      rot.z = 0
      leave_object.setRotation(rot)
    end, 1)

    count = count + 1
    if not counting then
      counting = true
      Wait.time(function() counting = false count = 0 end, 2)
    end
    if count > 3 then
      --print("All is lost ", zone.guid)
    end

      --If flicked too far
    if zone.getGUID() == OutZone then
      pos = leave_object.getPosition()
      leave_object.setPositionSmooth(
      {math.min(math.max(pos.x, -12), 12),5,math.min(math.max(pos.z, -12), 12)}
      , true, true)
    end
  end
end

function onObjectEnterScriptingZone(zone, enter_object)
  if enter_object.tag == "Block" then
    Wait.condition(function() enter_object.auto_raise = false end,
    function() return enter_object.held_by_color == nil end)
  end
end

function onObjectDrop(player_color, dropped_object)
  if dropped_object.tag == "Block" then
    --Sometimes the piece makes it self sideways
    rot = dropped_object.getRotation()
    rot.z = 0
    --dropped_object.setRotation(rot)
  end
end