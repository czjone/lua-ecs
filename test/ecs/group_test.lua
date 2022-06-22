require("xlib.core.base")

local ecs_group_test = class(xlib.core.test_base)
ecs_group_test.name = "ecs group test"

function ecs_group_test:execute()
    return false;
end

return ecs_group_test;