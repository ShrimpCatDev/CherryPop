local codeEdit = {}
local scroll={}


function codeEdit:init()

end

function codeEdit:enter()
    scroll={x=0,y=0}
    mouse = {x=0, y=0, img=lg.newImage("assets/mouse.png")}
    bar.init()
    --if codeInit then
        codeLines={}
        local ind=1
        while ind <= string.len(cart) do
            table.insert(codeLines,[====[]====])
            while string.sub(cart,ind,ind)~="\n" do
                codeLines[#codeLines]=codeLines[#codeLines]..string.sub(cart,ind,ind)
                ind=ind+1
            end
            ind=ind+1
        end
        if not codeLines[1] then
            codeLines[1]=""
        end
    --end
    selection={x=0,y=0}
end

function codeEdit:leave()
    cart=[[]]
    for k,v in ipairs(codeLines) do
        cart=cart..v.."\n"
    end
end

function codeEdit:update()
    require("lovebird").update()
    local x,y = love.mouse.getPosition()
    if x and y then
        local xx,yy = push:toGame(x,y)
        if xx and yy then
            mouse.x,mouse.y = math.floor(xx),math.floor(yy)
        end
    end
end

function codeEdit:draw()
    push:start()

    love.graphics.setColor(palCol(0))
    lg.rectangle("fill",0,0,128,96)
        
        --buttons.draw()
        lg.setColor(1,1,1)
        local lineBreak=0
        local ii=0
        local otherEnd=[[]]
        ofs=0

        colr(6)
        lg.rectangle("fill",(selection.x*7)+(scroll.x*7)+1,(selection.y*8)+9+(scroll.y*8),7,8)

        local color=13

        for i,v in ipairs(codeLines) do
            colr(color)
            drawFont(v,(scroll.x*7)+1,(i*8)+(scroll.y*8)+1)
            --drawChar(string.sub(cart,i,i),(ii*7)+1,9+(lineBreak*8)+(scroll.y*8))
        end

        bar.draw()
        lg.setColor(1,1,1)
        if mouse.x and mouse.y then
            lg.draw(mouse.img,mouse.x,mouse.y)
        end
        
    push:finish()
    --lg.print("length: "..#codeLines,0,0)
    --lg.print("selection X: "..selection.x.." Y:"..selection.y,0,12)
end

function codeEdit:mousepressed(x, y, b)
    if b == 1 then
        if mouse.y < 8 then
            bar.press(b)
        else
            local smx = math.floor(mouse.x / 7)
            local smy = math.floor(mouse.y / 8)

            local lineIndex = smy - 1 - scroll.y
            lineIndex = math.max(0, math.min(#codeLines - 1, lineIndex)) -- clamp to valid range

            selection.y = lineIndex

            local line = codeLines[selection.y + 1] or ""
            selection.x = math.min(#line, smx - scroll.x)
        end
    end
end


function codeEdit:wheelmoved(x,y)
    if y>0 and scroll.y<0 then
        scroll.y=scroll.y+1
    elseif y<0  then
        scroll.y=scroll.y-1
    end

end

local function removeCharAt(str, index)
    return str:sub(1, index - 1) .. str:sub(index + 1)
end

function codeEdit:keypressed(k)
    runCartFromEditor(k)

    if love.keyboard.isDown("lctrl") and k=="s" then
        save()
    end

    if k=="backspace" and selection.x>=0 then
        if string.len(codeLines[selection.y+1])==0 and #codeLines~=1 then
            table.remove(codeLines,selection.y+1)
            if selection.y>0 then selection.y=selection.y-1 end
            selection.x=#codeLines[selection.y+1]
        elseif selection.x>0 then
            codeLines[selection.y+1]=removeCharAt(codeLines[selection.y+1],selection.x)
            selection.x=selection.x-1
        end
        
    end
    if k=="return" then
        local text=string.sub(codeLines[selection.y+1],selection.x+1,#codeLines[selection.y+1])
        print(text)
        codeLines[selection.y+1]=string.sub(codeLines[selection.y+1],1,selection.x)
        table.insert(codeLines,selection.y+2,text)
        selection.y=selection.y+1
        selection.x=0
    end

    if k=="down" and selection.y+1 < #codeLines then
        selection.y=selection.y+1
        if #codeLines[selection.y+1]<selection.x then
            selection.x=#codeLines[selection.y+1]
        end
        
    end
    if k=="up" then
        if selection.y>0 then
            selection.y=selection.y-1
        end
        if selection.x>#codeLines[selection.y+1] then
            selection.x=(#codeLines[selection.y+1])
        end
        
    end
    if k=="right" then
        selection.x=selection.x+1
        if selection.x+1 > #codeLines[selection.y+1]+1 then
            if selection.y+2<= #codeLines then
                selection.y=selection.y+1
                selection.x=0
            else
                selection.x=selection.x-1
            end
        end
        
    end
    if k=="left" then
        selection.x=selection.x-1
        if selection.y==0 and selection.x<0 then
            selection.x=0
        end
        if selection.x<0 and selection.y>0 then
            selection.y=selection.y-1
            selection.x=#codeLines[selection.y+1]
        end
        
    end
    --down
    if scroll.y>-(selection.y-10) then
        scroll.y=-(selection.y-10)
    end
    --up
    if scroll.y<-selection.y then
        scroll.y=-(selection.y)
    end
    --right
    if scroll.x<selection.x-16 then
        scroll.x=-(selection.x-16)
    end
    --left
    if scroll.x<-selection.x then
        scroll.x=-(selection.x)
    end
    scroll.x=math.min(scroll.x,0)
end


function insertCharAt(str, index, char)
    return str:sub(1, index) .. char .. str:sub(index+1)
end

function codeEdit:textinput(k)
    codeLines[selection.y+1]=insertCharAt(codeLines[selection.y+1],selection.x,k)
    selection.x=selection.x+1
    print(k)
    print(codeLines[selection.y+1])
end

return codeEdit