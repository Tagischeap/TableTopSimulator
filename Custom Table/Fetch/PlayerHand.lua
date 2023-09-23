
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