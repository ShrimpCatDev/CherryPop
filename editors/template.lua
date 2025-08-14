local template={}

function template:enter()
    mouse=require("editors/mouse")
    bar.init()
end

function template:update()
    mouse.update()
end

function template:draw()
    push:start()
        bar.draw()
        mouse.draw()
    push:finish()
end

function template:mousepressed(x,y,b)
    if b==1 then
        --buttons.pressed()
        bar.press(b)
    end
end

function template:keypressed(k)
    bar.key(k)
end

return template