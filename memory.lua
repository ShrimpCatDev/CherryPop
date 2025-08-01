local mem={}

function mem.init()
    mem.map={}
    if not cartLoaded then
        --0x1fffe
        for i=0x0000,0xffff do
            table.insert(mem.map,0)
        end
    end
    pal=loadPal("assets/palette1.png")
    defPal=pal
    for i=0,15 do
        mem.poke(0x3001+(i*3)+0,pal[i+1].r)
        mem.poke(0x3001+(i*3)+1,pal[i+1].g)
        mem.poke(0x3001+(i*3)+2,pal[i+1].b)
    end
end

function mem.poke(a,v)
    if not type(a) == "number" then return false end
    if not type(v) == "number" then return false end
    mem.map[a+1]=v%256
    return true
end

function mem.peek(a)
    if not type(a) == "number" then return 0 end
    return mem.map[a+1]
end

function mem.toDisp(x,y)
    xx=math.floor(x)
    yy=math.floor(y)
    --return(yy+(xx*96))
    return(xx+(yy*128))
end

return mem