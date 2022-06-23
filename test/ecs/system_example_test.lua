require("xlib.core.base")

local system_example_test = class(xlib.core.test_base)
system_example_test.name = "ecs system example  test"

function system_example_test:execute()

    local ret = true;
    -- entites
    local entity = class(xlib.ecs.entity)
    -- systems
    local system_a = class(xlib.ecs.system)
    local system_b = class(xlib.ecs.system)
    local example_system = class(xlib.ecs.system)
    -- start system
    local context = xlib.ecs.context.new(entity);
    local main_system = example_system.new("main_system", context)
    function main_system:ctor(name, context)
        self:add_system(system_a.new("system_a", context))
        self:add_system(system_b.new("system_b", context))
    end

    main_system:iniztion();

    for i = 1, 10, 1 do
        main_system:execute();
        -- system sleep
        if i == 1 then
            main_system:deactivate()
        end
        -- system resume
        if i == 2 then
            main_system:activate()
        end
        -- system sleep;
        if i == 3 then
            main_system:deactivate()
        end
    end

    return ret
end

return system_example_test
