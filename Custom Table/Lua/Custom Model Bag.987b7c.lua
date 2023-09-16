cube = ""
function filterObjectEnter(obj)
    if self.getQuantity() < 1 then
        return true
    end
    return false
end

function onObjectLeaveContainer(bag, obj)
    --Deletes self when emptied
    if self == bag and self.getQuantity() < 1 then
        pos = bag.getPosition()
        rot = bag.getRotation()
        rot.z = 180
        Wait.frames(function() 
            col = obj.held_by_color
            tr = Player[col].getHandTransform()
            obj.setName("Booster Pack: " .. col)
            if obj.held_by_color != "Black" and #Player[col].getHandObjects() == 0 then
                --obj.deal(obj.getQuantity(),obj.held_by_color,1)
                siz = obj.getQuantity()
                obj.setLock(true)
                obj.setPosition(pos)
                obj.setRotation(rot)
                c = {}
                for i = 1, siz do 
                    c[i] = obj.takeObject({
                        flip     = true,
                        smooth   = false, 
                        callback_function = function(obj)
                            obj.setLock(true)
                            obj.setPosition(pos + {x=0,y=(0.025 * i),z=0})
                            obj.setRotation(rot)
                        end
                    })
                end
                Wait.frames(function()
                    for i = 1, #c do
                        c[i].setPositionSmooth(tr.position + (tr.forward * 6) + {x=10,y=0,z=0}, false, false)
                        c[i].setRotation({x = 180, y = tr.rotation.y, z = 0})
                        c[i].setLock(true)
                    end
                    Wait.time(function()
                        Wait.time(function()
                            i = i + 1
                            pop = (tr.forward * (tr.scale.z - 1)) + (tr.right * -(tr.scale.x - 1))
                            c[i].setPositionSmooth(tr.position + {x=8,y=0,z=0}, false, false)
                            c[i].setRotationSmooth({x = 0, y = tr.rotation.y - 180, z = 0}, false, false)
                            c[i].setLock(false)
                        end, 0.075, #c)
                    end, 0.5)
                    i = 0
                end, 1)
            end
        end, 1)
        --Deletes cube if it exist
        if cube ~= "" then
            cube.destruct()
        end
        self.destruct()
    end
end

function onLoad(obj)
    self.addDecal(
        {
            name = "WOE",
            url = "https://gatherer.wizards.com/Handlers/Image.ashx?type=symbol&set=WOE&size=large&rarity=M",
            position = {0, 0.21, 1},
            rotation = {90, 180, 0},
            scale = {1.5,1.5,1}
        })
    --[[
    if obj == self and cube == "" then
        --Makes a cube on spawn
        cube = spawnObject({
            type = "BlockSquare",
            position = self.getPosition(),
            rotation = self.getRotation(),
            scale = {x=2.75,y=0.25,z=3.75},
            sound = false
        })
        cube.setLock(true)
        Wait.frames(function()
            --Attaches cube to object
            cube.setName("Booster Pack")
            self.setName("")
            cube.setColorTint(Color(0,0,0,0))
            cube.setPosition(self.getPosition())
            cube.setRotation(self.getRotation())
            self.jointTo(cube,{
                ["type"]        = "Fixed",
                ["collision"]   = false,
                ["break_force"]  = 0,
                ["break_torgue"] = 0,
            })
            
            cube.setLock(false)
        end, 1)
    end 
    ]]
end