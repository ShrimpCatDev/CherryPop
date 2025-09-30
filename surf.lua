menu={}
local items={}
local ind=1
load={}

https=require("https")

local function getFileList()
    local names = {}
    err,body=https.request("https://raw.githubusercontent.com/ShrimpCatDev/cherrypop-db/refs/heads/main/db")
    
    print(err)
    print(body)
    local ind=1
    local newLine=0

    while ind <= string.len(body) do
        local curr=string.sub(body,ind,ind)

        newLine=newLine+1
        table.insert(names,"")
        while string.sub(body,ind,ind)~="\n" do
            names[#names]=names[#names]..string.sub(body,ind,ind)
            ind=ind+1
        end

        ind=ind+1
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
    local err,body=https.request("https://raw.githubusercontent.com/ShrimpCatDev/cherrypop-db/refs/heads/main/carts/"..path..".chp")
    local contents = body
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
    --print(sprString)
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


local makingFile=false
local fileName=""
local message=""

local function refreshFiles()
    items=getFileList()
    --love.filesystem.write("DONTREADME.txt", "this is a temporary file just ignore this")
    --table.insert(items,"new cart...")
end

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
            --if ind==#items then
                --makingFile=true
            --else
                loadSheet={}
                mapSheet={}
                load.readFile(items[ind])
                name=items[ind]
                boot=true

                editor.sprite.boot=true
                editor.code.boot=true
                editor.map.boot=true

                gs.switch(runCart)
            --end
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
        colr(1)
        lg.rectangle("fill",0,0,128,96)
        colr(13)
        drawFont("S cartverse S",1,1)
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

name=""

local templateCart=[[
#CART

#SPRITE

#MAP
]]

function menu:keypressed(key)
    if key=="escape" and cartLoaded then
        gs.switch(editor.code)
    end
end

return menu
