local sprite={}

local function undo()
    if #sprite.undo > 0 then
        local t={}
        for i,j in ipairs(sprite.undo[#sprite.undo]) do
            table.insert(t,{x=j.x,y=j.y,c=api.sget(j.x,j.y)})
            print("added redo")
            api.sset(j.x,j.y,j.c)
            print("undid pixel at x: "..j.x.." y: "..j.y)
        end
        table.insert(sprite.redo,t)
        table.remove(sprite.undo,#sprite.undo)
        print(#sprite.redo)
    end
    if #sprite.undo>64 then
        table.remove(sprite.undo,1)
    end
end

local function redo()
    if #sprite.redo > 0 then
        local t={}
        for i,j in ipairs(sprite.redo[#sprite.redo]) do
            table.insert(t,{x=j.x,y=j.y,c=api.sget(j.x,j.y)})
            print("added undo")
            api.sset(j.x,j.y,j.c)
            print("redid pixel at x: "..j.x.." y: "..j.y.." color:",j.c)
        end
        table.insert(sprite.undo,t)
        table.remove(sprite.redo,#sprite.redo)
    end
    if #sprite.redo>64 then
        table.remove(sprite.redo,1)
    end
end

local function copy()
    Sclip={}
    for y=0,7 do
        for x=0,7 do
            table.insert(Sclip,api.sget(x+sel.x*8,y+sel.y*8))
        end
    end
end

local function paste()
    if #Sclip>0 then
        local t={}
        for x1=0,7 do
            for y1=0,7 do
                table.insert(t,{x=x1+sel.x*8,y=y1+sel.y*8,c=api.sget(x1+sel.x*8,y1+sel.y*8)})
                api.sset(x1+sel.x*8,y1+sel.y*8,Sclip[x1+(y1*8)+1])
            end
        end
        table.insert(sprite.undo,t)
    end
end

local function delete()
    local t={}

    for x1=0,7 do
        for y1=0,7 do
            table.insert(t,{x=x1+sel.x*8,y=y1+sel.y*8,c=api.sget(x1+sel.x*8,y1+sel.y*8)})
            api.sset(x1+sel.x*8,y1+sel.y*8,0)
        end
    end

    table.insert(sprite.undo,t)
end

local function col(ax,ay,bx,by,aw,ah,bw,bh)
    return ax<bx+bw and bx<ax and ay<by+bh and by<ay
end

local se=6 --scale of sprite editor

local sheetOs=0

function sprite:init()
    sprite.undo={}
    sprite.redo={}
    sel={x=0,y=0} --selection position
    Sclip={} --clipbboard
    sheetOs=0 --spritesheet selection offset
    lso=0
    self.boot=false
    color={0,2,lg.newImage("assets/selectedColor.png")} --color selection image (TODO: change to non-png drawable)
end

function sprite:enter()

    self.rect={down=false,x=0,y=0,w=0,h=0}

    self.mode="draw"

    mouse=require("editors.mouse") --define mouse
    if not mem.map and not cartLoaded then mem.init() end --fix missing memory if thats an issue
    
    Sundo={} --undo variable (TODO)
    sprImg=love.graphics.newCanvas(8,8) --sprite edit canvas
    colorSel=lg.newCanvas(32,32) --color selection canvas

    if self.boot then
        sel={x=0,y=0} --selection position
        --Sclip={} --clipbboard
        sheetOs=0 --spritesheet selection offset
        lso=0
        self.boot=false
        self.undo={}
        self.redo={}
        color={0,2,lg.newImage("assets/selectedColor.png")} --color selection image (TODO: change to non-png drawable)
    end

    sheetImg=lg.newCanvas(128,8*3+1) --spritesheet selection image

    bar.init()

    --draw mode button
    buttons.new(116,16,8,8,"0000000000000100000011100001110000111000011100000110000000000000",3,13,function()
        self.mode="draw"
    end)
    --rectangle button
    buttons.new(116,24,8,8,"0000000001111100010001000101111001011110011111100001111000000000",3,13,function()
        self.mode="rect"
    end)
    buttons.new(116,32,8,8,"0000000000001000000001000111111001111110010111000100100000000000",3,13,function()
        self.mode="fill"
    end)

    local bos=78
    buttons.new(bos,57,8,8,"0000000000100000011111000010001000000010011111000000000000000000",3,12,function()
        undo()
    end)
    buttons.new(bos+8,57,8,8,"0000000000000100001111100100010001000000001111100000000000000000",3,5,function()
        redo()
    end)
    buttons.new(bos+16,57,8,8,"0000000000011000011101000100101001000110010001100111110000000000",3,11,function()
        copy()
    end)
    buttons.new(bos+24,57,8,8,"0000000000011000011111100101101001000010010000100111111000000000",3,13,function()
        paste()
    end)
    buttons.new(bos+32,57,8,8,"0000000000011000011111100011110000111100001111000011110000000000",3,8,function()
        delete()
    end)
end

function sprite:update()
    --require("lovebird").update()
    --mouse position code
    mouse.update()

    if mouse.x and mouse.y then
        if love.mouse.isDown(1) then
            --sprite editor
            if col(mouse.x,mouse.y,16,16,1,1,8*se,8*se) then
                local x,y=math.floor((mouse.x-16)/se +sel.x*8),math.floor((mouse.y-17)/se +sel.y*8)
                if self.mode=="draw" then
                    if api.sget(x,y)~=color[1] then
                        table.insert(self.undo,{{x=x,y=y,c=api.sget(x,y)}})
                        api.sset(x,y,color[1])
                    end
                else

                end
            end
            --color picker
            if col(mouse.x,mouse.y,80,16,1,1,32,32) then
                local x,y=math.floor((mouse.x-80)/8),math.floor((mouse.y-17)/8)
                color[1]=x+(y*4)
            end
            --spritesheet
            if col(mouse.x,mouse.y,0,71,1,1,128,8*3) then
                local x,y=math.floor((mouse.x)/8),math.floor(((mouse.y-72+sheetOs)/8))
                
                if y>-1 and y<16 then 
                    sel.y=y 
                    sel.x=x
                end
            end
        end
    end
    if lso<sheetOs then
        lso=lso+4
    elseif lso>sheetOs then
        lso=lso-4
    end
end


function deco(x,y,w,h)
    colr(1)
    lg.line(x,y,x+w,y)
    lg.line(x+w,y,x+w,y+h)
    colr(3)
    lg.line(x+1,y,x+1,y+h)
    lg.line(x+1,y+h,x+w,y+h)
end

function sprite:draw()

    lg.setColor(1,1,1)

    love.graphics.setCanvas(sprImg)
        love.graphics.setColor(palCol(0))
        lg.rectangle("fill",0,0,8,8)
        for y=0,8 do
            for x=0,7 do
                love.graphics.setColor(palCol(api.sget(x+(sel.x*8),y+(sel.y*8))))
                lg.points(x,y)
            end
        end

    lg.setCanvas(colorSel)
    for y=0,3 do
        for x=0,3 do
            love.graphics.setColor(palCol(x+(y*4)))
            lg.rectangle("fill",x*8,(y)*8,8,8)
            --love.graphics.setColor(palCol(13))
            --lg.draw(color[3],(color[1]%4)*8,math.floor(color[1]/4)*8)
            drawBinary("1110000011000000100000000000000000000000000000000000000000000000",(color[1]%4)*8,math.floor(color[1]/4)*8,13)
        end
    end

    lg.setCanvas(sheetImg)
    lg.clear(palCol(1))
    for y=0,127 do
        for x=0,127 do
            love.graphics.setColor(palCol(api.sget(x,y)))
            lg.points(x,y-math.floor(lso))
        end
    end

    --selection box
    colr(0)
    lg.rectangle("line",sel.x*8+0.5-2,sel.y*8+0.5-2-math.floor(lso),11,11)
    colr(13)
    lg.rectangle("line",sel.x*8+0.5-1,sel.y*8+0.5-1-math.floor(lso),9,9)
    for i=0,15 do
        colr((i%2)+1)
        lg.line(128,i*8-lso,128,i*8+8-lso)
    end
    love.graphics.setCanvas()
    
    shove.beginDraw()
    shove.beginLayer("screen")

    --draw bg
    love.graphics.setColor(palCol(2))
    lg.rectangle("fill",0,0,128,96)

    --draw bar
    --[[love.graphics.setColor(palCol(1))
    lg.rectangle("fill",0,0,128,8)
    buttons.draw()]]
    

    --draw spritesheet rect
    love.graphics.setColor(palCol(0))
    lg.rectangle("fill",0,72,128,128)
    
    lg.setColor(1,1,1)

    --draw the sprite thats being edited
    lg.draw(sprImg,16,17,0,se,se)

    --draw the color picker
    lg.draw(colorSel,80,17)
    

    lg.draw(sheetImg,0,72)
    --draw decorations
    deco(79,17,34,33)
    deco(15,17,50,49)

    colr(13)
    drawFont(tostring(color[1]),79,51)
    --112,51
    drawFont(self.mode,112-(string.len(self.mode)*font.w)+2,51)
    --113
    drawFont(tostring(sel.x+(sel.y*16)),123-((string.len(tostring(sel.x+(sel.y*16)))-1)*5),66)

    bar.draw()

     --draw the mouse
    mouse.draw()

    lg.setColor(1,1,1)

    shove.endLayer()
    lg.setColor(1,1,1)
    shove.endDraw()
    --lg.print("x: "..mouse.x.." y: "..mouse.y,0,0)
    --lg.print(love.timer.getFPS(),0,20)
    --lg.print(tostring(self.mode))
end

lso=0

function sprite:mousepressed(x,y,b)
    bar.press(b)
    --self.rect={down=false,x=0,y=0,w=0,h=0}
    if self.mode=="rect" and b==1 and col(mouse.x,mouse.y,16,16,1,1,8*se,8*se) then
        self.rect.down=true
        local x,y=math.floor((mouse.x-16)/se +sel.x*8),math.floor((mouse.y-17)/se +sel.y*8)
        self.rect.x=x
        self.rect.y=y
        self.rect.w=0
        self.rect.h=0
    end
    
end

function sprite:mousereleased(x2,y2,b)
    if b==1 and col(mouse.x,mouse.y,16,16,1,1,8*se,8*se) then
        if self.mode=="rect" then
            if self.rect.down then
            local x,y=math.floor((mouse.x-16)/se +sel.x*8),math.floor((mouse.y-17)/se +sel.y*8)
            --api.sset(x,y,color[1])
            --api.sset(self.rect.x,self.rect.y,color[1])
            local t={}
            local dx,dy=1,1
            if x>= self.rect.x then
                dx=1
            else
                dx=-1
            end
            if y>= self.rect.y then
                dy=1
            else
                dy=-1
            end

            local xx,yy=self.rect.x,self.rect.y

            if love.keyboard.isDown("lshift") then
               for x1=self.rect.x,x,dx do
                   table.insert(t,{x=x1,y=yy,c=api.sget(x1,yy)})
                    table.insert(t,{x=x1,y=y,c=api.sget(x1,y)})
                    api.sset(x1,yy,color[1])
                    api.sset(x1,y,color[1])
                end
                for y1=self.rect.y,y,dy do
                    table.insert(t,{x=xx,y=y1,c=api.sget(xx,y1)})
                    table.insert(t,{x=x,y=y,c=api.sget(x,y1)})
                    api.sset(xx,y1,color[1])
                    api.sset(x,y1,color[1])
                end
            else
                for x1=self.rect.x,x,dx do
                    for y1=self.rect.y,y,dy do
                        table.insert(t,{x=x1,y=y1,c=api.sget(x1,y1)})
                        api.sset(x1,y1,color[1])
                    end
                end
            end

            table.insert(self.undo,t)

            self.rect.down=false
        end
        elseif self.mode=="fill" then

            local dir={
                {x=1,y=0},
                {x=-1,y=0},
                {x=0,y=1},
                {x=0,y=-1}
            }

            local xx,yy=math.floor((mouse.x-16)/se +sel.x*8),math.floor((mouse.y-17)/se +sel.y*8)

            local q={{x=xx,y=yy}}

            local old=api.sget(xx,yy)

            if old==color[1] then return end

            local t={}
            local w,h=8,8

            for x=sel.x*8,sel.x*8+w do
                for y=sel.y*8,sel.y*8+h do
                    table.insert(t,{x=x,y=y,c=api.sget(x,y)})
                end
            end

            while #q>0 do
                local p=table.remove(q,1)
                
                api.sset(p.x,p.y,color[1])

                

                for k,v in pairs(dir) do
                    if api.sget(p.x+v.x,p.y+v.y)==old and p.x+v.x>=sel.x*8 and p.x+v.x<sel.x*8+w and p.y+v.y>=sel.y*8 and p.y+v.y<sel.y*8+h then
                        --table.insert(t,{x=p.x+v.x,y=p.y+v.y,c=api.sget(p.x+v.x,p.y+v.y)})
                        table.insert(q,{x=p.x+v.x,y=p.y+v.y})
                    end
                end
                
            end

            table.insert(self.undo,t)
 
        end
    else

    end
end

function sprite:wheelmoved(x,y)
    if y>0 and sheetOs>0 then
        sheetOs=sheetOs-4
    elseif y<0 and sheetOs<104 then
        sheetOs=sheetOs+4
    end
end

function sprite:keypressed(k)
    if love.keyboard.isDown("lctrl") and k=="z" then
        undo()
    end
    if love.keyboard.isDown("lctrl") and k=="y" then
        redo()
    end
    if love.keyboard.isDown("lctrl") and k=="c" then
        copy()
    end
    if love.keyboard.isDown("lctrl") and k=="x" then
        local t={}
        Sclip={}
        for y1=0,7 do
            for x1=0,7 do
                table.insert(Sclip,api.sget(x1+sel.x*8,y1+sel.y*8))
                table.insert(t,{x=x1+sel.x*8,y=y1+sel.y*8,c=api.sget(x1+sel.x*8,y1+sel.y*8)})
                api.sset(x1+sel.x*8,y1+sel.y*8,0)
            end
        end
        table.insert(self.undo,t)
    end
    if love.keyboard.isDown("lctrl") and k=="v" then
        paste()
    end
    if k=="delete" then
        delete()
    end

    bar.key(k)
end

return sprite