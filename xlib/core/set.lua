xlib.core.set = xlib.core.set or class()
local set = xlib.core.set

function set:ctor()
    self._data = {}
    self._size = 0
end

function set:size()
    return self._size
end

function set:insert(k, v)
    if self._data[k] ~= nil then
        log:info("exist key error:", k);
    end
    self._data[k] = v
    self._size = self._size + 1
end

function set:set_value(k, v)
    if self._data[k] == nil then
        self._size = self._size + 1
    end
    self._data[k] = v;
end

function set:has(k)
    return self._data[k] ~= nil;
end

function set:remove(k)
    if self._data[k] ~= nil then
        self._data[k] = nil
        self._size = self._size - 1
    end
end

function set:clear()
    for k, _ in pairs(self._data) do
        self._data[k] = nil
    end
    self._size = 0;
end

return set;
