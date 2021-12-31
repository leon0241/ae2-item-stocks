local component = require("component")
local sr = require("serialization")

require("variables")
require("gui")

local ae2 = component.me_interface

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


-- loop indefinitely
while true do
  -- Reset timer bar in GUI
  resetTimerBar()

  -- Reset queuedCrafts
  queuedCrafts = false

  -- Reset time
  waitTime = waitTimeStatic

  -- Initialise each item box with loading icon before doing processing
  for i = 1, itemListLength do
    local item = itemListGui[i]

    -- item: {Shortened Item Name, X-coord, Y-coord}
    textProcessing(item[2], item[3])
  end


  -- For each item in the item list
  for i = 1, itemListLength do
    -- if the previous entry was already full then this one will also be full
    if queuedCrafts == true then
      -- print("break out of loop")
      waitTime = waitTimeStatic * queueTimeMultiplier
      break
    end

    -- Entries from main item and item GUI arrays
    local itemNames = itemList[i]
    local itemGui = itemListGui[i]

    -- Information from main item array
    local ingot = itemNames[1]
    local block = itemNames[2]

    -- Information from item GUI array
    local startX = itemGui[2]
    local startY = itemGui[3]


    -- Get the item details of the specified ingot
    local item = ae2.getItemsInNetwork({label=ingot})

    -- If item doesn't exist then skip
    if item.n == 0 then
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
        
        -- Rough estimate of how much a 16k storage can process
        if blockCrafts > 1400 then
          blockCrafts = 1400
        end
        
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
                -- store into freecpu var
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
            textCrafting(blockCrafts, startX, startY)
          else
            -- Show all cpus are taken up
            queuedCrafts = true

            textOnHold(startX, startY)
            changeQueuedCrafts("Yes")
          end
        end
      else
        textNoCrafts(startX, startY)
      end
    end
  end

  -- Wait for specified time until next cycle
  for i = 0, waitTime do
    -- Update timer GUI every second
    updateTimer(i, waitTime)
    os.sleep(1)
  end
end