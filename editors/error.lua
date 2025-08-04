local error={}
local msg=""

function error:enter(prev,err)
    msg="error: line "..string.sub(err,18,string.len(err))
end

function error:draw()
    lg.print(msg,0,0)
    lg.print("press esc to return to editor",0,12)
    lg.print("ERROR HANDLING IS A WIP, SO IT MAY NOT WORK CORRECTLY",0,24)
end

function error:keypressed(k)
    if k=="escape" then
        gs.switch(editor.code)
    end
end

return error