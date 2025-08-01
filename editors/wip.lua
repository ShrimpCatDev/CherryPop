local wip = {}
local t=0

function wip:init()

end

function wip:enter()
    mouse = {x=0, y=0, img=lg.newImage("assets/mouse.png")}
    bar.init()
    t=0
end

function wip:update()
    require("lovebird").update()
    local x,y = love.mouse.getPosition()
    if x and y then
        local xx,yy = push:toGame(x,y)
        if xx and yy then
            mouse.x,mouse.y = math.floor(xx),math.floor(yy)
        end
    end
    t=t+1
end

function wip:draw()
    push:start()
        --[[love.graphics.setColor(palCol(2))
        lg.rectangle("fill",0,0,128,96)]]

        local str="work in progress"
        for i=0,string.len(str) do
            colr((i+math.floor(t/5)+1)%16)
            drawFont(string.sub(str,i,i),(i*7)+2,math.cos(love.timer.getTime()*10+i)*3+((96/2)-4)+1)
            colr((i+math.floor(t/5))%16)
            drawFont(string.sub(str,i,i),(i*7)+2,math.cos(love.timer.getTime()*10+i)*3+((96/2)-4))
        end
        
        bar.draw()
        lg.setColor(1,1,1)
        if mouse.x and mouse.y then
            lg.draw(mouse.img,mouse.x,mouse.y)
        end
        
    push:finish()
end

function wip:mousepressed(x,y,b)
    if b==1 then
        --buttons.pressed()
        bar.press(b)
    end
end

function wip:keypressed(k)

    runCartFromEditor(k)
    if love.keyboard.isDown("lctrl") and k=="s" then
        save()
    end
end

return wip