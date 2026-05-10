local icon={}

local function col(ax,ay,bx,by,aw,ah,bw,bh)
    return ax<bx+bw and bx<ax and ay<by+bh and by<ay
end

local function click(mouse,obj)
    return col(mouse.x,mouse.y,obj.x,obj.y,1,1,obj.w,obj.h)
end

local function genArray(w,h,def)
    local t={}
    for y=1,h do
        t[y]={}
        for x=1,w do
            t[y][x]=def
        end
    end
    return t
end

function icon:enter()
    self.canvas=genArray(34,34,0)
    self.canvas[1][1]=8
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

    local sw,sh=64,96/2
    local w,h=36,48
    local x,y=sw-w/2,sh-h/2-7
    iconEdit={
        x=x+1,
        y=y+7,
        w=34,h=34,
        brush={
            scale=8
        }
    }
    local pix=function(x,y,c)
        self.canvas[math.min(x,34)][math.min(y,34)]=c
    end
    iconEdit.update=function(mouse)
        local s=iconEdit
        
        if click(mouse,iconEdit) then
            local mx,my=mouse.x-s.x,mouse.y-s.y
            for x=0,s.brush.scale-1 do
                for y=0,s.brush.scale-1 do
                    pix(my+y,mx+x,colorSelect.sel)
                end
            end
        end
    end
end

function icon:update()
    mouse.update()
    if mouse.x and mouse.y then
        if love.mouse.isDown(1) then
            colorSelect.update(mouse)
            iconEdit.update(mouse)
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

        for i,y in ipairs(self.canvas) do
            for j,x in ipairs(y) do
                colr(x)
                lg.points(j-1+iconEdit.x,i-1+iconEdit.y)
            end
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