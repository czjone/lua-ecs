require("xlib.core.base")

local ecs_entity_test = class(xlib.core.test_base)
ecs_entity_test.name = "ecs entity test"

function ecs_entity_test:execute()

    local entity_a= class (xlib.ecs.entity)
    local entity_b= class (xlib.ecs.entity)
    
    local context = xlib.ecs.context.new();

    return false;
end

return ecs_entity_test;