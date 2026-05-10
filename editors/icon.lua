local icon={}

local function col(ax,ay,bx,by,aw,ah,bw,bh)
    return ax<bx+bw and bx<ax and ay<by+bh and by<ay
end

local function click(mouse,obj)
    return col(mouse.x,mouse.y,obj.x,obj.y,1,1,obj.w,obj.h)
end

function icon:enter()
    mouse=require("editors.mouse")
    bar.init()
    colorSelect={
        len=16,
        sel=0,
        scale=6,
        x=64-(16*6*0.5),
        y=80,
        
    }
    colorSelect.w=colorSelect.len*colorSelect.scale
    colorSelect.h=colorSelect.scale
    colorSelect.update=function(mouse)
        local s=colorSelect
        if click(mouse,s) then
            local mx,my=mouse.x-s.x,mouse.y-s.y
            colorSelect.sel=math.floor(mx/s.scale)
        end
    end
end

function icon:update()
    mouse.update()
    if mouse.x and mouse.y then
        if love.mouse.isDown(1) then
            colorSelect.update(mouse)
        end
    end
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

        local len=16
        for i=0,len-1 do
           colr(i) 
           local s=6
           lg.rectangle("fill",i*s+colorSelect.x,colorSelect.y,s,s)
        end

        colr(colorSelect.sel)
        lg.rectangle("fill",16,16,8,8)

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