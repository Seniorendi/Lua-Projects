---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Srendi.
--- DateTime: 25.04.2021 20:44
---

mon = peripheral.wrap("top")
me = peripheral.wrap("right")

data = {
    cpus = 0,
    oldCpus = 0,
    crafting = 0
}

local firstStart = true

local monX, monY

os.loadAPI("bars")

function prepareMon()
    mon.clear()
    mon.setBackgroundColor(colors.black)
    mon.setTextScale(1)
    monX, monY = mon.getSize()
    --drawBox(2,78,4,38,"CPU's", colors.gray, colors.lightGray)
    --drawBox(2,78,40,50,"Stats", colors.gray, colors.lightGray)
    drawBox(2, 38, 3, 16, "CPU's", colors.gray, colors.lightGray)
    drawBox(2, 38, 18, 25, "Stats", colors.gray, colors.lightGray)
    addBars()
end

function addBars()
    cpus = me.getCraftingCPUs()
    for i=1, #cpus do
        x = 3*i
        full = (cpus[i].storage/65536) + cpus[i].coProcessors
        bars.add(""..i,"ver", full, cpus[i].coProcessors, 1+x, 5, 2, 10, colors.lightBlue, colors.blue)
        --print("Test1 ".. full)
        --print("Test2 ".. cpus[i].storage/65536)
    end
    --bars.add("#0", "ver", 50, 20, 4, 5, 2, 9, colors.lightBlue, colors.blue)
    bars.construct(mon)
    bars.screen()
end


function drawBox(xMin, xMax, yMin, yMax, title, bcolor, tcolor)
    mon.setBackgroundColor(bcolor)
    for xPos = xMin, xMax, 1 do
        mon.setCursorPos(xPos, yMin)
        mon.write(" ")
    end
    for yPos = yMin, yMax, 1 do
        mon.setCursorPos(xMin, yPos)
        mon.write(" ")
        mon.setCursorPos(xMax, yPos)
        mon.write(" ")

    end
    for xPos = xMin, xMax, 1 do
        mon.setCursorPos(xPos, yMax)
        mon.write(" ")
    end
    mon.setCursorPos(xMin+2, yMin)
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(tcolor)
    mon.write(" ")
    mon.write(title)
    mon.write(" ")
    mon.setTextColor(colors.white)
end

function clear(xMin,xMax, yMin, yMax)
    mon.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax, 1 do
            mon.write(" ")
        end
    end
end

function updateStats()
    clear(3,37,19,24)
    print("CPUs: ".. data.cpus)
    print("Working: ".. data.crafting)
    mon.setCursorPos(4,20)
    mon.write("CPUs: ".. data.cpus)
    mon.setCursorPos(4,21)
    mon.write("Working: ".. data.crafting)

    if not firstStart and not oldCpus == cpus then
        bars.clear()
        addBars()
    end
    oldCpus = cpus
    firstStart = false
end

prepareMon()

while true do
    cpus = {}
    for k in pairs(me.getCraftingCPUs()) do
        table.insert(cpus, k)
    end
    data.cpus = 0
    data.crafting = 0
    table.sort(cpus)
    for i = 1, #cpus do
        local k, v = cpus[i], me.getCraftingCPUs()[cpus[i]]
        data.cpus = data.cpus+1
        if v.isBusy then
            data.crafting = data.crafting+1
        end
        -- print(i, v.coProcessors, v.isBusy, v.storage/65536)
    end
    updateStats()
    sleep(2)
end