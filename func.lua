function loadPal(image)
    local img=love.image.newImageData(image)
    local temp={}

    for x=0,img:getWidth()-1 do
        local r,g,b=img:getPixel(x,0)
        table.insert(temp,{r=r*255,g=g*255,b=b*255})
    end

    return temp
end

function palCol(n)
    if n>=0 and n<16 then
        return mem.peek(0x3001+(n*3)+0)/255,mem.peek(0x3001+(n*3)+1)/255,mem.peek(0x3001+(n*3)+2)/255
    else
        return mem.peek(0x3001+(0*3)+0)/255,mem.peek(0x3001+(0*3)+1)/255,mem.peek(0x3001+(0*3)+2)/255
    end
end

function generateTable(w, h)
    local tbl = {}
    for i = 1, h do
        tbl[i] = {}
        for j = 1, w do
            tbl[i][j] = 0
        end
    end
    return tbl
end

function initFont(image,text,w,h)
    local img=love.image.newImageData(image)
    font={chars={},text=text,w=w,h=h}
    for y=0,math.floor(img:getHeight()/h)-1 do
        for x=0,math.floor(img:getWidth()/w)-1 do
            local tempChar=""
            for y1=y*h,h+(y*h)-1 do
                for x1=x*w,w+(x*w)-1 do
                    local r,g,b=img:getPixel(x1,y1)
                    if r~=0 then
                        tempChar=tempChar.."1"
                    else
                        tempChar=tempChar.."0"
                    end
                end
            end
            table.insert(font.chars,tempChar)
        end
    end
end

function drawChar(letter,x,y)
    local indx=string.find(font.text,letter)
    if indx then
        local i=1
        for y1=0,font.h-1 do
            for x1=0,font.w-1 do
                if getChar(font.chars[indx], i)=="1" then
                    love.graphics.points(x1+x,y1+y)
                end
               i=i+1
            end
        end
    end
end

function drawFont(text,x,y)
    for i=0,string.len(text)-1 do
        drawChar(getChar(text,i+1),i*font.w+x,y)
    end
end

function getChar(str, index)
    return string.sub(str, index, index)
end

function writeToFile(path,data)
    love.filesystem.write(path..".chp", data)
end

local hex="0123456789abcdef"

function save()
    local data = "#CODE\n"
    data = data .. cart .. "\n"
    data = data .. "#SPRITE\n"
    for i=0,(128*128)-1 do
        data = data .. string.sub(hex,mem.peek(0x3032+i)+1,mem.peek(0x3032+i)+1)
    end
    writeToFile(name,data)
end

function runCartFromEditor(k)
    if love.keyboard.isDown("lctrl") and k=="r" then
        if cartLoaded then
            for y=0,127 do
                for x=0,127 do
                    loadSheet[x+(y*128)+1]=api.sget(x,y)
                end
            end
            gs.switch(runCart,mem.map)
        else
            gs.switch(menuProg)
        end
    end
end