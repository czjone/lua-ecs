require("xlib.core")
require("xlib.ecs")

local ecs_application = class(xlib.ecs.application)

function ecs_application:_on_init()
    self._feature = require("xlib.ecs.feature").new()
    -- add system for logic
    self._feature:add_system("sample.logic.init_system");
    self._feature:add_system("sample.logic.input_system");
    self._feature:add_system("sample.logic.move_car_system");
    self._feature:add_system("sample.logic.un_init_system");
end

return ecs_application
