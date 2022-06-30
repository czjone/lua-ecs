-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.feature = class(xlib.ecs.system)
local feature = xlib.ecs.feature

function feature:ctor(name)
    self.context = xlib.ecs.context.new();
end

function feature:add_system(system, name)
    if not name and type(system) == "string" then
        name = system;
    else
        name = "undefined"
    end
    local sys = create(system, name, self.context);
    feature.super.add_system(self, sys);
end

return feature
