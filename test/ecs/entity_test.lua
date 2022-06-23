require("xlib.core.base")

local ecs_entity_test = class(xlib.core.test_base)
ecs_entity_test.name = "ecs entity test"

function ecs_entity_test:execute()

    local ret = true;

    local entity_class = class(xlib.ecs.entity)

    local context = xlib.ecs.context.new(entity_class);

    -- create entity with context
    local entity = context:create_entity()
    ret = self.test:expect_true(entity ~= nil, "create entity with context.") and ret

    -- get entites
    local entites = context:get_entites()
    ret = self.test:expect_true(#entites == 1, "get entites with context.") and ret

    -- has entites
    ret = self.test:expect(context:has_entity(entity), true, "get entites with context.") and ret
  
    -- matcher
    local matcher = xlib.ecs.matcher.new();
    -- test entites group


    -- destroy entity
    context:destroy_entity(entity);
    return true;
end

return ecs_entity_test;
