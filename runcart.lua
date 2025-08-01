local runCart={}

function runCart:enter(p,arg)
    --if not cartLoaded then
    api.setup()
    sb.initCart(cart)
    math.randomseed(love.math.random(0,99999999999))
    if #loadSheet>0 then
        for i=0,#loadSheet-1 do
            mem.poke(0x3032+i,loadSheet[i+1])
        end
    end
    cartLoaded=true
    --end
    --[[if arg then
        mem.map=arg
    end]]
end

function runCart:update()
    api.updateInput()
    if input:pressed('pause') then
        if paused then
            paused=false
        else
            paused=true
        end
    end
    if input:pressed("exit") then
        gs.switch(menuProg)
    end
end

function runCart:draw()
    push:start()   
    sb.tickCart()

    
    for y=0,95 do
        for x=0,127 do
        
            love.graphics.setColor(palCol(mem.peek(mem.toDisp(x,y))))
            love.graphics.points(x,y+1)
            
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
        gs.switch(editor.sprite)
    end
end

return runCart