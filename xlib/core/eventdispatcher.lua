xlib = xlib or {}
------------------------------------------------
-- xlib.core.eventdispatcher
xlib.core.eventdispatcher = xlib.core.eventdispatcher or class()
local eventdispatcher = xlib.core.eventdispatcher

function eventdispatcher:ctor(...)
    self._event_set = require("xlib.core.set").new();
end

function eventdispatcher:_make_event(key, func, obj)
    local event = {
        k = key,
        f = func,
        o = obj or self
    }
    setmetatable(event, {
        __call = function(_self, ...)
            _self.f(_self.o, ...);
        end,
        __eq = function(a, b)
            return a.k == b.k and a.f == b.f and a.o == b.o
        end
    })
    return event;
end

function eventdispatcher:add_eventlistener(key, func, obj)
    if not self._event_set:has(key) then
        self._event_set:set_value(key, xlib.core.array.new());
    end
    local events = self._event_set:get_value(key);
    local event = self:_make_event(key, func, obj)
    if events:has(event) then
        log:error("Repeated events:", key, func, obj);
    end
    events:push(event);
end

function eventdispatcher:remove_listener(key, func, obj)
    local events_array = self._event_set:get_value(key);
    if events_array then
        local event = self:_make_event(key, func, obj)
        events_array:remove(event)
        if events_array:size() == 0 then
            self._event_set:remove(key);
        end
    end
end

function eventdispatcher:dispatch(key, ...)
    local events_array = self._event_set:get_value(key);
    if events_array then
        local events = events_array:get_all();
        for _, event in pairs(events) do
            event(...);
        end
    end
end

function eventdispatcher:get_listeners()
    return self._event_set:get_all();
end
