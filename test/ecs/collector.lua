require("xlib.core.base")

local ecs_collector_test = class(xlib.core.test_base)
ecs_collector_test.name = "ecs collector test"

function ecs_collector_test:execute()
    return false
end

return ecs_collector_test
