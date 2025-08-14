local bar={}


function bar.init()
    buttons.reset()
    --13
    --3
    buttons.new(0,0,8,8,"0000000000100100010000100100001001000010010000100010010000000000",3,13,function()
        print("switching to code")
        gs.switch(editor.code)
    end)
    buttons.new(8,0,8,8,"0000000001100110011001100110011001111110010110100111111000000000",3,13,function()
        print("switching to sprite")
        gs.switch(editor.sprite)
    end)
    buttons.new(16,0,8,8,"0000000001110110011101100111000000000110011101100111011000000000",3,13,function()
        print("switching to tilemap")
        gs.switch(editor.map)
    end)
    buttons.new(24,0,8,8,"0000000000000100001000100110101001101010001000100000010000000000",3,13,function()
        print("switching to sfx")
        gs.switch(editor.wip)
    end)
    buttons.new(32,0,8,8,"0000000000001100000010100000100001111000011110000111100000000000",3,13,function()
        print("switching to music")
        gs.switch(editor.wip)
    end)
    buttons.new(120,0,8,8,"0000000001100000011110000111111001111110011110000110000000000000",3,13,function()
        print("running cart")
        runCartCode()
    end)
    buttons.new(112,0,8,8,"0000000000111100011001100000011000001100000000000001100000000000",3,13,function()
        love.system.openURL("https://github.com/ShrimpCatDev/CherryPop")
    end)
    bar.timer=0
end

function bar.draw()
    love.graphics.setColor(palCol(1))
    lg.rectangle("fill",0,0,128,8)
    buttons.draw()
    if bar.timer>0 then
        colr(5)
        lg.rectangle("fill",0,96-8,128,8)
        colr(13)
        drawFont("cart saved!",1,(96-8)+1)
        bar.timer=bar.timer-1
    end
end

function bar.press(btnn)
    if btnn == 1 then
        buttons.pressed()
    end
end

function bar.key(k)
    if love.keyboard.isDown("lctrl") and k=="s" then
        save()
        bar.timer=100
    end
    runCartFromEditor(k)
end

return bar