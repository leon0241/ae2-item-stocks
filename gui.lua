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
  setColours(colours.black, colours.gray)
  gpu.set(29, 18, "▅▅")
  setColours(colours.gray, colours.black)
  gpu.set(29, 19, "▶◀")
  gpu.set(29, 20, "▃▃")
end

function textCrafting(startX, startY)
  setColours(colours.black, colours.gray)
  gpu.set(startX, startY + 1, "To craft:")
  gpu.set(startX + 1, startY + 2, "▗▄▄▖▗▄▄▖")
  gpu.set(startX + 1, startY + 3, "▐▙▄▖▐▙▟▌")
  gpu.set(startX + 1, startY + 4, "▐▙▟▌▗▄▟▌")
end

function textNoCrafts(startX, startY)
  gpu.set(startX, startY + 1, "All good!")
  gpu.set(startX + 1, startY + 2, "     ▞ ")
  gpu.set(startX + 1, startY + 2, " ▗  ▞ ")
  gpu.set(startX + 1, startY + 2, "  ▚▞ ")
end

function textProcessing(startX, startY)
  gpu.set(startX, startY + 1, "Loading..")
  setColours(colours.black, colours.gray)
  gpu.set(startX + 4, startY + 2, "▅▅")
  setColours(colours.gray, colours.black)
  gpu.set(startX + 4, startY + 3, "▶◀")
  gpu.set(startX + 4, startY + 4, "▃▃")
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