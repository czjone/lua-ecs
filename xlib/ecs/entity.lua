-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.entity = class()
local entity = xlib.ecs.entity
function entity:ctor()
    self._components = {}
    self._components_pool = {}
end

function entity:add_com(com_type_id)

end

function entity:remove_com(com_type_id)

end

function entity:replace_com(com_type_id)

end

function entity:reactivate()
end


function entity:deactivate()
end

function entity:get_components()

end
