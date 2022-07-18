-- ==========================================================================
-- xlib.ecs.groun
-- entites groups
xlib.ecs = xlib.ecs or {}
xlib.ecs.group = class(xlib.core.eventdispatcher)
local group = xlib.ecs.group

group.event = group.event or {}

group.event.on_entity_added = 1
group.event.on_entity_removed = 2
group.event.on_will_destroy = 3

function group:ctor(entites_matcher)
    self._matcher = entites_matcher
    self._catch_entites = xlib.core.array.new();
    local metatable = getmetatable(self)
    metatable.__eq = function(a, b)
        return a._matcher == b._matcher
    end
end

function group:destroy()

end

function group:is_matcher(entites_matcher)

end

function group:has_entity(entity)
    local pos, _ = table.index_of(self._catch_entites, entity)
    return pos > 0
end
function group:get_entites()
    return self._catch_entites;
end

function group:get_single_entity()
    
end

function group:update_entity(entity, event)
    if event == group.event.on_entity_added and self._matcher:match(entity) then
        self._catch_entites:push(entity)
    else
        self._catch_entites:remove(entity)
    end
end

