-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.collector = class({})
local collector = xlib.ecs.collector;
function collector:ctor(groups, group_events)
    self._groups = groups;
    self._group_events = group_events;
    self._collectedEntities = {};
end
function collector:get_collected_entities()
end
function collector:activate(entities)
    local groups = self._groups
    for _, group in ipairs(groups) do
        group:removelistener(group.event.on_entity_added, self._add_entity)
        group:addeventlistener(group.event.on_entity_added, self._add_entity)
    end
end
function collector:deactivate(entities)
    local groups = self._groups
    for _, group in ipairs(groups) do
        group:removelistener(group.event.on_entity_added, self._add_entity)
    end
end
function collector:clear()
    table.remove_all_for_array(self._collectedEntities);
end

function collector:_add_entity(entity)
    local pos, _ = table.index_of(self._collectedEntities, entity)
    if (pos > 0) then
        return
    end
    table.insert(self._collectedEntities, entity);
end

function collector:_remove_enity(entity)
    table.remove_item(self._collectedEntities, entity);
end