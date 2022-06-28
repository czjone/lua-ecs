-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.feature = class(xlib.ecs.system)
local feature = xlib.ecs.feature

function feature:ctor(name)
    self.context = xlib.ecs.context.new();
end

function feature:add_system(system)
    local t = type(system)
    local instance = nil
    if t == "string" then
        instance = require(system).new(system, self.context);
    end

    if t == "table" then
        instance = system
    end

    feature.super.add_system(instance);

end

return feature
