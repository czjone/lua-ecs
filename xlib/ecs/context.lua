-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.context = xlib.ecs.context or class(xlib.core.eventdispatcher)
local context = xlib.ecs.context;

function context:ctor()
    self._entity_pools = xlib.core.object_pool.new(xlib.ecs.entity);
    self._entites = xlib.core.array.new();
    self._groups = xlib.core.array.new();
end

function context:get_group(...)
    local groups = self._groups;
    local matchers = {...}
    local pos, group = self._groups:find(function(group)
        return group:is_matcher(matchers);
    end)
    if pos > 0 then
        return group
    else
        group = xlib.ecs.group.new(...);
        self._groups:push(group)
        local entites = self._entites:get_buf()
        for _, entity in ipairs(entites) do
            self:_update_group(group, entity, group.event.on_entity_added)
        end
    end
    return group;
end

function context:create_entity()
    local entity = self._entity_pools:get();
    self._entites:push(entity);
    entity:activate();
    for _, group in pairs(self._groups:get_buf()) do
        self:_update_group(group, entity, group.event.on_entity_added);
    end
    return entity;
end

function context:destroy_entity(entity)
    local entity_type = entity:get_class();
    self._entites:remove(entity);
    for _, group in pairs(self._groups:get_buf()) do
        self:_update_group(group, entity, group.event.on_entity_removed);
        self:_update_group(group, entity, group.event.on_will_destroy);
    end
    entity:deactivate();
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

function context:_update_group(group, entity, event)
    group:update_entity(entity, event)
end
