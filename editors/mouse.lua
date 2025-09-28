local ms={x=0,y=0,img=lg.newImage("assets/mouse.png")} --define mouse}

function ms.update()
    local inv,x,y=shove.screenToViewport(love.mouse.getPosition())
    if inv then --make sure x and y arent nil
        ms.x,ms.y=math.floor(x),math.floor(y) --set the mouse position
    end
end

function ms.draw()
    lg.setColor(1,1,1)
    if mouse.x and mouse.y then
        --lg.draw(mouse.img,mouse.x,mouse.y)
        drawBinary("0000000001000000011000000111000001111000011000000001000000000000",mouse.x,mouse.y,13)
        drawBinary("0100000010100000100100001000100010000100100110000110100000000000",mouse.x,mouse.y,0)
    end
end

return ms