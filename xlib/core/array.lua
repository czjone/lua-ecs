xlib.core.array = xlib.core.array or class()
local array = xlib.core.array

function array:ctor()
    self._data = {}
end

function array:size()
    return #self._data
end

function array:pop()
    local size = self:size()
    local ret = self:get(size)
    table.remove(self._data, size);
    return ret;
end

function array:get(index)
    if index > #self.data then
        log:error("Index out of range exception!");
    end
    return self._data[index];
end

function array:get_all()
    return self._data;
end

function array:push(val)
    table.insert(self._data, val)
end

function array:clear()
    for i = 1, #self._data, 1 do
        table.remove(self._data, 1);
    end
end

return array;
