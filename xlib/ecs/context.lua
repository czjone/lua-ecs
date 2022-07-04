-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
log:assert(xlib.core.eventdispather, "xlib.core.eventdispather is nil")
xlib.ecs.context = class(xlib.core.eventdispather)
local context = xlib.ecs.context;

function context:ctor()
    self._object_pools = {}
    self._entites = {}
    self._collectors = {}
    self._groups = {}
    self._entity_class_matchers = {}
end

function context:_get_or_create_pool(entites_class)
    local catch_pool = self._object_pools
    local pool_class = xlib.core.object_pool
    local pool_object_class = entites_class
    local pool = table.get_or_create(catch_pool, pool_object_class, pool_class, pool_object_class);
    return pool
end

function context:create_entity(entites_class)
    entites_class = to_class(entites_class)
    local pool = self:_get_or_create_pool(entites_class);
    local entity = pool:get();
    table.insert(self._entites, entity);
    self:update_group(entity, xlib.ecs.group.event.on_entity_added)
end

function context:destroy_entity(entity)
    local pool = self:_get_or_create_pool();
    pool:put(entity);
    self:update_group(entity, xlib.ecs.group.event.on_entity_removed);
end

function context:get_group(matcher)
    local group = self._groups;
    if group[matcher] == nil then
        group[matcher] = xlib.ecs.group.new(matcher);
        for _, entity in ipairs(self._entites) do
            self:update_group(entity, xlib.ecs.group.event.on_entity_added);
        end
    end
    return group[matcher];
end

function context:get_group_for_entites_class(entites_class)
    entites_class = to_class(entites_class);
    local matcher = self._entity_class_matchers[entites_class];
    if matcher == nil then
        local matcher_class = to_class("xlib.ecs.matches.matcher_for_entity_class");
        matcher = matcher_class.new(self._entites, entites_class);
        self._entity_class_matchers[entites_class] = matcher;
    end
    return self:get_group(matcher);
end

function context:update_group(entity, group_event)
    for _, group in pairs(self._groups) do
        group:update_entity(entity, group_event);
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
