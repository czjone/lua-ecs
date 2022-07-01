-- ==========================================================================
-- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.collector = class({})
local collector = xlib.ecs.collector;

function collector:ctor(etities_group)
    self._etities_group = {}
    self._collect_entites = {}
    self:activate();
end

function collector:dector()
    self:deactivate();
    collector.super.dector(self)
end

function collector:get_entites()
    return self._collect_entites;
end

function collector:get_groups()
    return self._etities_group
end

function collector:activate()
    local groups = self._etities_group
    for _, group in ipairs(groups) do
        group:remove_listener(group.event.on_entity_added, self._add_entity, self)
        group:add_eventlistener(group.event.on_entity_added, self._add_entity, self)

        group:remove_listener(group.event.on_entity_removed, self._remove_enity, self)
        group:add_eventlistener(group.event.on_entity_removed, self._remove_enity, self)
    end
end

function collector:deactivate()
    local groups = self._etities_group
    for _, group in ipairs(groups) do
        group:remove_listener(group.event.on_entity_added, self._add_entity)
        group:remove_listener(group.event.on_entity_removed, self._remove_enity)
    end
end

function collector:clear()
    table.remove_all_for_array(self._collect_entites);
end

function collector:_add_entity(entity)
    table.insert(self._collect_entites, entity);
end

function collector:_remove_enity(entity)
    table.remove_item(self._collect_entites, entity);
end
