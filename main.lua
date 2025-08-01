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

function love.load()
    loadSheet={}
    lg.setLineStyle("rough")
    rand=love.math.random
    mem=require("memory")
    mem.init()
    sb=require("sandbox")
    gs.registerEvents()
    runCart=require("runcart")
    menuProg=require("menu")
    editor={sprite=require("editors/sprite")}
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
    
end

num=false
ind=0

lg=love.graphics
function love.draw()
    
   
    
end

function love.resize(w, h)
    return push:resize(w, h)
end

function love.keypressed(k)
    --[[if k=="right" then
        num=true
    end
    if k=="up" then
        api.palset(ind,255,255,255)
        ind=ind+1
        
    end
    if k=="down" then
        for j=0,95 do
            for i=0,127 do
                api.pset(i,j,i%16)
            end
        end
    end
    if k=="left" then
        num=false
        for i=0,9 do
            api.rectfill(rand(0,127),rand(0,95),rand(0,127),rand(0,95),rand(1,15))
        end
    end]]
end