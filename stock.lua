local event = require("event")
local component = require("component")
local sr = require("serialization")

require("stocklist")


local ae2 = component.me_interface

local buffer = 1000
local waitTime = 60

-- loop indefinitely
while true do
  -- For each item in the item list
  for _,k in pairs(itemList) do
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

      -- If item is above the buffer, craft items to put it under the buffer
      if stockSize > buffer then
        
        -- Get amount of crafts needed
        local difference = stockSize - buffer

        -- Ceiling always puts the calculated number below the buffer
        local blockCrafts = math.ceil(difference / 9)

        -- Get craft details for the corresponding block
        local craftables = ae2.getCraftables({label=block})

        -- If there is a craft available
        if craftables.n >= 1 then
          -- set craftables to first entry in list
          craftItem = craftables[1]

          -- request to craft item(s)
          local retVal = craftItem.request(blockCrafts)
        end
      end
    end
  end

  -- Wait for specified time until next cycle
  os.sleep(waitTime)
end