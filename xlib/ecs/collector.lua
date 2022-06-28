-- -- ==========================================================================
-- -- xlib.ecs
-- A Collector can observe one or more groups from the same context
-- and collects changed entities based on the specified groupEvent.
xlib.ecs = xlib.ecs or {}
xlib.ecs.collector = class({})
local collector = xlib.ecs.collector;
---
-- Creates a Collector and will collect changed entities
-- based on the specified groupEvent.
function collector:ctor(etities_group, com_group_for_entity_events)
    self._com_group_for_entity = com_group_for_entity;
    self._com_group_for_entity_evetns = com_group_for_entity_events;
    self._collectedEntities = {};

    self:activate();
end

function collector:dector()
    self:deactivate();
    collector.super.dector(self)
end

function collector:get_collected_entities()
    return self._collectedEntities;
end

function collector:activate()
    local groups = self._com_group_for_entity
    for _, group in ipairs(groups) do
        group:removelistener(group.event.on_entity_added, self._add_entity, self)
        group:addeventlistener(group.event.on_entity_added, self._add_entity, self)
    end
end

function collector:deactivate()
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
