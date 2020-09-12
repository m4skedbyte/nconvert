local screen = platform.window
local w = screen:width()

title = "Unit:" --title

unit = "MiB" --unit (default MiB)
unit_count = 1
input = "" --input
noinputmsg = "Please enter a value"

answer={}
answer[1] = "" --answer 1
answer[2] = "" --answer 2
answer[3] = "" --answer 3
noinput = ""


function on.paint(gc)
    local title_width = gc:getStringWidth(title)
    local unit_width = gc:getStringWidth(unit)

    gc:drawString(title,((w/2) - (title_width / 2)), 5, "top") --title

    gc:setFont("sansserif", "b", 10)
    gc:drawString(unit,((w/2) - (unit_width/2)),40) --unit
    gc:setFont("sansserif", "r", 10)

    if  input ~= "" then
        local input_width = gc:getStringWidth(input)
        gc:drawString(input,((w/2) - (input_width/2)),63) --input
        gc:setPen("thin","smooth")
        if string.len(input) <= 4 then
            gc:drawRect(((w/2) - 20), 45, 40, 20)
        else
            gc:drawRect((((w/2) - (input_width/2) - 5)), 45, (input_width + 10), 20)
        end
    else
        if noinput == noinputmsg then
            gc:setColorRGB(255,0,0)
            gc:setPen("medium","dashed")
            gc:drawRect(((w/2) - 20), 45, 40, 20)
        else
            gc:setColorRGB(0,0,0)
            gc:setPen("thin","dashed")
            gc:drawRect(((w/2) - 20), 45, 40, 20)
        end
    end

    if answer[1] ~= "" then
        local answer_1_width = gc:getStringWidth(answer[1])
        local answer_2_width = gc:getStringWidth(answer[2])
        local answer_3_width = gc:getStringWidth(answer[3])
        gc:setFont("sansserif", "b", 12)
        gc:setColorRGB(0,0,255)
        gc:drawString(answer[1],((w/2) - (answer_1_width/2) - 10),100)
        gc:drawString(answer[2],((w/2) - (answer_2_width/2) - 10),120)
        gc:drawString(answer[3],((w/2) - (answer_3_width/2) -10),140)
        gc:setFont("sansserif", "r", 10)
        gc:setColorRGB(0,0,0)
    end

    if noinput == noinputmsg then --noinput
        local noinput_width = gc:getStringWidth(noinputmsg)
        gc:setFont("sansserif", "b", 12)
        gc:setColorRGB(255,0,0)
        gc:drawString(noinputmsg,((w/2)-(noinput_width/2)-15),100)
        gc:setFont("sansserif", "r", 10)
        gc:setColorRGB(0,0,0)
    end

    --explanation
    local change_width = gc:getStringWidth("[<->] Change Unit")
    gc:drawString("[<->] Change Unit",((w/2) - (change_width/2)),200)
    gc:drawString("[Tab] Reset",5,200)
    gc:drawString("[Enter] Calc",(w - (5 + 69)),200)
end

function on.charIn(char) --value input
    if string.find(char, '%d') == 1 then
        if answer[1] ~= "" then --reset answers, if new input appears after calc
            answer[1] = ""
            answer[2] = ""
            answer[3] = ""
            input = input..char
            noinput = ""
        else
            input = input..char
            noinput = ""
        end
    end
    screen:invalidate()
end

function on.backspaceKey()
    input = string.usub(input,0,-2)
    screen:invalidate()
end

function on.enterKey() --calculation
    if input ~= "" then
        if unit == "GiB" then
            answer[1] = "MiB: "..(input * 1024)
            answer[2] = "KiB: "..(input * 1024 * 1024)
            answer[3] = "Bytes: "..(input * 1024 * 1024 * 1024)
        end
        if unit == "MiB" then
            answer[1] = "GiB: "..(input / 1024) --MiB to GiB
            answer[2] = "KiB: "..(input * 1024) --MiB to KiB
            answer[3] = "Bytes: "..(input * 1024 * 1024) -- MiB to Bytes
        end
        if unit == "KiB" then
            answer[1] = "GiB: "..((input / 1024) / 1024) --KiB to GiB
            answer[2] = "MiB: "..(input / 1024) --KiB to MiB
            answer[3] = "Bytes: "..(input * 1024) -- KiB to Bytes
        end
        if unit == "Bytes" then
            answer[1] = "GiB: "..(((input / 1024) / 1024) / 1024) --Bytes to GiB
            answer[2] = "MiB: "..((input / 1024) / 1024) --Bytes to MiB
            answer[3] = "KiB: "..(input / 1024) --Bytes to KiB
        end
    else
        noinput = noinput..noinputmsg
    end
    screen:invalidate()
end

function on.arrowRight()
    if unit_count < 4 then
        unit_count = (unit_count + 1)
    else
        unit_count = 1
    end

    if unit_count == 1 then
        unit = "MiB"
    end
    if unit_count == 2 then
        unit = "KiB"
    end
    if unit_count == 3 then
        unit = "Bytes"
    end
    if unit_count == 4 then
        unit = "GiB"
    end
    screen:invalidate()
end

function on.arrowLeft()
    if unit_count > 1 then
        unit_count = (unit_count - 1)
    else
        unit_count = 4
    end

    if unit_count == 1 then
        unit = "MiB"
    end
    if unit_count == 2 then
        unit = "KiB"
    end
    if unit_count == 3 then
        unit = "Bytes"
    end
    if unit_count == 4 then
        unit = "GiB"
    end
    screen:invalidate()
end

function on.tabKey() --reset
    input = ""
    noinput = ""
    answer[1] = ""
    answer[2] = ""
    answer[3] = ""
    unit = "MiB"
    unit_count = 1
    screen:invalidate()
end