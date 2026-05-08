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

        local sw,sh=64,96/2
        local w,h=36,48
        local x,y=sw-w/2,sh-h/2-7
        hexImg(cartImg,x,y,w,h,1)

        for i=0,15 do
           colr(i) 
           local s=6
           lg.rectangle("fill",i*s,80,s,s)
        end

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