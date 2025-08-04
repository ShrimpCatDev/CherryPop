local runCart={}

function runCart:enter(p,arg)
    --if not cartLoaded then
    --[[codeLines={}
    local ind=1
    while ind <= string.len(cart) do
        table.insert(codeLines,[====[]====])
        while string.sub(cart,ind,ind)~="\n" do
            codeLines[#codeLines]=codeLines[#codeLines]..string.sub(cart,ind,ind)
            ind=ind+1
        end
        ind=ind+1
    end]]
    print(cart)
    api.setup()
    api.cls()
    sb.initCart(cart)
    print("cart loaded!")
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
            lg.points(x,y)
            
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