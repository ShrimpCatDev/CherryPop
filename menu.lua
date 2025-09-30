local menu={}
local items={}
local ind=1
load={}

local function getFileList()
    local names = {}
    local files = love.filesystem.getDirectoryItems("")
    for k,file in ipairs(files) do
        local name = file:match("^(.+)%.chp$")
        if name then
            table.insert(names,tostring(name))
        end
    end
    return names
end

local templateCart=keyWordCode.."\n\n"..keyWordSprite.."\n\n"..keyWordMap.."\n\n"

local makingFile=false
local fileName=""
local message=""

local function refreshFiles()
    items=getFileList()
    --love.filesystem.write("DONTREADME.txt", "this is a temporary file just ignore this")
    table.insert(items,"new cart...")
    table.insert(items,"B surf online")
end

local input2={}

function menu:enter()

    makingFile=false
    fileName=""
    --local isFile = love.filesystem.getInfo("textdemo.chp")
    --[[if not isFile then
        love.filesystem.write("textdemo.chp", demo)
    end]]
    refreshFiles()
    
    
    input2=baton.new {
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
    input2:update()
end

function menu:update()
    --require("lovebird").update()
    input2:update()
    if not makingFile then
        if input2:pressed("down") then
            ind=ind+1
            if ind>#items then ind=1 end
        end
        if input2:pressed("up") then
            ind=ind-1
            if ind<1 then ind=#items end
        end
        if input2:pressed("a") then
            if ind==#items-1 then
                makingFile=true
            elseif ind==#items then
                gs.switch(surfProg)
            else
                loadSheet={}
                mapSheet={}
                readFile(love.filesystem.read(items[ind]..".chp"))
                name=items[ind]
                boot=true

                editor.sprite.boot=true
                editor.code.boot=true
                editor.map.boot=true

                gs.switch(runCart)
            end
        end
    end
end

function menu:draw()
    shove.beginDraw()
    shove.beginLayer("screen")
    --[[for y=0,95 do
        for x=0,127 do
            colr((math.floor((x+y+(love.timer.getTime()*25))/4)%2)+1)
            lg.points(x,y)
        end
    end]]
    if not makingFile then
        colr(2)
        lg.rectangle("fill",0,0,128,96)
        colr(13)
        drawFont("select a cart",1,1)
        for k=1,#items do
            if k==ind then
                colr(13)
                drawFont("A"..items[k],1,(k*font.h)-font.h+9)
            else
                colr(3)
                drawFont(items[k],1,(k*font.h)-font.h+9)
            end
        --lg.print(items[k],8,k*12)
        end
    else
        colr(2)
        lg.rectangle("fill",0,0,128,96)
        colr(13)
        drawFont("input cart name:",1,1)
        drawFont(fileName.."_",1,8)
    end
    drawFont(message,1,89)
    --drawFont("hello world",0,0)
    --drawChar("a",0,0)
    --lg.print(tostring(string.find(font.text,"a")))
    --lg.print(font.text)
    shove.endLayer()
    shove.endDraw()
end

function menu:textinput(k)
    if makingFile and string.len(fileName)<25 then
        fileName=fileName..k
    end
end

name=""



function menu:keypressed(key)
    if not makingFile then
        if key=="escape" and cartLoaded then
            gs.switch(editor.code)
        end
        if key=="f" then
            love.system.setClipboardText(love.filesystem.getSaveDirectory( ))
            local suc= love.system.openURL("file://"..love.filesystem.getSaveDirectory())
            if suc then
                message="opened data directory!"
            else
                message="didn't open data directory"
            end
        end
    else
        if key=="backspace" and string.len(fileName)>0 then
            fileName=string.sub(fileName,1,string.len(fileName)-1)
        end
        if key=="return" then
            if not love.filesystem.getInfo(fileName..".chp") then
                love.filesystem.write(fileName..".chp", templateCart)
                makingFile=false
                fileName=""
                refreshFiles()
                message=""
            else
                message="file already exists"
            end
        end
        if key=="escape" then
            makingFile=false
            fileName=""
            message=""
            refreshFiles()
        end
    end
end

return menu
