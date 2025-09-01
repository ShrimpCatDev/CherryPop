local codeEdit = {}
local scroll={}


function codeEdit:init()

end

function mysplit(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]*)") do
      table.insert(t, str)
    end
    return t
end
local codeSelection={x=0,y=0,active=false}

function codeEdit:enter()
    print("CODE:")
    print(cart)
    scroll={x=0,y=0}
    mouse=require("editors/mouse") --define mouse
    bar.init()
    --if codeInit then
        codeLines={}--mysplit(cart, "\n")
        --[[print("TABLE:")
        for k,v in ipairs(codeLines) do
            print(v)
        end]]

        local ind=1
        local newLine=0
        while ind <= string.len(cart) do
            local curr=string.sub(cart,ind,ind)

            newLine=newLine+1
            table.insert(codeLines,"")
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
    selection={x=0,y=0,endX=0,endY=0,color=6}
end

function codeEdit:leave()
    cart=[[]]
    for k,v in ipairs(codeLines) do
        cart=cart..v.."\n"
    end
end

function codeEdit:update()
    --require("lovebird").update()
    mouse.update()
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
        lg.rectangle("fill",(selection.x*font.w)+(scroll.x*font.w)+1,(selection.y*font.h)+(scroll.y*font.h)+9,font.w,font.h)

        local color=13

        for i,v in ipairs(codeLines) do
            colr(color)
            drawFont(v,(scroll.x*font.w)+1,(i*font.h)+(scroll.y*font.h)+3)
            --drawChar(string.sub(cart,i,i),(ii*7)+1,9+(lineBreak*8)+(scroll.y*8))
        end

        bar.draw()
        mouse.draw()
        
    push:finish()
    --lg.print(scroll.x,0,0)
    --lg.print("selection X: "..selection.x.." Y:"..selection.y,0,12)
end

function codeEdit:mousepressed(x, y, b)
    if b == 1 then
        if mouse.y < 8 then
            bar.press(b)
        elseif mouse.x>=1 then
            local smx = math.floor((mouse.x-1) / font.w)
            local smy = math.floor((mouse.y-(font.h/2)) / font.h)

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

    bar.key(k)

    if k=="backspace" then
        if selection.x>=0 then
            if string.len(codeLines[selection.y+1])==0 and #codeLines~=1 then
                table.remove(codeLines,selection.y+1)
                if selection.y>0 then selection.y=selection.y-1 end
                selection.x=#codeLines[selection.y+1]
            elseif selection.x>0 then
                codeLines[selection.y+1]=removeCharAt(codeLines[selection.y+1],selection.x)
                selection.x=selection.x-1
            end
        end
        if selection.y>0 and selection.x==0 then
            local prev=#codeLines[selection.y]
            codeLines[selection.y]=codeLines[selection.y]..codeLines[selection.y+1]        

            table.remove(codeLines,selection.y+1)

            selection.x=prev
            selection.y=selection.y-1
            
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
    local scrollStartY=math.floor(96/font.h)-3--13
    local scrollStartX=math.floor(128/font.w)-2--23
    --down
    if scroll.y>-(selection.y-scrollStartY) then
        scroll.y=-(selection.y-scrollStartY)
    end
    --up
    if scroll.y<-selection.y then
        scroll.y=-(selection.y)
    end
    --left
    if scroll.x<-selection.x then
        scroll.x=-(selection.x)
    --end
    --right
    elseif scroll.x<selection.x-scrollStartX then
        scroll.x=-(selection.x-scrollStartX)
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