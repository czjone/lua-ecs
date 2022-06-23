-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.system = class(xlib.core.eventdispather)
local system = xlib.ecs.system

function system:ctor(name, context)
    self.name = name;
    self.context = context
    self._systems = {}
    self._is_inited = false
end

function system:_set_status(status)
    self._status = status;
end

function system:add_system(system)
    if (self._is_inited == true) then
        log:error("add system only befor parent system iniztioned.");
    end
    table.insert(self._systems, system);
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

function system:_clear()
    table.remove_all_for_array(self._systems);
end
