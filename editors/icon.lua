local icon={}

function icon:enter()
    mouse=require("editors.mouse")
    bar.init()
end

function icon:update()
    mouse.update()
end

function icon:draw()
    shove.beginDraw()
    shove.beginLayer("screen")
        colr(2)
        lg.rectangle("fill",0,0,128,96)
        bar.draw()
        mouse.draw()
    shove.endLayer()
    shove.endDraw()
end

function icon:mousepressed(x,y,b)
    if b==1 then
        --buttons.pressed()
        bar.press(b)
    end
end

function icon:keypressed(k)
    bar.key(k)
end

return icon