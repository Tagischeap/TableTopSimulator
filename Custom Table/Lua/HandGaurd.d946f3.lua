playerHands = {}

--Checks if the object is in specific hand
function checkHand(objGuid, player_color)
  local handObjects = Player[player_color].getHandObjects()
  for i,j, obj in pairs(handObjects) do
    if j.getGUID() == objGuid then
      return true
    end
  end
  return false
end

--Check is object is in a players hand
function inHand(objGuid)
  for i, p in pairs(Player.getColors()) do
    if p ~= "Grey" then
      for j = 1, Player[p].getHandCount() do
        for k, o in pairs(Player[p].getHandObjects(j)) do
          if o.getGUID() == objGuid then
            return true;
          end
        end
      end
    end
  end
  return false;
end

function onObjectPickUp(player_color, picked_up_object)
  gid = picked_up_object.getGUID()
  if (inHand(gid) and not checkHand(gid, player_color)) and player_color ~= "Black" then
    picked_up_object.reload()
  end
end