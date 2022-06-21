-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.system = class({})
local system = xlib.ecs.system

function system:ctor(name, context)
    self.name = name;
    self.context = context
    self._systems = {}
end

function system:iniztion()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        system:initialize();
    end
end
function system:execute()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        -- reactive_system _execute call execute.
        local exec = system._execute or system.execute;
        exec(system);
    end
end
function system:activate()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        system:activate();
    end
end
function system:deactivate()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        system:deactivate();
    end
end
function system:clear()
    table.remove_all_for_array(self._systems);
end