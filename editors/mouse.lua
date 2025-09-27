local ms={x=0,y=0,img=lg.newImage("assets/mouse.png")} --define mouse}

function ms.update()
    local x,y=love.mouse.getPosition() --get the mouse position XD
    if x and y then --make sure x and y arent nil
        local xx,yy=push:toGame(x,y) --convert screen coords to pixel coords using push
        if xx and yy then --check if xx and yy are nil
            ms.x,ms.y=math.floor(xx),math.floor(yy) --set the mouse position
        end
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