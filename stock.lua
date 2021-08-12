local event = require("event")
local component = require("component")
local sr = require("serialization")

require("stocklist")

component.gpu.setResolution(160, 50)

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

print(sr.serialize(stockCpus, 10000))

-- loop indefinitely
while true do
  queuedCrafts = false
  waitTime = 60
  -- For each item in the item list
  for _,k in pairs(itemList) do

    -- if the previous entry was already full then this one will also be full
    if queuedCrafts == true then
      print("break out of loop")
      waitTime = 30
      break
    end

    -- K in array of format {ingot, block}

    -- Split K into ingot/block pair
    local ingot = k[1]
    local block = k[2]

    -- Get the item details of the specified ingot
    local item = ae2.getItemsInNetwork({label=ingot})

    -- If item doesn't exist then skip
    if item.n == 0 then
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
          for _,k in pairs(cpuArr) do
            -- type and name check
            if type(k) == "table" and string.find(k.name, "Ingots") ~= nil then
              -- check if it's unoccupiped
              if k.busy == false then
                -- store
                freeCpu = k

                -- no need to check the other cpus
                break
              end
            end
          end

          -- If free cpu isn't empty
          if next(freeCpu) ~= nil then
            -- Craft the items with freeCpu
            print("crafting" .. ingot)
            local retVal = craftItem.request(blockCrafts, false, freeCpu.name)
          else
            -- Show all cpus are taken up
            print("full")
            queuedCrafts = true
          end

          -- if type(result) == "boolean" then
          --   queuedCrafts = true
          -- end
        end
      end
    end
  end

  -- Wait for specified time until next cycle
  print(waitTime)
  os.sleep(waitTime)
end