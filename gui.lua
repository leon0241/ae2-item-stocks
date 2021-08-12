local event = require("event")
local component = require("component")
local sr = require("serialization")
local gpu = component.gpu

gpu.setResolution(73, 36)

local w, h = gpu.getResolution()

local ae2 = component.me_interface

local colours = {
  white = 0xFFFFFF,
  blue = 0x0051BA,
  gray = 0xD3D3D3,
  black = 0x000000,
}

-- gpu.setForeground(colours.gray)
-- gpu.setBackground(0x00FF00)

-- gpu.fill(1, 1, 10, 10, colours.white)

-- local table = ae2.getCpus()

-- for _,k in pairs(table) do
--   if type(k) == "table" then
--     for _,a in pairs(k) do
--       print(a)
--     end
--   end

--   print(k)
-- end



-- local filter = {name="minecraft:iron_ingot"}

-- local items = ae2.getItemsInNetwork()
-- print(sr.serialize(items, 100000))

gpu.fill(1, 1, w, h, " ") -- clears the screen
                                                  

-- print("      _    _____ ____    ____  _             _         - Made by Leon")
-- print("     / \\  | ____|___ \\  / ___|| |_ ___   ___| | _____ ")
-- print("    / _ \\ |  _|   __) | \\___ \\| __/ _ \\ / __| |/ / __|")
-- print("   / ___ \\| |___ / __/   ___) | || (_) | (__|   <\\__ \\")
-- print("  /_/   \\_\\_____|_____| |____/ \\__\\___/ \\___|_|\\_\\___/")

gpu.setForeground(colours.white)
gpu.setBackground(colours.blue)

gpu.fill(1, 1, w, 6, " ") -- fill top left quarter of screen

gpu.set(1, 1, "      _    _____ ____    ____  _             _")
gpu.set(1, 2, "     / \\  | ____|___ \\  / ___|| |_ ___   ___| | _____")
gpu.set(1, 3, "    / _ \\ |  _|   __) | \\___ \\| __/ _ \\ / __| |/ / __|")
gpu.set(1, 4, "   / ___ \\| |___ / __/   ___) | || (_) | (__|   <\\__ \\")
gpu.set(1, 5, "  /_/   \\_\\_____|_____| |____/ \\__\\___/ \\___|_|\\_\\___/")

gpu.setBackground(colours.white)
gpu.setForeground(colours.black)
gpu.fill(1, 7, w, (h - 6), " ")


-- Remaining time phrase

local timeUntilPhrase = "Progress until next cycle"

 -- Remaining time bar
local centerOffset = (w - string.len(timeUntilPhrase)) / 2 + 1
gpu.set(centerOffset, 8, timeUntilPhrase)
gpu.setBackground(colours.black)

gpu.fill(4, 9, w - 6, 2, " ")

-- gpu.copy(1, 1, w/2, h/2, w/2, h/2) -- copy top left quarter of screen to lower right
-- time to 
-- next cycle

local startX = 3
local startY = 12

for i = 1, 4 do
  for i = 1, 7 do
    -- Title
    gpu.setBackground(colours.blue)
    gpu.setForeground(colours.white)
    gpu.fill(startX, startY, 9, 1, " ")
    gpu.set(startX, startY, "Yellorium")

    -- Main fill
    gpu.setBackground(colours.gray)
    gpu.fill(startX, startY + 1, 9, 4, " ")

    -- Bottom half fill
    gpu.setBackground(colours.white)
    gpu.setForeground(colours.gray)
    gpu.set(startX, startY + 5, "▀▀▀▀▀▀▀▀▀")

    startX = startX + 10
  end 

  startX = 3
  startY = startY + 6
end

-- gpu.setBackground(colours.gray)
-- gpu.fill(4, 13, 7, 4, " ")

-- gpu.set(3, 12, "Yellorium")
-- gpu.set(3, 13, "║       ║")
-- gpu.set(3, 14, "║       ║")
-- gpu.set(3, 15, "║       ║")
-- gpu.set(3, 16, "║       ║")
-- gpu.set(3, 17, "╚═══════╝")

gpu.setBackground(colours.white)
gpu.setForeground(colours.black)

while true do
  local _,_,x,y = event.pull("touch")
  component.gpu.set(x,y, x .. y)
  os.sleep(1)
  for i = 0, 3 do
    component.gpu.set(x + i,y, " ")
  end
 end