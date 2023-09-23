

      --By Amuzet
      mod_name,version='LifeTracker',1
      author='76561198045776458'

      function updateSave()
        self.script_state=JSON.encode({['c']=count})
      end

      function wait(t)
        local s=os.time()
        repeat coroutine.yield(0) until os.time()>s+t
      end

      function sL(l,n)
        plus=''
        if n~=nil then
          if n>0 then plus='+' end
          if n==0 then
            n=nil
          end
        end
        self.editButton({index=0,label=l})
        self.editButton({index=1,label=plus..(n or'')})

      end

      function option(o,c,a)
        local n=1
        if a then
          n=-n
        end
        click_changeValue(o,c,n)
      end

      function click_changeValue(obj, color, val)
        if color==owner or Player[color].admin then
          local C3=count
          count=count+val
          local C1=count
          function clickCoroutine()
            if not C2 then
              C2=C3
            end
            sL(count,(count-C2))
            wait(3)
            if C2 and C1==count then
              local gl='lost'
              if C1>C2 then
                gl='gained'
              end
              if C1~=C2 then
                sL(count)
                local t=txt:format(gl,math.abs(count-C2),count)
                printToAll(t,ownerRGB)
                log(t)
              end
              C2=nil
            end
          return 1
          end
          startLuaCoroutine(self,'clickCoroutine')
          updateSave()
        end
      end

      local lCheck={
        ['extort_']=function(n,c)if c==owner then for _,p in pairs(Player.getPlayers())do if p.seated and p.color~=owner then count=count+n end end return count,'extorted everyone for'else return count-n,false,true end end,
        ['drain_']=function(n,c)if c==owner then return count+n,'drained everyone for'else return count-n,false,true end end,
        ['opponents_lose_']=function(n,c)if c~=owner then return count-n else return count,'opponents lost'end end,
        ['everyone_loses_']=function(n,c)return count-n,'made everyone lose'end,
        ['double_my_life_']=function(n,c)if c==owner then return count*2^n,'doubled their life this many times'end end,
        ['set_life_']=function(n,c)if c==owner then return n,'life total changed by '..math.abs(n-count)..'. Setting it to'end end,
        ['RESET_Life_']=function(n,c)return n,'reset life totals to'end,
        -- ['test_']=function(n,c)return count end,
      }

      function onChat(msg,player)
        if msg:find('[ _]%d+') then
          local m=msg:lower():gsub(' ','_')
          local a,sl,t,n=false,false,'',tonumber(m:match('%d+'))
          for k,f in pairs(lCheck) do
            if m:find(k..'%d+') then
              a,t,sl=f(n,player.color)
              if a then
                count=a
                if sl then
                  sL(count,n)
                end
              break
              else
                return msg
              end
            end
          end
          updateSave()
          if t and t~='' then
            broadcastToAll(player.color..'[999999] '..t..' [-]'..n,ownerRGB)
            sL(count,count-JSON.decode(self.script_state).c)
            return false
          end
        end
      end

      function onload(s)
        owner = playercolor
        ownerRGB = Color.fromString(owner)
        ref_type = self.getName():gsub('%s.+','')
        txt = owner..' [888888]%s %s '..ref_type..'.[-] |%s|'
        self.setColorTint(ownerRGB)
        if s~='' then
          local ld=JSON.decode(s); count=ld.c
        else
          count=40
        end
        local rgb = stringColorToRGB(owner)

        self.createButton({             -- the main button
          tooltip='Click to increase\nRight click to decrease',
          click_function='option',
          function_owner=self,
          height=750,
          width=950,
          font_size=1000,
          label='\n'..count..'\n',
          position={0,y,z},
          hover_color={1,1,1,0.1},
          scale=scale,
          color=back,
          font_color=font
        })

        self.createButton({             -- moved the change value to a separate button for more control
          click_function='null',
          function_owner=self,
          height=0,
          width=0,
          font_size=400,
          label='',
          position={0-0.05,y,z+1},
          hover_color={1,1,1,0.1},
          scale=scale,
          color=back,
          font_color=font
        })

        for i,v in ipairs({             -- the side buttons
            {n=1,l='▲',p={x*0.95,y,z+0.2}},
            {n=-1,l='▼',p={-x,y,z+0.2}},
            {n=20,l='+20',p={x*1.05,y,z-0.4}},
            {n=-20,l='-20',p={-x*1.1,y,z-0.4}}}) do

          local fn='valueChange'..i
          self.setVar(fn, function(o,c,a) local b=1 if a then b=5 end click_changeValue(o,c,v.n*b) end)
          self.createButton({
            tooltip='Right-click for '..v.n*5,
            label=v.l,
            position=v.p,
            click_function=fn,
            function_owner=self,
            height=800,
            width=800,
            font_size=700,
            hover_color={1,1,1,0.1},
            scale=scale2,
            color=back,
            font_color={font[1],font[2],font[3],50},
          })
        end

        self.createButton({            -- reset life to 40 button
          label='[R]',
          click_function='resetLife',
          tooltip='Reset Life',
          function_owner=self,
          position={x*0.72,y,z-1.05},
          height=800,
          width=800,
          alignment = 3,
          font_size=700,
          hover_color={1,1,1,0.1},
          scale=scale2,
          font_color={font[1],font[2],font[3],20},
          color=back,
        })
      end

      function resetLife(obj,color)
        --if color==owner then
          sL(40,0)
          count=40
          printToAll(owner..'[999999] reset their life to [-]|'..count..'|',ownerRGB)
          updateSave()
        --end
      end

      function null()
      end

      x=1.2
      y=0.15
      z=-0.3
      objsca = self.getScale()
      scale  = {1,1,1}
      scale2 = {0.3,1,0.3}
      back = {0,0,0,0}
      font = {1,1,1,100}
      mode=''
      ref_type=''
      owner=''
      C2=nil