
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

function createReplaceLandWithFoil()
    commons_counter = getObjectFromGUID("939890")
    uncommons_counter = getObjectFromGUID("f1c45b")
    rares_counter = getObjectFromGUID("b7ed3b")

    number_of_commons = commons_counter.getValue()
    number_of_uncommons = uncommons_counter.getValue()
    number_of_rares = rares_counter.getValue()

    if findCardStack(ZONE_SPECIAL) == true then
        foil_type = drawFoil(8,findCardStack(ZONE_MYTHICS) != -1,6)
    else
        foil_type = drawFoil(7,findCardStack(ZONE_MYTHICS) != -1,6)
    end

    if findCardStack(ZONE_SPECIAL) != -1 and number_of_commons > 0 then
        drawSingles(ZONE_SPECIAL,1,5.8)
        number_of_commons = number_of_commons - 1
    end

    if mythicCheck() == true and findCardStack(ZONE_MYTHICS) != -1 then
        drawSingles(ZONE_MYTHICS,1,5.6)
    else
        drawSingles(ZONE_RARES,1,5.6)
    end

    if number_of_uncommons > 0 then
        drawSingles(ZONE_UNCOMMONS,number_of_uncommons,5.4)
    end

    if number_of_commons > 0 then
        drawCommons(number_of_commons,number_of_commons > 7,4.8)
    end
    
    if findCardStack(ZONE_TOKENS) != -1 then
        drawSingles(ZONE_TOKENS,1,6.4)
    end
end

function createNoFoils()

    commons_counter = getObjectFromGUID("939890")
    uncommons_counter = getObjectFromGUID("f1c45b")
    rares_counter = getObjectFromGUID("b7ed3b")

    number_of_commons = commons_counter.getValue()
    number_of_uncommons = uncommons_counter.getValue()
    number_of_rares = rares_counter.getValue()

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
        drawCommons(number_of_commons,number_of_commons > 6,4.8)
    end
    
    if findCardStack(ZONE_LANDS) != -1 then
        drawSingles(ZONE_LANDS,1,6.2)
    end
    
    if findCardStack(ZONE_TOKENS) != -1 then
        drawSingles(ZONE_TOKENS,1,6.4)
    end
end

function createOldFoil()
    foil_type = 0

    commons_counter = getObjectFromGUID("939890")
    uncommons_counter = getObjectFromGUID("f1c45b")
    rares_counter = getObjectFromGUID("b7ed3b")

    number_of_commons = commons_counter.getValue()
    number_of_uncommons = uncommons_counter.getValue()
    number_of_rares = rares_counter.getValue()

    if foilCheck() == true then
        if findCardStack(ZONE_SPECIAL) == true then
            foil_type = drawFoil(8,findCardStack(ZONE_MYTHICS) != -1,6)
        else
            foil_type = drawFoil(7,findCardStack(ZONE_MYTHICS) != -1,6)
        end
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
            number_of_rares = number_of_rares - 1
        end
    end
    
    if foil_type > 0 and foil_type < 4 and number_of_commons > 0 then
        number_of_commons = number_of_commons - 1
    end

    if foil_type > 3 and foil_type < 6 and number_of_uncommons > 0 then
        number_of_uncommons = number_of_uncommons - 1
    end

    if number_of_uncommons > 0 then
        drawSingles(ZONE_UNCOMMONS,number_of_uncommons,5.4)
    end

    if number_of_commons > 0 then
        drawCommons(number_of_commons,number_of_commons > 7,4.8)
    end

    if findCardStack(ZONE_LANDS) != -1 and foil_type != 7 then
        drawSingles(ZONE_LANDS,1,6.2)
    end

    if findCardStack(ZONE_TOKENS) != -1 then
        drawSingles(ZONE_TOKENS,1,6.4)
    end

end

function generateInterface()
    basic_zone = getObjectFromGUID(ZONE_UI_GENERATE_NORMAL)
    basic_button = {}
    basic_button.click_function = "createStandard"
    basic_button.label = "Generate A Basic Pack"
    basic_button.width = 1300
    basic_button.height = 400
    basic_button.font_size = 120
    basic_button.rotation = {180, 0, 180}
    basic_zone.createButton(basic_button)

    oldfoil_zone = getObjectFromGUID(ZONE_UI_GENERATE_FOIL_REPLACES_RARITY)
    oldfoil_button = {}
    oldfoil_button.click_function = "createOldFoil"
    oldfoil_button.label = "Generate With Foils\nReplacing Their Rarity"
    oldfoil_button.width = 1300
    oldfoil_button.height = 400
    oldfoil_button.font_size = 120
    oldfoil_button.rotation = {180, 0, 180}
    oldfoil_zone.createButton(oldfoil_button)

    replaceland_zone = getObjectFromGUID(ZONE_UI_GENERATE_REPLACE_LAND)
    replaceland_button = {}
    replaceland_button.click_function = "createReplaceLandWithFoil"
    replaceland_button.label = "Generate With Land\nReplaced By Foil"
    replaceland_button.width = 1300
    replaceland_button.height = 400
    replaceland_button.font_size = 120
    replaceland_button.rotation = {180, 0, 180}
    replaceland_zone.createButton(replaceland_button)

    nofoils_zone = getObjectFromGUID(ZONE_UI_GENERATE_NO_FOILS)
    nofoils_button = {}
    nofoils_button.click_function = "createNoFoils"
    nofoils_button.label = "Generate With\nNo Random Foils"
    nofoils_button.width = 1300
    nofoils_button.height = 400
    nofoils_button.font_size = 120
    nofoils_button.rotation = {180, 0, 180}
    nofoils_zone.createButton(nofoils_button)
end

zones = {}

function generateZones()
    print("Boop")
    local scl = {2.75, 5, 2.75}
    for i=1, 19 do
        if #zones == 19 then return end
        local zone = spawnObject({
          type = "ScriptingTrigger",
          rotation          = {x=0, y=90, z=0},
          scale             = scl,
          position          = {x=3 * i, y=3, z=0}
        })
        table.insert(zones, zone.getGUID())
    end
    
    ZONE_WORKPLACE = zones[1]
    ZONE_WHITE_COMMONS = zones[2]
    ZONE_BLUE_COMMONS = zones[3]
    ZONE_BLACK_COMMONS = zones[4]
    ZONE_RED_COMMONS = zones[5]
    ZONE_GREEN_COMMONS = zones[6]
    ZONE_OTHER_COMMONS = zones[7]
    ZONE_UNCOMMONS = zones[8]
    ZONE_RARES = zones[9]
    ZONE_MYTHICS = zones[10]
    ZONE_SPECIAL = zones[11]
    ZONE_LANDS = zones[12]
    ZONE_FOIL_COMMONS = zones[13]
    ZONE_FOIL_UNCOMMONS = zones[14]
    ZONE_FOIL_RARES = zones[15]
    ZONE_FOIL_MYTHICS = zones[16]
    ZONE_FOIL_SPECIAL = zones[17]
    ZONE_FOIL_LANDS = zones[18]
    ZONE_TOKENS = zones[19]
    ZONE_UI_GENERATE_NORMAL = "ace50f"
    ZONE_UI_GENERATE_FOIL_REPLACES_RARITY = "d60513"
    ZONE_UI_GENERATE_REPLACE_LAND = "18b128"
    ZONE_UI_GENERATE_NO_FOILS = "4d4d9f"

end

function onload()
    math.randomseed(os.time())
    self.addContextMenuItem("Zones", generateZones)
    --generateInterface()
    self.addContextMenuItem("Standard Pack", createStandard)
end

function getZones() return zones end
function __call() end