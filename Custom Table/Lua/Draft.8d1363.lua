boosterBox = {}
cubeDeck = {}
packSize = 15
com = {}
unc = {}
rar = {}
myt = {}

function onLoad()
    myPosition = self.getPosition()
    --cubeDeck = getObjectFromGUID("471518")
    self.addContextMenuItem("Make Boosters", makeBoosters)
    self.addContextMenuItem("Make Pack", createPack)
end

function onCollisionEnter(collision_info)
    local obj = collision_info.collision_object
    -- collision_info table:
    --   collision_object    Object
    --   contact_points      Table     {Vector, ...}
    --   relative_velocity   Vector
    if obj.tag == "Deck" then
        if obj.getName() == "Commons" then
            com = obj
        elseif obj.getName() == "Uncommons" then
            unc = obj
        elseif obj.getName() == "Rares" then
            rar = obj
        elseif obj.getName() == "Mythics" then
            myt = obj
        end
    end
end

function createPack()
    local spawnParams = {
        mesh              = "http://pastebin.com/raw/PqfGKtKR",
        diffuse           = "https://i.imgur.com/FpN9IaV.jpg",
        normal            = "https://i.imgur.com/GZwYZnf.png",
        type              = 6,
        material          = 1,
        specular_intensity= 5,
        --specular_color    = {r=255, g=251/255, b=194/255},
        specular_sharpness= 6.70,
        freshnel_strength = 1,
        scale             = {x=1, y=0.5, z=1},
        sound             = false,
        snap_to_grid      = true,
    }
    local thing = spawnObject({type = "Custom_Model"})
    thing.setCustomObject(spawnParams)
    --thing.setColorTint({r=243/255, g=202/255, b=74/255})
    return thing
end

function makeBoosters()
    boosterBox = {}
    myPosition = self.getPosition()
    pos = {x = myPosition.x, y = myPosition.y, z = myPosition.z - 4}
    --cubeDeck.setInvisibleTo(Player.GetColors())
    
    --Getting Object to put cards in
    --TODO: Make pack object here or in a function.
        boosterBag = getObjectFromGUID("987b7c")
        --boosterBag = createPack()
        
        Wait.frames(function()
            --Offsetting position
            basePosition = {x = pos.x, y = pos.y, z = pos.z}
            tempPosition = {x = pos.x, y = pos.y, z = pos.z}
            tempPosition.x = tempPosition.x - 5
            tempPosition.y = tempPosition.y + 0.25
            tempPosition.z = tempPosition.z + 5
            tempPosition = {x = 0, y = 0, z = 0}
            
            --Cloneing deck for packs
            t1 = com.clone()
            t1.setPosition({com.getPosition().x, pos.y, pos.z})
            t2 = unc.clone()
            t2.setPosition({unc.getPosition().x, pos.y, pos.z})
            t3 = rar.clone()
            t3.setPosition({rar.getPosition().x, pos.y, pos.z})
            t4 = myt.clone()
            t3.putObject(t4)
            
            --Locking the object for stability
            t1.setLock(true)
            t2.setLock(true)
            t3.setLock(true)
            --Spicing it up
            t1.randomize()
            t2.randomize()
            t3.randomize()
            
            Wait.frames(function()
                Wait.frames(function()
                    for n = 1, 36 do
                        t1.randomize()
                        t2.randomize()
                        t3.randomize()
                        --Making a booster "bag", and locking it
                        
                        pack = boosterBag.clone()
                        pack.setLock(true)
                        for i = 1, 14 do
                            local card = nil
                            pack.setPosition(tempPosition)
                            if i < 11 then
                                pull = t1.takeObject(tempPosition)
                                pull.setLock(true)
                                card = pull.clone(tempPosition)
                                t1.putObject(pull)
                            else
                                if i < 14 then
                                    pull = t2.takeObject(tempPosition)
                                    pull.setLock(true)
                                    card = pull.clone(tempPosition)
                                    t2.putObject(pull)
                                else 
                                    pull = t3.takeObject(tempPosition)
                                    pull.setLock(true)
                                    card = pull.clone(tempPosition)
                                    t3.putObject(pull)
                                end
                            end
                            card.setLock(true)
                            card.setInvisibleTo(Player.GetColors())
                            card.setRotation(pack.getRotation())
                            card.setLock(false)
                            pack.putObject(card)
                        end
                        tempPosition.y = tempPosition.y + 0.25
                        table.insert(boosterBox, pack)
                    end
                end, 1)
            end, 1)
        end, 1)
        
        Wait.time( function()
            local ps = #boosterBox
            local x, y, r, i = 0, 0, 25, 1
            Wait.time( function()
                local angle = i * math.pi / (ps/2)--26
                local ptx, pty = x + r * math.cos(angle), y + r * math.sin(angle)
                local pos = {x = ptx, y = 3.5, z = pty}
                local rot = {x = 5, y = 90 + (i * -360 / ps), z = 125}
                boosterBox[i].setPosition(pos, false, true)
                boosterBox[i].setRotation(rot, false, true)
                i = i + 1
            end, 0.015, ps)
            Wait.time( function()
                for i = 1, ps do
                    boosterBox[i].unlock()
                    local pos = boosterBox[i].getPosition()
                    boosterBox[i].setPositionSmooth(pos, false, true)
                    pos.y = 1.2
                    Wait.time(function()
                        boosterBox[i].interactable = true
                    end, 1)
                end
            end, 1.35, 1 )
            
        end, 1.25 )
        
    end