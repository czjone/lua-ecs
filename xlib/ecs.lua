--[[
    —————————————————————————————————————————————————————————————————————
    |                   data structure                                  |
    —————————————————————————————————————————————————————————————————————
    |contexts -> context -> entites -> entity -> components -> component|
    |         -> context            -> entity               -> component|
    |         -> context            -> entity               -> component|
    —————————————————————————————————————————————————————————————————————
]] 

require("xlib.ecs.collector")
require("xlib.ecs.component")
require("xlib.ecs.context")
require("xlib.ecs.entity")
require("xlib.ecs.group")
require("xlib.ecs.matcher")
require("xlib.ecs.system")
require("xlib.ecs.reactive_system")
require("xlib.ecs.feature")
require("xlib.ecs.world")
-- default matchers.
require("xlib.ecs.matches.matcher_for_entity_class")
