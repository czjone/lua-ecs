require("xlib.core.base")

local ecs_reactive_system_test = class(xlib.core.test_base)
ecs_reactive_system_test.name = "ecs reactive system test"

function ecs_reactive_system_test:execute()
    return false;
end

return ecs_reactive_system_test;