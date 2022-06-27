require("xlib.core.base")
require("test.ecs.generate")

local generator_test = class(xlib.core.test_base)
generator_test.name = "ecs auto generate sample test."

function generator_test:execute()
    local feature = generate.feature;
    local f = feature.new(generate.contexts.instance);
    f:initialize();
    while f:is_activate() do
        f:execute();
    end
    f:deactivate();
    return true;
end

return generator_test
