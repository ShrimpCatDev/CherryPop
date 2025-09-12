local error={}
local msg=""
local tt=0

local msgs={
    "it will be okay H",
    "you can do it!",
    "just a minor setback!",
    "take a deep breath",
    "keep moving forward!",
    "ill be here for you F",
    "make sure to take a break"
}
local msgIndex=1

function error:enter(prev,err)
    msg="error: "..tostring(err)
    msgIndex=love.math.random(1,#msgs)
    tt=0
end

function error:draw()
    t=t+1
    --[[lg.print(msg,0,0)
    lg.print("press esc to return to editor",0,12)
    lg.print("ERROR HANDLING IS A WIP, SO IT MAY NOT WORK CORRECTLY",0,24)]]
    push:start()
    love.graphics.setColor(palCol(2))
    lg.rectangle("fill",0,0,128,96)
    colr(13)
    for i=1,#msg do
        drawChar(string.sub(msg,i,i),(((i)%24)*5)+1,1+math.floor(i/24)*6)
    end
    colr(3)
    drawFont(msgs[msgIndex],1,96-7)
    push:finish()
end

function error:keypressed(k)
    if k=="escape" then
        gs.switch(editor.code)
    end
end

return error