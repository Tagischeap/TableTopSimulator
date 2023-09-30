
function onLoad(save_state)
    self.addContextMenuItem("Start Draft", startDraft)
    self.addContextMenuItem("Next Pile", passPile)
end
function startDraft()
    Player["White"].lookAt({
        position = {x=14,y=-5,z=-14},
        pitch    = 90,
        yaw      = 0,
        distance = 30,
    })
    --Player["White"].setCameraMode("TopDown")
      
  self.createButton({ 
        click_function = 'pileHand',
        label = 'Pile Hand',
        function_owner = self,
        position = {0, 0.55, 0},rotation = {0, 0, 0},
        width = 500,
        height = 500,
        font_size = 150
    })
end

piles = {}

function pileHand(clicked_object, player)
    local hand = Player[player].getHandObjects() --Getting Objects in Players hand
    local pos = Player[player].getHandTransform().position -- Getting Position of players hand
    local rot = Player[player].getHandTransform().rotation -- Getting Rotation of players hand
    if math.floor(rot.y) == 0 then --Position is based on rotation TODO: Use an algorithm instead
        pos = pos + vector(-13.5, -2.5, 3.5) 
    elseif math.floor(rot.y) == 90 then
        pos = pos + vector(3.5, -2.5, 13.5)
    elseif math.floor(rot.y) == 180 then
        pos = pos + vector(13.5, -2.5, -3.5)
    elseif math.floor(rot.y) == 270 then
        pos = pos + vector(-3.5, -2.5, -13.5)
    end
    local pile = nil

    if #hand > 1 then --Is it more than one card?
        pile = group(hand) --Turns hand into a deck
    else
        pile = hand --Is single card
    end

    if #pile ~= 0 then --If hand isn't empty
        pile[1].setLock(true)
        pile[1].interactable = false
        Wait.time(function() --Make it look nicer
            pile[1].setPositionSmooth(pos, false, true)
            pile[1].setRotationSmooth(vector(180,rot.y,rot.z), false, true)
        end, 1)
    else
        --Hand is empty
    end
    
    piles[player] = pile[1]
    --table.insert(piles, pile[1])
    Wait.time(function()
        if allPicked() then
            passPile()
        end
    end, 2)

    return pile[1] --Return the created pile
end

function allPicked()
    for i,k in pairs(getSeatedPlayers()) do
        if piles[k] == nil then
            print(k, " hasn't picked.")
            return false
        end
        print(k, " has passed a ", piles[k].type)
    end
    return true
end

function passPile()
    local seats = getSeatedPlayers()
    for n,p in pairs(seats) do
        seat = n + 1
        if n == 0 then
        elseif n == #seats then
            seat = 1
        end
        
        print("--Passing--> " .. piles[p].type .. p .. " to " .. seats[seat])
        if piles[p].type == 'Deck' then
            for i = 0, piles[p].getQuantity() do
                piles[p].dealToColorWithOffset({0,0,0}, true, seats[seat])
            end
        else
            piles[p].setPositionSmooth(Player[seats[seat]].getHandTransform().position, false, true)
            piles[p].setRotationSmooth(Player[seats[seat]].getHandTransform().rotation, false, true)
        end
    end
    for n,p in pairs(seats) do
        print(p," pile is nilled.")
        table.remove(piles)
    end
end

--Bellow doesn't do much now
--Intended to find the card a player takes out of their hand
cardPick = nil
leftZone = false
--Checks if the object is in specific hand
function checkHand(objGuid, player_color)
    local handObjects = Player[player_color].getHandObjects() --Getting all objects in Players hand
    for i,j, obj in pairs(handObjects) do
        if j.getGUID() == objGuid then --If object matches returns true
            return true
        end
    end
    return false
end
--Check is object is in a players hand
function inHand(objGuid)
    for i, p in pairs(Player.getColors()) do --Loops through all players
        if p ~= "Grey" then --Skips Grey, because they don't have a hand
            for j = 1, Player[p].getHandCount() do --Loops the amount of hands
                for k, o in pairs(Player[p].getHandObjects(j)) do --Loops through every object in hand
                    if o.getGUID() == objGuid then --If the object is found return true
                        return true;
                    end
                end
            end
        end
    end
    return false;
end
function onObjectPickUp(player_color, picked_up_object) --Checking when object is picked up.
    local gid = picked_up_object.getGUID()
    if (inHand(gid) and checkHand(gid, player_color)) and player_color ~= "Black" then --If the picked up object is in a hand and the person holding it's their hand.
        --picked_up_object.reload() --Forces the player to drop the object
        cardPick = picked_up_object --Set cardPick to object
    else
        cardPick = nil
    end
end
function onObjectLeaveZone(zone, object)
    if object == cardPick then
        leftZone = true
    end
end
function onObjectEnterZone(zone, object)
    if object == cardPick then
        leftZone = false
    end
end
function onObjectDrop(colorName, object)
    if object == cardPick and leftZone then
        
    end
end