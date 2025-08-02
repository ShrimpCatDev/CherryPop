local buttons={btns={}}

local function colr(c)
    love.graphics.setColor(palCol(c))
end

local function pointCol(px, py, bx, by, bw, bh)
    return px >= bx and px < bx + bw and py >= by and py < by + bh
end

function buttons.reset()
    buttons.btns={}
end

function buttons.new(x,y,w,h,imgData,color,colorSel,func)
    table.insert(buttons.btns,{x=x,y=y,w=w,h=h,img=imgData,color=color,colorSel=colorSel,func=func})
end

function buttons.pressed()
    for i, bn in pairs(buttons.btns) do
        if pointCol(mouse.x,mouse.y, bn.x, bn.y, bn.w, bn.h) then
            bn.func()
        end
    end
end

function buttons.draw()
    for i, b in pairs(buttons.btns) do
        local e=0
        for y=0,7 do
            for x=0,7 do
                e=e+1
                if string.sub(b.img,e,e)=="1" then
                    if pointCol(mouse.x,mouse.y, b.x, b.y, b.w, b.h) then
                        colr(b.colorSel)
                        
                    else
                        colr(b.color)
                    end
                    lg.points(b.x+x,b.y+y)
                end
                
            end
        end
    end
end

return buttons