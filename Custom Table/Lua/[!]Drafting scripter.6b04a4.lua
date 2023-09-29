
function onLoad(save_state)
    self.addContextMenuItem("Start Draft", startDraft)
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
function pileHand(clicked_object, player)
    local hand = Player[player].getHandObjects()
    local pos = Player[player].getHandTransform().position
    local rot = Player[player].getHandTransform().rotation
    local pile = group(hand)
    pile[1].setLock(true)
    if math.floor(rot.y) == 0 then
        pos = pos + vector(-13.5, 1, 3.5)
    elseif math.floor(rot.y) == 90 then
        pos = pos + vector(3.5, 1, 13.5)
    elseif math.floor(rot.y) == 180 then
        pos = pos + vector(13.5, 1, -3.5)
    elseif math.floor(rot.y) == 270 then
        pos = pos + vector(-3.5, 1, -13.5)
    end
    pile[1].setPositionSmooth(pos, false, true)
    pile[1].setRotationSmooth(vector(180,rot.y,rot.z), false, true)
end