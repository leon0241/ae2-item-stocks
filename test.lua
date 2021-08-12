local event = require("event")
local component = require("component")
local sr = require("serialization")
local gpu = component.gpu

local ae2 = component.me_interface

local cpus = ae2.getCpus()

print(sr.serialize(cpus, 10000))