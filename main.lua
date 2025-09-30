tick=require 'lib.tick'

love.graphics.setDefaultFilter("nearest","nearest")

--push=require("lib/push")
--push:setupScreen(128,96,128*5,96*5,{resizable=true,pixelperfect=true})

shove=require("lib.shove")
shove.setResolution(128,96,{fitMethod="pixel",renderMode="layer"})
shove.setWindowMode(128*6,96*6,{resizable=true})


require("func")
local api=require("api")
paused=false
t=0
gs=require "lib.gamestate"

cart=[[

]]

console = require "lib.console"

function colr(c)
    love.graphics.setColor(palCol(c))
end

function love.textinput(txt)
    --gs.textinput(txt)
end


function love.load(arg)
    love.keyboard.setTextInput(true)
    shove.createLayer("screen")
    tick.framerate=60

    camera={x=0,y=0}
    boot=false

    initFont("assets/font.png",[===[abcdefghijklmnopqrstuvwxyz !CF0123456789.:(){}-+/*,="'_[]RBSH?<>@#$%^&A]===],5,6)
    spriteUndo={}

    love.window.setTitle("CherryPop")
    love.window.setIcon(love.image.newImageData("assets/windowIcon.png"))
    codeLines={}
    love.keyboard.setKeyRepeat(true)
    memCode=[[]]
    buttons=require("buttons")
    bar=require("editors.bar")
    loadSheet={}
    mapSheet={}
    lg.setLineStyle("rough")
    
    local pnt=love.graphics.points
    function lg.point(x,y)
        pnt(math.floor(x)+0.5,math.floor(y)+0.5)
    end
    lg.points=lg.point

    rand=love.math.random
    mem=require("memory")
    mem.init()
    sb=require("sandbox")
    gs.registerEvents()
    runCart=require("runcart")
    menuProg=require("menu")
    --surfProg=require("surf")

    editor={}
    editor.sprite=require("editors.sprite")
    editor.code=require("editors.code")
    editor.map=require("editors.map")
    editor.wip=require("editors.wip")
    editor.error=require("editors.error")

    love.mouse.setVisible(false)
    loadSheet={}
    cartLoaded=false
    codeInit=false
    codeLines={}
    gs.switch(menuProg)
    
end

function love.wheelmoved(x,y)
    gs.wheelmoved(x,y)
end

c=0

local rand=love.math.random
--display memory: 0x0000 to 0x3000
--palette memory: 0xd000 to 0xd030 NEW: 0x3001 to 0x3031
--sprite memory: 0x3032 to 0x7032

function love.update()
    --require("lovebird").update()
end

num=false
ind=0

lg=love.graphics
function love.draw()
    
   
    
end

fullscreen=false
function love.keypressed(k)
    --[[if k=="f11" then
        push:switchFullscreen()
    end]]
end

function love.resize(w, h)
    --return push:resize(w, h)
end

function drawBinary(txt,xx,yy,clr)
    local e=0
    for y=0,7 do
        for x=0,7 do
            e=e+1
            if string.sub(txt,e,e)=="1" then
                colr(clr)
                lg.points(xx+x,yy+y)
            end
            
        end
    end
end
