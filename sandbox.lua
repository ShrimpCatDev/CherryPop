sb={}

sb.box={

    --system functions
    poke=mem.poke,
    peek=mem.peek,
    _load=function() end,
    _tick=function() end,

    pal=api.palset,

    --drawing
    pset=api.pset,
    pget=api.pget,
    rectfill=api.rectfill,
    rect=api.rect,
    cls=api.cls,
    print=api.print,
    sset=api.sset,
    sget=api.sget,
    sspr=api.sspr,
    spr=api.spr,

    --input
    btn=api.btn,
    btnp=api.btnp,

    --external stuff
    math=math,
    ipairs=ipairs,
    pairs=pairs,
    table=table
}

function sb.initCart(code)
    func, err = loadstring(code)
    setfenv(func,sb.box)
    func()
    if sb.box._load then sb.box._load() end
    ran=true
end

function sb.tickCart()
    if not paused then
    if sb.box._tick then sb.box._tick() end
    t=t+1
    end
end

return sb