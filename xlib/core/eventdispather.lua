xlib = xlib or {}
------------------------------------------------
-- xlib.core.eventdispather
xlib.core.eventdispather = class(xlib.core.base)
local eventdispather = xlib.core.eventdispather
function eventdispather:ctor(...)
    self._events = {}
end

function eventdispather:add_eventlistener(key, func, obj, unique)
    local pos, find = self:_find_event(key, func);
    if pos > 0 then
        return
    end
    local events = self._events;
    obj = obj or self
    -- 唯一性检查
    if unique then
        for _, evt in ipairs(events) do
            if (evt.k == key and evt.f == func and evt.o == obj) then
                return;
            end
        end
    end
    table.insert(events, {
        k = key,
        f = func,
        o = obj
    });
end

function eventdispather:_find_event(key, func)
    local events = self._events;
    for pos, v in ipairs(events) do
        if key == v.k and func == v.f then
            return pos, v;
        end
    end
    return -1, nil;
end

function eventdispather:remove_listener(key, func)
    local pos, find = self:_find_event(key, func)
    if pos > 0 then
        table.remove(self._events, pos)
    end
end

function eventdispather:dispatch(key, ...)
    local events = self._events;
    for i, v in ipairs(events) do
        if v.k == key then
            v.f(v.o, ...);
        end
    end
end