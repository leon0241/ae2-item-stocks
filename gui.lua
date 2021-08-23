local event = require("event")
local component = require("component")
local sr = require("serialization")
local gpu = component.gpu

gpu.setResolution(80, 40)

local w, h = gpu.getResolution()

local ae2 = component.me_interface

colours = {
  white = 0xFFFFFF,
  blue = 0x0051BA,
  gray = 0xD3D3D3,
  black = 0x000000,
}

-- cpuTextPositions = {}

function setColours(foreground, background)
  gpu.setForeground(foreground)
  gpu.setBackground(background)
end

function colourBackgrounds()
  -- Clears the screen
  setColours(colours.white, colours.black)
  gpu.fill(1, 1, w, h, " ")

  -- Fill title background
  setColours(colours.white, colours.blue)
  gpu.fill(1, 1, w, 6, " ")

  -- Fill Rest of page background
  setColours(colours.black, colours.white)
  gpu.fill(1, 7, w, (h - 6), " ")
end

function setTitleText()
  setColours(colours.white, colours.blue)

  -- Title text
  gpu.set(1, 1, "      _    _____ ____     ____  _             _")
  gpu.set(1, 2, "     / \\  | ____|___ \\   / ___|| |_ ___   ___| | _____")
  gpu.set(1, 3, "    / _ \\ |  _|   __) |  \\___ \\| __/ _ \\ / __| |/ / __|")
  gpu.set(1, 4, "   / ___ \\| |___ / __/    ___) | || (_) | (__|   <\\__ \\")
  gpu.set(1, 5, "  /_/   \\_\\_____|_____|  |____/ \\__\\___/ \\___|_|\\_\\___/")
end

function setRemainingTime()
  -- Remaining time phrase

  local timeUntilPhrase = "Progress until next cycle"

  -- Remaining time text
  local centerOffset = (w - string.len(timeUntilPhrase)) / 2 + 1
  setColours(colours.black, colours.white)
  gpu.set(centerOffset, 8, timeUntilPhrase)

  -- Remaining time bar
  gpu.setBackground(colours.black)
  gpu.fill(4, 9, w - 6, 2, " ")

end

function statusInformation()
  -- Fill box headers
  setColours(colours.white, colours.blue)
  gpu.fill(3, 8, 37, 1, " ")
  gpu.fill(42, 8, 37, 1, " ")

  -- Box titles
  gpu.set(4, 8, "Time remaining")
  gpu.set(43, 8, "Free Crafting CPU cores")

  -- Fill box contents
  setColours(colours.black, colours.gray)
  gpu.fill(3, 9, 37, 6, " ") --76
  gpu.fill(42, 9, 37, 6, " ")

  -- Queued Crafts and time remaining
  gpu.set(4, 10, "Queued Crafts: No")
  gpu.set(4, 11, "Time until next cycle: 69")
  setColours(colours.white, colours.black)
  gpu.fill(4, 12, 35, 2, " ")

  -- Free CPUs
  setColours(colours.black, colours.gray)
  local xValue = 43
  local yValue = 10
  local cpuIndex = 1

  for i = 1, 2 do
    xValue = 43
    for i = 1, 4 do
      gpu.set(xValue, yValue, cpuIndex .. ": Yes")
      -- table.insert(cpuTextPositions, {xValue, yValue})
      xValue = xValue + 9
      cpuIndex = cpuIndex + 1
    end

    yValue = yValue + 3
  end
end

function setItemBox(startX, startY, name)
  -- Title
  setColours(colours.white, colours.blue)
  gpu.fill(startX, startY, 10, 1, " ")

  if string.len(name) >= 9 then
    gpu.set(startX, startY, name)
  else
    gpu.set(startX, startY, " " .. name)
  end

  -- Main fill
  gpu.setBackground(colours.gray)
  gpu.fill(startX, startY + 1, 10, 4, " ")

  -- Bottom half fill
  setColours(colours.gray, colours.white)
  gpu.set(startX, startY + 5, "▀▀▀▀▀▀▀▀▀▀")
end

function dummyText()
  setColours(colours.black, colours.gray)
  gpu.set(3, 17, "To craft:")
  gpu.set(4, 18, "▗▄▄▖▗▄▄▖")
  gpu.set(4, 19, "▐▙▄▖▐▙▟▌")
  gpu.set(4, 20, "▐▙▟▌▗▄▟▌")


  gpu.set(14, 17, "All good!")
  gpu.set(15, 18, "     ▞ ")
  gpu.set(15, 19, " ▗  ▞ ")
  gpu.set(15, 20, "  ▚▞ ")

  gpu.set(25, 17, "Loading..")
  -- setColours(colours.black, colours.gray)
  -- gpu.set(29, 18, "▅▅")
  -- setColours(colours.gray, colours.black)
  -- gpu.set(29, 19, "▶◀")
  -- gpu.set(29, 20, "▃▃")

  gpu.set(28, 18, "▗▖▗▖")
  gpu.set(28, 19, "▐▌▐▌")
  gpu.set(28, 20, "▝▘▝▘")
end

function textClear(startX, startY)
  gpu.setBackground(colours.gray)
  gpu.fill(startX, startY + 1, 10, 4, " ")
end

function textCrafting(number, startX, startY)
  setColours(colours.black, colours.gray)
  gpu.set(startX, startY + 1, "To craft:")

  local numberString = ""

  if number <= 9 then
    numberString = "0" .. tostring(number)
  else 
    numberString = tostring(number)
  end

  local numberCodes = {}

  for i = 1, 2 do
    local c = string.sub(numberString, i, i)

    for _, k in pairs(numbers) do
      if c == k[1] then 
        table.insert(numberCodes, k)
      end
    end
  end

  gpu.set(startX + 1, startY + 2, numberCodes[1][2] .. numberCodes[2][2])
  gpu.set(startX + 1, startY + 3, numberCodes[1][3] .. numberCodes[2][3])
  gpu.set(startX + 1, startY + 4, numberCodes[1][4] .. numberCodes[2][4])
end

function textNoCrafts(startX, startY)
  setColours(colours.black, colours.gray)
  gpu.set(startX, startY + 1, "All good!")
  gpu.set(startX + 1, startY + 2, "     ▞ ")
  gpu.set(startX + 1, startY + 3, " ▗  ▞ ")
  gpu.set(startX + 1, startY + 4, "  ▚▞ ")
end

function textProcessing(startX, startY)
  setColours(colours.black, colours.gray)
  gpu.set(startX, startY + 1, "Loading..")
  gpu.set(startX + 4, startY + 2, "▅▅")
  setColours(colours.gray, colours.black)
  gpu.set(startX + 4, startY + 3, "▶◀")
  gpu.set(startX + 4, startY + 4, "▃▃")
end

function textOnHold(startX, startY)
  setColours(colours.black, colours.gray)
  gpu.set(startX, startY + 1, "Queued...")
  gpu.set(startX + 3, 18, "▗▖▗▖")
  gpu.set(startX + 3, 19, "▐▌▐▌")
  gpu.set(startX + 3, 20, "▝▘▝▘")
end

function textNoItem(startX, startY)
  setColours(colours.black, colours.gray)
  gpu.set(startX, startY + 1, "No item...")
  gpu.set(startX + 3, startY + 2, "\\ /")
  gpu.set(startX + 3, startY + 3, " X ")
  gpu.set(startX + 3, startY + 4, "/ \\")
end

-- type, value
function changeQueuedCrafts(value)
  setColours(colours.black, colours.gray)
  gpu.fill(19, 10, 3, 1, " ")
  gpu.set(19, 10, value)
end

function updateTimer(timePassed, totalTime)
  local percentageDone = timePassed / totalTime
  local remainingTime = tostring(totalTime - timePassed)
  gpu.fill(27, 11, 3, 1, " ")
  gpu.set(27, 11, remainingTime)
end

-- local startX = 3
-- local startY = 12

-- for i = 1, 4 do
--   startX = 3

--   for i = 1, 7 do
--     setItemBox(startX, startY)

--     startX = startX + 10
--   end 
--   startY = startY + 6
-- end

-- gpu.setBackground(colours.white)
-- gpu.setForeground(colours.black)

function pollInputs()
  while true do
    local _,_,x,y = event.pull("touch")
    component.gpu.set(x,y, x .. y)
    os.sleep(1)
    for i = 0, 3 do
      component.gpu.set(x + i,y, " ")
    end
  end
end