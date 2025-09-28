local wip = {}
local t=0

function wip:init()

end

function wip:enter()
    mouse=require("editors.mouse") --define mouse
    bar.init()
    t=0
end

function wip:update()
    --require("lovebird").update()
    mouse.update()
    t=t+1
end

function wip:draw()
    shove.beginDraw()
    shove.beginLayer("screen")
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
        mouse.draw()
        
        shove.endLayer()
        shove.endDraw()
end

function wip:mousepressed(x,y,b)
    if b==1 then
        --buttons.pressed()
        bar.press(b)
    end
end

function wip:keypressed(k)
    bar.key(k)
end

return wip