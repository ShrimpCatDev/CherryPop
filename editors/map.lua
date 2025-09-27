local map={}
local activated=true

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

local cam={x=0,y=0,osx=0,osy=0}
local selectedTile=0
local sel={x=0,y=0}
local sheetOs=0
local mode="draw"

function map:init()
    sel.x,sel.y=0,0
    cam={x=0,y=0,osx=0,osy=0}
    selectedTile=0
    sheetOs=0
    self.boot=false
end

function map:enter()
    mouse=require("editors/mouse")
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
    --zoom button
    buttons.new(24,96-8,8,8,"0000000001111000010010000100100001111100000011100000011000000000",3,13,function()
        mode="zoom"
    end)
    if self.boot then
        sel.x,sel.y=0,0
        cam={x=0,y=0,osx=0,osy=0}
        selectedTile=0
        sheetOs=0
        self.boot=false
    end
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
            if mode=="draw" then
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
    
    push:start()
        
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

        lg.push()
        if selOpen then
            
            lg.setColor(1,1,1)
            lg.draw(selCanvas,0,8)
            
        end
        lg.pop()
        bar.draw()
        
        mouse.draw()
    push:finish()
    --lg.print(mouse.x.." "..mouse.y)
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
end

function map:mousereleased(x,y,b)
    if b==3 and not selOpen then
        cam.osx,cam.osy=0,0
        activated=false
    end
    if b==1 and selOpen then
        if mouse.y>=8 and mouse.y<96-8 then
            selOpen=false
        end
    end
end

function map:keypressed(k)
    bar.key(k)
    if k=="delete" then
        local cx,cy=math.floor(cam.x/8),math.floor(cam.y/8)
        local mx,my=math.floor(mouse.x/8),math.floor(mouse.y/8)
        for x=0,15 do
            for y=0,11 do
                api.mset(x-cx,y-cy,0)
            end
        end
    end
end

return map