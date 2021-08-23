local sr = require("serialization")

itemList = {
  -- Vanilla
  {"Iron Ingot", "Block of Iron", "Iron"},
  {"Gold Ingot", "Block of Gold", "Gold"},
  {"Lapis Lazuli", "Lapis Lazuli Block", "Lapis"},
  {"Coal", "Block of Coal", "Coal"},
  {"Diamond", "Block of Diamond", "Diamond"},
  {"Emerald", "Block of Emerald", "Emerald"},

  -- Overworld ores
  {"Copper Ingot", "Block of Copper", "Copper"},
  {"Silver Ingot", "Block of Silver", "Silver"},
  {"Lead Ingot", "Block of Lead", "Lead"},
  {"Zinc Ingot", "Block of Zinc", "Zinc"},
  {"Tin Ingot", "Block of Tin", "Tin"},
  {"Platinum Ingot", "Block of Platinum", "Platinum"},
  {"Nickel Ingot", "Block of Nickel", "Nickel"},
  {"Aluminum Ingot", "Block of Aluminum", "Aluminum"},
  {"Osmium Ingot", "Osmium Block", "Osmium"},
  {"Yellorium Ingot", "Yellorium Block", "Yellorium"},

  -- Nether ores
  {"Titanium Ingot", "Titanium Block", "Titanium"},
  {"Tungsten Ingot", "Tungsten Block", "Tungsten"},
  {"Iridium Ingot", "Block of Iridium", "Iridium"},
  {"Mana Infused Ingot", "Block of Mana Infused Metal", "Mithril"}, -- mithril
  {"Cobalt Ingot", "Block of Cobalt", "Cobalt"},
  {"Ardite Ingot", "Block of Ardite", "Ardite"},

  -- End ores
  {"Draconium Ingot", "Draconium Block", "Draconium"}
}

itemListGui = {}

local itemIndex = 1
local startX = 3
local startY = 16

local xOffset = 11
local yOffset = 6

-- 4 rows of 7 columns
for i = 1, 4 do
  -- Reset x to left hand side
  startX = 3

  for i = 1, 7 do
    local values = {}

    -- If there's a value put the name, otherwise leave empty
    if #itemList >= itemIndex then
      values = {itemList[itemIndex][3], startX, startY}
    else
      values = {" ", startX, startY}
    end

    table.insert(itemListGui, values)

    itemIndex = itemIndex + 1
    startX = startX + xOffset
  end

  startY = startY + yOffset
end

sevenSegment = {
  topFull = "▗▄▄▖",
  topLR = "▗▖▗▖",
  topR = "  ▗▖",

  segmentR = "▗▄▟▌",
  segmentL = "▐▙▄▖",
  segmentLR = "▐▙▟▌",
  segmentOnlyLR = "▐▌▐▌",
  segmentOnlyR = "  ▐▌"
}

numbers = {
  zero = {
    "0",
    sevenSegment.topFull,
    sevenSegment.segmentOnlyLR,
    sevenSegment.segmentLR
  },
  one = {
    "1",
    sevenSegment.topR,
    sevenSegment.segmentOnlyR,
    sevenSegment.segmentOnlyR
  },
  two = {
    "2",
    sevenSegment.topFull,
    sevenSegment.segmentR,
    sevenSegment.segmentL
  },
  three = {
    "3",
    sevenSegment.topFull,
    sevenSegment.segmentR,
    sevenSegment.segmentR
  },
  four = {
    "4",
    sevenSegment.topLR,
    sevenSegment.segmentLR,
    sevenSegment.segmentOnlyR
  },
  five = {
    "5",
    sevenSegment.topFull,
    sevenSegment.segmentL,
    sevenSegment.segmentR
  },
  six = {
    "6",
    sevenSegment.topFull,
    sevenSegment.segmentL,
    sevenSegment.segmentLR
  },
  seven = {
    "7",
    sevenSegment.topFull,
    sevenSegment.segmentOnlyR,
    sevenSegment.segmentOnlyR
  },
  eight = {
    "8",
    sevenSegment.topFull,
    sevenSegment.segmentLR,
    sevenSegment.segmentLR
  },
  nine = {
    "9",
    sevenSegment.topFull,
    sevenSegment.segmentLR,
    sevenSegment.segmentR
  }
}