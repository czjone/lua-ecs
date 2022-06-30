-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.context = class({})
local context = xlib.ecs.context;

function context:ctor()
    self._entites = {}
    self._collectors = {}
end

function context:create_entity()
    -- local entity = self._entites_pool:get();
    -- table.insert(self._entites, entity);
    -- return entity;
end

function context:get_entites_collector(matcher_func)
    return table.get_or_create_class(self._collectors, matcher_func, xlib.ecs.matcher, self._entites, matcher_func);
end

function context:destroy_entity(entity)
    if not self:has_entity(entity) then
        log:error("not contais entity in enties.");
    end
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
