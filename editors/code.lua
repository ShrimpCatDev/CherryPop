local codeEdit = {}


function codeEdit:init()

end

function codeEdit:enter()
    mouse = {x=0, y=0, img=lg.newImage("assets/mouse.png")}
    bar.init()
end

function codeEdit:update()
    require("lovebird").update()
    local x,y = love.mouse.getPosition()
    if x and y then
        local xx,yy = push:toGame(x,y)
        if xx and yy then
            mouse.x,mouse.y = math.floor(xx),math.floor(yy)
        end
    end
end

function codeEdit:draw()
    push:start()
        
        --buttons.draw()
        bar.draw()
        lg.setColor(1,1,1)
        if mouse.x and mouse.y then
            lg.draw(mouse.img,mouse.x,mouse.y)
        end
    push:finish()
end

function codeEdit:mousepressed(x,y,b)
    if b==1 then
        --buttons.pressed()
        bar.press(b)
    end
end

function codeEdit:keypressed(k)

    runCartFromEditor(k)
    if love.keyboard.isDown("lctrl") and k=="s" then
        save()
    end
end

return codeEdit