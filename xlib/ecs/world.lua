xlib = xlib or {}
xlib.ecs = xlib.ecs or {}
xlib.ecs.world = class(xlib.core.eventdispather)
local world = xlib.ecs.world
world.event = {
    on_init = 1,
    on_update = 2,
    on_destroy = 3
}

function world:ctor()
    self._feature = nil;
    self:add_eventlistener(world.event.on_init, self._on_init);
    self:add_eventlistener(world.event.on_update, self._on_update);
    self:add_eventlistener(world.event.on_destroy, self._on_destroy);
end

function world:_on_init()
    error("not implement application _on_init")
end

function world:_on_update()
    self._feature:execute();
end

function world:_on_destroy()
    self._feature = nil;
end

-- application driver.
function world:dispatch_event(evt_key)
    self:dispatch(evt_key);
end

return world
