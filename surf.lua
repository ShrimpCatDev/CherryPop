local menu={}
local items={}
local ind=1
load={}

https=require("https")

local function getWebList()
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

    return names,err
end

local keyWordSprite="#SPRITE"
local keyWordCode="#CODE"
local keyWordMap="#MAP"

local makingFile=false
local fileName=""
local message=""

local function refreshFiles()
    items,er=getWebList()
    if er==0 then
        table.insert(items,"no carts found!")
    end
    table.insert(items,"B back to menu")
end

function menu:enter()
    fileName=""

    refreshFiles()
    
    
    input3=baton.new {
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
    input3:update()
end

function menu:update()
    --require("lovebird").update()
    input3:update()
    if not makingFile then
        if input3:pressed("down") then
            ind=ind+1
            if ind>#items then ind=1 end
        end
        if input3:pressed("up") then
            ind=ind-1
            if ind<1 then ind=#items end
        end
        if input3:pressed("a") then
            if ind==#items then
                gs.switch(menuProg)
            elseif items[ind]~="no carts found!" then
                loadSheet={}
                mapSheet={}

                local err,body=https.request("https://raw.githubusercontent.com/ShrimpCatDev/cherrypop-db/refs/heads/main/carts/"..items[ind]..".chp")
                readFile(body)
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
    drawFont(message,1,89)

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
