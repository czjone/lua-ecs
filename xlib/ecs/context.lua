-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.context = xlib.ecs.context or class(xlib.core.eventdispatcher)
local context = xlib.ecs.context;

function context:ctor()
    self._entity_pools = xlib.core.object_pool.new(xlib.ecs.entity);
    self._entites = xlib.core.array.new();
    self._groups = xlib.core.set.new();
end

function context:get_group(matcher)
    matcher = to_class(matcher);
    if matcher:is_instance() then
        log:error("mather must a class type or model string");
    end

    local groups = self._groups;
    local group = groups:get_value(matcher) or groups:set_value(matcher, xlib.ecs.group.new(matcher));
    local _self = self;

    self._entites:foreach(function(entity)
        group:update_entity(entity, xlib.ecs.group.event.on_entity_added);
    end)
end

function context:create_entity()
    local entity = self._entity_pools:get();
    self._entites:push(entity);
    return entity;
end

function context:destroy_entity(entity)
    local entity_type = entity:get_class();
    self._entites:remove(entity);
    self._entity_pools:put(entity);
end

function context:has_entity(entity)
    return self._entites:has(entity);
end

function context:get_entites_array()
    return self._entites
end

function context:set_unique_component(com_type, ...)
    local entity = self:create_entity();
    entity:add(com_type, ...)
    return entity;
end

function context:get_unique_component(com_type)
    local group = self:get_group()
    local entity = group:single_entity();
    return entity:get(com_type)
end

function context:entity_size()
    return self._entites:size();
end
