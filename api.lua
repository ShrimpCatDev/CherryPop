api={}
baton=require "lib/baton"



function api.setup()
    input=baton.new {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            a={'key:z', "button:a"},
            b={'key:x', "button:b"},
            c={'key:c', "button:y"},
            pause={'key:return','button:start'},
            exit={'button:x'}
          },
          joystick = love.joystick.getJoysticks()[1],

    }
    api.inputDown={
        input:down('up'),
        input:down('down'),
        input:down('left'),
        input:down('right'),
        input:down('a'),
        input:down('b'),
        input:down('c')
    }
    
    api.inputPressed={
        input:pressed('up'),
        input:pressed('down'),
        input:pressed('left'),
        input:pressed('right'),
        input:pressed('a'),
        input:pressed('b'),
        input:pressed('c')
    }
end

function api.updateInput()
    input:update()
    api.inputDown={
        input:down('up'),
        input:down('down'),
        input:down('left'),
        input:down('right'),
        input:down('a'),
        input:down('b'),
        input:down('c')
    }
    
    api.inputPressed={
        input:pressed('up'),
        input:pressed('down'),
        input:pressed('left'),
        input:pressed('right'),
        input:pressed('a'),
        input:pressed('b'),
        input:pressed('c')
    }
end

function api.btn(num)
    if num<=6 and num>=0 then
        return api.inputDown[num+1]
    else
        return false
    end
end

function api.btnp(num)
    if num<=6 and num>=0 then
        return api.inputPressed[num+1]
    else
        return false
    end
end

function api.pset(x,y,c)
    if x>=0 and x<=127 and y>=0 and y<=95 then
        if c then
            mem.poke(mem.toDisp(x,y),c)
        end
    end
end

function api.pget(x,y)
    if x>=0 and x<=127 and y>=0 and y<=95 then
        return mem.peek(mem.toDisp(x,y))
    else
        return 0
    end
end

function api.rectfill(x,y,w,h,c)
    for i=x,x+w do
        for j=y,y+h do
            api.pset(i,j,c)
        end
    end
end

function api.rect(x,y,w,h,c)
    for i=x,x+w do
        api.pset(i,y,c)
        api.pset(i,y+h,c)
    end
    for j=y,y+h do
        api.pset(x,j,c)
        api.pset(x+w,j,c)
    end
end


function api.cls(c)
    local cc=c or 0
    for x=0,127 do
        for y=0,95 do
            api.pset(x,y,cc)
        end
    end
end

local function Color(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, value or 1}
end

--palette memory: 0xd000 to 0xd030 NEW: 0x3001 to 0x3031
function api.palset(c,r,g,b)
        mem.poke(0x3001+(c%16*3)+0,r)
        mem.poke(0x3001+(c%16*3)+1,g)
        mem.poke(0x3001+(c%16*3)+2,b)
end

function api.palget(c)
    return mem.peek(0x3001+(c*3)+0),mem.peek(0x3001+(c*3)+1),mem.peek(0x3001+(c*3)+2)
end

function api.printc(letter,x,y,color)
    local indx=string.find(font.text,letter)
    if indx then
        local i=1
        for y1=0,font.h-1 do
            for x1=0,font.w-1 do
                if getChar(font.chars[indx], i)=="1" then
                    --love.graphics.points(x1+x,y1+y)
                    api.pset(x1+x,y1+y,color)
                end
               i=i+1
            end
        end
    end
end

function api.print(text,x,y,c)
    for i=0,string.len(text)-1 do
        api.printc(getChar(text,i+1),i*font.w+x,y,c)
    end
end

--sprite memory: 0x3032 to 0x7032

function api.sget(x,y)
    if x>=0 and x<=127 and y>=0 and y<=127 then
        return mem.peek(0x3032+(y*128)+x)
    else
        return 0
    end
end

function api.sset(x,y,c)
    if x>=0 and x<=127 and y>=0 and y<=127 then
        mem.poke(0x3032+(y*128)+x, c%16)
    end
end

function api.sspr(sx,sy,sw,sh,x,y,tc)
    for y1=0,sh-1 do
        for x1=0,sw-1 do
            if api.sget(x1+sx,y1+sy)~=tc then
                api.pset(x1+x,y1+y,api.sget(x1+sx,y1+sy))
            end
        end
    end
end

function api.spr(index,x,y,tc,w,h)
    ww=w or 1
    hh=h or 1
    local sx=math.floor(index%16)*8
    local sy=math.floor(index/16)*8
    api.sspr(sx,sy,ww*8,hh*8,x,y,tc)
end

return api