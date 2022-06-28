local application = class(xlib.core.eventdispather)

application.event = {
    on_init = 1,
    on_update = 2,
    on_destroy = 3
}

function application:ctor()
    self._feature = nil;
    self:add_eventlistener(application.event.on_init, self._on_init);
    self:add_eventlistener(application.event.on_update, self._on_update);
    self:add_eventlistener(application.event.on_destroy, self._on_destroy);
end

function application:_on_init()
    self._feature = require("sample.sources.feature").new()
end

function application:_on_update()
    self._feature:execute();
end

function application:_on_destroy()
    self._feature = nil;
end

-- application driver.
function application:dispatch_event(evtKey)
    self:dispatch(evtKey);
end

return application
