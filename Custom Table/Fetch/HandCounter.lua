
      
      --- Hand counter by Schokolabbi
      --- Click delay time in seconds
      options = {["clickDelay"] = 0.3}

      clickCounter = 0

      doubleClickParameters = {
          ["identifier"] = "ClickTimer" .. self.guid,
          ["function_name"] = "resetClickCounter",
          ["delay"] = options.clickDelay,
      }

      function onSave()
          if not owner then return nil end
          return JSON.encode({
              ["ownerColor"] = owner.color,
          })
      end

      function onLoad(jsonData)
          if jsonData == "" then
              setOwner(nill)
              findOwner(playercolor)
              setOwner(playercolor)
          else
              local data = JSON.decode(jsonData)
              setOwner(data.ownerColor)
          end
      end

      function update()
          if not owner then return end
          if owner.getHandTransform() == nill then return end
          self.editButton({index=0, label=#owner.getHandObjects()})
          self.setName(#owner.getHandObjects())
      end

      function findOwner(color)
          if not isPlayerAuthorized(color) then return end
          if clickCounter == 0 then
              Timer.create(doubleClickParameters)
          end
          if isDoubleClick() then
              setOwner(nil)
          elseif not owner then
              setOwner(color)
          end
      end

      function onPickedUp(color)
          findOwner(color)
      end

      function onClick(object, color)
          findOwner(color)
      end

      function resetClickCounter()
          clickCounter = 0
      end

      function isDoubleClick()
          clickCounter = clickCounter + 1
          return clickCounter > 1
      end

      function setOwner(color)
          local objectCount = 0
          if color then
              owner = Player[color]
              objectCount = #owner.getHandObjects()
              self.setName(objectCount)
          else
              owner = nil
              color = "Grey"
              objectCount = 0
              self.setName("Card Counter - Click to claim!")
          end
          local rgbColorTable = stringColorToRGB(color)
          self.setColorTint(rgbColorTable)
          self.clearButtons()
          self.createButton({
              label=tostring(objectCount), click_function="onClick", function_owner=self,
              position={0.4,0.15,-1.0}, height=0, width=0; font_size=650
          })
      end

      function isPlayerAuthorized(color)
          player = Player[color]
          return player == owner or player.admin
      end