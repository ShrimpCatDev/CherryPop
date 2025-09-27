menu={}
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

--[[function load.readFile(path)
    contents, size=love.filesystem.read(path..".chp")
    cart=contents
end]]

local keyWordSprite="#SPRITE"
local keyWordCode="#CODE"
local keyWordMap="#MAP"

function load.readFile(path)
    local contents = love.filesystem.read(path..".chp")
    local codeLoc=string.find(contents,keyWordCode)
    local spriteLoc=string.find(contents,keyWordSprite)
    local mapLoc=string.find(contents,keyWordMap)
    --love.filesystem.write("output.txt", tostring(mapLoc))


    if codeLoc then 
        cart=string.sub(contents,codeLoc+string.len(keyWordCode)+1,spriteLoc-1)
    else
        cart=""
    end

    local sprString=string.sub(contents,spriteLoc+string.len(keyWordSprite)+1,(mapLoc or (string.len(contents)+1))-1)
    print(sprString)
    if spriteLoc and string.len(sprString)>16383 then
        for i=1,string.len(sprString) do
            local char="0x"..string.sub(sprString,i,i)
            local charNum=tonumber(char)
            table.insert(loadSheet,charNum)
        end
    else
        for i=1,16384 do
            table.insert(loadSheet,0)
        end
    end

    if mapLoc then 
        local mapString=string.sub(contents,mapLoc+string.len(keyWordMap)+1,string.len(contents))
        if string.len(mapString)>((128*96)*2)-1 then
            for i=1,string.len(mapString)/2 do
                local char="0x"..string.sub(mapString,((i-1)*2)+1,((i-1)*2)+2)
                local charNum=tonumber(char)
                table.insert(mapSheet,charNum)
            end
        else
            for i=1,(128*96)*2 do
                table.insert(mapSheet,0)
            end
        end
    end
end

function load.readCode(path)
    local contents = love.filesystem.read(path..".chp")
    sections = {}
    local current = ""
    local currentSection = ""
    
    -- Parse file into sections
    for line in contents:gmatch("[^\r\n]+") do
        if line:match("^#%w*") then
            -- Found section marker
            if currentSection ~= "" then
                sections[currentSection] = current
                current = ""
            end
            currentSection = line:match("^#(%w*)")
        else
            current = current .. line .. "\n"
        end
    end
    -- Add final section
    if currentSection ~= "" then
        sections[currentSection] = current
    end
    
    -- Load code section
    return sections.CODE or ""
    
    -- Add similar loading for MAP and SFX sections
end


local makingFile=false
local fileName=""
local message=""

local function refreshFiles()
    items=getFileList()
    --love.filesystem.write("DONTREADME.txt", "this is a temporary file just ignore this")
    table.insert(items,"new cart...")
end

function menu:enter()

    makingFile=false
    fileName=""
    local isFile = love.filesystem.getInfo("textdemo.chp")
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
            if ind==#items then
                makingFile=true
            else
                loadSheet={}
                mapSheet={}
                load.readFile(items[ind])
                name=items[ind]
                spriteUndo={}
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
    push:start()
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
    push:finish()
end

function menu:textinput(k)
    if makingFile and string.len(fileName)<25 then
        fileName=fileName..k
    end
end

name=""

local templateCart=[[
#CART

#SPRITE

#MAP
]]

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
