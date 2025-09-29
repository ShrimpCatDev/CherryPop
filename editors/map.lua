local map={}
local activated=true

local cam={x=0,y=0,osx=0,osy=0}
local selectedTile=0
local sel={x=0,y=0}
local sheetOs=0
local mode="draw"

local function undo()
    if #map.undo > 0 then

        local t={}
        for i,j in ipairs(map.undo[#map.undo]) do
            table.insert(t,{x=j.x,y=j.y,c=api.mget(j.x,j.y)})
            api.mset(j.x,j.y,j.c)
            print("undid tile at x: "..j.x.." y: "..j.y)
        end
        table.insert(map.redo,t)
        table.remove(map.undo,#map.undo)
        print(#map.redo)
        
    end
    if #map.undo>24 then
        table.remove(map.undo,1)
    end
end

local function fill()
    if not selOpen and mode=="fill" then
    local dir={
        {x=1,y=0},
        {x=-1,y=0},
        {x=0,y=1},
        {x=0,y=-1}
    }

    local cx,cy=-math.floor(cam.x/8),-math.floor(cam.y/8)
    local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)

    local xx,yy=mx+cx,my+cy

    local q={{x=xx,y=yy}}

    local old=api.mget(xx,yy)

    if old==selectedTile then return end

    local t={}
    local w,h=16,12

    for x=cx,cx+w do
        for y=cy,cy+h do
            table.insert(t,{x=x,y=y,c=api.mget(x,y)})
        end
    end

    while #q>0 do
        local p=table.remove(q)
                
        api.mset(p.x,p.y,selectedTile)


        for k,v in pairs(dir) do
            if api.mget(p.x+v.x,p.y+v.y)==old and p.x+v.x>=cx and p.x+v.x<cx+16 and p.y+v.y>=cy and p.y+v.y<cy+12 then
                table.insert(q,{x=p.x+v.x,y=p.y+v.y})
            end
        end
                
    end

    table.insert(map.undo,t)
    end
end

local function redo()
    if #map.redo > 0 then
        local t={}
        for i,j in ipairs(map.redo[#map.redo]) do
            table.insert(t,{x=j.x,y=j.y,c=api.mget(j.x,j.y)})
            api.mset(j.x,j.y,j.c)
        end
        table.insert(map.undo,t)
        table.remove(map.redo,#map.redo)
        
    end
    if #map.redo>24 then
            table.remove(map.redo,1)
        end
end

function pixelSspr(sx,sy,sw,sh,x,y,tc)
    for y1=0,sh-1 do
        for x1=0,sw-1 do
            if api.sget(x1+sx,y1+sy)~=tc then
                colr(api.sget(x1+sx,y1+sy))
                lg.points(x1+x,y1+y)
            end
        end
    end
end

function pixelSpr(index,x,y,tc,w,h)
    ww=w or 1
    hh=h or 1
    local sx=math.floor(index%16)*8
    local sy=math.floor(index/16)*8
    pixelSspr(sx,sy,ww*8,hh*8,x,y,tc)
end



local function delete()
    local cx,cy=math.floor(cam.x/8),math.floor(cam.y/8)
    local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)

    local t={}
        
    for x=0,15 do
        for y=0,11 do
            table.insert(t,{x=x-cx,y=y-cy,c=api.mget(x-cx,y-cy)})
            api.mset(x-cx,y-cy,0)
            print("deleted tile at x: "..x-cx.."y: "..y-cy)
        end
    end

    table.insert(map.undo,t)
end

function map:init()
    mode= "draw"
    sel.x,sel.y=0,0
    cam={x=0,y=0,osx=0,osy=0}
    selectedTile=0
    sheetOs=0
    self.boot=false
    self.undo={}
    self.redo={}
end

function map:enter()
    mouse=require("editors.mouse")
    bar.init()
    activated=false
    
    selOpen=false
    selCanvas=love.graphics.newCanvas(128,96-16)
    mode="draw"
    buttons.new(0,96-8,8,8,"0000000001111110010101100110101001010110011010100111111000000000",3,13,function()
        if selOpen then
            selOpen=false
        else
            selOpen=true
        end
        
    end)
    --draw mode button
    buttons.new(8,96-8,8,8,"0000000000000100000011100001110000111000011100000110000000000000",3,13,function()
        mode="draw"
    end)
    --rectangle button
    buttons.new(16,96-8,8,8,"0000000001111100010001000101111001011110011111100001111000000000",3,13,function()
        mode="rect"
    end)
    buttons.new(24,96-8,8,8,"0000000000001000000001000111111001111110010111000100100000000000",3,13,function()
        mode="fill"
    end)
    --zoom button
    buttons.new(32,96-8,8,8,"0000000001111000010010000100100001111100000011100000011000000000",3,13,function()
        mode="zoom"
    end)
    if self.boot then
        sel.x,sel.y=0,0
        cam={x=0,y=0,osx=0,osy=0}
        selectedTile=0
        sheetOs=0
        self.boot=false
        self.undo={}
        self.redo={}
        mode= "draw"
    end
    self.rect={}
end

function map:update()
    mouse.update()
    if not selOpen then
        if love.keyboard.isDown("left") then
            cam.x=cam.x+2
        end
        if love.keyboard.isDown("right") then
            cam.x=cam.x-2
        end
        if love.keyboard.isDown("up") then
            cam.y=cam.y+2
        end
        if love.keyboard.isDown("down") then
            cam.y=cam.y-2
        end
        if activated then
            cam.x,cam.y=mouse.x+cam.osx,mouse.y+cam.osy
        end
        local cx,cy=math.floor(cam.x/8),math.floor(cam.y/8)
        local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)
        if love.mouse.isDown(1) and mouse.y>=8 and mouse.y<96-8 then
            if mode=="draw" and api.mget(mx-cx,my-cy)~=selectedTile then
                table.insert(self.undo,{{x=mx-cx,y=my-cy,c=api.mget(mx-cx,my-cy)}})
                api.mset(mx-cx,my-cy,selectedTile)
            end
        end
        if love.mouse.isDown(2) and mouse.y>=8 and mouse.y<96-8 then
            if mode=="draw" then
                --api.mset(mx-cx,my-cy,selectedTile)
                selectedTile=(api.mget(mx-cx,my-cy))
            end
        end
    else
        local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)+sheetOs
        if love.mouse.isDown(1) and mouse.y>=8 and mouse.y<96-8 then
            sel.x,sel.y=mx,my-1
        end
        selectedTile=sel.x+(sel.y*16)
    end
end

function map:draw()
    lg.setColor(1,1,1)
    lg.setCanvas(selCanvas)

            local w=16
            for i=0,255 do
                pixelSpr(i,(i%w)*8,(math.floor(i/w)-sheetOs)*8)
            end
            colr(13)
            lg.rectangle("line",(sel.x*8)+1,((sel.y-sheetOs)*8)+1,7,7)

    lg.setCanvas()
    
    shove.beginDraw()
    shove.beginLayer("screen")
        
        local cx,cy=-math.floor(cam.x/8),-math.floor(cam.y/8)
        for y=0,11 do
            for x=0,15 do
                pixelSpr(api.mget(x+cx,y+cy),x*8,y*8,-1)
            end
        end

        local mx,my=math.floor(mouse.x/8)*8,math.floor(mouse.y/8)*8
        pixelSpr(selectedTile,mx,my,-1)

        colr(2)
        lg.rectangle("fill",0,96-8,128,8)

        if not love.mouse.isDown(1) then
            colr(13)
            drawFont(selectedTile,1,9)
        end

        local cx,cy=math.floor(cam.x/8),math.floor(cam.y/8)
        local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)
        local string=mx-cx..","..my-cy
        colr(13)
        drawFont(string,123-((string.len(string)-1)*5),96-7)

        colr(13)
        drawFont(mode,1,96-8-7)

        lg.push()
        if selOpen then
            
            lg.setColor(1,1,1)
            lg.draw(selCanvas,0,8)
            
        end
        lg.pop()
        bar.draw()
        
        mouse.draw()
        lg.setColor(1,1,1,1)
        shove.endLayer()
        lg.setColor(1,1,1,1)
        shove.endDraw()
        local cx,cy=-math.floor(cam.x/8),-math.floor(cam.y/8)
    lg.print(cx..", "..cy)
    --lg.print(tostring(activated),0,12)
    --lg.print(sheetOs)
end

function map:wheelmoved(x,y)
    if selOpen then
        if y>0 and sheetOs>0 then
            sheetOs=sheetOs-1
        elseif y<0 and sheetOs<6 then
            sheetOs=sheetOs+1
        end
    end
end

function map:mousepressed(x,y,b)
    if b==1 then
        bar.press(b)
    elseif b==3 and not selOpen then
        cam.osx=cam.x-mouse.x
        cam.osy=cam.y-mouse.y
        activated=true
    end

    if b==1 and not selOpen then
        if mode=="rect" and mouse.y>=8 and mouse.y<96-8 then
            local cx,cy=math.floor(cam.x/8),math.floor(cam.y/8)
            local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)

            local xx,yy=mx-cx,my-cy

            print("init rect at x: "..xx.." y: "..yy)

            self.rect.down=true
            local x,y=xx,yy
            self.rect.x=x
            self.rect.y=y
            self.rect.w=0
            self.rect.h=0
        end
    end
end

function map:mousereleased(x,y,b)

    if b==1 and not selOpen then
        if mode=="rect" and mouse.y>=8 and mouse.y<96-8 then
            if self.rect.down then
            local cx,cy=math.floor(cam.x/8),math.floor(cam.y/8)
            local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)

            local x,y=mx-cx,my-cy
            print("end rect at x: "..x.." y: "..y)
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

            --[[if love.keyboard.isDown("lshift") then
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
            else]]
                for x1=self.rect.x,x,dx do
                    for y1=self.rect.y,y,dy do
                        table.insert(t,{x=x1,y=y1,c=api.mget(x1,y1)})
                        api.mset(x1,y1,selectedTile)
                    end
                end
            --end

            table.insert(self.undo,t)

            self.rect.down=false
            end
        end
    end
    
    if b==3 and not selOpen then
        cam.osx,cam.osy=0,0
        activated=false
    end
    if b==1 and mouse.y>=8 and mouse.y<96-8 then
        fill()
    end
    if b==1 and selOpen then
        if mouse.y>=8 and mouse.y<96-8 then
            selOpen=false
        end
    end
    
end

function map:keypressed(k)
    bar.key(k)
    if k=="space" then 
        selOpen=true
    end
    if k=="delete" then
        delete()
    end
    if love.keyboard.isDown("lctrl") and k=="z" then
        undo()
    end
    if love.keyboard.isDown("lctrl") and k=="y" then
        redo()
    end
end

return map