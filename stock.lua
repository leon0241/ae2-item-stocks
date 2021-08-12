local event = require("event")
local component = require("component")
local sr = require("serialization")

require("stocklist")

component.gpu.setResolution(160, 50)

local ae2 = component.me_interface

local buffer = 1000
local maxAmount = 1000

local waitTime = 60

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

          local cpuArr = ae2.getCpus()
          local stockCpus = {}

          local freeCpu = {}

          for _,k in pairs(cpuArr) do
            -- if it's one of the ingot cpus
            if type(k) == "table" and string.find(k.name, "Ingots") ~= nil then
              print(k.name)
              -- check if it's unoccupiped
              -- table.insert(stockCpus, k)

              if k.busy == false then
                freeCpu = k
                break
              end
            end
          end

          if next(freeCpu) ~= nil then
            print("crafting" .. ingot)
            local retVal = craftItem.request(blockCrafts, false, freeCpu.name)
          else
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