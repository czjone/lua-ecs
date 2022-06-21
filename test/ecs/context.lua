require("xlib.core.base")

local ecs_context_test = class(xlib.core.test_base)
ecs_context_test.name = "ecs context test"

function ecs_context_test:execute()
    return false;
end

return ecs_context_test;