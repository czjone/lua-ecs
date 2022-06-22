require("xlib.core.base")

local ecs_feature_test = class(xlib.core.test_base)
ecs_feature_test.name = "ecs feature test"

function ecs_feature_test:execute()
    return false;
end

return ecs_feature_test;