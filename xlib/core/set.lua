xlib.core.set = xlib.core.set or class()
local set = xlib.core.set

function set:ctor()
    self._keys = xlib.core.array.new();
    self._data = {}
    self._size = 0
end

function set:size()
    return self._size
end

function set:insert(k, v)
    self:set_value(k, v)
end

function set:get_buf()
    return self._data;
end

function set:set_value(k, v)
    if self._data[k] == nil then
        self._size = self._size + 1
        self._keys:push(k);
    end
    self._data[k] = v;
    return v;
end

function set:has(k)
    return self._data[k] ~= nil;
end

function set:get_value(k)
    return self._data[k];
end

function set:get_keys()
    return self._keys:get_buf()
end

function set:remove(k)
    if self._data[k] ~= nil then
        self._data[k] = nil
        self._size = self._size - 1
        self._keys:remove(k);
    end
end

function set:clear()
    for k, _ in pairs(self._data) do
        self._data[k] = nil
    end
    self._size = 0;
end

function set:foreach(func)
    local d = self._data;
    for k, v in pairs(d) do
        func(k, v)
    end
end

return set;
