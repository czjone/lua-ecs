xlib.ecs = xlib.ecs or {}
xlib.ecs.group = class(xlib.core.eventdispather)
local group = xlib.ecs.group

group.event = group.event or {}
group.event.on_entity_added = 1
group.event.on_entity_removed = 2

function group:ctor(entites, entites_matcher)
    self._entites = entites
    self._matcher = entites_matcher
end

function group:has_entity(entity)
end
function group:get_entites()
end
