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

function entity:has(_class)
    return self._components:has(_class);
end

function entity:has_any(_classes)
    -- return self._components:find_all(function(k,v)
    --     return v:get_class 
    -- end)
    return false;
end

function entity:add(com)
    if self._enable then
        local components = self._components;
        self._components:set_value(com:get_class(), com);
        self:dispatch(entity.event.add, com);
    end
end

function entity:replace(com)
    if self._enable then
        local components = self._components;
        local _class = com:get_class();
        if not components:has(_class) then
            self:add(com);
        else
            components:remove(_class);
            components:set_value(_class, com);
            self:dispatch(entity.event.replace, com);
        end
    end
end

function entity:dector()
    self:deactivate();
    entity.super.dector(self);
end

function entity:remove(com)
    if self._enable then
        local components = self._components;
        local _class = com:get_class();
        if components:has(_class) then
            components:remove(_class);
            self:dispatch(entity.event.remove, com);
        end
    end
end

function entity:activate()
    self._enable = true;
end

