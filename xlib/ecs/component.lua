-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.component = class()
local component = xlib.ecs.component
function component:ctor()
    self.com_type_id = nil
    self.com_id = nil
end
