-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.component = class()
local component = xlib.ecs.component

function component:ctor(...)
    self.__keys = {...}
end

function component:set_value(...)
    local keys = self.__keys
    local val = {...}
    for i, key in ipairs(keys) do
        self[key] = val[i];
    end
end

function xlib.ecs.make_component(name, ...)
    local _class = class(component);
    return _class;
end

