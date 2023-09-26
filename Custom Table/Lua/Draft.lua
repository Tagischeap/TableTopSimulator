--
    boosterBox = {}
    cubeDeck = {}
    packSize = 15
    com = {}
    w = {}
    u = {}
    b = {}
    r = {}
    g = {}
    c = {}
    unc = {}
    rar = {}
    myt = {}
    zones = {}
    ZONE_WORKPLACE = "1"
    ZONE_WHITE_COMMONS = "2"
    ZONE_BLUE_COMMONS = "3"
    ZONE_BLACK_COMMONS = "4"
    ZONE_RED_COMMONS = "5"
    ZONE_GREEN_COMMONS = "6"
    ZONE_OTHER_COMMONS = "7"
    ZONE_UNCOMMONS = "8"
    ZONE_RARES = "9"
    ZONE_MYTHICS = "10"
    ZONE_SPECIAL = "11"
    ZONE_LANDS = "12"
    ZONE_FOIL_COMMONS = "13"
    ZONE_FOIL_UNCOMMONS = "14"
    ZONE_FOIL_RARES = "15"
    ZONE_FOIL_MYTHICS = "16"
    ZONE_FOIL_SPECIAL = "17"
    ZONE_FOIL_LANDS = "18"
    ZONE_TOKENS = "19"
    ZONE_UI_GENERATE_NORMAL = "20"
    ZONE_UI_GENERATE_FOIL_REPLACES_RARITY = "21"
    ZONE_UI_GENERATE_REPLACE_LAND = "22"
    ZONE_UI_GENERATE_NO_FOILS = "23"
--
boosterBag = getObjectFromGUID("29f784")

function onLoad()
    myPosition = self.getPosition()
    --cubeDeck = getObjectFromGUID("471518")
    --self.addContextMenuItem("Make Boosters", makeBoosters)
    --self.addContextMenuItem("Make Pack", createPack)
    if #self.getSnapPoints() == 0 and false then
        self.setPosition({0,3.49,0})
        self.setSnapPoints({
            {
                position = self.positionToLocal({-11.63, 3.5, 3.1}),
                rotation = {0, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-9.30, 3.5, 3.1}),
                rotation = {-2.33, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-6.98, 3.5, 3.1}),
                rotation = {-4.65, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-4.65, 3.5, 3.1}),
                rotation = {-6.97, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-2.33, 3.5, 3.1}),
                rotation = {-9.30, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({0, 3.5, 3.1}),
                rotation = {-11.63, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({2.33, 3.5, 3.1}),
                rotation = {-9.30, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({4.65, 3.5, 3.1}),
                rotation = {-6.97, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({6.98, 3.5, 3.1}),
                rotation = {-4.65, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({9.30, 3.5, 3.1}),
                rotation = {-2.33, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({11.63, 3.5, 3.1}),
                rotation = {0, 180, 0},
                rotation_snap = true
            },

            -- Row Two

            
            {
                position = self.positionToLocal({-11.63, 3.5, 0}),
                rotation = {0, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-9.30, 3.5, 0}),
                rotation = {-2.33, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-6.98, 3.5, 0}),
                rotation = {-4.65, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-4.65, 3.5, 0}),
                rotation = {-6.97, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-2.33, 3.5, 0}),
                rotation = {-9.30, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({0, 3.5, 0}),
                rotation = {-11.63, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({2.33, 3.5, 0}),
                rotation = {-9.30, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({4.65, 3.5, 0}),
                rotation = {-6.97, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({6.98, 3.5, 0}),
                rotation = {-4.65, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({9.30, 3.5, 0}),
                rotation = {-2.33, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({11.63, 3.5, 0}),
                rotation = {0, 180, 0},
                rotation_snap = true
            },

            -- Row Three

            
            {
                position = self.positionToLocal({-11.63, 3.5, -3.1}),
                rotation = {0, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-9.30, 3.5, -3.1}),
                rotation = {-2.33, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-6.98, 3.5, -3.1}),
                rotation = {-4.65, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-4.65, 3.5, -3.1}),
                rotation = {-6.97, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({-2.33, 3.5, -3.1}),
                rotation = {-9.30, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({0, 3.5, -3.1}),
                rotation = {-11.63, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({2.33, 3.5, -3.1}),
                rotation = {-9.30, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({4.65, 3.5, -3.1}),
                rotation = {-6.97, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({6.98, 3.5, -3.1}),
                rotation = {-4.65, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({9.30, 3.5, -3.1}),
                rotation = {-2.33, 180, 0},
                rotation_snap = true
            },
            {
                position = self.positionToLocal({11.63, 3.5, -3.1}),
                rotation = {0, 180, 0},
                rotation_snap = true
            },
    
        })
        
        for i,k in pairs(self.getSnapPoints()) do
            --print(k.position)
            local pos = self.positionToWorld(k.position)
            pos = {pos[1], pos[2] + 1.1, pos[3]}
            local scl = {2, 2, 2}
            local zone = spawnObject({
            type = "ScriptingTrigger",
            rotation          = {x=0, y=90, z=0},
            scale             = scl,
            position          = pos
            })
            zone.setName("DRAFTER ZONE")
            table.insert(zones, zone.getGUID())
        end
    end
   --
    ZONE_WORKPLACE = zones[33]
    ZONE_WHITE_COMMONS = zones[1]
    ZONE_BLUE_COMMONS = zones[2]
    ZONE_BLACK_COMMONS = zones[3]
    ZONE_RED_COMMONS = zones[4]
    ZONE_GREEN_COMMONS = zones[5]
    ZONE_OTHER_COMMONS = zones[6]
    ZONE_UNCOMMONS = zones[7]
    ZONE_RARES = zones[8]
    ZONE_MYTHICS = zones[9]
    ZONE_SPECIAL = zones[10]
    ZONE_LANDS = zones[11]
    ZONE_FOIL_COMMONS = zones[12]
    ZONE_FOIL_UNCOMMONS = zones[13]
    ZONE_FOIL_RARES = zones[14]
    ZONE_FOIL_MYTHICS = zones[15]
    ZONE_FOIL_SPECIAL = zones[16]
    ZONE_FOIL_LANDS = zones[17]
    ZONE_TOKENS = zones[18]
   --
    self.addContextMenuItem("Spawn Booster", makeBooster)
end

function checkPoints()
    
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

function spawnPack()
    --[[
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
    ]]
    
    pack = boosterBag.clone()
    --createBooser()
    return pack
end

function makeBooster()
    createStandard()
    local pos = getObjectFromGUID(zones[30]).getPosition()
    local pack = spawnPack()
    pack.setPosition(pos)
    Wait.condition(function()
        local pile = findCardStack(ZONE_WORKPLACE)
        pack.putObject(pile)
        pack.setName("Kamigawa: Neon Dynasty Draft Booster")
    end, function()
        return findCardStack(ZONE_WORKPLACE) != -1 and findCardStack(ZONE_WORKPLACE).getQuantity() == 15
    end)

    Wait.frames(function()
        
    end, 1)
end

function makeBoosters()
    boosterBox = {}
    myPosition = self.getPosition()
    pos = {x = myPosition.x, y = myPosition.y + 1, z = myPosition.z - 4}
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
        --Spicing it up
        t1.randomize()
        t2.randomize()
        t3.randomize()

        local off = pos.y
        local i1 = 1
        local i2 = 1
        local i3 = 1

        local s1 = #t1.getObjects()
        local s2 = #t2.getObjects()
        local s3 = #t3.getObjects()
        local c1 = {}
        local c2 = {}
        local c3 = {}
        Wait.time(function()
            local c
            if i1 ~= s1-1 then
                c = t1.takeObject({index = 1})
                c.setLock(true)
            else
                c = t1
            end
            c.setPosition({com.getPosition().x, pos.y + off, pos.z})
            off = off + 0.01
            i1 = i1 + 1
            table.insert(c1, c)
        end,0.015, s1)
        Wait.time(function()
            local off = pos.y
            Wait.time(function()
                local c
                if i2 ~= s2-1 then
                    c = t2.takeObject({index = 1})
                    c.setLock(true)
                else
                    c = t2
                end
                c.setPosition({unc.getPosition().x, pos.y + off, pos.z})
                off = off + 0.01
                i2 = i2 + 1
                table.insert(c2, c)
            end,0.015, s2)
            
            Wait.time(function()
                local off = pos.y
                Wait.time(function()
                    local c
                    if i3 ~= s3-1 then
                        c = t3.takeObject({index = 1})
                        c.setLock(true)
                    else
                        c = t3
                    end
                    c.setPosition({rar.getPosition().x, pos.y + off, pos.z})
                    off = off + 0.01
                    i3 = i3 + 1
                    table.insert(c3, c)
                end,0.015, s3)
            end, 0.015 * s2, 1)
        end, 0.015 * s1, 1)
        Wait.condition(function() 
            for a = 1, 32 do
            end


        end, function() return #c1 + #c2 + #c3 == s1 + s2 + s3 end, 30, function() print("Timed out.") end)

    end, 1.25 )

end

function createBooser(posit, rotat)
    pack = createPack()
    --pack.setLock(true)

    local p = {}
    for i = 1, packSize do
        local c
        if i <= 10 then
            c = c1[ math.random( #c1 ) ].clone()
        elseif i <= 13 then
            c = c2[ math.random( #c2 ) ].clone()
        elseif i <= 14 then
            c = c3[ math.random( #c3 ) ].clone()
        end
        if c ~= nil then
            c.setLock(false)
            c.setPosition({0.75 * i, 0.1 * i, 0})
        end
        table.insert(p, c)
    end
    local pa = group(p)
    Wait.condition(function()
            pack.putObject(pa)
            pack.setPosition(posit)
            table.insert(boosterBox, pack)
    end, function() 
        if pa ~= nil then
            return (table.getn(pa) >= 14)
        else
            return false 
        end 
    end, 30, function() print("Time Out") end)
    
    Wait.time( function()
        local ps = #boosterBox
        local x, y, r, i = 0, 0, 25, 1

        Wait.time( function()
            local angle = i * math.pi / (ps/2)--26
            local ptx, pty = x + r * math.cos(angle), y + r * math.sin(angle)
            local pos = {x = ptx, y = 3.5, z = pty}
            local rot = {x = 5, y = 90 + (i * -360 / ps), z = 125}
            -boosterBox[i].setPosition(pos, false, true)
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

-- Pasta
    function devReturnZoneName(zone_id)
        if zone_id == ZONE_WORKPLACE then return "workplace"
        elseif zone_id == ZONE_WHITE_COMMONS then return "white commons"
        elseif zone_id == ZONE_BLUE_COMMONS then return "blue commons"
        elseif zone_id == ZONE_BLACK_COMMONS then return "black commons"
        elseif zone_id == ZONE_RED_COMMONS then return "red commons"
        elseif zone_id == ZONE_GREEN_COMMONS then return "green commons"
        elseif zone_id == ZONE_OTHER_COMMONS then return "\"other\" commons"
        elseif zone_id == ZONE_UNCOMMONS then return "uncommons"
        elseif zone_id == ZONE_RARES then return "rares"
        elseif zone_id == ZONE_MYTHICS then return "mythic rares"
        elseif zone_id == ZONE_LANDS then return "basic lands"
        elseif zone_id == ZONE_SPECIAL then return "special"
        elseif zone_id == ZONE_FOIL_COMMONS then return "foil commons"
        elseif zone_id == ZONE_FOIL_UNCOMMONS then return "foil uncommons"
        elseif zone_id == ZONE_FOIL_RARES then return "foil rares"
        elseif zone_id == ZONE_FOIL_MYTHICS then return "foil mythics"
        elseif zone_id == ZONE_FOIL_LANDS then return "foil basic lands"
        elseif zone_id == ZONE_FOIL_SPECIAL then return "foil specials"
        elseif zone_id == ZONE_TOKENS then return "tokens"
        else return "unnamed"
        end
    end

    function findCardStack(zone_id)
        is_error = 0
        target = getObjectFromGUID(zone_id)
        if target != nil then
            objects = target.getObjects()
        else
            is_error = -1
        end

        if is_error == 0 then
            if #objects < 1 then
                is_error = -1
            elseif #objects > 1 then
                is_error = -1
            else
                is_error = objects[1]
            end
        end

        return is_error
    end

    function takeCard(card_pile,to_here,height)
        target = getObjectFromGUID(to_here)
        params = {}
        params.position = { target.getPosition().x, height, target.getPosition().z }
        card_pile.takeObject(params)
    end

    function shuffleTable(table_to_shuffle)
        iterations = #table_to_shuffle
    
        for i = iterations, 2, -1 do
            j = math.random(1,i)
            table_to_shuffle[i], table_to_shuffle[j] = table_to_shuffle[j], table_to_shuffle[i]
        end
        return table_to_shuffle
    end

    function mythicCheck()
        return math.random(1, 8) == 8
    end

    function foilCheck()
        return math.random(1, 7) == 7
    end

    function drawFoil(maxrandom,blockHasMythics,height)
        if math.random(1,21) == 21 and findCardStack(ZONE_SPECIAL) == -1 and findCardStack(ZONE_FOIL_SPECIAL) != -1 then
            drawSingles(ZONE_FOIL_SPECIAL,1,height)
            foil_type = 9
        else
            foil_type = math.random(1,maxrandom)
            if foil_type < 4 then
                if findCardStack(ZONE_FOIL_COMMONS) != -1 then
                    drawSingles(ZONE_FOIL_COMMONS,1,height)
                else
                    drawCommons(1,false,height)
                end
            elseif foil_type < 6 then
                if findCardStack(ZONE_FOIL_UNCOMMONS) != -1 then
                    drawSingles(ZONE_FOIL_UNCOMMONS,1,height)
                else
                    drawSingles(ZONE_UNCOMMONS,1,height)
                end
            elseif foil_type < 7 then
                if mythicCheck() == true and blockHasMythics == true then
                    if findCardStack(ZONE_FOIL_MYTHICS) != -1 then
                        drawSingles(ZONE_FOIL_MYTHICS,1,height)
                    else
                        drawSingles(ZONE_MYTHICS,1,height)
                    end
                else
                    if findCardStack(ZONE_FOIL_RARES) != -1 then
                        drawSingles(ZONE_FOIL_RARES,1,height)
                    else
                        drawSingles(ZONE_RARES,1,height)
                    end
                end
            elseif foil_type < 8 then
                if findCardStack(ZONE_FOIL_LANDS) != -1 then
                    drawSingles(ZONE_FOIL_LANDS,1,height)
                elseif findCardStack(ZONE_LANDS) != -1 then
                    drawSingles(ZONE_LANDS,1,height)
                end
            else
                if findCardStack(ZONE_FOIL_SPECIAL) != -1 then
                    drawSingles(ZONE_FOIL_SPECIAL,1,height)
                elseif findCardStack(ZONE_SPECIAL) != -1 then
                    drawSingles(ZONE_SPECIAL,1,height)
                end
            end
        end
        return foil_type
    end

    function drawCommons(number_of_commons,take_five,height)
        white_commons_pile = findCardStack(ZONE_WHITE_COMMONS)
        blue_commons_pile = findCardStack(ZONE_BLUE_COMMONS)
        black_commons_pile = findCardStack(ZONE_BLACK_COMMONS)
        red_commons_pile = findCardStack(ZONE_RED_COMMONS)
        green_commons_pile = findCardStack(ZONE_GREEN_COMMONS)
        white_commons = white_commons_pile.clone({})
        blue_commons = blue_commons_pile.clone({})
        black_commons = black_commons_pile.clone({})
        red_commons = red_commons_pile.clone({})
        green_commons = green_commons_pile.clone({})

        white_commons.shuffle()
        blue_commons.shuffle()
        black_commons.shuffle()
        red_commons.shuffle()
        green_commons.shuffle()

        if take_five == true then
            number_of_commons = number_of_commons - 5
            takeCard(white_commons,ZONE_WORKPLACE,height)
            height = height - 0.2
            takeCard(blue_commons,ZONE_WORKPLACE,height)
            height = height - 0.2
            takeCard(black_commons,ZONE_WORKPLACE,height)
            height = height - 0.2
            takeCard(red_commons,ZONE_WORKPLACE,height)
            height = height - 0.2
            takeCard(green_commons,ZONE_WORKPLACE,height)
            height = height - 0.2
        end

        if findCardStack(ZONE_OTHER_COMMONS) != -1 then
            other_commons_pile = findCardStack(ZONE_OTHER_COMMONS)
            other_commons = other_commons_pile.clone({})
            other_commons.shuffle()

            coloured_commons_weight = math.ceil( ( white_commons.getQuantity() + blue_commons.getQuantity() + black_commons.getQuantity() + red_commons.getQuantity() + green_commons.getQuantity() ) / 5 )
            other_commons_weight = other_commons.getQuantity()

            if other_commons_weight < (coloured_commons_weight - 8) then
                generated_commons = {"W", "W", "U", "U", "B", "B", "R", "R", "G", "G", "O" }
            elseif other_commons_weight < (coloured_commons_weight - 4) then
                generated_commons = {"W", "U", "B", "R", "G", "O" }
            elseif other_commons_weight < (coloured_commons_weight + 5) then
                takeCard(other_commons,ZONE_WORKPLACE,height)
                height = height - 0.2
                generated_commons = {"W", "U", "B", "R", "G", "O"}
                number_of_commons = number_of_commons - 1
            else
                        takeCard(other_commons,ZONE_WORKPLACE,height)
                height = height - 0.2
                generated_commons = {"W", "U", "B", "R", "G", "O", "O", "O", "O", "O"}
                number_of_commons = number_of_commons - 1
            end
        else
            generated_commons = {"W", "U", "B", "R", "G", "W", "U", "B", "R", "G"}
        end

        generated_commons = shuffleTable(generated_commons)

        for i=1, number_of_commons, 1 do
            if generated_commons[i] == "W" then takeCard(white_commons,ZONE_WORKPLACE,height + (i * 0.2))
            elseif generated_commons[i] == "U" then takeCard(blue_commons,ZONE_WORKPLACE,height + (i * 0.2))
            elseif generated_commons[i] == "B" then takeCard(black_commons,ZONE_WORKPLACE,height + (i * 0.2))
            elseif generated_commons[i] == "R" then takeCard(red_commons,ZONE_WORKPLACE,height + (i * 0.2))
            elseif generated_commons[i] == "G" then takeCard(green_commons,ZONE_WORKPLACE,height + (i * 0.2))
            else takeCard(other_commons,ZONE_WORKPLACE,height + (i * 0.2))
            height = height - 0.2
            end
        end

        white_commons.destruct()
        blue_commons.destruct()
        black_commons.destruct()
        red_commons.destruct()
        green_commons.destruct()

        if findCardStack(ZONE_OTHER_COMMONS) != -1 then
            other_commons.destruct()
        end
    end

    function drawSingles(zone,number,height)
        card_pile = findCardStack(zone)
        if card_pile != -1 then
            card = card_pile.clone({})
            card.shuffle()
            for i=1, number, 1 do
                takeCard(card,ZONE_WORKPLACE,height+((i-1)*0.2))
                height = height - 0.2
            end
            card.destruct()
        else
            print("Error: Nothing was found when trying to get an object from the " .. devReturnZoneName(zone) .. " zone.")
        end
    end

    function createStandard()
        foil_type = 0

        commons_counter = getObjectFromGUID("939890")
        uncommons_counter = getObjectFromGUID("f1c45b")
        rares_counter = getObjectFromGUID("b7ed3b")

        --number_of_commons = commons_counter.getValue()
        --number_of_uncommons = uncommons_counter.getValue()
        --number_of_rares = rares_counter.getValue()

        number_of_commons = 10
        number_of_uncommons = 3
        number_of_rares = 1

        if foilCheck() == true and number_of_commons > 0 then
            if findCardStack(ZONE_SPECIAL) == true then
                foil_type = drawFoil(8,findCardStack(ZONE_MYTHICS) != -1,6)
            else
                foil_type = drawFoil(7,findCardStack(ZONE_MYTHICS) != -1,6)
            end
            number_of_commons = number_of_commons - 1
        end

        if findCardStack(ZONE_SPECIAL) != -1 and number_of_commons > 1 then
            drawSingles(ZONE_SPECIAL,1,5.8)
            number_of_commons = number_of_commons - 1
        end

        if number_of_rares > 0 then
            for i=1, number_of_rares, 1 do
                if mythicCheck() == true and findCardStack(ZONE_MYTHICS) != -1 then
                    drawSingles(ZONE_MYTHICS,1,5.6)
                else
                    drawSingles(ZONE_RARES,1,5.6)
                end
            end
        end

        if number_of_uncommons > 0 then
            drawSingles(ZONE_UNCOMMONS,number_of_uncommons,5.4)
        end

        if number_of_commons > 0 then
            drawCommons(number_of_commons,number_of_commons > 7,4.8)
        end
        
        if findCardStack(ZONE_LANDS) != -1 then
            drawSingles(ZONE_LANDS,1,6.2)
        end
        
        if findCardStack(ZONE_TOKENS) != -1 then
            drawSingles(ZONE_TOKENS,1,6.4)
        end
    end
--