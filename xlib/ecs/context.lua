-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.context = xlib.ecs.context or class(xlib.core.eventdispatcher)
local context = xlib.ecs.context;

function context:ctor()
    -- pool set,k:entity_class_type v:entity object pool
    self._entity_pools = xlib.core.set.new();
    -- entity array
    self._entites = xlib.core.array.new();
    -- groups set,k:matcher v:group
    self._groups = xlib.core.set.new();
end

function context:_get_entity_pool(entites_type)
    local entity_pools = self._entity_pools;
    local pool_type = xlib.core.object_pool;
    return entity_pools:get_value(entites_type) or entity_pools:set_value(entites_type, pool_type.new(entites_type))
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

function context:_update_group(entity, group_event)
    for _, group in pairs(self._groups) do
        group:update_entity(entity, group_event);
    end
end

function context:create_entity(entites_class)
    entites_class = to_class(entites_class)
    local pool = self:_get_entity_pool(entites_class);
    local entity = pool:get();
    self._entites:push(entity);
    self:_update_group(entity, xlib.ecs.group.event.on_entity_added)
end

function context:destroy_entity(entity)
    local entity_type = entity:get_class();
    local pool = self:_get_entity_pool(entity_type);
    pool:put(entity);
    self:_update_group(entity, xlib.ecs.group.event.on_entity_removed);
end

function context:has_entity(entity)
    return self._entites:has(entity);
end

function context:get_entites_array()
    return self._entites
end