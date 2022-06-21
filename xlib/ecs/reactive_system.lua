-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.system = class({})
xlib.ecs.reactive_system = class({})
local reactive_system = xlib.ecs.reactive_system

function reactive_system:ctor(name, context)
    self.name = name
    self.context = context
    self._execute_buf = {}
    self._collector = self:get_collector();
end

function reactive_system:get_collector()
    return self.context:create_collector({}, {});
end

function reactive_system:filter(entity)
    return true;
end

function reactive_system:_execute()
    local entities = self._execute_buf;
    local collect_entities = self._collector:get_collected_entities();
    for _, entity in ipairs(collect_entities) do
        if (self:filter(entity)) then
            table.insert(entities, entity)
        end
    end
    self:execute(entities);
    table.remove_all_for_array(entities);
end
function reactive_system:execute(entities)
    error("not execute implements for reactive_system.");
end
function reactive_system:activate()
    self._collector:activate();
end
function reactive_system:deactivate()
    self._collector:deactivate();
end
function reactive_system:clear()
    self._collector:clear();
end