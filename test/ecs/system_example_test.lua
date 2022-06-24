require("xlib.core.base")

local system_example_test = class(xlib.core.test_base)
system_example_test.name = "ecs system example  test"

function system_example_test:execute()

    local ret = true;

    -- entites
    local game_entity = class(xlib.ecs.entity)
    local input_entity = class(xlib.ecs.entity)
    
    -- component
    local position_com = class(xlib.ecs.component) 
    position_com.x = 1;
    position_com.y = 1;
    position_com.z = 1;

    local car_com = class(xlib.ecs.component)
    car_com.color = {r = 1, g = 0, b = 0 }
    car_com.id = 0

    local player_com = class(xlib.ecs.component)
    player_com.id = 0
    player_com.name = nil

    -- init systems
    local init_player_system = class(xlib.ecs.system)
    function init_player_system:iniztion()
        self._context:create_entity();
    end

    -- test component
    local com = position_com.new();
    ret = self.test:expect(com.x, 1, "com.x.") and ret
    ret = self.test:expect(com.y, 1, "com.y.") and ret
    ret = self.test:expect(com.z, 1, "com.z.") and ret
    -- test modify com value
    com.x = 2
    ret = self.test:expect(com.x, 2, "com.x.") and ret
    ret = self.test:expect(position_com.x, 1, "position_com.x.") and ret

    -- test ecs
    local context = xlib.ecs.context.new(entity);
    local main_system = example_system.new("main_system", context)
    function main_system:ctor(name, context)
        self:add_system(input_system.new("input_entity", context))
        self:add_system(view_system.new("view_entity", context))
    end

    main_system:iniztion();

    for i = 1, 10, 1 do
        main_system:execute();
    end

    return ret;
end

return system_example_test
