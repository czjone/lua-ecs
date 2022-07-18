-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.entity = class(xlib.core.eventdispatcher)
local entity = xlib.ecs.entity

entity.event = {
    add = 1,
    remove = 2,
    replace = 3
}

function entity:ctor()
    self._components = xlib.core.set.new();
    self._enable = nil;
end

function entity:has(com_type)
    return self._components:has(com_type);
end

function entity:get(com_type)
    return self._components:get_value(com_type);
end

function entity:has_any(...)
    local com_types = {...}
    for _, com_type in ipairs(com_types) do
        if self._components:has(com_type) then
            return true;
        end
    end
    return false;
end

function entity:has_all(...)
    local com_types = {...}
    for _, com_type in ipairs(com_types) do
        if not self._components:has(com_type) then
            return false;
        end
    end
    return true;
end

function entity:add(com_type, ...)
    if self._enable then
        local components = self._components;
        local com = com_type.new(...);
        components:set_value(com_type, com);
        self:dispatch(entity.event.add, com);
    end
end

function entity:replace(com_type, ...)
    if self._enable then
        local components = self._components;
        if not components:has(com_type) then
            self:add(com_type, ...);
        else
            local com = components:get_value(com_type);
            com:set_value(...);
            self:dispatch(entity.event.replace, com);
        end
    end
end

function entity:remove(com_type)
    if self._enable then
        local coms = self._components
        local com = coms:get_value(com_type)
        if com then
            self._components:remove(com_type);
            self:dispatch(entity.event.remove, com);
        end
    end
end

function entity:activate()
    self._enable = true;
end

function entity:deactivate()
    self._enable = nil;
end

