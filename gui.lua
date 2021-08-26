local event = require("event")
local component = require("component")
local sr = require("serialization")
local gpu = component.gpu
require("variables")


local ae2 = component.me_interface

-- Set resolution to be 1:1
gpu.setResolution(screenWidth, screenHeight)

-- Colours array
-- Switch to a global variable if u wanna use test.lua
local colours = {
  white = 0xFFFFFF,
  blue = 0x0051BA,
  gray = 0xD3D3D3,
  lightGray = 0xa9a9a9,
  black = 0x000000,
}

-- sets Foreground background
function setColours(foreground, background)
  gpu.setForeground(foreground)
  gpu.setBackground(background)
end



--[[#################################
#                                   #
#        Initial GUI Drawing        #
#                                   #
#################################--]]

-- Sets the background of the GUI
function colourBackgrounds()
  -- Clears the screen
  setColours(colours.white, colours.black)
  gpu.fill(1, 1, screenWidth, screenHeight, " ")

  -- Fill title background
  setColours(colours.white, colours.blue)
  gpu.fill(1, 1, screenWidth, 6, " ")

  -- Fill Rest of page background
  setColours(colours.black, colours.white)
  gpu.fill(1, 7, screenWidth, (screenHeight - 6), " ")
end

-- Draws the title text in ASCII art
function setTitleText()
  setColours(colours.white, colours.blue)

  -- Title text
  gpu.set(1, 1, "      _    _____ ____     ____  _             _")
  gpu.set(1, 2, "     / \\  | ____|___ \\   / ___|| |_ ___   ___| | _____")
  gpu.set(1, 3, "    / _ \\ |  _|   __) |  \\___ \\| __/ _ \\ / __| |/ / __|")
  gpu.set(1, 4, "   / ___ \\| |___ / __/    ___) | || (_) | (__|   <\\__ \\")
  gpu.set(1, 5, "  /_/   \\_\\_____|_____|  |____/ \\__\\___/ \\___|_|\\_\\___/")
end

-- Draws the status information
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
  gpu.set(4, 11, "Time until next cycle:")
  setColours(colours.white, colours.black)
  gpu.fill(4, 12, 35, 2, " ")

  -- Free CPUs (Currently not implemented)
  setColours(colours.lightGray, colours.gray)
  local xValue = 43
  local yValue = 10
  local cpuIndex = 1

  -- For 2 rows of 4 columns
  for i = 1, 2 do
    xValue = 43
    for i = 1, 4 do
      -- List the cpu and the status
      gpu.set(xValue, yValue, cpuIndex .. ": Yes")
      -- table.insert(cpuTextPositions, {xValue, yValue})
      xValue = xValue + 9
      cpuIndex = cpuIndex + 1
    end

    yValue = yValue + 3
  end
end

-- Draw inital item box
function setItemBox(startX, startY, name)
  -- Title
  setColours(colours.white, colours.blue)
  gpu.fill(startX, startY, itemBoxLength, 1, " ")

  -- If there's enough space to add an extra space then do it
  if string.len(name) >= (itemBoxLength) then
    gpu.set(startX, startY, name)
  else
    gpu.set(startX, startY, " " .. name)
  end

  -- Main fill
  gpu.setBackground(colours.gray)
  gpu.fill(startX, startY + 1, itemBoxLength, itemBoxHeight, " ")

  -- Bottom half fill
  setColours(colours.gray, colours.white)
  gpu.set(startX, startY + 5, "▀▀▀▀▀▀▀▀▀▀")
end



--[[##############################
#                                #
#        Item Box Editing        #
#                                #
##############################--]]

-- Set the colours, clears the box and sets the status message
function initBox(startX, startY, message)
  setColours(colours.black, colours.gray)
  gpu.fill(startX, startY + 1, itemBoxLength, itemBoxHeight, " ")

  gpu.set(startX, startY + 1, message)
end

-- Processing crafts - draws a 2 digit number using the seven segment display
function textCrafting(number, startX, startY)
  initBox(startX, startY, "To craft:")

  -- Convert number to string and put a 0 on the front if it's under 10
  local numberString = ""

  if number <= 9 then
    numberString = "0" .. tostring(number)
  else 
    numberString = tostring(number)
  end


  -- Array of seven segment display slice arrays (both numbers)
  local numberCodes = {}

  -- For both numbers (could be 3 numbers but unlikely and i cba)
  for i = 1, 2 do
    -- Substring for the number
    local c = string.sub(numberString, i, i)

    -- search for corresponding number in number array and append
    for _, k in pairs(numbers) do
      if c == k[1] then 
        table.insert(numberCodes, k)
      end
    end
  end

  -- Write numbers
  gpu.set(startX + 1, startY + 2, numberCodes[1][2] .. numberCodes[2][2])
  gpu.set(startX + 1, startY + 3, numberCodes[1][3] .. numberCodes[2][3])
  gpu.set(startX + 1, startY + 4, numberCodes[1][4] .. numberCodes[2][4])
end

-- No Crafts required - Draws a tick
function textNoCrafts(startX, startY)
  initBox(startX, startY, "All good!")

  gpu.set(startX + 1, startY + 2, "     ▞ ")
  gpu.set(startX + 1, startY + 3, " ▗  ▞ ")
  gpu.set(startX + 1, startY + 4, "  ▚▞ ")
end

-- Loading item - Draws an hourglass
function textProcessing(startX, startY)
  initBox(startX, startY, "Loading..")

  gpu.set(startX + 4, startY + 2, "▅▅")
  setColours(colours.gray, colours.black)
  gpu.set(startX + 4, startY + 3, "▶◀")
  gpu.set(startX + 4, startY + 4, "▃▃")
end

-- Queued item - Draws a pause sign
function textOnHold(startX, startY)
  initBox(startX, startY, "Queued...")

  gpu.set(startX + 3, 18, "▗▖▗▖")
  gpu.set(startX + 3, 19, "▐▌▐▌")
  gpu.set(startX + 3, 20, "▝▘▝▘")
end

-- No item in storage - Draws an X sign
function textNoItem(startX, startY)
  initBox(startX, startY, "No item...")

  gpu.set(startX + 3, startY + 2, "\\ /")
  gpu.set(startX + 3, startY + 3, " X ")
  gpu.set(startX + 3, startY + 4, "/ \\")
end



--[[################################
#                                  #
#        Remaining time bar        #
#                                  #
################################--]]

-- Changes the status of queued crafts bool
function changeQueuedCrafts(value)
  setColours(colours.black, colours.gray)
  -- Clears 3 spaces (so Yes -> No isn't Nos)
  gpu.fill(19, 10, 3, 1, " ")
  gpu.set(19, 10, value)
end

-- Resets the timer bar to fully black
function resetTimerBar()
  setColours(colours.white, colours.black)
  gpu.fill(4, 12, 35, 2, " ")
end

-- Updates the timer bar
function updateTimer(timePassed, totalTime)
  setColours(colours.black, colours.gray)

  local percentageDone = timePassed / totalTime
  local remainingTime = tostring(totalTime - timePassed)

  -- Clears 3 spaces and puts the remaining time
  gpu.fill(27, 11, 3, 1, " ")
  gpu.set(27, 11, remainingTime)

  -- Calculates number of characters to fill in and colour them blue
  local fillInAmount = math.ceil(percentageDone * 35)
  setColours(colours.black, colours.blue)
  gpu.fill(4, 12, fillInAmount, 2, " ")

end



--[[##################################
#                                    #
#        Deprecated functions        #
#                                    #
##################################--]]

-- Will print the coords of where you click on screen, and disappear after 3s

-- function pollInputs()
--   while true do
--     local _,_,x,y = event.pull("touch")
--     component.gpu.set(x,y, x .. y)
--     os.sleep(1)
--     for i = 0, 3 do
--       component.gpu.set(x + i,y, " ")
--     end
--   end
-- end


-- Dummy text function (test)

-- function dummyText()
--   setColours(colours.black, colours.gray)
--   gpu.set(3, 17, "To craft:")
--   gpu.set(4, 18, "▗▄▄▖▗▄▄▖")
--   gpu.set(4, 19, "▐▙▄▖▐▙▟▌")
--   gpu.set(4, 20, "▐▙▟▌▗▄▟▌")


--   gpu.set(14, 17, "All good!")
--   gpu.set(15, 18, "     ▞ ")
--   gpu.set(15, 19, " ▗  ▞ ")
--   gpu.set(15, 20, "  ▚▞ ")

--   gpu.set(25, 17, "Loading..")
--   -- setColours(colours.black, colours.gray)
--   -- gpu.set(29, 18, "▅▅")
--   -- setColours(colours.gray, colours.black)
--   -- gpu.set(29, 19, "▶◀")
--   -- gpu.set(29, 20, "▃▃")

--   gpu.set(28, 18, "▗▖▗▖")
--   gpu.set(28, 19, "▐▌▐▌")
--   gpu.set(28, 20, "▝▘▝▘")
-- end

-- Draws a remaining time bar that goes across the whole screen
-- function setRemainingTime()
--   -- Remaining time phrase

--   local timeUntilPhrase = "Progress until next cycle"

--   -- Remaining time text
--   local centerOffset = (screenWidth - string.len(timeUntilPhrase)) / 2 + 1
--   setColours(colours.black, colours.white)
--   gpu.set(centerOffset, 8, timeUntilPhrase)

--   -- Remaining time bar
--   gpu.setBackground(colours.black)
--   gpu.fill(4, 9, screenWidth - 6, 2, " ")

-- end