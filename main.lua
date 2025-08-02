love.graphics.setDefaultFilter("nearest","nearest")
push=require("lib/push")
push:setupScreen(128,96,128*5,96*5,{resizable=true})

require("func")
local api=require("api")
paused=false
t=0
gs=require "lib/gamestate"

cart=[[

]]

console = require "lib/console"

function colr(c)
    love.graphics.setColor(palCol(c))
end

function love.load()
    buttons=require("buttons")
    bar=require("editors/bar")
    loadSheet={}
    lg.setLineStyle("rough")
    rand=love.math.random
    mem=require("memory")
    mem.init()
    sb=require("sandbox")
    gs.registerEvents()
    runCart=require("runcart")
    menuProg=require("menu")

    editor={}
    editor.sprite=require("editors/sprite")
    editor.code=require("editors/code")
    editor.wip=require("editors/wip")

    love.mouse.setVisible(false)
    loadSheet={}
    cartLoaded=false
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
    require("lovebird").update()
end

num=false
ind=0

lg=love.graphics
function love.draw()
    
   
    
end

function love.resize(w, h)
    return push:resize(w, h)
end
