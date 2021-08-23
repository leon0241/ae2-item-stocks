local event = require("event")
local component = require("component")
local sr = require("serialization")
local gpu = component.gpu

require("stocklist")
require("gui")

local ae2 = component.me_interface

-- Number to autocraft to
local buffer = 1000

-- Max number before autocrafting (this means that it overcrafts
-- and doesn't need to run again right after it crafts)
local maxAmount = 1000

-- Wait time
local waitTime = 60

-- Check if all cpus are taken up
local queuedCrafts = false

local itemListLength = #itemList

colourBackgrounds()
setTitleText()
statusInformation()


for _,k in pairs(itemListGui) do
  local name = k[1]
  local startX = k[2]
  local startY = k[3]

  setItemBox(startX, startY, name)
end

-- dummyText()

-- loop indefinitely
while true do
  queuedCrafts = false
  waitTime = 60

  for i = 1, itemListLength do
    local item = itemListGui[i]
    textClear(item[2], item[3])
    textProcessing(item[2], item[3])
  end


  -- For each item in the item list
  for i = 1, itemListLength do
    -- if the previous entry was already full then this one will also be full
    if queuedCrafts == true then
      -- print("break out of loop")
      waitTime = 30
      break
    end

    -- K in array of format {ingot, block}

    local itemNames = itemList[i]
    local itemGui = itemListGui[i]

    -- Split K into ingot/block pair
    local ingot = itemNames[1]
    local block = itemNames[2]

    local startX = itemGui[2]
    local startY = itemGui[3]


    -- Get the item details of the specified ingot
    local item = ae2.getItemsInNetwork({label=ingot})

    -- If item doesn't exist then skip
    if item.n == 0 then
      textClear(startX, startY)
      textNoItem(startX, startY)
    else
      -- Amount of items stored in network
      local stockSize = item[1].size

      -- If item is above the max amount, craft items to put it under the buffer
      if stockSize > maxAmount then
        
        -- Get amount of crafts needed
        local difference = stockSize - buffer

        -- Ceiling always puts the calculated number below the buffer
        local blockCrafts = math.ceil(difference / 9)

        -- Get craft details for the corresponding block
        local craftables = ae2.getCraftables({label=block})

        -- print(sr.serialize(craftables, 10000))

        -- If there is a craft available
        if craftables.n >= 1 then
          -- set craftables to first entry in list
          craftItem = craftables[1]

          -- get all cpus in network
          local cpuArr = ae2.getCpus()

          -- value of a free cpu
          local freeCpu = {}

          -- look through all cpus for a free cpu that's called %ingots%
          for _,cpu in pairs(cpuArr) do
            -- type and name check
            if type(cpu) == "table" and string.find(cpu.name, "Ingots") ~= nil then
              -- check if it's unoccupiped
              if cpu.busy == false then
                -- store
                freeCpu = cpu

                -- no need to check the other cpus
                break
              end
            end
          end

          -- If free cpu array isn't empty
          if next(freeCpu) ~= nil then
            -- Craft the items with freeCpu
            local retVal = craftItem.request(blockCrafts, false, freeCpu.name)
            textClear(startX, startY)
            textCrafting(blockCrafts, startX, startY)
          else
            -- Show all cpus are taken up
            queuedCrafts = true

            textClear(startX, startY)
            textOnHold(startX, startY)
            changeQueuedCrafts("Yes")
          end
        end
      else
        textClear(startX, startY)
        textNoCrafts(startX, startY)
      end
    end
  end

  -- Wait for specified time until next cycle
  for i = 0, waitTime do
    updateTimer(i, waitTime)
    os.sleep(1)
  end
end