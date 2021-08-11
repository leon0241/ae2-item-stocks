local event = require("event")
local component = require("component")
local colors = require("colors")
local sr = require("serialization")

local ae2 = component.me_interface

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



while true do
 local _,_,x,y = event.pull("touch")
 component.gpu.set(x,y,"@")
end