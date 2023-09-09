boosterBox = {}
cubeDeck = {}
packSize = 15

function onLoad()
    myPosition = self.getPosition()
    --cubeDeck = getObjectFromGUID("471518")
    self.addContextMenuItem("Make Boosters", makeBoosters)
    self.addContextMenuItem("Make Pack", createPack)
end

function onCollisionEnter(collision_info)
    -- collision_info table:
    --   collision_object    Object
    --   contact_points      Table     {Vector, ...}
    --   relative_velocity   Vector
    if collision_info.collision_object.tag == "Deck" then
        cubeDeck = collision_info.collision_object
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
    thing = spawnObject({type = "Custom_Model"})
    thing.setCustomObject(spawnParams)
    --thing.setColorTint({r=243/255, g=202/255, b=74/255})
    return thing
end

function makeBoosters()
    boosterBox = {}
    myPosition = self.getPosition()
    
    pos = myPosition
    --Cloneing deck for packs
    cubeDeck = cubeDeck.clone()
    cubeDeck.setInvisibleTo(Player.GetColors())
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
        --Locking the object for stability
        cubeDeck.setLock(true)
        --Spicing it up
        cubeDeck.randomize()
        --Calculating the most groups of fifteen out of deck
        s = cubeDeck.getQuantity()
        siz = math.floor((s / packSize))
        Wait.frames(function()
            --cuting off the extra cards
            extra = s-(siz*packSize)
            if extra > 0  then
                cubeDeck = cubeDeck.cut(extra)
                extra = cubeDeck[2]
                cubeDeck = cubeDeck[1]
                extra.setPosition(tempPosition)
                extra.setLock(false)
            end
            --Cutting the deck into boosters
            spl = cubeDeck.split(siz)
            --Waiting a frame for the cut to register
            Wait.frames(function()
                --Looping through each cut
                for i,p in pairs(spl) do
                    --Making a booster "bag", and locking it
                    pack = boosterBag.clone()
                    pack.setLock(true)
                    --Stacking each booster pack in groups of twelve
                    
                    --[[if (i - 1) % 12 == 0 then 
                        tempPosition.y = basePosition.y
                        tempPosition.x =  tempPosition.x + 3
                    end]]--

                    tempPosition.y = tempPosition.y + 0.5

                    --[[
                    if (i - 1) % 6 == 0 then 
                        tempPosition.z = basePosition.z
                        tempPosition.x =  tempPosition.x + 4
                    end
                    tempPosition.z = tempPosition.z + 5
                    ]]--

                    pack.setPosition(tempPosition)
                    p.setInvisibleTo(Player.GetColors())
                    --Setting boosters rotation to the bags for consistancy
                    p.setRotation(pack.getRotation())
                    --pack.setRotation({x=0,y=math.random(0,350),z=0})
                    --Dropping cut so it's unlocked when taken out of bag
                    p.setLock(false)
                    --Putting booster in bag
                    pack.putObject(p)
                    --Dropping booster pack
                    --pack.setLock(false)
                    
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