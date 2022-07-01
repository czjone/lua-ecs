-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.context = class(xlib.core.eventdispather)
local context = xlib.ecs.context;

function context:ctor()
    self._object_pools = {}
    self._entites = {}
    self._collectors = {}
    self._groups = {}
end

function context:_get_or_create_pool(entites_class)
    local catch_pool = self._object_pools
    local pool_class = xlib.core.object_pool
    local pool_object_class = entites_class
    local pool = table.get_or_create(catch_pool, pool_class, pool_class, pool_object_class);
    return pool
end

function context:create_entity(entites_class)
    local pool = self:_get_or_create_pool(entites_class);
    local entity = pool:get();
    table.insert(self._entites, entity);
    self:update_group(entity)
end

function context:destroy_entity(entity)
    local pool = self:_get_or_create_pool();
    pool:put(entity);
    self:update_group(entity);
end

function context:get_group(matcher, ...)
    return table.get_or_create(self._groups, matcher, matcher, self._entites, ...);
end

function context:get_group_for_entites_class(entites_class)
    local match_class = to_class("xlib.ecs.matches.matcher_for_entity_class");
    return self:get_group(match_class, entites_class)
end

function context:update_group(entity)
    for _, group in ipairs(self._groups) do
        group:update_entity(entity);
    end
end

function context:get_collector(group)
    return self:get_collector_with_groups({group});
end

function context:get_collector_with_groups(groups)
    local collectors = self._collectors;
    local find = nil;
    for _, collector in ipairs(collectors) do
        if (collector == groups) then
            return collector
        end
    end
    return table.get_or_create(self._collectors, groups, xlib.ecs.collector, groups);
end

function context:has_entity(entity)
    local pos, val = table.index_of(self._entites, entity)
    return pos > 0
end

function context:get_entites()
    return self._entites;
end

-- function context:get_entites_group(entites_matcher)
--     local group = self._groups[entites_matcher]
--     if (group == nil) then
--         group = xlib.ecs.group.new(entites_matcher);
--     end
--     return group;
-- end

-- function context:get_group()
--     local matcher = nil
--     return self:get_entites_group(matcher);
-- end
