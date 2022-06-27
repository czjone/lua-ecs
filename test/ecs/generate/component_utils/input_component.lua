-- ==========================================================================
-- auto generate code.(Don't modify it)
-- create by:xtool.
-- ==========================================================================
xlib.ecs = xlib.ecs or {}
xlib.ecs.feature = class(xlib.ecs.system)
local feature = xlib.ecs.feature

function feature:ctor(name)
    self.name = name
    self._systems = {}
    self._is_inited = false
    self.context = xlib.ecs.context.new();
end

return feature
