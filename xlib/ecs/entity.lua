-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.entity = class()
local entity = xlib.ecs.entity
function entity:ctor()
    self._components = {}
    self._components_pool = {}
end
function entity:add(com)
end
function entity:remove(com)
end
function entity:replace(com)
end

function entity:reactivate()
end

function entity:get_components()

end
