local menu={}
local items={}
local ind=1
load={}

local noIcon="88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888d88d88dd8888ddd88dd88dd88d88d88888dd8d9d89d8888d99d899d89d8dd8d98888d9dd9d98d9888d98d988d98d9d9dd98888d98d98dd8988ddd88dd88dd89d98d988888988988998888999889988998898898888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
local function getFileList()
    local names = {}
    local icons={}
    local files = love.filesystem.getDirectoryItems("")
    for k,file in ipairs(files) do
        local name = file:match("^(.+)%.chp$")
        if name then
            table.insert(names,tostring(name))

            local c=love.filesystem.read(file)
            local loc=string.find(c,keyWordIcon)
            if loc then
                local str=string.sub(c,loc+string.len(keyWordIcon)+1,string.len(c))
                table.insert(icons,str)
            else
                table.insert(icons,noIcon)
            end
        end
    end
    return names,icons
end

local templateCart=keyWordCode.."\n\n"..keyWordSprite.."\n\n"..keyWordMap.."\n\n"

local makingFile=false
local fileName=""
local message=""

local function refreshFiles()
    items,icons=getFileList()
    --love.filesystem.write("DONTREADME.txt", "this is a temporary file just ignore this")
    table.insert(items,"new cart...")
    table.insert(icons,"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbeeeeeeecbbbbbbbbbbbbbbbbbbbbbbbbbedddddddecbbbbbbbbbbbbbbbbbbbbbbbbedddddddeccbbbbbbbbbbbbbbbbbbbbbbbedddddddecccbbbbbbbbbbbbbbbbbbbbbbedddddddeccccbbbbbbbbbbbbbbbbbbbbbedddddddecccccbbbbbbbbbbbbbbbeeeeeedddddddeeeeeecbbbbbbbbbbbbbedddddddddddddddddddecbbbbbbbbbbbbedddddddddddddddddddeccbbbbbbbbbbbedddddddddddddddddddecccbbbbbbbbbbedddddddddddddddddddeccccbbbbbbbbbedddddddddddddddddddecccccbbbbbbbbedddddddddddddddddddeccccccbbbbbbbedddddddddddddddddddecccccccbbbbbbfeeeeeedddddddeeeeeefcccccccbbbbbbfeeeeeedddddddeeeeeefcccccccbbbbbbcfffffedddddddefffffccccccccbbbbbbbcccccedddddddecccccccccccccbbbbbbbbccccedddddddecccccccccccccbbbbbbbbbcccedddddddecccccccccccccbbbbbbbbbbccfeeeeeeefcccccccccccccbbbbbbbbbbbcfeeeeeeefcccccccccccccbbbbbbbbbbbbcfffffffccccccccccccccbbbbbbbbbbbbbcccccccccccccccccccccbbbbbbbbbbbbbbccccccccccccccccccccbbbbbbbbbbbbbbbcccccccccccccccccccbbbbbbbbbbbbbbbbccccccccccccccccccbbbbbbbbbbbbbbbbbcccccccccccccccccbbbbbbbbbbbbbbbbbbcccccccccccccccc")
    table.insert(items,"B surf online")
    table.insert(icons,"000000000000000000000000000000000000000000000e0000000000e000000000e0000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002222222200000000000000000000000022333333332200000000000000000e0002333333333333100000d000000000000025535533333333210000000000000000025555555355333332100000000000000025565555555533333221000000000000025565555555533335332210000000000002555555555553335553221000e00000002556555555553333555322210000000000255555555553333333532221000000000025335555555333333333222100000000002333555555333333333322210000000000233555555333333333332221000000000023355555533333333353222100000000002335555555333335355442210000000000233333555533333355544421000000e000023333355553333355444210000000000002333335553333355444421000000000000023333355333333444421000000000000000123333333333244221000000000000000001223333332224221000000e000000000000122222222242210000000000000000d00001122222222110000000000000000000000001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000e00000d00000000000000e000000000000000000000000000000000000000000000000000000000")
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
    self.t=0
    self.ox=0
end

function menu:update()
    self.t=self.t+1
    --require("lovebird").update()
    input2:update()
    if not makingFile then
        if input2:pressed("right") then
            ind=ind+1
            if ind>#items then ind=1 end
        end
        if input2:pressed("left") then
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
        self.ox=lerp(self.ox,(ind-1)*(36+16),0.2)
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
        colr(3)
        lg.rectangle("fill",0,0,128,96)
        colr(2)
        local t=math.floor(self.ox*0.5)
        for x=-2-t,(128/8)+t do
            for y=-2-t,(96/8)+t do
                if (x+y)%2==0 then
                    local a=(self.t/6)%16
                    lg.rectangle("fill",x*8+a-math.floor(self.ox*0.5),y*8+a,8,8)
                end
            end
        end
        colr(1)
        lg.rectangle("fill",0,0,128,7)
        lg.rectangle("fill",0,96-8,128,8)
        colr(13)
        drawFont("game select",1,1)

        local sw,sh=128/2,96/2
        for k=1,#items do
            local w,h=36,48
            
            local x,y=sw-w/2+((k-1)*(w+16))-math.floor(self.ox),sh-h/2-7
            colr(13)

            local o=4
            if k==ind then
               o=0 
            end
            --lg.rectangle("fill",x+1,y+7,34,34)
            hexImg(icons[k],x+1,y+7+o,34,34,-1)
            hexImg(cartImg,x,y+o,w,h,1)
        end

        local w=string.len(items[ind])*5/2

        colr(0)
        drawFont(items[ind],sw-w+1,73)
        colr(13)
        drawFont(items[ind],sw-w,72)
        
        --[[for k=1,#items do
            if k==ind then
                colr(13)
                drawFont("A"..items[k],1,(k*font.h)-font.h+9)
            else
                colr(1)
                drawFont(items[k],1,(k*font.h)-font.h+9)
            end
        --lg.print(items[k],8,k*12)
        end]]
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
