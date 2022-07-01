require("xlib.core")
require("xlib.ecs")

local ecs_world = class(xlib.ecs.world)

function ecs_world:_on_init()
    self._feature = require("xlib.ecs.feature").new()
    -- add system for logic
    self._feature:add_system("sample.logic.input_system");
    self._feature:add_system("sample.logic.move_system");
end

return ecs_world
