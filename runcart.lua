local runCart={}

function runCart:enter(p,arg)
    api.setup()
    api.cls()
    
    print("cart loaded!")
    math.randomseed(love.math.random(0,99999999999))
    if #loadSheet>0 then
        for i=0,#loadSheet-1 do
            mem.poke(0x3032+i,loadSheet[i+1])
        end
    end
    mem.resetPal()
    sb.initCart(cart)
    
    cartLoaded=true

    pauseMenu={
        "resume",
        "reset",
        "exit"
    }
    menuSel=0
end

local function getLongestString(tbl)
    local long=0
    for k,v in ipairs(tbl) do
        if string.len(v)>long then
            long=string.len(v)
        end
    end
    return long
end

function runCart:update()
    api.updateInput()
    if input:pressed('pause') then
        if paused then
            local selected=pauseMenu[menuSel+1]
            if selected=="resume" then
                paused=false
            elseif selected=="reset" then
                api.setup()
                sb.initCart(cart)
                api.updateInput()
            elseif selected=="exit" then
                gs.switch(menuProg)
            end
        else
            paused=true
            menuSel=0
        end
    end
    if paused then
        if input:pressed("up") then
            menuSel=menuSel-1
            if menuSel<0 then
                menuSel=#pauseMenu-1
            end
        end
        if input:pressed("down") then
            menuSel=menuSel+1
            if menuSel>#pauseMenu-1 then
                menuSel=0
            end
        end
        if input:pressed("c") then
            
        end
    end
end

function runCart:draw()
    push:start()   
    sb.tickCart()
    
    for y=0,95 do
        for x=0,127 do        
            love.graphics.setColor(palCol(mem.peek(mem.toDisp(x,y))))
            lg.points(x,y)            
        end
    end

    if paused then
        local osx=64-((((getLongestString(pauseMenu)+1)*5)+2)/2)
        local osy=96/2-(((#pauseMenu*6)+2)/2)
        colr(0)
        lg.rectangle("fill",osx,osy,((getLongestString(pauseMenu)+1)*5)+1,(#pauseMenu*6)+1)
        colr(13)
        lg.rectangle("line",osx-1,osy,((getLongestString(pauseMenu)+1)*5)+2,(#pauseMenu*6)+2)
        for k,i in ipairs(pauseMenu) do
            
            if menuSel+1==k then
                colr(13)
                drawFont("A"..i,osx+1,((k-1)*6)+osy+1)
            else
                colr(14)
                drawFont(i,osx+1,((k-1)*6)+osy+1)
            end
        end
    end

    push:finish()
end

function runCart:keypressed(k)
    if k=="r" then
        api.setup()
        sb.initCart(cart)
    end
    if k=="escape" then
        gs.switch(editor.code)
    end
end

return runCart