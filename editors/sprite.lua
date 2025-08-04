local sprite={}

local function col(ax,ay,bx,by,aw,ah,bw,bh)
    return ax<bx+bw and bx<ax and ay<by+bh and by<ay
end

local se=6 --scale of sprite editor



function sprite:enter()
    mouse={x=0,y=0,img=lg.newImage("assets/mouse.png")} --define mouse
    if not mem.map and not cartLoaded then mem.init() end --fix missing memory if thats an issue
    Sclip={} --clipbboard
    Sundo={} --undo variable (TODO)
    sprImg=love.graphics.newCanvas(8,8) --sprite edit canvas
    colorSel=lg.newCanvas(32,32) --color selection canvas
    sel={x=0,y=0} --selection position
    color={0,2,lg.newImage("assets/selectedColor.png")} --color selection image (TODO: change to non-png drawable)
    sheetOs=0 --spritesheet selection offset
    sheetImg=lg.newCanvas(128,8*3+1) --spritesheet selection image

    --[[[buttons.reset()

   --[[buttons.new(9,0,8,8,"0000000001100110011001100110011001111110010110100111111000000000",3,13,function()
        print("switching to sprite")
        gs.switch(editor.sprite)
    end)
    buttons.new(0,0,8,8,"0000000000100100010000100100001001000010010000100010010000000000",3,13,function()
        print("switching to code")
        gs.switch(editor.code)
    end)
    buttons.new(9,0,8,8,"0000000001100110011001100110011001111110010110100111111000000000",3,13,function()
        print("switching to sprite")
        gs.switch(editor.sprite)
    end)]]
    bar.init()
end

function sprite:update()
    require("lovebird").update()
    --mouse position code
    local x,y=love.mouse.getPosition() --get the mouse position XD
    if x and y then --make sure x and y arent nil
        local xx,yy=push:toGame(x,y) --convert screen coords to pixel coords using push
        if xx and yy then --check if xx and yy are nil
            mouse.x,mouse.y=math.floor(xx),math.floor(yy) --set the mouse position
        end
    end

    if mouse.x and mouse.y then
        if love.mouse.isDown(1) then
            --sprite editor
            if col(mouse.x,mouse.y,16,16,1,1,8*se,8*se) then
                if api.sget(math.floor((mouse.x-16)/se +sel.x*8),math.floor((mouse.y-16)/se +sel.y*8))~=color[1] then
                    api.sset(math.floor((mouse.x-16)/se +sel.x*8),math.floor((mouse.y-16)/se +sel.y*8),color[1])     
                end
            end
            --color picker
            if col(mouse.x,mouse.y,80,16,1,1,32,32) then
                local x,y=math.floor((mouse.x-80)/8),math.floor((mouse.y-17)/8)
                color[1]=x+(y*4)
            end
            --spritesheet
            if col(mouse.x,mouse.y,0,72,1,1,128,8*3) then
                local x,y=math.floor((mouse.x)/8),math.floor(((mouse.y-73+sheetOs)/8))
                sel.x,sel.y=x,y
            end
        end
    end
    if lso<sheetOs then
        lso=lso+2
    elseif lso>sheetOs then
        lso=lso-2
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
            love.graphics.setColor(palCol(13))
            lg.draw(color[3],(color[1]%4)*8,math.floor(color[1]/4)*8)
        end
    end

    lg.setCanvas(sheetImg)
    lg.clear(palCol(1))
    for y=0,127 do
        for x=0,127 do
            love.graphics.setColor(palCol(api.sget(x,y)))
            lg.points(x,y+1-math.floor(lso))
        end
    end

    --selection box
    colr(13)
    lg.rectangle("line",sel.x*8+1,sel.y*8+2-math.floor(lso),7,7)
    for i=0,15 do
        colr((i%2)+1)
        lg.line(128,i*8-lso,128,i*8+8-lso)
    end
    love.graphics.setCanvas()
    
    push:start()

    --draw bg
    love.graphics.setColor(palCol(2))
    lg.rectangle("fill",0,0,128,96)

    --draw bar
    --[[love.graphics.setColor(palCol(1))
    lg.rectangle("fill",0,0,128,8)
    buttons.draw()]]
    bar.draw()

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
    --[[drawFont(tostring(sel.x+(sel.y*16)),1,1)

    if mouse.x and mouse.y then
        if col(mouse.x,mouse.y,0,72,1,1,128,8*3) then
            local x,y=math.floor((mouse.x)/8),math.floor(((mouse.y-71+sheetOs)/8))
            colr(14)
            drawFont(tostring(x+(y*16)),8*3+1,1)
        end
    end]]
    

     --draw the mouse
    lg.setColor(1,1,1)
    if mouse.x and mouse.y then
        lg.draw(mouse.img,mouse.x,mouse.y)
    end

    push:finish()
end

lso=0

function sprite:mousepressed(x,y,b)
    --[[if b==1 then
        buttons.pressed()
    end]]
    bar.press(b)
end

function sprite:wheelmoved(x,y)
        if y>0 then
            sheetOs=sheetOs-4
        elseif y<0 then
            sheetOs=sheetOs+4
        end
end

function sprite:keypressed(k)
    if love.keyboard.isDown("lctrl") and k=="c" then
        Sclip={}
        for y=0,7 do
            for x=0,7 do
                table.insert(Sclip,api.sget(x+sel.x*8,y+sel.y*8))
            end
        end
    end
    if love.keyboard.isDown("lctrl") and k=="x" then
        Sclip={}
        for y1=0,7 do
            for x1=0,7 do
                table.insert(Sclip,api.sget(x1+sel.x*8,y1+sel.y*8))
                api.sset(x1+sel.x*8,y1+sel.y*8,0)
            end
        end
    end
    if love.keyboard.isDown("lctrl") and k=="v" then
        for x1=0,7 do
            for y1=0,7 do
                api.sset(x1+sel.x*8,y1+sel.y*8,Sclip[x1+(y1*8)+1])
            end
        end
    end
    if k=="delete" then

        for x1=0,7 do
            for y1=0,7 do
                api.sset(x1+sel.x*8,y1+sel.y*8,0)
            end
        end

    end
    runCartFromEditor(k)
    if love.keyboard.isDown("lctrl") and k=="s" then
        save()
    end
    if love.keyboard.isDown("f1") then
        gs.switch(menuProg)
    end
end

return sprite