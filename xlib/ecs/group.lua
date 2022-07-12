-- ==========================================================================
-- xlib.ecs.groun
-- entites groups
xlib.ecs = xlib.ecs or {}
xlib.ecs.group = class(xlib.core.eventdispatcher)
local group = xlib.ecs.group

group.event = group.event or {}
group.event.on_entity_added = 1
group.event.on_entity_removed = 2

function group:ctor(entites_matcher)
    self._matcher = entites_matcher
    self._catch_entites = {}
end

function group:has_entity(entity)
    local pos, _ = table.index_of(self._catch_entites, entity)
    return pos > 0
end
function group:get_entites()
    return self._catch_entites;
end

function group:update_entity(entity, group_event)
    if (self._matcher:match(entity)) and group_event == group.event.on_entity_added then
        table.insert(self._catch_entites, entity);
    else
        table.remove_item(self._catch_entites, entity)
    end
end
