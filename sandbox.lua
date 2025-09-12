sb={}

sb.box={

    --system functions
    poke=mem.poke,
    peek=mem.peek,
    _load=function() end,
    _tick=function() end,

    pal=api.palset,
    color=api.color,

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
    mget=api.mget,
    mset=api.mset,
    map=api.map,
    camera=api.camera,
    circ=api.circ,
    circfill=api.circfill,

    --input
    btn=api.btn,
    btnp=api.btnp,

    --external stuff
    math=math,
    ipairs=ipairs,
    pairs=pairs,
    table=table,
    string=string
}

--[[function sb.initCart(code)
    func, err = loadstring(code)
    setfenv(func,sb.box)
    
    func()
    if sb.box._load then sb.box._load() end
    ran=true
end]]

function yeetError(err)
    gs.switch(editor.error,err)
end

function sb.initCart(code)
    camera={x=0,y=0}
    sb.box._load=nil
    sb.box._tick=nil
    func, err = loadstring(code)

    if not func then
        gs.switch(editor.error,err)
        return
    end

    setfenv(func,sb.box)

    xpcall(func,yeetError)

    if sb.box._load then xpcall(sb.box._load,yeetError)  end
    ran=true
    paused=false
end


function sb.tickCart()
    if not paused then
        if sb.box._tick then xpcall(sb.box._tick,yeetError)  end
        t=t+1
    end
end

return sb