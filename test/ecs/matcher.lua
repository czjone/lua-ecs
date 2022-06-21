require("xlib.core.base")

local ecs_matcher_test = class(xlib.core.test_base)
ecs_matcher_test.name = "ecs matcher test"

function ecs_matcher_test:execute()
    return false;
end

return ecs_matcher_test;