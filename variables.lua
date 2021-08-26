--[[################################
#                                  #
#        Editable Variables        #
#                                  #
################################--]]

-- Program Variables

-- Wait time between cycles
waitTimeStatic = 60

-- Wait time multiplier for a queued cycle
queueTimeMultiplier = 0.5

-- Number to autocraft to
buffer = 1000

-- Max number before autocrafting (this means that it overcrafts
-- and doesn't need to run again right after it crafts)
maxAmount = 1200


-- GUI Variables

-- Screen Resolution
screenWidth = 80
screenHeight = 40

-- Item box length (This is only the gray part of the box)
itemBoxLength = 10
itemBoxHeight = 4

-- Number of rows and columns of boxes
local itemBoxRows = 4
local itemBoxColumns = 7

-- Starting Co-ordinates of item boxes
local startX = 3
local startY = 16

-- Amount to offset each axis by (Size of box + any filler space)
local xOffset = 11
local yOffset = 6


--[[ 
Item list to autocraft
{Ingot, Block name, Shortened name}
Shortened name is for GUI only
Max of 28 values default
--]]

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

  -- SPACE FOR 5 MORE INGOTS
}


--[[##################################
#                                    #
#        Uneditable Variables        #
#                                    #
##################################--]]


-- Starting Position (Top left corner) of item boxes
-- {Item name, X co-ordinate, Y co-ordinate}

itemListGui = {}

-- Index of item in GUI loop (can't use index as it's for 7x4 and not 1x28)
local itemIndex = 1

-- 4 rows of 7 columns
for i = 1, itemBoxRows do

  -- Reset x to left hand side
  startX = 3

  for i = 1, itemBoxColumns do
    local values = {}

    -- If it's still going through item list, put the name of the entry
    if #itemList >= itemIndex then
      values = {itemList[itemIndex][3], startX, startY}

    -- Otherwise, leave the box with a blank name
    else
      values = {" ", startX, startY}
    end

    table.insert(itemListGui, values)

    itemIndex = itemIndex + 1

    -- Add offset to prepare for next square
    startX = startX + xOffset
  end

  -- Add offset to prepare for next row
  startY = startY + yOffset
end

-- Parts of the 4x3 character (4x6 pixels) Seven Segment display 

sevenSegment = {
  -- Top section (has half cut off)
  topFull = "▗▄▄▖", -- Used in 0, 2, 3, 5, 6, 7, 8, 9, 0
  topLR = "▗▖▗▖", -- Used in 4
  topR = "  ▗▖", -- Used in 1

  -- Middle and bottom sections
  segmentR = "▗▄▟▌", -- Used in 2, 3, 5, 9
  segmentL = "▐▙▄▖", -- Used in 2, 5, 6
  segmentLR = "▐▙▟▌", -- Used in 4, 6, 8, 9, 0
  segmentOnlyLR = "▐▌▐▌", -- Used in 4, 0
  segmentOnlyR = "  ▐▌" -- Used in 1, 7
}

-- Numbers as parts of seven segment display slices

-- {Number (Can't use integer as entry name), Top, Middle, Bottom}

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