-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.context = class({})
local context = xlib.ecs.context;

function context:ctor(entity_type)
    self._entity_type = entity_type
    self._entites_pool = xlib.core.object_pool.new(self._entity_type);
    self._entites = {}
    self._groups = {}; -- kv
end

function context:create_entity()
    local entity = self._entites_pool:get();
    table.insert(self._entites, entity);
    return entity;
end

-- function context:get_collector(group_matchers, group_events)

-- end

function context:destroy_entity(entity)
    table.remove_item(self._entites, entity);
    self._entites_pool:put(entity)
end

function context:has_entity(entity)
    local pos, val = table.index_of(self._entites, entity)
    return pos > 0
end

function context:get_entites()
    return self._entites;
end

function context:get_entites_group(entites_matcher)
    local group = self._groups[entites_matcher]
    if (group == nil) then
        group = xlib.ecs.group.new(entites_matcher);
    end
    return group;
end
